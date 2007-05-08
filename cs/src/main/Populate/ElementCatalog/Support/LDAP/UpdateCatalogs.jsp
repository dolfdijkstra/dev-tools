<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>

<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>

<cs:ftcs>

<%!
public final static String kGO              = "GO";
public final static String kRollback        = "Rollback";

// Instance variables
private boolean debugEnabled                = false;
private String inputDataSubDir              = "Support/LDAP/Data";
private String inputDataFilename            = "userinput";
%>

<%!
// Checks whether the directory exists are not,
// if not, and the create is true it will create else returns false.
private boolean CheckDirectory (String dir, boolean create, StringBuffer errors) {
    boolean status = true;

    try {
        File d = new File(dir);
        if (! d.exists()) {
            if (create) {
                if (! d.mkdirs()) {
                    errors.append ("<li>ERROR: Failed to create the directory, " + dir + "</li>");
                    status = false;
                }
            } else {
                errors.append ("<li>ERROR: Directory, " + dir + ", is not found." + "</li>");
                status = false;
            }
        }
    } catch (Exception e) {
        errors.append ("<li>ERROR: Exception occured. Look at the stack trace. " + "</li>");
        LogDebugMessage ("Exception occured.");
        status = false;
        e.printStackTrace();
    }

    return status;
}

// Store the user input entered on LDAP's InputScreen
private boolean StoreUserInput(ICS ics, String dir, String filename, StringBuffer errors) {
    boolean status = true;

    try {
        String []keys = {"PeopleDN", "RootDN", "IniDir", "LoginAttr", "OldPeopleDN", "OldUsernameAttr"};

        Properties p = new Properties();

        for (int i=0; i<keys.length; i++) {
            String value = ics.GetVar(keys[i]);
            if (value != null) {
                p.setProperty (keys[i], value);
            }
        }

        FileOutputStream fout = new FileOutputStream(dir + "/" + filename);
        p.store (fout, "These are user input values needed if he decided to rollback later");
        fout.close();
    } catch (Exception e) {
        errors.append ("<li>ERROR: Exception occured. Look at the stack trace. " + dir + "</li>");
        LogDebugMessage ("Exception occured.");
        status = false;
        e.printStackTrace();
    }

    return status;
}

// Loads the user input stored thru StoreUserInput()
// into the current environment
private boolean LoadUserInput(ICS ics, String dir, String filename, StringBuffer errors) 
{
    boolean status = true;

    try {
        Properties p = new Properties();

        if (! new File(dir + "/" + filename).exists()) {
            errors.append ("<li>ERROR: Can't perform the operation. Either the ini directory specified is incorrect or there is nothing to rollback.</li>");
            LogDebugMessage ("File, " + filename + ", is not found under. Possible that inidir specified is incorrect or there is nothing to rollback. " + dir);
            return false;
        }

        FileInputStream fin = new FileInputStream(dir + "/" + filename);
        p.load (fin);
        fin.close();

        Enumeration enum = p.propertyNames();
        while (enum.hasMoreElements()) {
            String key = (String) enum.nextElement();
            String value = p.getProperty(key);
            LogDebugMessage (key + " = " + value + " set in the environment.");
            ics.SetVar (key, value);
        }
    } catch (Exception e) {
        errors.append ("<li>ERROR: Exception occured. Look at the stack trace. " + "</li>");
        LogDebugMessage ("Exception occured.");
        status = false;
        e.printStackTrace();
    }
    return status;
}

// Read SystemUsers Catalog
private IList ReadSysUsers (ICS ics, StringBuffer errors)
                throws Exception {

    boolean status = true;

    // Read the SystemUsers table
    String su_table     = "SystemUsers";
    String su_columns   = "id, username";

    ics.ClearErrno();

    StringBuffer error  = new StringBuffer();
    String sql      = "select " + su_columns + " from " + su_table;
    IList u_list    = ics.SQL (su_table, sql, "xml_access", -1, false, error);

    if (ics.GetErrno() != 0) {
        AddMessage (ics, "ERRORS", errors.toString());
    } else {
        if (debugEnabled) {
            PrintList (u_list);
        }
    }

    return u_list;
}

