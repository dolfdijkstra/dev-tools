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
// Instance variables
private boolean debugEnabled                = false;
%>

<%
// Default values
String pagename     = "Support/LDAP/Integrate";

String kLDAPStage       = "Stage3";
String kRollbackStage   = "Stage5";

String authUsername = null;
String authPassword = null;

String status_header    = "Status Header NOT Set";
String status_message   = "Status Message NOT Set";
String notes        = null;
String steps        = null;
String errors       = null;

String iniDir       = null;

String op           = null;
String stage        = null;

debugEnabled        = false;
boolean encrypt     = false;

// Override any defaults
String temp_str = null;

if (ics.GetVar("encrypt") != null) {
    encrypt = true;
}
if (ics.GetVar("authusername") != null) {
    authUsername = ics.GetVar("authusername");
}
temp_str = ics.GetVar("authpassword");
if (temp_str != null) {
    authPassword = (encrypt)?temp_str:new dir().encrypt(temp_str);
    encrypt = true;
}
if (ics.GetVar("debug") != null) {
    debugEnabled = true;
}
if (ics.GetVar("ERRORS") != null) {
    errors = ics.GetVar("ERRORS");
}
if (ics.GetVar("StatusHeader") != null) {
    status_header = ics.GetVar("StatusHeader");
}
if (ics.GetVar("StatusMsg") != null) {
    status_message = ics.GetVar("StatusMsg");
}
if (ics.GetVar("Notes") != null) {
    notes = ics.GetVar("Notes");
}
if (ics.GetVar("Steps") != null) {
    steps = ics.GetVar("Steps");
}
if (ics.GetVar("Operation") != null) {
    op = ics.GetVar("Operation");
}
if (ics.GetVar("Stage") != null) {
    stage = ics.GetVar("Stage");
}
if (ics.GetVar("IniDir") != null) {
    iniDir = ics.GetVar("IniDir");
}
%>

<p>
<% if (errors != null) { %>
    <center><table COLS=1 WIDTH="60%" BGCOLOR="#FFFFFF" >
    <tr BGCOLOR="#FFFF00">
    <td BGCOLOR="#FFFFCC"><b><font color="#FF6666"><ul><%= errors %></ul></font></b></td>
    </tr>
    </table></center>
    <hr WIDTH="100%">
<% } %>

<% if (steps != null) { %>
    <center><table COLS=1 WIDTH="60%" BGCOLOR="#DDDDDD" >
    <td ALIGN="left"><b><font color="#0000FF">Steps :</font></b></td>
    </tr>
    <td ALIGN="left"><ul><%= steps %></ul></font></td>
    </tr>
    </table></center>
    <hr WIDTH="100%">
<% } %>


<br>&nbsp;
<center><table COLS=1 WIDTH="60%" >
<tr>
<td WIDTH="100%" BGCOLOR="#3366FF">
<center><b><blink><font color="#FFFF00"><font size=+2><%= status_header
%>&nbsp;</font></font></blink></b>
<p><b><font color="#FFFF00"><font size=+1><%= status_message %>&nbsp;</font></font></b></center>
</td>
</tr>
</table></center>

<%
if ((stage != null) && stage.equals(kLDAPStage)) 
{
    StringBuffer rollbackURL = new StringBuffer();
    rollbackURL.append ("ContentServer");
    rollbackURL.append ("?" + "pagename=" + pagename);
    rollbackURL.append ("&" + "Operation=Rollback");
    rollbackURL.append ("&" + "Stage=" + kRollbackStage);
    rollbackURL.append ("&" + "IniDir=" + iniDir);
    if (debugEnabled) 
    {
        rollbackURL.append ("&" + "debug=" + "true");
    }
    rollbackURL.append ("&" + "authusername=" + authUsername);
    rollbackURL.append ("&" + "authpassword=" + authPassword);
    if (encrypt) 
    {
        rollbackURL.append ("&" + "encrypt=" + "true");
    }
%>
    <center><table COLS=1 WIDTH="60%" >
    <tr><td WIDTH="100%" ALIGN="right">
        Click here to <a hRef="<%= rollbackURL.toString() %>"> Rollback </a> .
    </td></tr>
    </table></center>
<%
} 
else 
{
    StringBuffer loginURL = new StringBuffer();
    loginURL.append ("ContentServer");
    loginURL.append ("?" + "pagename=Support/LDAP/Integrate");
    if (debugEnabled) 
    {
        loginURL.append ("&" + "debug=" + "true");
    }
%>
    <center><table COLS=1 WIDTH="60%" >
    <tr><td WIDTH="100%" ALIGN="right">
        Return to <a hRef="<%= loginURL.toString() %>"> Login Page </a> .
    </td></tr>
    </table></center>
<% } %>

<br>
<hr WIDTH="100%">

<% if (notes != null) { %>
    <center><table COLS=1 WIDTH="60%" BGCOLOR="#DDDDDD" >
    <td ALIGN="left"><b><font color="#0000FF">Notes :</font></b></td>
    </tr>
    <td ALIGN="left"><ul><%= notes %></ul></font></td>
    </tr>
    </table></center>
<% } %>

</cs:ftcs>
