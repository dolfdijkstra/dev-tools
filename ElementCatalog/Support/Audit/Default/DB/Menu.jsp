<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/DB/Menu
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
<%!
String buildMenuUrl(String cmd){
return "<a href=\"ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=" + cmd + "\">";
}
%>
<cs:ftcs>

<center><h4>DB Consistency Check</h4></center>

<table class="altClass">
<tr>
<td><b><%= buildMenuUrl("DB/cleartemptables") %>TT-Tables</a></b></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<td><b><%= buildMenuUrl("DB/Queries") %>ContentServer Queries</a></b></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<td><b><%= buildMenuUrl("DB/CSDirectQueries") %>CS-Direct Queries</a></b></td>
<td>CSDirect releated</td>
<td>&nbsp;</td>
</tr>

<tr>
<td><b><%= buildMenuUrl("DB/AssetTypeQueries") %>AssetType Queries</a></b></td>
<td>AssetType</td>
<td>&nbsp;</td>
</tr>

<tr>
<td><b><%= buildMenuUrl("DB/PubTargets") %>PubTarget Queries</a></b></td>
<td>PubTarget</td>
<td>Lists number of approved assets per target</td>
</tr>

<tr>
<td><b><%= buildMenuUrl("DB/Templates") %>Templates</a></b></td>
<td>Templates</td>
<td>&nbsp;</td>
</tr>

</table>
</cs:ftcs>