// Update a column in the catalog
private boolean Update (ICS ics, String op,
        IList userList,
        String updateTable, String updateColumn,
        String loginAttr, String old_usernameAttr,
        String peopleDN, String old_peopleDN, String rootDN,
        StringBuffer errors) throws Exception {

    boolean status = true;

    StringBuffer error  = new StringBuffer();

    if (userList == null) {
        AddMessage (ics, "ERRORS", "<li>ERROR: Userlist is NULL." + "</li>");
        return false;
    }

    IList r_list = userList;
    int num_rows = r_list.numRows();
    int num_cols = r_list.numColumns();

    // Update the catalog now.
    String up_table     = updateTable;
    String up_column    = updateColumn;

    boolean all_success = true;
    boolean table_updated = false;

    try {
        for (int i=1; i<=num_rows; i++) {

            r_list.moveTo (i);

            StringBuffer new_username = new StringBuffer();
            StringBuffer old_username = new StringBuffer();
            String user_id = null;
            int errno = 0;

            LogDebugMessage ("'" + op + "' == '" + kGO.trim() + "' ? " + op.equals(kGO.trim()));
            LogDebugMessage ("'" + op + "' == '" + kRollback + "' ? " + op.equals(kRollback));
            if (op.equals (kRollback)) {
                //  This is for rollback .....
                new_username.append (old_usernameAttr + "=" + r_list.getValue(r_list.getColumnName(1)) + "," + old_peopleDN);
                user_id = r_list.getValue(r_list.getColumnName(0));
                old_username.append (loginAttr + "=" + user_id);
                if (peopleDN != null) {
                    old_username.append ("," + peopleDN);
                }
                if (rootDN != null) {
                    old_username.append ("," + rootDN);
                }
            } else if (op.equals (kGO.trim())) {
                // This is for integrating ....
                new_username.append (loginAttr + "=" + r_list.getValue(r_list.getColumnName(0)));
                if (peopleDN != null) {
                    new_username.append ("," + peopleDN);
                }
                if (rootDN != null) {
                    new_username.append ("," + rootDN);
                }
                user_id = r_list.getValue(r_list.getColumnName(1));
                old_username.append (old_usernameAttr + "=" + user_id + "," + old_peopleDN);
            }

            String select_sql = "select id from "+ up_table +
                    " where " + up_column + "='" + old_username.toString() + "'";
            LogDebugMessage ("Running SELECT SQL <" + up_table + "> : " + select_sql);

            error = new StringBuffer();
            ics.ClearErrno();
            IList select_list = ics.SQL (up_table,  select_sql, "select_sql", -1, false, error);
            errno = ics.GetErrno();
            LogDebugMessage ("ERRNO After running the SELECT SQL = " + errno);

            if (errno != 0) {
                continue;
            } else if (select_list != null) {
                int ret_rows = select_list.numRows();
                LogDebugMessage ("# rows returned after running the SELECT SQL = " + ret_rows);
                if (ret_rows == 0) {
                    continue;
                } else {
                    table_updated = true;
                }
            }

            /* String update_sql = "update "+ up_table + " set " + up_column +
                    "=replace (" + up_column + "," + up_column + ", '" +  new_username.toString() +
                    "') where " + up_column + "='" + old_username.toString() + "'";
            */
            String update_sql = "update "+ up_table + " set " +
                    up_column + "= '" +  new_username.toString() +
                    "' where " + up_column + "='" + old_username.toString() + "'";
            LogDebugMessage ("Running UPDATE SQL <" + up_table + "> : " + update_sql);

            error = new StringBuffer();
            ics.ClearErrno();
            IList nothing = ics.SQL (up_table,  update_sql, "update_sql", -1, false, error);
            errno = ics.GetErrno();
            LogDebugMessage ("ERRNO After running the UPDATE SQL = " + errno);

            if (errno != 0) {
                if (errno != -502) {
                    all_success = false;
                    errors.append("<li>ERROR: Failed to update row in UserPublication." + "</li>");
                    // AddMessage (ics, "ERRORS", "<li>ERROR: Failed to update row in UserPublication." + "</li>");
                    LogDebugMessage ("Got error[" + errno + "] while running the UPDATE SQL: " + update_sql);
                }
            }
        }

    } catch (Exception e) {
        errors.append ("<li>ERROR: Exception occured while updating the catalog " + updateTable + "</li>");
        e.printStackTrace();
    }


    if (! table_updated) {
        errors.append ("<li>ERROR: Nothing updated in the " + updateTable + " catalog. Verify the values provided." + "</li>");
        all_success = false;
    }

    if (! all_success) {
        status = false;
    }

    return status;
}

