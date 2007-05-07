<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/xml/tablelist
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
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Verify/LeftNav"/>
<div class="right-column">
<center><h4>Table in XML Format</h4></center>
<table class="altClass" style="width:30%">
    <tr><th>TableName</th></tr>
<%
StringBuffer err = new StringBuffer();
IList tschema = ics.SQL("SystemInfo","select tblname from SystemInfo where tblname not like (\'tt%\') order by lower(tblname)",null,-1,true,err);

if(tschema != null && tschema.hasData()){
	int cols= tschema.numColumns();
	int rows= tschema.numRows();
	String[] colNames= new String[cols];
	for (int i=0; i<cols; i++){
		colNames[i]= tschema.getColumnName(i);
	}
	for (int j=1; j<=rows; j++){
		tschema.moveTo(j);
		for (int i=0; i<cols; i++){
%>
            <tr><td>
            <a href="ContentServer?pagename=Support/Verify/xml/schema&tbl=<%= tschema.getValue(colNames[i]) %>"><%= tschema.getValue(colNames[i]) %></a>
            </td></tr>
        <% } %>
    <% } %>
<% } else { %>
    No schema found!
<% } %>
</table>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
