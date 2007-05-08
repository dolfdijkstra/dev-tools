<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/DB/pageinsitetree
//
// INPUT
// treetable: the table to check, either AssetRelationTree or SitePlanTree
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
<h4>Any missing Pages entries in the <%= ics.GetVar("treetable") %></h4>
<%
String table = ics.GetVar("treetable");
//	String query = "select count(p.id) as num from Page p, AssetRelationTree/SitePlanTree a where p.id =a.oid(+) and a.oid Is Null";
	String query = "select count(p.id) as num from Page p where p.id  NOT IN (SELECT t.oid FROM  " + table + " t )";
	String listname = null;
	StringBuffer errstr = new StringBuffer();


	ics.ClearErrno();
	int count=0;
	IList resultList = ics.SQL("Page", query, listname, -1, true, errstr); 
	if (ics.GetErrno()==0 && resultList.hasData()){
		int numrows = resultList.numRows();
		for (int i=1; i<=numrows; i++) {
			resultList.moveTo(i);
			count =Integer.parseInt( resultList.getValue("num")) ;
			out.write("count: " + count + "<br>");
		}
	}
if(count>0){
	query = "select p.id as assetid, status , 'Page' as assettype from Page p WHERE p.id  NOT IN (SELECT t.oid FROM  " + table + " t ) order by id";
	errstr = new StringBuffer();
	listname ="missingPages";

	ics.ClearErrno();

	resultList = ics.SQL("Page", query, listname, -1, true, errstr); 
	if (ics.GetErrno()==0 && resultList.hasData()){
/*
	FTValList valList = new FTValList();
	valList.put("list",ics.GetList(listname));
	Object o = valList.get("list");
	out.write(o.getClass().getName());
	if (o instanceof IList) out.write("<br>list is an IList<br>");
	ics.CallElement("OpenMarket/Xcelerate/Actions/AssetMgt/TileMixedAssets",valList);
*/

		int numrows = resultList.numRows();
		for (int i=1; i<=numrows; i++) {
			resultList.moveTo(i);
			out.write("<a href=\"ContentServer?pagename=OpenMarket/Xcelerate/Actions/ContentDetailsFront&AssetType=" + resultList.getValue("assettype") + "&id="+resultList.getValue("assetid") + "\">"+resultList.getValue("assetid") + "</a>"+ resultList.getValue("status")+"<br>"); 
		}

	resultList.flush();
	}
}

%>
</cs:ftcs>
