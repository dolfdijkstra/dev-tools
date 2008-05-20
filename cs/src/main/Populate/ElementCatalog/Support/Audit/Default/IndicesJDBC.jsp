<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/IndicesJDBC
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
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>

<cs:ftcs>

<%!
String[] indexes = {"INDEX_NAME","COLUMN_NAME","TYPE","ASC_OR_DESC","CARDINALITY","PAGES","FILTER_CONDITION","NON_UNIQUE"};
int indexNum = indexes.length;
String[] types = {"Statistic","Clustered","Hashed","Other"};

private Connection getConnection(String connectString) throws Exception
{
    Connection connection = null;
    InitialContext ic = new InitialContext();     
	DataSource ds   =  (DataSource) ic.lookup(connectString);
	connection   =  ds.getConnection();
    return connection;
}   
%>

<%
Connection con = null;
String sFormat = ics.GetProperty(ftMessage.propDBConnPicture);

if (!Utilities.goodString(sFormat)) {
	sFormat = "jdbc/$dsn";
}

String connectString = Utilities.replaceAll(sFormat, ftMessage.connpicturesub, ics.GetProperty("cs.dsn"));

try {    
    con  =  getConnection(connectString);
    boolean makeUpperCase = con.getMetaData().storesUpperCaseIdentifiers();
	%><ics:setvar name="errno" value="0"/>
	<h3><center>Overview of ContentServer Table Indices</center></h3>

	<table class="altClass">
	<tr>
		<th>INDEX_NAME</th>
		<th>(ORDINAL_POSITION)<br/>COLUMN_NAME</th>
		<th>TYPE</th>
		<th>ASC_OR_DESC</th>
		<th>CARDINALITY</th>
		<th>PAGES</th>
		<th>FILTER_CONDITION</th>
		<th>NON_UNIQUE</th>
	</tr>
	<ics:setvar name="tablename" value="SystemInfo"/>
	<% String sql = "select distinct tblname from SystemInfo where tblname not in (\'SystemAssets\') order by tblname asc"; %>
	<ics:sql sql='<%= sql %>' listname='B' table='SystemInfo' />
		<ics:listloop listname="B">
		<tr><td colspan="8"><font color="blue"><b><ics:listget listname="B" fieldname="tblname" /></b></font></th></tr>
	<%
	//
		String tableName = ics.GetList("B", false).getValue("tblname");
		if (makeUpperCase) tableName= tableName.toUpperCase(); else tableName= tableName.toLowerCase();
		try{
			ResultSet rs= con.getMetaData().getIndexInfo(null, null, tableName, false, false);
			int c=0;
			%><tr><%
			while (rs.next()) {
				for (int i=0; i<indexNum; i++) {
					if (indexes[i].equals("TYPE")) {
						%><td><%= types[rs.getShort("TYPE")]%></td><%
					} else if (indexes[i].equals("COLUMN_NAME")) {
							%><td><%= "("+rs.getString("ORDINAL_POSITION")+") "+rs.getString(indexes[i])%></td><%
					} else {
							%><td><%= rs.getString(indexes[i])%></td><%
					}
				}
				%></tr><%
			}
			rs.close();
		} catch (SQLException e){
			%><%= e.getMessage() %><%
		}
	%>
		</ics:listloop>
	</table>
<% } finally {
	if (con !=null){
		con.close();
	}
}%>

</cs:ftcs>