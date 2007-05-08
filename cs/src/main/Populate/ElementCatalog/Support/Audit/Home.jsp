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
<% if (!ics.UserIsMember("SiteGod")){ %>
    <div class="left-column">
      <h2>Categories</h2>
      <ul class="subnav divider">
        <li><a href="http://www.fatwire.com" class="Fatwire">Fatwire</a></li>								
      </ul>
      <h2>Recent Entries</h2>
      <ul class="subnav divider">
        <li><a href="http://www.fatwire.com/cs/Satellite/NewsITNewsPage_US.html">News</a></li>
      </ul>
      <h2>Fatwire Support</h2>
      <ul class="subnav divider">
        <li><a href="http://www.fatwire.com/support/">Support</a></li>
      </ul>
    </div>

   <div class="right-column">      
      <div class="entry">
      <h3>General Information</h3> 
        <p>The Content Server Support Tools are intended for use by experienced users with SiteGod privileges to assist in audit, cleanup, help diagnose and resolve problems. These tools can be customized by end users to their need.</p>      
        <div class="entry-header">
             <ics:callelement element="Support/Login"/>
        </div>
      </div>
   </div>
<% } else { %>
        <ics:callelement element="Support/Audit/Menu" />   
<% } %>
<ics:callelement element="Support/Footer" />
</div>
</cs:ftcs> 
