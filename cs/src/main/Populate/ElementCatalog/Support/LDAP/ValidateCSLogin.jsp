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

<cs:ftcs>

<%!
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

// Validate user
private boolean Login (ICS ics, String username, String password, StringBuffer error) {
    boolean status = true;

    ics.ClearErrno();
    FTValList inList = new FTValList();

    inList.setValString("ftcmd", "login");
    inList.setValString("username", username);
    inList.setValString("password", password);

    ics.CatalogManager(inList);
    int err = ics.GetErrno();
    if (err != 0) {
        status = false;
        error.append ("<li>ERROR [" + err + "] : Failed to login user '" + username + "'" + "</li>");
    }

    return status;
}
%>

<%
String csUsername = ics.GetVar("authusername");
String csPassword = ics.GetVar("authpassword");

if ((ics.GetVar("encrypt") != null) && (csPassword != null)) {
    csPassword = new dir().decrypt(csPassword);
}

StringBuffer errors = new StringBuffer();
if (! Login (ics, csUsername, csPassword, errors)) {
    AddMessage (ics, ics.GetVar("ERRORS"), errors.toString());
}
%>

</cs:ftcs>