// Print the list in a tabular fashion
private void PrintList (IList r_list)  throws Exception {
    if (r_list == null) {
        return;
    }

    int num_rows = r_list.numRows();
    int num_cols = r_list.numColumns();
    for (int i=1; i<=num_rows; i++) {
        r_list.moveTo(i);
        for (int j=0; j<num_cols; j++) {
            System.out.println (r_list.getValue(r_list.getColumnName(j)));
        }
    }

    // Reset the list pointer
    r_list.moveTo (1);
}

private boolean AddMessage (ICS ics, String type, String msg) {
    boolean status = true;
    int errno = ics.GetErrno();

    String message = ics.GetVar(type);
    if (message == null) {
        message = msg;
    } else {
        message += msg;
    }

    if (message != null) {
        ics.ClearErrno();
        ics.SetVar (type, message);
        if (ics.GetErrno() != 0) {
            status = false;
        }
    }

    ics.SetErrno(errno);
    return status;
}

// Log the message to the stdout
public void LogDebugMessage (String msg) {
    if (debugEnabled) {
        LogMessage ("DEBUG", msg);
    }
}

// This method should only be accessed thru the wrapper methods.
private void LogMessage (String type, String msg) {
    StringBuffer final_msg = new StringBuffer();
    if (type != null) {
        final_msg.append (type);
    }
    if (msg != null) {
        if (final_msg.length() > 0) {
            final_msg.append (": ");
        }
        final_msg.append (msg);
    }

    if (final_msg.length() > 0) {
        System.out.println (final_msg);
    }
}
%>

<%
// Default values
String peopleDN         = null;
String groupsDN         = null;
String rootDN           = null;

String loginAttr        = "uid";
String old_peopleDN     = "ou=People";
String old_usernameAttr = "userid";

String op               = "NoOperation";
String iniDir           = "";

String updateTable      = null;
String updateColumn     = null;

boolean status          = true;

debugEnabled            = false;

// Override any defaults
if (ics.GetVar("IniDir") != null) {
    iniDir = ics.GetVar("IniDir");
}
if (ics.GetVar("Operation") != null) {
    op = ics.GetVar("Operation");
}
if (ics.GetVar("debug") != null) {
    debugEnabled = true;
}

// Set the environment for the rollback action.
// This is needed here so that the defaults can be overridden
StringBuffer errors = null;
String dir      = iniDir + "/" + inputDataSubDir;
String filename = inputDataFilename;

if (op.equals(kRollback)) {
    LogDebugMessage ("Current op is " + kRollback);
    if (CheckDirectory(dir, false, errors)) {
        if (! LoadUserInput(ics, dir, filename, errors)) {
            AddMessage (ics, "ERRORS", errors.toString());
            LogDebugMessage ("LoadUserInput Failed.");
            status = false;
        }
    } else {
        LogDebugMessage ("CheckDirectory Failed.");
        AddMessage (ics, "ERRORS", errors.toString());
        status = false;
    }
}

// Continuation .....Override any defaults
if (ics.GetVar("PeopleDN") != null) {
    peopleDN = ics.GetVar("PeopleDN");
}
if (ics.GetVar("RootDN") != null) {
    rootDN = ics.GetVar("RootDN");
}
if (ics.GetVar("LoginAttr") != null) {
    loginAttr = ics.GetVar("LoginAttr");
}
if (ics.GetVar("OldPeopleDN") != null) {
    old_peopleDN = ics.GetVar("OldPeopleDN");
}
if (ics.GetVar("OldUsernameAttr") != null) {
    old_usernameAttr = ics.GetVar("OldUsernameAttr");
}

