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
%>

<%
// Defaults ....
String pagename             = "Support/LDAP/Integrate";
String action               = "ContentServer";

String kLDAPStage           = "Stage3";

String authUsername         = null;
String authPassword         = null;

String ldapUsername         = "";
String ldapPassword         = "";

String ldapPlugin           = "com.openmarket.directory.jndi.auth.JNDILogin";
String ldapHost             = "localhost";
String ldapPort             = "389";

String peopleDN             = "CN=Users";
String groupsDN             = "CN=Users";
String rootDN               = "DC=fatwire,DC=com";

String dirIDir              = "com.openmarket.directory.jndi.JNDIDir";
String dirIName             = "com.openmarket.directory.jndi.NameWrapper";
String defaultPeopleAttrs   = "objectClass=top&objectClass=person&objectClass=organizationalPerson&objectClass=user";
String defaultGroupsAttrs   = "objectClass=top&objectClass=group";
String reqPeopleAttrs       = "givenName=First Name&sn=Last Name&cn=Full&mail=mail";
String authType             = "simple";

String usernameAttr         = "sAMAccountName";
String passwordAttr         = "userPassword";
String cnAttr               = "CN";
String loginAttr            = "CN";
String old_peopleDN         = "ou=People";
String old_usernameAttr     = "userid";

String iniDir               = "/FutureTense/futuretense/";

String xcelUserclass        = "com.openmarket.xcelerate.user.LDAPSchemaUserManager";
String xcelSitesroot        = "CN=Sites";
String xcelSitenameattr     = "CN";

String notes                = null;
String errors               = null;
String steps                = null;

String encoding             = "";
String scope                = "2";

boolean anonymousAccess     = true;
boolean debugEnabled        = false;
boolean advanced_flag       = false;
boolean sitesroles_flag     = false;
boolean encrypt             = false;

// Override the defaults here
String temp_str = null;

if (ics.GetVar("encrypt") != null) {
    encrypt = true;
}
temp_str = ics.GetVar("authusername");
if (temp_str != null) {
    authUsername = temp_str;
}
temp_str = ics.GetVar("authpassword");
if (temp_str != null) {
    authPassword = (encrypt)?temp_str:new dir().encrypt(temp_str);
    encrypt = true;
}
if (ics.GetVar("LDAPUsername") != null) {
    ldapUsername = ics.GetVar("LDAPUsername");
}
if (ics.GetVar("LDAPPassword") != null) {
    ldapPassword = ics.GetVar("LDAPPassword");
}
if (ics.GetVar("anonymousAccess") != null) {
    anonymousAccess = true;
}
if (ics.GetVar("Host") != null) {
    ldapHost = ics.GetVar("Host");
}
if (ics.GetVar("Port") != null) {
    ldapPort = ics.GetVar("Port");
}
if (ics.GetVar("LDAPPlugin") != null) {
    ldapPlugin = ics.GetVar("LDAPPlugin");
}
if (ics.GetVar("PeopleDN") != null) {
    peopleDN = ics.GetVar("PeopleDN");
}
if (ics.GetVar("GroupsDN") != null) {
    groupsDN = ics.GetVar("GroupsDN");
}
if (ics.GetVar("RootDN") != null) {
    rootDN = ics.GetVar("RootDN");
}
if (ics.GetVar("OldPeopleDN") != null) {
    old_peopleDN = ics.GetVar("OldPeopleDN");
}
if (ics.GetVar("OldUsernameAttr") != null) {
    old_usernameAttr = ics.GetVar("OldUsernameAttr");
}
if (ics.GetVar("IniDir") != null) {
    iniDir = ics.GetVar("IniDir");
}
temp_str = ics.GetVar("ERRORS");
if ((temp_str != null) && (temp_str.length() != 0)) {
    errors = temp_str;
}
temp_str = ics.GetVar("Steps");
if ((temp_str != null) && (temp_str.length() != 0)) {
    steps = temp_str;
}
temp_str = ics.GetVar("Notes");
if ((temp_str != null) && (temp_str.length() != 0)) {
    notes = temp_str;
}
if (ics.GetVar("Encoding") != null) {
    encoding = ics.GetVar("Encoding");
}
if (ics.GetVar("SearchScope") != null) {
    scope = ics.GetVar("SearchScope");
}
if (ics.GetVar("debug") != null) {
    debugEnabled = true;
}
if (ics.GetVar("advanced") != null) {
    advanced_flag = true;
}

