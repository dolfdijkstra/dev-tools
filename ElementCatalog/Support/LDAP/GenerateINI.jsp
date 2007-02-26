<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>

<%@ page import="com.openmarket.apps.properties.dir" %>
<%@ page import="COM.FutureTense.Apps.PropEditor" %>
<%@ page import="COM.FutureTense.Util.FormPoster" %>

<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>

<cs:ftcs>

<%!
//Instance Vairables
private boolean debugEnabled                = false;
private String genIniSubDir                 = "Support/LDAP/Generated/ini";
private String genBackupSubDir              = "Support/LDAP/Backup/ini";
private String genTempSubDir                = "Support/LDAP/temp";
private String header                       = "Header";
private String timestamp                    = null;
%>

<%!
// Generate map file for dir.ini
private boolean GenerateDIRMap (ICS ics, HashMap map, StringBuffer errors) {
    boolean status = true;

    String propertyValue     = null;
    String qualifiedPeopleDN = "";

    propertyValue = ics.GetVar("DirIDir");
    map.put ("className.IDir", propertyValue==null?"":propertyValue);
    
    propertyValue = ics.GetVar("DirIName");
    map.put ("className.IName", propertyValue==null?"":propertyValue);
    
    map.put ("jndi.baseURL", "ldap://" + ics.GetVar("Host") + ":" + ics.GetVar("Port"));

    String peopleDN = ics.GetVar("PeopleDN");
    String groupsDN = ics.GetVar("GroupsDN");
    String rootDN   = ics.GetVar("RootDN");

    propertyValue = null;
    if (peopleDN != null) {
        propertyValue = peopleDN;
        if (rootDN != null) {
            propertyValue = propertyValue + "," + rootDN;
        }
    } else if (rootDN != null) {
            propertyValue = rootDN;
    }
    map.put ("peopleparent", propertyValue==null?"":propertyValue);

    qualifiedPeopleDN = propertyValue==null?qualifiedPeopleDN:propertyValue;

    propertyValue = null;
    if (groupsDN != null) {
        propertyValue = groupsDN;
        if (rootDN != null) {
            propertyValue = propertyValue + "," + rootDN;
        }
    } else if (rootDN != null) {
            propertyValue = rootDN;
    }
    map.put ("groupparent", propertyValue==null?"":propertyValue);

    propertyValue = ics.GetVar("RequiredPeopleAttrs");
    map.put ("requiredPeopleAttrs", propertyValue==null?"":propertyValue);
    
    propertyValue = ics.GetVar("DefaultPeopleAttrs");
    map.put ("defaultPeopleAttrs", propertyValue==null?"":propertyValue);

    propertyValue = ics.GetVar("DefaultGroupsAttrs");
    map.put ("defaultGroupAttrs", propertyValue==null?"":propertyValue);

    propertyValue = ics.GetVar("PasswordAttr");
    map.put ("password", propertyValue==null?"userpassword":propertyValue);

    propertyValue = ics.GetVar("CNameAttr");
    map.put ("cn", propertyValue==null?"cn":propertyValue);

    propertyValue = ics.GetVar("LoginAttr");
    map.put ("loginattribute", propertyValue==null?"uid":propertyValue);
    
    propertyValue = ics.GetVar("UsernameAttr");
    map.put ("username", propertyValue==null?"uid":propertyValue);

    map.put ("baseDN", "");

    // new for v5.0
    propertyValue = ics.GetVar("SearchScope");
    map.put ("search.scope", propertyValue==null?"2":propertyValue);

    boolean anonymousAccess = false;

    propertyValue = ics.GetVar("anonymousAccess");
    if (propertyValue != null) {
        anonymousAccess = true;
    }

    map.put ("jndi.connectAsUser", propertyValue==null?"false":"true");

    propertyValue = null;
    if (! anonymousAccess) {
        propertyValue = ics.GetVar("LDAPUsername");
    }
    map.put ("jndi.login", propertyValue==null?"":propertyValue);

    propertyValue = null;
    if (! anonymousAccess) {
        propertyValue = ics.GetVar("LDAPPassword");
    }
    map.put ("jndi.password", propertyValue==null?"":new dir().encrypt(propertyValue));

    return status;
}

