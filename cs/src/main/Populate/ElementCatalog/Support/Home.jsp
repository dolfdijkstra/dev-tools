<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/Home
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
  <div class="entry-header">
    <h3>General Information</h3>
    <p>The Content Server Support Tools are intended for use by experienced users with SiteGod privileges to assist in audit, cleanup, help diagnose and resolve problems. These tools can be customized by end users to their need.</p>
  </div>
  <div class="entry"><%
  if (!ics.UserIsMember("SiteGod")){
      %><ics:callelement element="Support/Login"/><%
  } else {
    %><h3>Overview</h3>
    <ul>
    <li><b>Info:</b> Displays information about current system and appserver properties.</li>
    <li><b>System:</b> Helps general audit of the system and miscellaneous cleanup tools.</li>
    <li><b>Approval:</b> Displays information about approval subsystem, approval affected tables and events.</li>
    <li><b>Cache:</b> Displays information about CacheManager subsystem.</li>
    <li><b>Assets:</b> Displays information about assets.</li>
    <li><b>Flex:</b> Shows the general layout of flex assets and find any missing data.</li>
    <li><b>Misc:</b> Miscellaneous tools which include cluster tests, encoding tests and displays files from filesystem.</li>
    <li><b>Log4J:</b> Dynamically set logger levels if log4j is configured.</li>
    <li><b>Performance:</b>Some basic simple pages for baseline performance testing.</li>
   </ul><%
   }
%></div></cs:ftcs>