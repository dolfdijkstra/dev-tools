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
<%
// Defaults
String pagename = "Support/LDAP/Integrate";
String action = "ContentServer";

String csUsername = "ContentServer";

String kLoginStage = "Stage1";
boolean debugEnabled = false;

// Override Defaults
String errors = ics.GetVar("ERRORS");
String steps = ics.GetVar("Steps");

if (ics.GetVar("debug") != null) {
    debugEnabled = true;
}
%>
<!-- Present the login screen. -->
<form action="<%= action %>" method="post" onSubmit="return ValidateCSLoginScreen(this)">
<input type="hidden" name="pagename" value="<%= pagename %>"/>
<input type="hidden" name="Stage" value="<%= kLoginStage %>"/>

<% if (debugEnabled) { %>
    <input type="hidden" name="debug" value="<%= debugEnabled %>"/>
<% } %>

<% if (errors != null) { %>
    <table>
    <tr>
        <td><b><font color="#FF6666"><ul><%= errors %></ul></font></b></td>
    </tr>
    </table>
<% } %>

<% if (steps != null) { %>
    <table bgcolor="#dddddd">
        <tr><td align="left"><b><font color="#0000FF">Steps :</font></b></td></tr>
        <tr><td align="left"><font><ul><%= steps %></ul></font></td></tr>
    </table>
<% } %>
<br/>
<table style="border:none">
<tr>
    <td style="text-align:right; border:none"><b>Username</b></td>
    <td style="border:none"><input type="text" name="authusername" value="<%= csUsername %>"/></td>
</tr>
<tr>
    <td style="text-align:right; border:none"><b>Password</b></td>
    <td style="border:none"><input type="password" name="authpassword" value=""/></td>
</tr>
<tr>
    <td style="border:none">&nbsp;</td>
    <td style="border:none"><input type=submit name="Operation" value="Login"/>&nbsp;
    <input type=reset width="32" name="Operation" value="Clear"/></td>
</tr>
<tr>
    <td style="border:none">&nbsp;</td>
    <td style="border:none"><input type="checkbox" name="Rollback" value="true"/>&nbsp;
    <b>Rollback</b></td>
</tr>
</table>
</form>
<script language="JavaScript">
<![CDATA[
    document.LoginForm.authusername.focus();
]]>
</script>
</cs:ftcs>