// Generate map file for futuretense.ini
private boolean GenerateFTMap (ICS ics, HashMap map, StringBuffer errors) {
    boolean status = true;

    String propertyValue    = null;

    propertyValue = ics.GetVar("LDAPPlugin");
    map.put ("cs.manageUser", propertyValue==null?"":propertyValue);

    map.put ("cs.manageproperty", "dir.ini");

    map.put ("cs.manageUserSystem", "FutureTense");

    return status;
}

// Generate map file for futuretense_xcel.ini
private boolean GenerateFTXcelMap (ICS ics, HashMap map, StringBuffer errors) {
    boolean status = true;

    String propertyValue    = null;

    propertyValue = ics.GetVar("XcelUserclass");
    map.put ("xcelerate.usermanagerclass", propertyValue==null?"":propertyValue);
    
    propertyValue = ics.GetVar("XcelSitesroot");
    map.put ("xcelerate.sitesroot", propertyValue==null?"":propertyValue);
    
    propertyValue = ics.GetVar("XcelSitenameattr");
    map.put ("xcelerate.sitenameattr", propertyValue==null?"":propertyValue);

    return status;
}

// Add missing properties to the specified file
private boolean AddMissingProperties (String iniFilename, StringBuffer errors) {
    boolean status = true;

    try {
        PropEditor pe = new PropEditor(iniFilename);
        pe.loadFile();
        pe.UpdateProps();
        pe.doFileSave();
    } catch (Exception e) {
        e.printStackTrace();
    }

    return status;
}
%>

<%!
// This will load the specified src file and modify the entries
// based on the map passed in and stores it to the target file.
private boolean ReplaceEntries (ICS ics, String src_file, String target_file,
                Map m, StringBuffer errors) {
    boolean status = true;

    if (target_file == null) {
        errors.append ("<li>ERROR : target INI filename can't be NULL. </li>");
        return false;
    }

    if (m == null) {
        LogDebugMessage ("No entries in the map to replace, hence returning.");
        return status;
    }

    // Add any neccessary properties before updating
    AddMissingProperties (src_file, errors);

    try {
        FileInputStream in = null;
        FileOutputStream out = null;

        Properties p = new Properties();
        if (src_file != null) {
            in = new FileInputStream(src_file);
            p.load (in);
            in.close();

            status = BackupProperties (ics, p, new File(src_file).getName(), errors);
        }

        // New logic to support V5.0. We assume that the src file has all
        // properties that are needed in it. So, all we need to do is to
        // update those but not add new ones.
        for (Enumeration e = p.propertyNames(); e.hasMoreElements(); ) {
            String key = (String) e.nextElement();
            if (m.containsKey (key)) {
                String value = (String) m.get (key);
                p.setProperty (key, value);
            }
        }

        // This is followed until V4.0.x
        /*
        Iterator keys = m.keySet().iterator();
        while (keys.hasNext()) {
            String key = (String) keys.next();
            String value = (String) m.get(key);
            Object old = p.setProperty (key, value);
            LogDebugMessage ("Key[" + key + "] = Value[" + old + "] changed to New Value[" + value + "]");
        }
        */

        StringBuffer local_h_frags = new StringBuffer();
        local_h_frags.append ("\n");
        local_h_frags.append ("# This is a generated file by LDAP Integration Tool\n");
        local_h_frags.append ("#\n");
        local_h_frags.append ("#");
        local_h_frags.append (header);

        out = new FileOutputStream(target_file);
        p.store (out, local_h_frags.toString());
        out.close();
    } catch (FileNotFoundException e) {
        e.printStackTrace();
    } catch (Exception e) {
        e.printStackTrace();
    }

    return status;
}

private String GetTimeStamp() {
    if (timestamp == null) {
        SetTimeStamp();
        LogDebugMessage ("Setting the time stamp to=" + timestamp);
    }

    LogDebugMessage ("Returning the time stamp " + timestamp);
    return timestamp;
}

