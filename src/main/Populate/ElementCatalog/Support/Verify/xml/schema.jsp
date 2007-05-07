<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/xml/schema
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<cs:ftcs>
<SCHEMA>
<% String tbl = ics.GetVar("tbl"); %>
<TABLE NAME="<%= tbl %>">
<%
StringBuffer err = new StringBuffer();
IList schema = ics.CatalogDef(tbl,null,err);
if(ics.GetErrno() == 0 && schema != null && schema.hasData()){
    int cols= schema.numColumns();
    int rows= schema.numRows();
    String[] colNames= new String[cols];
    for (int i=0; i< cols;i++){
        colNames[i]= schema.getColumnName(i);
    }
    for (int j=1; j<=rows;j++){
        schema.moveTo(j);
        %><COLUMN><%
        for (int i=0; i< cols;i++){
            %><<%= colNames[i] %>><%= schema.getValue(colNames[i]) %></<%= colNames[i] %>><%
        }
        %></COLUMN><%
    }
} else {
    %>No schema found!<%= ics.GetErrno() %><%= err.toString() %><%
    ics.ClearErrno();
    ics.FlushStream();
}
%>
</TABLE>
</SCHEMA>
</cs:ftcs>
