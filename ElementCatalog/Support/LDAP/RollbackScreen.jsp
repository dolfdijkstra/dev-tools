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
private boolean debugEnabled    = false;
%>

<%
// Defaults ....
String pagename         = "Support/LDAP/Integrate";
String action           = "ContentServer";

String kRollbackStage   = "Stage5";

String authUsername     = null;
String authPassword     = null;

String errors           = null;
String steps            = null;

String iniDir           = "";

debugEnabled            = true;
boolean encrypt         = false;

// Override the defaults here
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
if (ics.GetVar("ERRORS") != null) {
    errors = ics.GetVar("ERRORS");
}
if (ics.GetVar("Steps") != null) {
    steps = ics.GetVar("Steps");
}
if (ics.GetVar("IniDir") != null) {
    iniDir = ics.GetVar("IniDir");
}
if (ics.GetVar("debug") != null) {
    debugEnabled = true;
}
%>

<p><form action="<%= action %>" method="post" onSubmit="return ValidateRollbackScreen(this)">

<input type="hidden" name="pagename" value="<%= pagename %>"/>
<input type="hidden" name="Stage" value="<%= kRollbackStage %>"/>

<% if (debugEnabled) { %>
    <input type="hidden" name="debug" value="<%= debugEnabled %>"/>
<% } %>

<input type="hidden" name="authusername" value="<%= authUsername %>"/>
<input type="hidden" name="authpassword" value="<%= authPassword %>"/>

<% if (encrypt) { %>
    <input type="hidden" name="encrypt" value="true"/>
<% } %>

<% if (errors != null) { %>
    <center><table COLS=1 WIDTH="60%" BGCOLOR="#FFFFFF" >
    <tr BGCOLOR="#FFFF00">
    <td BGCOLOR="#FFFFCC"><b><font color="#FF6666"><ul><%= errors %></ul></font></b></td>
    </tr>
    </table></center>
    <hr WIDTH="100%">
<% } %>

<br>&nbsp;
<center><table COLS="2">

<tr>
<td>
<div align=right><b>INI files directory&nbsp;</b></div>
</td>

<td><input type="text" SIZE="32" name="IniDir" value="<%= iniDir %>"/></td>
</tr>


<tr ALIGN="CENTER">
<td COLSPAN="2"> <br>
    <input type=submit name="Operation" value="Rollback"/>&nbsp;&nbsp;
    <input type=reset name="Operation" value="Clear"/>
</td>
</tr>
</table></center>
</form>
<p>

<hr WIDTH="100%">

</cs:ftcs>