private void SetTimeStamp() {
    StringBuffer timestamp = new StringBuffer();

    GregorianCalendar cal = new GregorianCalendar();
    StringBuffer timeStamp = new StringBuffer ();

    String t_str = String.valueOf((cal.get(Calendar.MONTH) + 1));
    timestamp.append ((t_str.length() == 1)? ("0" + t_str):t_str);

    t_str = String.valueOf(cal.get(Calendar.DATE));
    timestamp.append ((t_str.length() == 1)? ("0" + t_str):t_str);

    t_str = String.valueOf(cal.get(Calendar.YEAR));
    timestamp.append ((t_str.length() == 1)? ("0" + t_str):t_str);

    t_str = String.valueOf(cal.get(Calendar.HOUR));
    timestamp.append ((t_str.length() == 1)? ("0" + t_str):t_str);

    t_str = String.valueOf(cal.get(Calendar.MINUTE));
    timestamp.append ((t_str.length() == 1)? ("0" + t_str):t_str);

    t_str = String.valueOf(cal.get(Calendar.SECOND));
    timestamp.append ((t_str.length() == 1)? ("0" + t_str):t_str);

    LogDebugMessage ("Time Stamp : " + timestamp.toString());

    this.timestamp = timestamp.toString();
}


// ************************************************************
// Delete the specified directory or file
//
// recursive=true : Deletes all the files and it's sub-directories 
//                  if the file is a directory
// ************************************************************
private boolean Delete (String file, boolean recursive) {
    boolean status = true;

    if (file == null) {
        return true;
    }

    File f = new File (file);
    if (f.exists()) {

        if (f.isDirectory()) {
            String[] files = f.list();
            for (int i=0; i<files.length; i++) {
                StringBuffer newFile = new StringBuffer();
                newFile.append (file);
                newFile.append ("/");
                newFile.append (files[i]);
                File curFile = new File (newFile.toString());
                if (curFile.isDirectory() && recursive) {
                    if (! Delete (newFile.toString(), recursive)) {
                        status = false;
                        break;
                    }
                } else {
                    LogDebugMessage ("Deleting file -> " + newFile);
                    if (! curFile.delete()) {
                        LogErrorMessage ("Failed to delete '" + files[i] + "'");
                        status = false;
                    }
                }
            }
            LogDebugMessage ("Deleting directory -> " + file);
            f.delete();
        } else {
            LogDebugMessage ("Deleting file -> " + file);
            status = f.delete();
        }
    }

    return status;
}

