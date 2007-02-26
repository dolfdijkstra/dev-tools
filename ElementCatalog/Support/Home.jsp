<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld"
%><%//
// Support/Home
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><html>
<head>
<ics:callelement element="Support/general"/>
</head>
<body>
<div id="content">
<ics:callelement element="Support/Topnav"/>

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
    <b>General Information</b> 
        <p>The Content Server Support Tools are intended for use by experienced users with SiteGod privileges to assist in audit, cleanup, help diagnose and resolve problems. These tools can be customized by end users to their need.</p>
<% if (!ics.UserIsMember("SiteGod")){ %>      
      <div class="entry-header">
        <ics:callelement element="Support/Login"/>
      </div>
<% } else { %>
    <b>Overview</b>
        <p>
        <b>Home:</b> Displays information about current system and appserver properties.<br/>
        <b>System:</b> Helps general audit of the system and miscellaneous cleanup tools.<br/>
        <b>Approval:</b> Displays information about approval subsystem, approval affected tables and events.<br/>
        <b>Cache:</b> Displays information about CacheManager subsystem.<br/>
        <b>Flex:</b> Shows the general layout of flex assets and find any missing data.<br/>
        <b>Misc:</b> Miscellaneous tools which include cluster tests, encoding tests and displays files from filesystem.<br/>
        <b>LDAP:</b> Enable or disable LDAP in Content Server.<br/>
        <b>SQLPlus:</b> Helps connect to database and select/update data.<br/>
        </p>
<% } %>
  </div>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</body>
</html>
</cs:ftcs>