// Advanced
if (ics.GetVar("UsernameAttr") != null) {
    usernameAttr = ics.GetVar("UsernameAttr");
}
if (ics.GetVar("PasswordAttr") != null) {
    passwordAttr = ics.GetVar("PasswordAttr");
}
if (ics.GetVar("CNameAttr") != null) {
    cnAttr = ics.GetVar("CNameAttr");
}
if (ics.GetVar("LoginAttr") != null) {
    loginAttr = ics.GetVar("LoginAttr");
}
if (ics.GetVar("DirIDir") != null) {
    dirIDir = ics.GetVar("DirIDir");
}
if (ics.GetVar("DirIName") != null) {
    dirIName = ics.GetVar("DirIName");
}
if (ics.GetVar("DefaultPeopleAttrs") != null) {
    defaultPeopleAttrs = ics.GetVar("DefaultPeopleAttrs");
}
if (ics.GetVar("DefaultGroupsAttrs") != null) {
    defaultGroupsAttrs = ics.GetVar("DefaultGroupsAttrs");
}
if (ics.GetVar("RequiredPeopleAttrs") != null) {
    reqPeopleAttrs = ics.GetVar("RequiredPeopleAttrs");
}
if (ics.GetVar("authtype") != null) {
    authType = ics.GetVar("authtype");
}

if (ics.GetVar("SitesRoles") != null) {
    sitesroles_flag = true;
}

//SiteRoles
if (ics.GetVar("xcelUserclass") != null) {
    usernameAttr = ics.GetVar("xcelUserclass");
}
if (ics.GetVar("xcelSitesroot") != null) {
    passwordAttr = ics.GetVar("xcelSitesroot");
}
if (ics.GetVar("xcelSitenameattr") != null) {
    cnAttr = ics.GetVar("xcelSitenameattr");
}
%>

<form action="<%= action %>" method="post" onSubmit="return ValidateLDAPScreen(this)">
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
<% } %>
<hr WIDTH="100%">

<input type="hidden" name="pagename" value="<%= pagename %>"/>
<input type="hidden" name="Stage" value="<%= kLDAPStage %>"/>

<input type="hidden" name="authusername" value="<%= authUsername %>"/>
<input type="hidden" name="authpassword" value="<%= authPassword %>"/>

<input type="hidden" name="DirServer" value="<%= ics.GetVar("DirServer") %>"/>

<% if (sitesroles_flag) { %>
    <input type="hidden" name="SitesRoles" value="<%= sitesroles_flag %>"/>
<% } %>

<% if (encrypt) { %>
    <input type="hidden" name="encrypt" value="true"/>
<% } %>

<% if (debugEnabled) { %>
    <input type="hidden" name="debug" value="<%= debugEnabled %>"/>
<% } %>

<% if (!advanced_flag) { %>
    <input type="hidden" name="UsernameAttr" value="<%= usernameAttr %>"/>
    <input type="hidden" name="PasswordAttr" value="<%= passwordAttr %>"/>
    <input type="hidden" name="CNameAttr" value="<%= cnAttr %>"/>
    <input type="hidden" name="LoginAttr" value="<%= loginAttr %>"/>
    <input type="hidden" name="OldPeopleDN" value="<%= old_peopleDN %>"/>
    <input type="hidden" name="OldUsernameAttr" value="<%= old_usernameAttr %>"/>
    <input type="hidden" name="LDAPPlugin" value="<%= ldapPlugin %>"/>
    <input type="hidden" name="authtype" value="<%= authType %>"/>
    <input type="hidden" name="RequiredPeopleAttrs" value="<%= reqPeopleAttrs%>"/>
    <input type="hidden" name="DefaultGroupsAttrs" value="<%= defaultGroupsAttrs %>"/>
    <input type="hidden" name="DefaultPeopleAttrs" value="<%= defaultPeopleAttrs %>"/>
    <input type="hidden" name="DirIName" value="<%= dirIName %>"/>
    <input type="hidden" name="DirIDir" value="<%= dirIDir %>"/>

    <% if (sitesroles_flag) { %>
        <input type="hidden" name="XcelUserclass" value="<%= xcelUserclass %>"/>
        <input type="hidden" name="XcelSitesroot" value="<%= xcelSitesroot %>"/>
        <input type="hidden" name="XcelSitenameattr" value="<%= xcelSitenameattr %>"/>
<%     } %>
<% } %>

<div id="bdcolor"><br/>
<center><table cols=2 width="60%" style="border:none">

<tr>
<td>
<div align=right><b>LDAP Username&nbsp;</b><br/>(Please add full distinguished username)</div>
</td>

<td><input type="text" SIZE="32" name="LDAPUsername" value="<%= ldapUsername %>"/></td>
</tr>

<tr>
<td>
<div align=right><b>LDAP Password&nbsp;</b></div>
</td>

<td><input type="password" SIZE="32" name="LDAPPassword" value="<%= ldapPassword %>"/></td>
</tr>

<tr>
<td>
<div align=right><b>Allow Anonymous Access&nbsp;</b><br/>(Check if anonymous access is allowed)</div>
</td>