// ************************************************************
// Copy a specified to the target location
//
// If the targetFile is not specified the source file name will remain
// the same upon copying
//
// create=true  : create an empty targetfile irrespective of source files existance
// ************************************************************
private boolean CopyIniFile (String sourceDir, String sourceFile,
                        String targetDir, String targetFile,
                        boolean create, StringBuffer errors) {
    boolean status = true;
    boolean srcExists = true;

    StringBuffer src = new StringBuffer();
    if (sourceDir != null) {
        src.append (sourceDir + "/");
    }

    if (sourceFile != null) {
        src.append (sourceFile);
    } else {
        LogDebugMessage ("Source filename can't be NULL.");
        return false;
    }

    File srcFile = new File (src.toString());
    if (! srcFile.exists()) {
        LogDebugMessage ("Source file'" + src.toString() + "' is not found.");
        if (! create) {
            return true;
        }
        srcExists = false;
    }

    StringBuffer target = new StringBuffer();
    if (targetDir != null) {
        target.append (targetDir + "/");
        File f = new File (targetDir);
        if (! f.exists()) {
            if (! f.mkdirs()) {
                errors.append ("Failed to create the directory structure: '" + targetDir);
                return false;
            }
        }
    }

    if (targetFile != null) {
        target.append (targetFile);
    } else {
        target.append (sourceFile);
    }

    try {

        if ((! srcExists) && create) {
            if (target != null) {
                status = new File (target.toString()).createNewFile();
            }

            return status;
        }

        FileInputStream fin = new FileInputStream (src.toString());

        FileOutputStream fout = new FileOutputStream (target.toString());

        Properties p = new Properties();
        p.load (fin);
        p.store (fout, null);

        fin.close();
        fout.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    return status;
}

// Store properties into the specified target file.
private boolean BackupProperties (ICS ics, Properties p, String file, StringBuffer errors) {
    boolean status = true;

    String _timestamp = GetTimeStamp();

    LogDebugMessage ("Backing up ini file, " + file + ".");
    try {
        String abs_dir = ics.GetVar("IniDir") + "/" + genBackupSubDir + "/TS" + _timestamp;
        if (abs_dir != null) {
            File dir = new File (abs_dir);
            if (! dir.exists()) {
                if (! dir.mkdirs()) {
                    errors.append ("<li>ERROR: Failed to create the backup directory, " + dir);
                    status = false;
                }
            }
        }
        LogDebugMessage (file + ", being backed up under " + abs_dir);

        StringBuffer local_h_frags = new StringBuffer();
        local_h_frags.append ("\n");
        local_h_frags.append ("# These are original ini files backup by LDAP Integration Tool.\n");
        local_h_frags.append ("#\n");
        local_h_frags.append ("#");
        local_h_frags.append (header);

        String abs_filename = abs_dir + "/" + file;
        LogDebugMessage ("Backing up '" + file + "' to " + abs_filename);
        FileOutputStream out = new FileOutputStream(abs_filename);
        p.store(out, local_h_frags.toString());
        out.close();
    } catch (Exception e) {
        status = false;
        errors.append ("<li>ERROR: Failed to backup '" + file + "'. </li>");
        e.printStackTrace();
    }

    return status;
}

// Run checks on file ...
private boolean ValidateFile (String dir, String filename, boolean required, boolean create,
            StringBuffer final_path, StringBuffer errors) {

        LogDebugMessage ("Invoked ValidateFile (" +
            dir + ", " + filename + ", " + required + ", " + create +
            ", final_path, errors)" );

    boolean status = true;
    String abs_path = null;

    // Generate the file's absolute path
    if (filename != null) {
        if (dir != null) {
            abs_path = dir;
        }
        abs_path += "/" + filename;
    }

    // If the file is required and the absolute path happens to be NULL then
    if (required && (abs_path == null)) {
        errors.append ("<li>ERROR: Required file is set to NULL. </li>");
        status = false;
    }

    // Check for the file's existance, if required.
    if (status && (abs_path != null)) {
        boolean file_exists = new File (abs_path).exists();

        LogDebugMessage ("File, " + abs_path + ", exists ? = " + file_exists);

        if (! file_exists) {
            LogDebugMessage ("Phase 1");
            if (required) {
                if (! create) {
                    errors.append ("<li>ERROR: File, " + filename + ", could not be found. Please specify a valid ini directory" + "</li>");
                    status = false;
                } else {
                    LogDebugMessage ("Phase 2");
                    if (dir != null) {
                        LogDebugMessage ("Phase 3");
                        File d = new File (dir);

                        LogDebugMessage ("Directory, " + dir + ", exists ? = " + d.exists());

                        if (! d.exists()) {
                            LogDebugMessage ("Phase 4");
                            if (create) {
                                LogDebugMessage ("Phase 5");
                                LogDebugMessage ("Creating directory tree : " + dir);
                                // create the directories.
                                if (! d.mkdirs()) {
                                    LogDebugMessage ("Phase 6");
                                    LogDebugMessage ("Failed to create the directory " + dir);
                                }
                            }
                        }
                    }
                }
            } else {
                LogDebugMessage ("Phase 8");
                abs_path = null;
            }
        }
    }

    if (abs_path != null) {
        final_path.append (abs_path);
    }

    LogDebugMessage ("final_path = " + final_path);

    return status;
}

// This will look for the keys from map in src file and replace them with 
// value corresponding to key in map
private boolean ReplaceEntries (ICS ics, String src_dir, String src_filename, boolean src_file_required, boolean src_create,
                                String target_dir, String target_filename, boolean target_file_required, boolean target_create,
                                String encoding, HashMap map, StringBuffer errors) {

    boolean status = true;

    try {
        StringBuffer abs_src_file = new StringBuffer();
        StringBuffer abs_target_file = new StringBuffer();

        if ( ! ValidateFile (src_dir, src_filename, src_file_required, src_create, abs_src_file, errors)) {
            return false;
        }
        if (abs_src_file.length() == 0) {
            abs_src_file = null;
        }

        if ( ! ValidateFile (target_dir, target_filename, target_file_required, target_create, abs_target_file, errors)) {
            return false;
        }
        if (abs_target_file.length() == 0) {
            abs_target_file = null;
        }

        //
        // Backup the src file if one exists.
        //
        /*
        if ((abs_src_file != null) && (! BackupPropFile ())) {
        }
        */


        LogDebugMessage ("Invoking ReplaceEntries(" + abs_src_file +
                            ", " + abs_target_file +
                            ", map, errors).");
        if (! ReplaceEntries ( ics,
                (abs_src_file == null)?null:abs_src_file.toString(),
                (abs_target_file == null)?null:abs_target_file.toString(),
                map, errors)) {
            status = false;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return status;
}

// Add a specific error message
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

// Log the debug message
public void LogDebugMessage (String msg) {
    if (debugEnabled) {
        LogMessage ("DEBUG", msg);
    }
}

// Log the error message
public void LogErrorMessage (String msg) {
        LogMessage ("ERROR", msg);
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
debugEnabled            = false;
String encoding         = "ASCII";
String iniDir           = null;
String genIniDir        = null;
String tempDir          = null;
String currentIni       = null;
String resp             = null;
boolean has_errors      = false;
boolean sitesroles      = false;
StringBuffer errors     = new StringBuffer();
timestamp               = null;

// Override any defaults
String temp_str = null;

if (ics.GetVar("debug") != null) {
    debugEnabled = true;
}
if (ics.GetVar("IniDir") != null) {
    iniDir = ics.GetVar("IniDir");
    genIniDir = iniDir + "/" + genIniSubDir;
}
if (ics.GetVar("SitesRoles") != null) {
    sitesroles = true;
}

tempDir = iniDir + "/" + genTempSubDir + "/";

try {
    String hellourl = ics.GetProperty("cs.eventhost")+ics.GetProperty("ft.cgipath")+"HelloCS";
    FormPoster myFP = new FormPoster();                
    myFP.reset();
    myFP.setURL(hellourl);
    myFP.setAction(FormPoster.Get);   
    myFP.post();                    
    resp = myFP.getResponse();
}
catch(Exception e) {
    System.out.println("Unable to get information from FormPoster");
    resp = "Null Response";
}    

String respheader = resp.substring(resp.indexOf("FatWire"), resp.lastIndexOf("</font>"));

header = Utilities.replaceAll(respheader, "<br>\n", " ");

// Set/Reset the timestamp
SetTimeStamp();

// Generate the futuretense.ini file
currentIni = "futuretense.ini";
if (! has_errors) {
    errors = new StringBuffer();
    CopyIniFile (iniDir, currentIni, tempDir, null, false, errors);
    HashMap FTMap = new HashMap();
    if (! GenerateFTMap (ics, FTMap, errors)) {
        has_errors = true;
        AddMessage (ics, "ERRORS", errors.toString());
    } else {
        if (! ReplaceEntries (ics, tempDir, currentIni, true, false,
                genIniDir, currentIni, true, true,
                encoding, FTMap, errors)) {
            AddMessage (ics, "ERRORS", errors.toString());
            has_errors = true;
        }
    }
}

// Generate the dir.ini file
currentIni = "dir.ini";
if (! has_errors) {
    CopyIniFile (iniDir, currentIni, tempDir, null, false, errors);
    HashMap DIRMap = new HashMap();
    if (! GenerateDIRMap (ics, DIRMap, errors)) {
        has_errors = true;
        AddMessage (ics, "ERRORS", errors.toString());
    } else {
        if (! ReplaceEntries (ics, tempDir, currentIni, true, false,
                genIniDir, currentIni, true, true,
                encoding, DIRMap, errors)) {
            AddMessage (ics, "ERRORS", errors.toString());
            has_errors = true;
        }
    }
}

if (sitesroles) {
    // Generate the futuretense_xcel.ini file
    currentIni = "futuretense_xcel.ini";
    if (! has_errors) {
        CopyIniFile (iniDir, currentIni, tempDir, null, false, errors);
        HashMap FTXcelMap = new HashMap();
        if (! GenerateFTXcelMap (ics, FTXcelMap, errors)) {
            has_errors = true;
            AddMessage (ics, "ERRORS", errors.toString());
        } else {
            if (! ReplaceEntries (ics, tempDir, currentIni, true, false,
                    genIniDir, currentIni, true, true,
                    encoding, FTXcelMap, errors)) {
                AddMessage (ics, "ERRORS", errors.toString());
                has_errors = true;
            }
        }
    }
}

// Delete the temporary directory and all it's contents
// CAUTION: Never store anything important under the temporary directory
//          with recursive set to 'TRUE'.
if (! Delete (tempDir, true)) {
    LogErrorMessage ("Failed to delete the directory: '" + tempDir + "'");
}
%>

</cs:ftcs>
