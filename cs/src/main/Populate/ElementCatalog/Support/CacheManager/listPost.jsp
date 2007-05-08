<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%//
// Support/CacheManager/listPost
//
// INPUT
//
// OUTPUT
//
%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Cache.CacheManager"%>
<%@ page import="COM.FutureTense.Cache.CacheHelper"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<%
// create the cache manager
CacheManager cm = new CacheManager(ics);                 

if ("on".equals(ics.GetVar("ss"))) {
%>
	<CENTER><h3>Satellite Cache</h3></CENTER><br/>
	<%
	String [] inventory = cm.getSSInventory(ics,CacheHelper.sNames);
	int numServers = inventory.length;
	int curServer = 0;
	
    while (curServer<numServers) {
		// dump the contents of each server!
	%>
		<h5><%=inventory[curServer]%></h5>
		<br/>
		<%
		curServer++;
	}
}
	
if ("on".equals(ics.GetVar("cs"))) {
%>
	<CENTER><h3>ContentServer Cache</h3></CENTER><br/>

	<h5><%=cm.getCSInventory(ics,CacheHelper.sBasic)%></h5>
<% } %>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
