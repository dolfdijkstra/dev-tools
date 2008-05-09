<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/DispatcherFront
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
<cs:ftcs><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<ics:callelement element="Support/general" />
<body>
<div id="content">
<ics:callelement element="Support/Topnav" />
<ics:setvar name="errno" value="0" />
<% if(!ics.UserIsMember("SiteGod")) { %>
	<h2><center>ContentServer System Audit Tool</center></h2>
	<div>Sorry, you don't have access without SiteGod privledges.<br/>
	Please <a href="ContentServer?pagename=Support/Audit/Start">Login</a></div>
<% } else { %>
        <ics:callelement element="Support/Audit/Dispatcher" />
        <ics:callelement element="Support/Footer" /> 
<% } %>
</div>
</body>
</html>
</cs:ftcs>
