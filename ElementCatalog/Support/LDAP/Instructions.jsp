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

<%!
// Message constants
public final static String kStatusHeader    = "StatusHeader";
public final static String kStatusMsg       = "StatusMsg";
public final static String kNotes           = "Notes";
public final static String kSteps           = "Steps";

// Constants common for pages that throw HTML
public final static String kNoOp            = "NoOperation";
public final static String kOpSuccess       = "OpSuccess";
public final static String kOpFail          = "OpFail";
public final static String kGO              = "GO";
public final static String kRollback        = "Rollback";

// To identify the stage where the request has come from.
public final static String kNoneStage       = "none";
public final static String kLoginStage      = "Stage1";
public final static String kSelectStage     = "Stage2";
public final static String kLDAPStage       = "Stage3";
public final static String kConfirmStage    = "Stage4";
public final static String kRollbackStage   = "Stage5";

// Constants specific to this page
public final static String kIniDir          = "IniDir";

// Instance variables
private String genIniSubDir                 = "Support/LDAP/Generated/ini";
private boolean debugEnabled                = false;
%>

<%!
// Set the appropriate messages based on the stage
private void SetStageMessages (ICS ics, String stage, String op, String opStatus) 
{
    if (stage.equals (kNoneStage)) 
    {
        // do Nothing
    } 
    else if (stage.equals (kLoginStage)) 
    {
        AddMessage (ics, kSteps, "<li>Enter the username and password to login to ContentServer.</li>");
        AddMessage (ics, kSteps, "<li>Make sure that you have directory.jar in classpath before proceeding</li>");
        AddMessage (ics, kSteps, "<li>Select 'Rollback' to delink from LDAP, only if you are currently integrated with LDAP and have used this tool to do so.</li>");
    }
    else if (stage.equals (kSelectStage))
    {
        AddMessage (ics, kSteps, "<li>Please Choose all that Apply</li>");
    }
    else if (stage.equals (kLDAPStage)) 
    {
        AddMessage (ics, kSteps, "<li>Read notes at the bottom of this page before proceeding.</li>");
        AddMessage (ics, kSteps, "<li>Read the <a href=\"ContentServer?pagename=Support/LDAP/IntegrationDoc\" > document </a> before using this tool.</li>");
        AddMessage (ics, kSteps, "<li>Make sure that you have entered the correct path for <i>'INI files directory'</i>.</li>");
        AddMessage (ics, kSteps, "<li>Fill in LDAP username and LDAP password only if you do not wish to allow anonymous access to LDAP.</li>");

        AddMessage (ics, kNotes, "<li>For Advanced options, select 'Advanced' and click 'Refresh'.</li>");
        AddMessage (ics, kNotes, "<li>This tool does not setup your LDAP with users and groups.</li>");
    } 
    else if (stage.equals (kRollbackStage)) 
    {
        //do Nothing
    } 
    else if (stage.equals (kConfirmStage)) 
    {
        // Set the status header
        if (opStatus.equals (kOpSuccess)) 
        {
            AddMessage (ics, kStatusHeader, "Congratulations !!");
        } 
        else if (opStatus.equals (kOpFail)) 
        {
            AddMessage (ics, kStatusHeader, "!! E R R O R !!");
        }

        // Set the status message
        if (op.equals (kGO)) 
        {
            AddMessage (ics, kStatusMsg, "You have successfully integrated CSEE with LDAP");

            String iniDir = (ics.GetVar(kIniDir) != null)?ics.GetVar(kIniDir):"'ini not set'";
            String genIniDir = (iniDir != null)?iniDir + "/" + genIniSubDir:"'ini not set'";

            AddMessage (ics, kNotes, "<li>In order to complete the integration follow the steps below.</li>");
            AddMessage (ics, kNotes, "<ul>");
            AddMessage (ics, kNotes, "<li>Stop the Application Server.</li>");
            AddMessage (ics, kNotes, "<li>Take backup of <i> futuretense.ini,dir.ini and futuretense_xcel.ini</i>,if using sites and roles integration in ldap, files under <i>" + iniDir + "</i></li>");
            AddMessage (ics, kNotes, "<li>Copy the generated ini files under <i>" + genIniDir + "</i> into <i>" + iniDir + "</i></li>");
            AddMessage (ics, kNotes, "<li>Restart your Application Server." + "</li>");
            AddMessage (ics, kNotes, "</ul>");
        } 
        else if (op.equals (kRollback)) 
        {
            AddMessage (ics, kStatusMsg, "Successfully rolled back the changes.");
            
            AddMessage (ics, kNotes, "<li>In order to complete the delink operation follow the steps below. </li>");
            AddMessage (ics, kNotes, "<ul>");
            AddMessage (ics, kNotes, "<li>Stop the Application Server.</li>");
            AddMessage (ics, kNotes, "<li>Replace the ini files with the files backed up after successful LDAP integration." + "</li>");
            AddMessage (ics, kNotes, "<li>Restart your Application Server." + "</li>");
            AddMessage (ics, kNotes, "<ul>");
        }
    }
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
debugEnabled        = false;
String stage        = kNoneStage;
String op           = kNoOp;
String opStatus     = kOpSuccess;
boolean rollback    = false;

// Override any defaults
if (ics.GetVar("debug") != null) {
    debugEnabled = true;
}
if (ics.GetVar("Stage") != null) {
    stage = ics.GetVar("Stage");
}
if (ics.GetVar("Operation") != null) {
    op = ics.GetVar("Operation");
}
if (ics.GetVar("OpStatus") != null) {
    opStatus = ics.GetVar("OpStatus");
}
if (ics.GetVar("Rollback") != null) {
    rollback = true;
}

String prevStage = (stage != null)?stage:kNoneStage;
String currentStage = prevStage;

// Based on the current request status, decide which screen will be rendered now
// so that we can show the relavent messages
if (prevStage.equals (kNoneStage)) 
{
    currentStage = kLoginStage;
} 
else if (rollback && prevStage.equals (kLoginStage)) 
{
    currentStage = kRollbackStage;
} 
else if ((! rollback) && prevStage.equals (kLoginStage)) 
{
    currentStage = kSelectStage;
} 
else if (prevStage.equals (kSelectStage)) 
{
    currentStage = kLDAPStage;
} 
else if (prevStage.equals (kLDAPStage)) 
{
    currentStage = kConfirmStage;
} 
else if (prevStage.equals (kRollbackStage)) 
{
    currentStage = kConfirmStage;
} 
else if (prevStage.equals (kConfirmStage)) 
{
    // currentStage = kLoginStage;
}

if (opStatus.equals(kOpFail)) 
{
    currentStage = prevStage;
}

LogDebugMessage ("Invoking >> SetStageMessages (ics, " + currentStage + ", " + op + ", " + opStatus + ")");
SetStageMessages (ics, currentStage, op, opStatus);
%>

</cs:ftcs>
