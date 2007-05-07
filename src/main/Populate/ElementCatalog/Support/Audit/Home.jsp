<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="user" uri="futuretense_cs/user.tld" %>
<%//
//  Support/Audit/Home
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
<ics:callelement element="Support/Topnav"/>

<div class="left-column gray">
  <ul class="subnav divider">
    <a href="ContentServer?pagename=Support/Audit/Home">Login</a>
  </ul>
</div>
<div class="right-column">
<% if (!ics.UserIsMember("SiteGod")){ %>      
      <div class="entry-header">
        <ics:callelement element="Support/Audit/Start"/>
      </div>
<% } else { %>
        <ics:callelement element="Support/Audit/Menu" />   
<% } %>
</div>
<ics:callelement element="Support/Footer" />
</div>
</cs:ftcs> 
