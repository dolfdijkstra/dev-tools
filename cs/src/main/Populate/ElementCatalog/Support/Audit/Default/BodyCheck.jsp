<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Audit/Default/BodyCheck
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
%><%@ page import="java.io.*"%>
<%!
private void fileRollup(JspWriter out, String urlfile, String path, String tblname, String limit, String column, String key, String start) {
	try {
		out.print("<font color=\"green\">Delete Current Row: </font>");
		out.print("&nbsp;<a href=\"ContentServer?pagename=Support/Audit/Default/BodyCheck&tblname="+tblname+"&limit="+limit+"&col="+column+"&start="+start+"&deleteme=yes\">DeleteMe</a><br/>");

		String filename = Utilities.fileFromSpec(urlfile);
		String xfile = null;
		if (filename.lastIndexOf(",") > 0)
			xfile = filename.substring(0,filename.lastIndexOf(","));
		else
			xfile = filename.substring(0,filename.lastIndexOf("."));

		String dirname = urlfile.substring(0,urlfile.lastIndexOf(filename));
		String oldpath = path+dirname+filename;

		File dirfiles = new File(path+dirname);
		String[] files = dirfiles.list();

		if (files.length > 0)
			out.print("<font color=\"orange\">File Rollups: </font>");

		for (int j=0; j<files.length; j++) {
			String yfile = null;
			if (Utilities.isFolder(path+dirname+files[j])!=0) {
				if (files[j].lastIndexOf(",") < 0)
					yfile = files[j].substring(0,files[j].lastIndexOf("."));
				else
					yfile = files[j].substring(0,files[j].lastIndexOf(","));

				if (xfile.equalsIgnoreCase(yfile)) {
					String newpath = path+dirname+files[j];
					out.print("<font color=\"orange\">"+files[j]+"</font>");
					out.print("&nbsp;<a href=\"ContentServer?pagename=Support/Audit/Default/BodyCheck&tblname="+tblname+"&limit="+limit+"&col="+column+"&filespec="+newpath+"&filepath="+oldpath+"&start="+start+"&useme=yes\">UseMe</a><br/>");
				}
			}
		}
	} catch (Exception e) {
		//out.println(e.printStackTrace());
	}
}
%>
<cs:ftcs>
<div class="right-column"><%

	String tblName = ics.GetVar("tblname");
	String url="";
	String defdir=null, nonidkey=null;
	String thisPage = ics.GetVar("pagename");
	String start = ics.GetVar("start");

	defdir= ics.ResolveVariables("CS.CatalogDir.Variables.tblname");
	defdir= Utilities.osSafeSpec(defdir);
	defdir= new java.io.File(defdir).getCanonicalPath();
	if (defdir.charAt(defdir.length()-1) != java.io.File.separatorChar) {
		defdir = defdir.concat(java.io.File.separator);
	}

	ics.ClearErrno();
	if("yes".equals(ics.GetVar("useme"))) {
		String content = Utilities.readFile(ics.GetVar("filespec"));
		Utilities.writeFile(ics.GetVar("filepath"), content);
	}

	if (ics.GetVar("start") == null) {ics.SetVar("start",0);}
	ics.SetVar("key", ics.ResolveVariables("Variables.tblname.KEY"));
	%><ics:catalogdef listname="table" table='<%= tblName %>'/><%
	
	if (!"(integer)".equals(ics.ResolveVariables("table.COLTYPE"))) {
		nonidkey = "table.KEY > 'Variables.start'";
	} else {
		nonidkey = "table.KEY > Variables.start";
	}
	String sqlStatement="SELECT Variables.col, table.KEY AS akey FROM Variables.tblname WHERE Variables.col IS NOT NULL AND " + nonidkey + " ORDER BY akey";
	String sqlCountStatementUrl="SELECT COUNT(DISTINCT Variables.col) AS num FROM Variables.tblname WHERE Variables.col IS NOT NULL AND " + nonidkey;

	String sqlCountStatement="SELECT COUNT(*) AS num FROM Variables.tblname" ;
	String delStatement = "DELETE from Variables.tblname WHERE Variables.key = Variables.start";

	String mungoStatement = "SELECT Variables.col FROM Variables.tblaname l WHERE NOT EXISTS (SELECT 1 FROM MUNGOBLOBS m WHERE l.Variables.col=m.id) and l.Variables.col IS NOT NULL ORDER BY Variables.col";

	ics.ClearErrno();
	if("yes".equals(ics.GetVar("deleteme"))) {
	%><ics:sql sql='<%= ics.ResolveVariables(delStatement) %>' table='<%= tblName %>' listname="deleteme"/><%
	}
	%>

	<h3>Are all upload column entries present on Disk?</h3>
	<br/>Defdir: <b><%= defdir %></b><br/>

	<ics:sql sql='<%= ics.ResolveVariables(sqlCountStatement) %>' table='<%= tblName %>' listname="totalcount" />
	<ics:clearerrno/>
	

	<%
	if (Utilities.goodString(ics.GetVar("col"))) {
		int numrows = 0, badrows = 0; 
	%>
	<br/><br/>limiting to <ics:getvar name="limit" /> rows per upload field.
	<h4>upload field: <ics:resolvevariables name="Variables.col" /></h4>
	<ics:sql sql='<%= ics.ResolveVariables(sqlCountStatementUrl) %>' table='<%= tblName %>' listname="count" />
	Rows Remaining to be scanned: <b><ics:resolvevariables name="count.num" /></b><br/>
	

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
				foundBad=true; badrows++; 
			%>
			<% if (badrows!=0&&badrows<2) { %>
			<tr>
				<th>Nr</th>
				<th>ElementName</th>
				<th>Column</th>
				<th>URL</th>
				<th>State</th>
			</tr>
			<% } %>
			<tr>
				<td align="right"><ics:resolvevariables name="bodies.#curRow" /></td>
				<td><ics:resolvevariables name="bodies.akey" /></td>
				<td><ics:resolvevariables name="Variables.col" /></td>
				<td><%= url %></td>
				<td><span style="font-color:red"><b>NOT FOUND</b><br/><% fileRollup(out, url, defdir, tblName, ics.GetVar("limit"), ics.GetVar("col"), ics.GetVar("key"), ics.ResolveVariables("bodies.akey"));%></span></td>
			</tr>
			<% } %>
		</ics:listloop>	
	</table>
	<% if (badrows>0) { %>
	Total Rows without upload data: <b><%= badrows%></b><br/>
	<% } %>
	<% if (numrows > 0) { %>
	<a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tblname=<ics:getvar name="tblname"/>&limit=<ics:getvar name="limit"/>&col=<ics:getvar name="col"/>&start=<ics:resolvevariables name="bodies.akey" />'<b>==>><ics:getvar name="col"/></b> column - Next <ics:getvar name="limit"/> Rows</a><br/>
	<% } %>
	<%
	if (numrows > 0 && !foundBad){
	%><strong>Scanned <%= numrows%> urlbodies and all were fine!</strong><br/><br/><%
	}
	} else if (ics.GetErrno() == -101) {
		%>All the columns for <b><ics:getvar name="col" /></b> were empty.<br><%
	} else {
		%>Error no is: <%= ics.GetErrno() %><br><%
	}
	}
	%>

	Total Number of Rows in <%= tblName%>: <ics:resolvevariables name="totalcount.num" /><br/>

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
</div>
</cs:ftcs>
