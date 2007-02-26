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

<%
// Defaults
String pagename             = "Support/LDAP/Integrate";
String action               = "ContentServer";

String kSelectStage         = "Stage2";

String authUsername         = null;
String authPassword         = null;
String steps                = null;
String errors               = null;

boolean encrypt             = false;
boolean debugEnabled        = false;

//Override defaults ....
String temp_str = null;

temp_str = ics.GetVar ("Steps");
if ((temp_str != null) && (temp_str.length() != 0)) {
    steps = temp_str;
}
if (ics.GetVar("ERRORS") != null) {
    errors = ics.GetVar("ERRORS");
}
if (ics.GetVar("debug") != null) {
    debugEnabled = true;
}
if (ics.GetVar("authusername") != null) {
    authUsername = ics.GetVar("authusername");
}
temp_str = ics.GetVar("authpassword");
if (temp_str != null) {
    authPassword = (encrypt)?temp_str:new dir().encrypt(temp_str);
    encrypt = true;
}
%>

<form action="<%= action %>" method="post">

<% if (errors != null) { %>
    <table bgcolor="#FFFFFF">
    <tr bgcolor="#FFFF00">
        <td bgcolor="#FFFFCC"><b><font color="#FF6666"><ul><%= errors %></ul></font></b></td>
    </tr>
    </table>
    <hr/>
<% } %>

<% if (steps != null) { %>
    <table bgcolor="#dddddd" >
        <tr><td align="left"><b><font color="#0000FF">Steps :</font></b></td></tr>
        <tr><td align="left"><ul><%= steps %></ul></font></td></tr>
    </table>
<% } %>
<hr/>
<input type="hidden" name="pagename" value="<%= pagename %>"/>
<input type="hidden" name="Stage" value="<%= kSelectStage %>"/>

<input type="hidden" name="authusername" value="<%= authUsername %>"/>
<input type="hidden" name="authpassword" value="<%= authPassword %>"/>

<% if (encrypt) { %>
    <input type="hidden" name="encrypt" value="true"/>
<% } %>

<% if (debugEnabled) { %>
    <input type="hidden" name="debug" value="<%= debugEnabled %>"/>
<% } %>
<div id="bdcolor"><br/>
<div class="dtable">
<div class="smbox">
<h3><span>Select</span></h3>
<table style="border:none">
    <tr>
        <td style="text-align:right"><b>Select Directory Server:</b></td>
        <td><input type="radio" name="DirServer" value="SunOne" checked="true" />
        &nbsp;<b>SunOne Directory Server</b><br/>
        <input type="radio" name="DirServer" value="AD" />
        &nbsp;<b>Active Directory</b></td>
    </tr>
    <tr>
        <td  style="text-align:right"><b>Optional:</b></td>
        <td><input type="checkbox" name="SitesRoles" value="true"/>
        &nbsp;<b>Sites and Roles Integration</b></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td><input type="submit" name="Operation" value="GO"/>&nbsp;
        <input type="reset" width="32" name="Operation" value="Clear"/></td>
    </tr>
</table>
</div>
</div>
<br/></div>
</form>

</cs:ftcs>
