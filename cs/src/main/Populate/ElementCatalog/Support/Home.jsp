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
<ul class="entry-header">
  <li>
    <h3>General Information</h3>
    <p>The Content Server Support Tools are intended for use by experienced users with SiteGod privileges to assist in audit, cleanup, help diagnose and resolve problems. These tools can be customized by end users to their need.</p>
  <%
  if (!ics.UserIsMember("SiteGod")){
      %><p><ics:callelement element="Support/Login"/></p>
      <p><div style="text-align: center;font-size:1.5em"><u>FATWIRE CORPORATION SUPPORT TOOLS DISCLAIMER</u></div>
      <p>"Support Tools" are a set of diagnostic tools distributed by FatWire Corporation ("FatWire")
      to licensed users for use only under the direct supervision and guidance of a member of the FatWire support team.
      Incorrect usage of the Support Tools may cause permanent damage to installed FatWire products ("Licensed Software").</p>
      <p style="font-size:1.2em">UNDER NO CIRCUMSTANCES SHOULD THE SUPPORT TOOLS BE USED INDEPENDENTLY BY A FATWIRE CUSTOMER OR PARTNER FOR ANY REASON.</p>
      <p style="font-size:1.2em">THE USE OF SUPPORT TOOLS ARE NOT COVERED UNDER THE FATWIRE MAINTENANCE & SUPPORT AGREEMENTS,
      ARE NOT INTENDED TO BE USED IN CONNECTION WITH ANYTHING OTHER THAN FATWIRE  SOFTWARE
      AND ARE ONLY TO BE USED UNDER THE SUPERVISION OF FATWIRE SUPPORT TEAM. </p>
      <p  style="font-size:1.2em"><u>ANY UNAUTHORIZED USE OF SUPPORT TOOLS WILL VOID ALL FATWIRE REPRESENTATION AND WARRANTIES FOR LICENSED SOFTWARE.</u></p>
      <p>Support Tools are not licensed FatWire products and are provided to FatWire licensees "AS IS".
      FatWire makes no representation or warranty of any kind, whether oral or written, whether express,
      implied or arising by statute, custom, course of dealing, or trade usage with respect to the use of Support Tools.
      FatWire specifically disclaims any and all implied warranties or conditions of title, merchantability, fitness for a particular purpose
      or non-infringement.
      Under no circumstances shall FatWire be liable for any damages whatsoever
      for the use of Support Tools including, without limitation, direct,
      consequential, incidental or indirect damages, damages for loss of business profit,
      business interruption or for damage to the FatWire software or any
      of the FatWire Licensee&#39;s systems, data, software or hardware.</p>
      </p><%
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
%></li>
</ul>
</cs:ftcs>