errors = new StringBuffer();
IList u_list = ReadSysUsers (ics, errors);

if (u_list == null) {
    AddMessage (ics, "ERRORS", "<li>ERROR: Failed to retrieve the users from SystemUsers catalog" + "</li>");
    LogDebugMessage ("ReadSysUsers() failed with errno=" + ics.GetErrno());
    status = false;
}

if (status) {
    errors = new StringBuffer();
    // Update username column in UserPublication catalog
    updateTable = "UserPublication";
    updateColumn = "username";
    status = Update(ics, op, u_list, updateTable, updateColumn, loginAttr, old_usernameAttr, peopleDN, old_peopleDN, rootDN, errors);
    if (! status) {
        AddMessage (ics, "ERRORS", errors.toString());
        LogDebugMessage ("Update() failed while updating the column," + updateColumn + ", in catalog," + updateTable);
    }
}

// We don't care about the return status while updating the Assignment catalog.
// Reason we might fail when there are no workflows in action right now.
if (status) {
    errors = new StringBuffer();
    // Update assignedby column in Assignment catalog
    updateTable = "Assignment";
    updateColumn = "cs_assignedby";
    boolean ret_status = Update (ics, op, u_list, updateTable, updateColumn, loginAttr, old_usernameAttr, peopleDN, old_peopleDN, rootDN, errors);
    if (! ret_status) {
        LogDebugMessage ("Update() failed while updating the column," + updateColumn + ", in catalog," + updateTable);
    }
}

if (status) {
    errors = new StringBuffer();
    // Update assignedto column in Assignment catalog
    updateTable = "Assignment";
    updateColumn = "cs_assignedto";
    boolean ret_status = Update (ics, op, u_list, updateTable, updateColumn, loginAttr, old_usernameAttr, peopleDN, old_peopleDN, rootDN, errors);
    if (! ret_status) {
        LogDebugMessage ("Update() failed while updating the column," + updateColumn + ", in catalog," + updateTable);
    }
}

if (status) {
    errors = new StringBuffer();
    // Update username column in WorkflowParticipants catalog
    updateTable = "WorkflowParticipants";
    updateColumn = "cs_username";
    boolean ret_status = Update (ics, op, u_list, updateTable, updateColumn, loginAttr, old_usernameAttr, peopleDN, old_peopleDN, rootDN, errors);
    if (! ret_status) {
        LogDebugMessage ("Update() failed while updating the column," + updateColumn + ", in catalog," + updateTable);
    }
}

if (status) {
    errors = new StringBuffer();
    // Update username column in GroupParticipants catalog
    updateTable = "GroupParticipants";
    updateColumn = "username";
    boolean ret_status = Update (ics, op, u_list, updateTable, updateColumn, loginAttr, old_usernameAttr, peopleDN, old_peopleDN, rootDN, errors);
    if (! ret_status) {
        LogDebugMessage ("Update() failed while updating the column," + updateColumn + ", in catalog," + updateTable);
    }
}

if (status) {
    errors = new StringBuffer();
    // Update participant column in StartParticipantChoice catalog
    updateTable = "StartParticipantChoice";
    updateColumn = "participant";
    boolean ret_status = Update (ics, op, u_list, updateTable, updateColumn, loginAttr, old_usernameAttr, peopleDN, old_peopleDN, rootDN, errors);
    if (! ret_status) {
        LogDebugMessage ("Update() failed while updating the column," + updateColumn + ", in catalog," + updateTable);
    }
}

if (status && op.equals(kGO.trim())) {
    if (CheckDirectory (dir, true, errors)) {
        if (! StoreUserInput(ics, dir, filename, errors)) {
            AddMessage (ics, "ERRORS", errors.toString());
            LogDebugMessage ("StoreUserInput Failed.");
        }
    } else {
        LogDebugMessage ("CheckDirectory Failed.");
        AddMessage (ics, "ERRORS", errors.toString());
        status = false;
    }
}

if (status) {
    ics.SetErrno (0);
}
%>

</cs:ftcs>
