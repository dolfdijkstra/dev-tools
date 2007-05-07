<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/DB/Queries
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

<center><h4>Approval Queries</h4></center>

<%
String queryid = ics.GetVar("queryid");

String query[][] = {
{"SELECT COUNT(x.id ) as numtopublish , pt.name as name FROM ( "
+"SELECT DISTINCT PubKeyTable.id AS id, PubKeyTable.targetid as targetid "
+"FROM PubKeyTable,PublishedAssets  "
+"WHERE PubKeyTable.id=PublishedAssets.pubkeyid  "
+"AND EXISTS(SELECT 'x' FROM ApprovedAssets t0  "
+"WHERE PublishedAssets.assetid=t0.assetid  "
+"AND t0.targetid=PubKeyTable.targetid AND t0.state='A'  "
+"AND t0.locked='F'  "
+"AND (PublishedAssets.assetversion!=t0.assetversion  "
+"OR PublishedAssets.assetdate<t0.assetdate) "
+")  "
+"AND EXISTS(SELECT 'x' FROM ApprovedAssets t1  "
+"WHERE PubKeyTable.assetid=t1.assetid  "
+"AND t1.targetid=PubKeyTable.targetid "
+"AND t1.tstate='A' AND t1.locked='F')  "
+"UNION  "
+"SELECT PubKeyTable.id AS id, PubKeyTable.targetid as targetid "
+"FROM PubKeyTable,ApprovedAssets t2  "
+"WHERE newkey!='D' "
+"AND t2.tstate='A'AND t2.locked='F'  "
+"AND PubKeyTable.assetid=t2.assetid  "
+"AND PubKeyTable.targetid=t2.targetid "
+") x , PubTarget pt "
+" WHERE x.targetid=pt.id "
+"GROUP BY pt.name",

"PubKeyTable","Approved assets per target "},
{"SELECT pt.name AS name, count(assetid) AS num FROM ApprovedAssets,PubTarget pt  WHERE ApprovedAssets.targetid=pt.id AND locked='F' AND tstate='H' GROUP BY pt.name ORDER BY name","ApprovedAssets","Number of held assets per target"}

};

if (queryid!=null){ 
	int qid = Integer.parseInt(queryid);
	if (qid >=0 && qid < query.length) {
		%>
		<h3><%= query[qid][2] %></h3>
		<!-- <%= query[qid][0] %> -->
		<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
			<ics:argument name="query" value='<%= query[qid][0] %>' />
			<ics:argument name="table" value='<%= query[qid][1] %>' />
		</ics:callelement>
		<br>
		<% 
		if (qid > 0) {
			%><a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&#38;cmd=<%= ics.GetVar("cmd") %>&#38;queryid=<%= (qid - 1) %>'>Previous</a>&nbsp;<%
		} 
		 if (qid < query.length -1) {
			%><a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&#38;cmd=<%= ics.GetVar("cmd") %>&#38;queryid=<%= (qid + 1) %>'>Next</a><%
		} 
		%><br><%
	}
}


%><table class="altClass"><%

for (int i=0; i< query.length; i++){
	%><tr>
	<td><a href='ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=<%= ics.GetVar("cmd") %>&#38;queryid=<%=i %>'>Query <%= i %></a></td>
	<td><%= query[i][2] %></td>
	</td>
<%
}
%></table><%		
%>
</cs:ftcs>