<td><input type="checkbox" <% if (anonymousAccess) { %> CHECKED <% } %>name="anonymousAccess" value="true"/ ></td>
</tr>

<tr>
<td>
<div align=right><b>LDAP Host&nbsp;</b></div>
</td>

<td><input type="text" SIZE="32" name="Host" value="<%= ldapHost %>"/></td>
</tr>

<tr>
<td>
<div align=right><b>LDAP Port&nbsp;</b></div>
</td>

<td><input type="text" SIZE="32" name="Port" value="<%= ldapPort %>"/></td>
</tr>

<tr>
<td>
<div align=right><b>People DN&nbsp;</b></div>
</td>

<td><input type="text" SIZE="32" name="PeopleDN" value="<%= peopleDN %>"/></td>
</tr>

<tr>
<td>
<div align=right><b>Groups DN&nbsp;</b></div>
</td>

<td><input type="text" SIZE="32" name="GroupsDN" value="<%= groupsDN %>"/></td>
</tr>

<tr>
<td>
<div align=right><b>Root DN&nbsp;</b></div>
</td>

<td><input type="text" SIZE="32" name="RootDN" value="<%= rootDN %>"/></td>
</tr>

<tr>
<td>
<div align=right><b>INI files Directory &nbsp;</b></div>
</td>

<td><input type="text" SIZE="32" name="IniDir" value="<%= iniDir %>"/></td>
</tr>

<% if (advanced_flag) { %>
    <tr>
    <td colspan="2">
    <div align=left><b><u>Advanced Options :&nbsp;</u></b></div>
    </td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Username Attr.&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="UsernameAttr" value="<%= usernameAttr %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Password Attr.&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="PasswordAttr" value="<%= passwordAttr %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Common Name Attr.&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="CNameAttr" value="<%= cnAttr %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>LoginAttribute Attr.&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="LoginAttr" value="<%= loginAttr %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Old Username Attr.&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="OldUsernameAttr" value="<%= old_usernameAttr %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Old People DN&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="OldPeopleDN" value="<%= old_peopleDN %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>LDAP Plugin Class&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="LDAPPlugin" value="<%= ldapPlugin %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>LDAP IDir&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="DirIDir" value="<%= dirIDir %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>LDAP IName&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="DirIName" value="<%= dirIName %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Default People Attrs.&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="DefaultPeopleAttrs" value="<%= defaultPeopleAttrs %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Default Groups Attrs.&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="DefaultGroupsAttrs" value="<%= defaultGroupsAttrs %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Required People Attrs.&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="RequiredPeopleAttrs" value="<%= reqPeopleAttrs %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>LDAP Auth Type&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="authtype" value="<%= authType %>"/></td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Search at&nbsp;</b></div>
    </td>

    <td>
        <select name="SearchScope">
            <option value="1" <%= scope.equals("1")?"SELECTED":"" %>>One Level</option>
            <option value="2" <%= scope.equals("2")?"SELECTED":"" %>>Sub Tree</option>
        </select>
    </td>
    </tr>

    <tr>
    <td>
    <div align=right><b>Character Encoding&nbsp;</b></div>
    </td>

    <td><input type="text" SIZE="32" name="Encoding" value="<%= encoding!=null?encoding:"" %>"/></td>
    </tr>

    <% if (sitesroles_flag) { %>
        <tr>
        <td colspan="2">
        <div align=left><b><u>SiteRoles Options :&nbsp;</u></b></div>
        </td>
        </tr>

        <tr>
        <td>
        <div align=right><b>UserManagerClass&nbsp;</b></div>
        </td>
    
        <td><input type="text" SIZE="32" name="XcelUserclass" value="<%= xcelUserclass %>"/></td>
        </tr>
    
        <tr>
        <td>
        <div align=right><b>SitesRoot&nbsp;</b></div>
        </td>
    
        <td><input type="text" SIZE="32" name="XcelSitesroot" value="<%= xcelSitesroot %>"/></td>
        </tr>
    
        <tr>
        <td>
        <div align=right><b>SiteName Attr&nbsp;</b></div>
        </td>
    
        <td><input type="text" SIZE="32" name="XcelSitenameattr" value="<%= xcelSitenameattr %>"/></td>
        </tr>
    <% } %>

<% } %>

<tr>
<td>
<div align=right><b>Advanced&nbsp;</b></div>
</td>

<td><input type="checkbox" <% if (advanced_flag) { %> CHECKED <% } %>name="advanced" value="true"/ ></td>
</tr>

</table></center>
<br/></div>

<center>
<p><input type="submit" name="Operation" value="GO" />&nbsp;
<input type="submit" name="Operation" value="Refresh" />&nbsp;
<input type="reset" name="Operation" value="Clear"/>
</center>

</form>
<p>
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
