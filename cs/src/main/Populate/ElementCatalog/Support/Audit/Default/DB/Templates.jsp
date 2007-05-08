<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/DB/Templates
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

<center><h3>Templates</h3></center>

<%
ics.SetVar("cacheinfo","cacheinfo");
String version = ics.GetProperty("ft.version");
String majorversion = version.substring(0,1);
if (Integer.parseInt(majorversion) > 5) {
    ics.SetVar("cacheinfo", "cscacheinfo");
}
%>
<ics:sql sql="SELECT Publication.name as site, Template.subtype as subtype,Template.name as name ,Template.rootelement as rootelement FROM Template, AssetPublication, Publication WHERE Template.id = AssetPublication.assetid AND AssetPublication.pubid = Publication.id ORDER BY site,subtype,name" table="Template" listname="templates"/>

<table class="altClass">
<tr>
	<th>SiteCatalog</th>
	<th>RootElement</th>
	<th><%= ics.GetVar("cacheinfo")%></th>
    <% if (Integer.parseInt(majorversion) > 5) { %>
    <th>sscacheinfo</th>
    <% } %>
	<th>PageCriteria</th>
	<th>ResArgs</th>
</tr>
<ics:listloop listname="templates">
<tr>
	<% String pname = Utilities.replaceAll(ics.ResolveVariables("templates.site/templates.subtype/templates.name")," ","_"); %>
	<td><%= pname %></td>
	<td><ics:resolvevariables name="templates.rootelement"/></td>
	<ics:clearerrno/>
	<ics:sql sql='<%= "SELECT * FROM SiteCatalog WHERE pagename=\'" + pname + "\'" %>' table="SiteCatalog" listname="pages"/>
	<% if (ics.GetErrno() == 0){ %>
		<td><ics:resolvevariables name="pages.Variables.cacheinfo"/></td>
		<%
          StringBuffer ra = new StringBuffer();
          ra.append(ics.ResolveVariables("pages.resargs1"));
          if (ra.length() > 0 && Utilities.goodString(ics.ResolveVariables("pages.resargs2"))) {
              ra.append('&');
          }
          ra.append(ics.ResolveVariables("pages.resargs2"));
          java.util.Map map = Utilities.getParams(ra.toString());

          if (Integer.parseInt(majorversion) > 5) {
              %><td><ics:resolvevariables name="pages.sscacheinfo"/></td>
              <td><ics:resolvevariables name="pages.pagecriteria"/></td>
              <td><%= Utilities.stringFromValList(map) %></td><%
          } else {
              String pc = (String)map.remove("PageCriteria");
              %><td><%= (pc!=null?pc:"") %></td>
              <td><%= Utilities.stringFromValList(map) %></td><%
          }
		%>
	<% } %>
</tr>
</ics:listloop>
</table>

</cs:ftcs>
