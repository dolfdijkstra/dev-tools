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
<cs:ftcs>
<ics:callelement element="Support/general" />
<ics:setvar name="errno" value="0" />
<% if(!ics.UserIsMember("SiteGod")) { %>
	<h2><center>ContentServer System Audit Tool</center></h2>
	<div>Sorry, you don't have access without SiteGod privledges.<br/>
	Please <a href="ContentServer?pagename=Support/Audit/Start">Login</a></div>
<% } else { %>
    <div id="content">
        <ics:callelement element="Support/Audit/LeftNav"/>
            <div class="right-column">
                <ics:callelement element="Support/Audit/Dispatcher" />
            </div>
        <ics:callelement element="Support/Footer" /> 
    </div>
<% } %>
</cs:ftcs>
