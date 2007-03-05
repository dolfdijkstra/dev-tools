<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/DB/publicationinconsistancies
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

<!-- user code here -->
<%! 
private void displayResult(ICS ics, javax.servlet.jsp.JspWriter out, String query, String table, String description) throws java.lang.NoSuchFieldException , java.io.IOException {
	String listname = null;
	StringBuffer errstr = new StringBuffer();


	ics.ClearErrno();
	int count=0;
	IList resultList = ics.SQL(table, query, listname, -1, true, errstr); 
	if (ics.GetErrno()==0 && resultList.hasData()){
		int numrows = resultList.numRows();
		int numcols = resultList.numColumns();
		out.write("<h3>"+ description +"</h3>");
		out.write("<b>"+ query +"</b><br>");
		out.write("<table>");
			out.write("<tr>");

		for (int jj=0; jj< numcols; jj++){
			out.write("<th>" + resultList.getColumnName(jj) + "</th>");
		}
			out.write("</tr>");

		for (int i=1; i<=numrows; i++) {
			resultList.moveTo(i);
			out.write("<tr>");

			for (int j=0; j< numcols; j++){
				out.write("<td>" + resultList.getValue(resultList.getColumnName(j)) + "</td>");
			}
			out.write("</tr>");

		}
		out.write("</table>");

	}

}
%>
<%


