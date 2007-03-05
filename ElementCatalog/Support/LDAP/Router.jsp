<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>

<cs:ftcs>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>

<div class="left-column gray">
  <ul class="subnav divider">
    <a href="ContentServer?pagename=Support/LDAP/Integrate">Login</a>
  </ul>
</div>
<div class="right-column">
<%!
// Common Constants..
public static final String kPagename        = "pagename";
public final static String kDebug           = "debug";

// Message constants
public final static String kErrors          = "ERRORS";
public final static String kNotes           = "Notes";
public final static String kSteps           = "Steps";

// Constants common for pages that throw HTML
public final static String kOp              = "Operation";
public final static String kOpStatus        = "OpStatus";
public final static String kNoOp            = "NoOperation";
public final static String kOpSuccess       = "OpSuccess";
public final static String kOpFail          = "OpFail";
public final static String kClear           = "Clear";
public final static String kLogin           = "Login";
public final static String kGO              = "GO";
public final static String kRefresh         = "Refresh";
public final static String kRollback        = "Rollback";

// To identify the stage where the request has come from.
public final static String kStage           = "Stage";
public final static String kNoneStage       = "none";
public final static String kLoginStage      = "Stage1";
public final static String kSelectStage     = "Stage2";
public final static String kLDAPStage       = "Stage3";
public final static String kConfirmStage    = "Stage4";
public final static String kRollbackStage   = "Stage5";

public final static String kDirServer       = "DirServer";

private boolean debugEnabled                = false;
%>

<%!
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
boolean status      = true;
debugEnabled        = false;
String stage        = ics.GetVar(kStage);
String op           = ics.GetVar(kOp);
String ldserver     = ics.GetVar(kDirServer);
boolean rollback    = false;

FTValList args      = null;
String element      = null;

// Override any defaults    
if (ics.GetVar(kDebug) != null) {
    debugEnabled = true;
}
if (ics.GetVar(kStage) == null) {
    stage = kNoneStage;
}
if (ics.GetVar(kOp) == null) {
    op = kNoOp;
}
if (ics.GetVar(kRollback) != null) {
    rollback = true;
}

LogDebugMessage ("Stage=" + stage);
LogDebugMessage ("OP=" + op);
LogDebugMessage ("Rollback?=" + rollback);

// Add the JavaScript functions ...
element = "Support/LDAP/JSFunctions";
LogDebugMessage ("Now processing " + element);
if (! ics.CallElement (element, args)) {
    out.println ("ERROR: Failed to invoke JSFunctions.");
    status = false;
} else if (ics.GetVar(kErrors) != null) {
    status = false;
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Setting the status to false will make the same screen to show up with updates
// This is for 'Refresh' functionality
// Set the appropriate instruction based on the stage and the op status.
if (op.equals(kRefresh)) {
    status = false;
}
if (status) {
    AddMessage (ics, kOpStatus, kOpSuccess);
} else {
    AddMessage (ics, kOpStatus, kOpFail);
}
element = "Support/LDAP/Instructions";
LogDebugMessage ("Now processing " + element);
if (! ics.CallElement (element, args)) {
    out.println ("ERROR: Failed to invoke Instructions.");
    status = false;
} else if (ics.GetVar(kErrors) != null) {
    status = false;
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Render the CSLogin screen
element = "Support/LDAP/CSLoginScreen";
if ( ((!status) && stage.equals(kLoginStage)) ||
    (status && stage.equals(kNoneStage))
    ) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke CSLoginScreen.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Make sure that all the required jars are present
element = "Support/LDAP/CheckRequiredJars";
if (status && stage.equals(kLoginStage)) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke CheckRequiredJars.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Validate the CS credentials if the request has come from the CSLogin screen
element = "Support/LDAP/ValidateCSLogin";
if (status && (!stage.equals(kNoneStage))) {
// if (status && stage.equals(kLoginStage)) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke ValidateCSLogin.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Render the Rollback screen
element = "Support/LDAP/RollbackScreen";
if ( (status && stage.equals(kLoginStage) && rollback) ||
    ((! status) && stage.equals(kRollbackStage))
    ) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke RollbackScreen.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Render the SelectLDAP screen.
element = "Support/LDAP/SelectLDAP";
if (((! status) && stage.equals(kSelectStage)) ||
    (status && (! rollback) && stage.equals(kLoginStage))
    ) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke SelectLDAP.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Render the LDAPAD screen to accept values needed for LDAP integration.
element = "Support/LDAP/LDAPADScreen";
if (((! status) && stage.equals(kLDAPStage) && ldserver.equals("AD")) ||
    (status && stage.equals(kSelectStage) && (op.equals(kGO) && ldserver.equals("AD")))
    ) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke SelectLDAP.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Render the LDAPSun screen to accept values needed for LDAP integration.
element = "Support/LDAP/LDAPSunScreen";
if (((! status) && stage.equals(kLDAPStage) && ldserver.equals("SunOne")) ||
    (status && stage.equals(kSelectStage) && (op.equals(kGO) && ldserver.equals("SunOne")))
    ) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke SelectLDAP.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Generate Ini files
element = "Support/LDAP/GenerateINI";
if (status && 
    (stage.equals(kLDAPStage) && op.equals(kGO))
    ) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke GenerateINI.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");


// Update the UserPublication table
// if the request is for integration or rollback
element = "Support/LDAP/UpdateCatalogs";
if (status &&
    ( (stage.equals(kLDAPStage) && op.equals(kGO)) || 
      stage.equals(kRollbackStage) || 
      (stage.equals(kRollbackStage) && op.equals(kRollback)) )
    ) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke UpdateCatalogs.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");
    

// Render this screen when integration is complete
element = "Support/LDAP/StatusScreen";
if ( (status && (! op.equals(kRefresh)) && stage.equals(kLDAPStage)) ||
    (stage.equals(kConfirmStage) && op.equals(kRollback)) ||
    (status && stage.equals(kRollbackStage) && op.equals(kRollback)) ) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Failed to invoke FinalScreen.");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");
%>
</div>
<%
// Invoke the product footer - This will be printed all the time
element = "Support/Footer";
if (status) {
    LogDebugMessage ("Now processing " + element);

    if (! ics.CallElement (element, args)) {
        out.println ("ERROR: Couldn't render header info");
        status = false;
    } else if (ics.GetVar(kErrors) != null) {
        status = false;
    }
}
LogDebugMessage ("After [" + element + "], Status[" + status + "], Stage[" + stage + "]");    
%>
</div>
</body>
</html>

</cs:ftcs>
