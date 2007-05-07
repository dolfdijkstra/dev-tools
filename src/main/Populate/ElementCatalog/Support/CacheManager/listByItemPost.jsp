<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%//
// Support/CacheManager/flushByItemPost
//
// INPUT
//
// OUTPUT
//
%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftStatusCode"%>
<%@ page import="COM.FutureTense.Cache.CacheManager"%>
<%@ page import="COM.FutureTense.Cache.CacheHelper"%>
<cs:ftcs>
<satellite:tag><satellite:parameter name='type' value='open'/></satellite:tag>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/CacheManager/LeftNav"/>
<div class="right-column">
<h3>List Pages by Item</h3><BR/>
<%
String idval = ics.GetVar("idlist");
String errorMsg = null;

if (!Utilities.goodString(idval)){
	ics.SetErrno(ftErrors.badparams);
	errorMsg="You must specify at least one ID to list";
} else {
	String idList = Utilities.replaceAll(idval,";","','");
	idList = "'"+ idList +"'";
%>
    <ics:sql sql='<%= "SELECT SystemItemCache.id as id, SystemPageCache.id as pid, SystemPageCache.urlqry, SystemPageCache.mtime FROM SystemPageCache, SystemItemCache WHERE SystemItemCache.page = SystemPageCache.id AND SystemItemCache.id IN (" + idList +") ORDER BY id,mtime" %>' table="SystemPageCache,SystemItemCache" listname="pages"/>
    <table class="altClass">
        <tr>
            <th widht="5%">Nr</th>
            <th width="30%">Asset</th>
            <th width="20%">ModTime</th>
            <th width="45%">Query String</th>
        </tr>
    	<ics:listloop listname="pages">
        <tr>
            <td nowrap align="right"><ics:resolvevariables name="pages.#curRow"/></td>
            <td nowrap><ics:resolvevariables name="pages.id"/></td>
            <td nowrap><ics:resolvevariables name="pages.mtime"/></td>
            <td><a href='ContentServer?pagename=Support/CacheManager/listItemsByPage&pid=<ics:resolvevariables name="pages.pid"/>'><ics:resolvevariables name="pages.@urlqry"/></a></td>
        </tr>
    	</ics:listloop>
    </table>
<%
    ics.ClearErrno(); 
}
%>

<% if (ics.GetErrno() < 0) { %>
    Error: <%=errorMsg%>
<% } %>
</div>
<ics:callelement element="Support/Footer"/>
</div>
<satellite:tag><satellite:parameter name='type' value='close'/></satellite:tag>
</cs:ftcs>
