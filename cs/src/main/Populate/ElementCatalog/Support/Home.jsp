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

  <div class="entry">
    <h3>General Information</h3>
        <p>The Content Server Support Tools are intended for use by experienced users with SiteGod privileges to assist in audit, cleanup, help diagnose and resolve problems. These tools can be customized by end users to their need.</p>
<% if (!ics.UserIsMember("SiteGod")){ %>
      <div class="entry-header">
        <ics:callelement element="Support/Login"/>
      </div>
<% } else { %>
    <br/><h3>Overview</h3>
        <p>
        <b>Info:</b> Displays information about current system and appserver properties.<br/>
        <b>System:</b> Helps general audit of the system and miscellaneous cleanup tools.<br/>
        <b>Approval:</b> Displays information about approval subsystem, approval affected tables and events.<br/>
        <b>Cache:</b> Displays information about CacheManager subsystem.<br/>
        <b>Assets:</b> Displays information about assets.<br/>
        <b>Flex:</b> Shows the general layout of flex assets and find any missing data.<br/>
        <b>Misc:</b> Miscellaneous tools which include cluster tests, encoding tests and displays files from filesystem.<br/>
        <b>Log4J:</b> Dynamically set logger levels if log4j is configured.<br/>
        <b>Performance:</b>Some basic simple pages for baseline performance testing.<br/>
        </p>
<% } %>
  </div>

</cs:ftcs>