String query[][] = {
{"SELECT count(id) , pubid FROM AssetPublication GROUP BY pubid","AssetPublication","Counts number of assets per publication"},
{"SELECT * FROM Publication","Publication","Displays publications"},
{"SELECT count(AssetPublication.id) FROM AssetPublication WHERE pubid NOT IN (SELECT id FROM Publication)","AssetPublication","Number of orphans"},
{"SELECT pubid, AssetPublication.* FROM AssetPublication WHERE pubid NOT IN (SELECT id FROM Publication)","AssetPublication","Orphans"},
{"SELECT assetid , count(pubid) as num FROM AssetPublication GROUP BY assetid HAVING count(pubid) > 1 ORDER BY num desc","AssetPublication","Assets that are in mulitple publications"},
{"SELECT * FROM AssetPublication WHERE assetid IN (SELECT assetid FROM AssetPublication GROUP BY assetid HAVING count(pubid) > 1 )","AssetPublication","Shows assets that are in mulitple publications"},
{"SELECT t.name ,t.id, t.rootelement ,t.updateddate ,t.description ,t.updatedby ,t.category ,t.template ,t.subtype ,t.source ,t.status FROM Template t WHERE t.rootelement NOT IN (SELECT e.elementname FROM  ElementCatalog e ) AND t.status != 'VO' ORDER BY t.rootelement","Template","Shows templates without an rootelement"},
{"SELECT category, assettype, count(id) as num FROM Category GROUP BY assettype, category HAVING count(id) > 1 ORDER BY assettype, category","Category","Shows duplicate entries in the Category table"},
{"SELECT s.* FROM  SiteCatalog s  WHERE rootelement NOT IN (SELECT elementname FROM ElementCatalog)","SiteCatalog","Shows SiteCatalog entries without a rootelement"},
{"SELECT s.* FROM  SiteCatalog s  WHERE LOWER(cacheinfo) NOT IN ('cs.nevercache,*,*','false')","SiteCatalog","Shows SiteCatalog entries that do not have cs.nevercache set"},
{"SELECT s.* FROM  SiteCatalog s  WHERE acl IS Null","SiteCatalog","Shows SiteCatalog entries without an acl"},
{"SELECT DISTINCT acl FROM SiteCatalog s","SiteCatalog","Shows distinct acls FROM the SiteCatalog" },
{"SELECT acl, count(pagename) as num  FROM  SiteCatalog s GROUP BY acl ORDER  BY acl","SiteCatalog","Shows number of SiteCatalog entries per acl"},
{"SELECT * FROM SiteCatalog s WHERE resargs1 LIKE ('%PageCriteria%') OR resargs2 LIKE ('%PageCriteria%')  ORDER BY LOWER(cacheinfo)","SiteCatalog","Shows SiteCatalog enrties with PageCriteria defined"},
{"SELECT * FROM ElementCatalog s WHERE LOWER(elementname) LIKE ('support/%' ) ORDER BY LOWER(elementname)","ElementCatalog","Shows element names starting with Support/"},
{"SELECT * FROM ElementCatalog s WHERE url LIKE ('%/%' )ORDER BY LOWER(elementname)","ElementCatalog","Shows url columns (file name) that contain a forward slash"},
{"SELECT * FROM AssetPublication WHERE assettype NOT IN (SELECT assettype FROM AssetType)","AssetPublication","Shows entries FROM AssetPublication that do not have a assettype present"},
{"SELECT * FROM AssetPublication WHERE assettype = 'Article' AND assetid  NOT IN (SELECT id FROM Article)","AssetPublication","Shows entries FROM AssetPublication that do not have a base asset present"},
{"SELECT * FROM AssetRelationTree WHERE otype = 'Article' AND oid NOT IN (SELECT id FROM Article)","AssetRelationTree","Shows element names starting with Support/"},
{"SELECT * FROM AssetRelationTree WHERE otype NOT IN (SELECT tblname FROM SystemInfo)","AssetRelationTree","Shows element names starting with Support/"},
{"SELECT * FROM AssetType WHERE assettype NOT IN (SELECT tblname FROM SystemInfo)","AssetType","Displays assettypes with no table present"},
{"SELECT * FROM AssetType WHERE usesearchindex=1","AssetType","Displays assettypes with index searching on"},
{"SELECT * FROM AssetType WHERE usesearchindex=1 AND assettype IN (SELECT  assettype FROM FlexAssetTypes)","AssetType","Displays FlexAssetTypes that have basic index searchging turned on"},
{"SELECT tblname,acl  FROM SystemInfo ORDER BY acl, tblname","SystemInfo","Shows acl's for tablenames"},
{"SELECT *  FROM SystemInfo WHERE systable IN ('tmp') ORDER BY acl, tblname","SystemInfo","Shows temporary tables"},
{"SELECT DISTINCT systable  FROM SystemInfo ORDER BY systable","SystemInfo","Shows distinct systables for SystemInfo"},
{"SELECT s.*, e.url FROM  SiteCatalog s, ElementCatalog e WHERE s.rootelement = e.elementname AND LOWER(s.cacheinfo) NOT IN ('cs.nevercache,*,*','false')","SiteCatalog","Shows SiteCatalog enrties with PageCriteria defined"},
{"SELECT DISTINCT s.cacheinfo  FROM  SiteCatalog s ORDER BY s.cacheinfo","SiteCatalog","Shows SiteCatalog enrties with PageCriteria defined"},
{"SELECT DISTINCT csstatus  FROM  SiteCatalog s ORDER BY s.csstatus","SiteCatalog","Shows distinct csstatusses FROM SiteCatalog"},
{"SELECT SUBSTR(e.url,-4) as ext, COUNT(*)   FROM  ElementCatalog e GROUP BY SUBSTR(e.url,-4)","ElementCatalog","Displays number of elements with distinct extensions"},
{"SELECT * FROM SystemEvents","SystemEvents","Shows SystemEvents"},
{"SELECT * FROM PubSession ORDER BY publishdate","PubSession","Shows PubSessions"},
{"SELECT * from PubMessage WHERE sessionid NOT IN (SELECT id FROM PubSession)","PubMessage",""},
{"SELECT * from PubContext WHERE target NOT IN (SELECT id FROM PubTarget)","PubContext",""},
{"SELECT * from PubSession WHERE context NOT IN (SELECT id FROM PubContext)","PubSession",""},
{"SELECT * from SitePlanTree WHERE otype ='Page' AND oid NOT IN (SELECT id FROM Page)","SitePlanTree","Entries in SitePlanTree without base assets"},

{"SELECT targetid, assettype, count(*) as num from ApprovedAssets GROUP BY targetid, assettype ORDER BY targetid, assettype","ApprovedAssets",""},
{"SELECT assettype, count(assetid) as num  from PublishedAssets GROUP BY assettype","PublishedAssets",""},
{"SELECT targetid,tstate, locked, assettype ,count(id) as num FROM ApprovedAssets GROUP BY targetid,tstate, locked, assettype ORDER BY targetid,tstate, locked, assettype","ApprovedAssets",""},
{"SELECT * from PubKeyTable WHERE assetid NOT IN (SELECT assetid FROM AssetPublication)","PubKeyTable",""},
{"SELECT * from PublishedAssets WHERE pubkeyid NOT IN (SELECT id FROM PubKeyTable)","PublishedAssets",""},
{"SELECT * FROM Page WHERE template NOT IN (SELECT name FROM Template)","Page",""},
{"SELECT * FROM Article WHERE template NOT IN (SELECT name FROM Template)","Article",""},
{"SELECT template,  COUNT(id) FROM ImageFile GROUP BY template","ImageFile",""}
};

for (int i=0; i< query.length; i++){
	try {
		%>
		<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
			<ics:argument name="query" value='<%= query[i][0] %>' />
			<ics:argument name="table" value='<%= query[i][1] %>' />
			<ics:argument name="description" value='<%= query[i][2] %>' />
		</ics:callelement>
		<%
		
	} catch (Exception e){
		out.write(e.getMessage());
		e.printStackTrace();
		throw e;
	}
}
%>
<pre>
Assets from a specific site are mentioned in:
AssetPublication
AssetRelationTree
Publication tables
Aproval tables
SitePlanTree

</pre>
</cs:ftcs>
