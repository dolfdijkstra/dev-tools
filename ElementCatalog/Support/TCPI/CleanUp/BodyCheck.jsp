<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/CleanUp/BodyCheck
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
%><%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<html>
<ics:callelement element="Support/stylecss"/>
<body topmargin="0">
<ics:callelement element="Support/TCPI/Header"/>

<%
String tblName = ics.GetVar("tblname");
String url="";
String defdir=null;

defdir= ics.ResolveVariables("CS.CatalogDir.Variables.tblname");
defdir= Utilities.osSafeSpec(defdir);
defdir= new java.io.File(defdir).getCanonicalPath();
if (defdir.charAt(defdir.length()-1) != java.io.File.separatorChar) {
	defdir = defdir.concat(java.io.File.separator);
}
if (ics.GetVar("start") == null) {ics.SetVar("start","0");}
String sqlStatement="SELECT Variables.col, table.KEY AS akey FROM Variables.tblname WHERE Variables.col IS NOT NULL AND table.KEY > Variables.start ORDER BY akey" ; 
String sqlCountStatementUrl="SELECT COUNT(DISTINCT Variables.col) AS num FROM Variables.tblname WHERE Variables.col IS NOT NULL AND table.KEY > Variables.start" ; 

String sqlCountStatement="SELECT COUNT(*) AS num FROM Variables.tblname" ; 
%>

<h2>Are all the urlbodies of the entries in <i><%= tblName %></i> present on disk?</h2>
defdir: <b><%= defdir %></b>

<ics:sql sql='<%= ics.ResolveVariables(sqlCountStatement) %>' table='<%= tblName %>' listname="count" />
<ics:clearerrno/>
<ics:catalogdef listname="table" table='<%= tblName %>'/>

<%
if (Utilities.goodString(ics.GetVar("col"))) {
	int numrows = 0;
%>
    <hr/>limiting to <ics:getvar name="limit" /> rows per upload field.
	<h4>upload field: <ics:resolvevariables name="Variables.col" /></h4>
	<ics:sql sql='<%= ics.ResolveVariables(sqlCountStatementUrl) %>' table='<%= tblName %>' listname="count" />
	Number of rows in table for <ics:resolvevariables name="Variables.col" />: <ics:resolvevariables name="count.num" /><br/>

	<ics:clearerrno />
	<ics:sql sql='<%= ics.ResolveVariables(sqlStatement) %>' table='<%= tblName %>' listname="bodies" limit='<%= ics.GetVar("limit") %>'/>
	<%
	if (ics.GetErrno() == 0){
		boolean foundBad=false;
	%>
		<table class="altClass">
		<ics:listloop listname="bodies">
			<%
			numrows++;
			url = ics.ResolveVariables("bodies."+ics.ResolveVariables("Variables.col"));
			if (Utilities.goodString(url) && !Utilities.fileExists(defdir + url)) {
				foundBad=true;
				%><tr>
					<td><ics:resolvevariables name="bodies.#curRow" /></td>
					<td><ics:resolvevariables name="bodies.akey" /></td>
					<td><ics:resolvevariables name="Variables.col" /></td>
					<td><%= url %></td>
					<td><b>NOT FOUND</b></td>
				</tr>
				<%
			}
			%>
		</ics:listloop>	
		</table>
        <%
        if (numrows==500) { %>
            <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tblname=<ics:getvar name="tblname"/>&limit=<ics:getvar name="limit"/>&col=<ics:getvar name="col"/>&start=<ics:resolvevariables name="bodies.akey" />'>Next <ics:getvar name="limit"/> rows for <ics:getvar name="col"/></a><br/>
        <% } %>
        <%
		if (numrows > 0 && !foundBad){
			%>Scanned <%=numrows %> urlbodies and all were fine!<br><%
		}
	} else if (ics.GetErrno() == -101) {
		%>All the columns for <b><ics.resolvevariables name="Variables.col" /></b> were empty.<br><%
	} else {
		%>Error no is: <%= ics.GetErrno() %><br><%
	}
}
%>

<hr/><div class="xleft">Number of rows in table: <ics:resolvevariables name="count.num" /></div>

<table class="altClass">
	<tr>
		<th>Colname</th>
		<th>Coltype</th>
		<th>Colsize</th>
		<th>Key</th>
	</tr>
	<ics:listloop listname="table" >
		<tr>
			<% if (" (upload):".equals(ics.ResolveVariables("table.COLTYPE"))) {		
                %><td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tblname=<ics:getvar name="tblname"/>&limit=<ics:getvar name="limit"/>&col=<ics:listget listname="table" fieldname="COLNAME"/>'><ics:listget listname="table" fieldname="COLNAME"/></a></td>
			<% } else {
				%><td><ics:listget listname="table" fieldname="COLNAME"/></td>
			<% } %>
			<td><ics:listget listname="table" fieldname="COLTYPE"/></td>
			<td align="right"><ics:listget listname="table" fieldname="COLSIZE"/></td>
			<td align="right"><ics:listget listname="table" fieldname="KEY"/></td>
		</tr>
	</ics:listloop>
</table>

<ics:callelement element="Support/Footer"/>
</body>
</html>
</cs:ftcs>
