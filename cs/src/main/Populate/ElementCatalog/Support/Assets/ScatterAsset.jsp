<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%//
// Support/Assets/ScatterAsset
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="java.util.*"
%><cs:ftcs><h3>Load Asset</h3>
<form method="GET">
<input type="hidden" name="pagename" value='<%= ics.GetVar("pagename") %>'/>
<input type="hidden" name="cmd" value='<%= ics.GetVar("cmd") %>'/>
Asset Type: <input type="text" name="assettype" /><br/>
Asset ID: <input type="text" name="assetid" /><br/>
<input type="submit" value="Submit"/><br/>
</form>
<br/>
<%
if (ics.GetVar("assettype") != null && !ics.GetVar("assettype").equals("") && ics.GetVar("assetid") != null && !ics.GetVar("assetid").equals("")) {
%>
<asset:load name="theAsset" type='<%=ics.GetVar("assettype")%>' objectid='<%=ics.GetVar("assetid")%>' />
<% if (ics.GetErrno() == 0) { %>
<asset:scatter name="theAsset" prefix="myAsset" /><br/>
<% } else { %>
Error Loading <%= ics.GetVar("assettype") %>:<%= ics.GetVar("assetid") %>!<br/>
<% }
}

String csString = "";
String assetString = "";
Enumeration e = ics.GetVars();

while ( e.hasMoreElements()) {
  String sVarName = (String)e.nextElement();
  String sVarValue = ics.GetVar( sVarName );
  if (sVarName.startsWith("myAsset:"))
    assetString += "<tr><td>" + sVarName.substring(8) + "</td><td>" + sVarValue + "</tr>";
  else
    csString += "<tr><td>" + sVarName + "</td><td>" + sVarValue + "</tr>";
 } %>

<% if (!assetString.equals("")) { %>
<br/><h3>Asset Variables (<%= ics.GetVar("assettype") %>:<%= ics.GetVar("assetid") %>)</h3>
<table class="altClass">
<%= assetString %>
</table>
<% } %>

<% if (!csString.equals("")) { %>
<br/><h3>Content Server Variables</h3>
<table class="altClass">
<%= csString %>
</table>
<% } %>

<br/><h3>Content Server SessionVariables</h3>
<table class="altClass">
<%
e = ics.GetSSVars();
while ( e.hasMoreElements()) {
  String sVarName = (String)e.nextElement();
  String sVarValue = ics.GetSSVar( sVarName );
%><tr><td><%= sVarName %></td><td><%= sVarValue %></tr>
<% } %>
</table>

</cs:ftcs>
