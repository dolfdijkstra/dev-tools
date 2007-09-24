<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/LeftNav
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
<%!
String buildMenuUrl(String cmd){
return "<a href=\"ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=" + cmd + "\">";
}
%>
<ics:callelement element="Support/Topnav"/>

<div class="left-column gray">
  <h2>General Audit</h2>
  <ul class="subnav divider">
      <li><%= buildMenuUrl("Versions") %>Version Check</a></li>
      <li><%= buildMenuUrl("PropFiles") %>Configuration Files</a></li>
      <li><%= buildMenuUrl("GetVars") %>ContentServer Variables</a></li>
      <li><%= buildMenuUrl("SysVariables") %>System Variables</a></li>
      <li><%= buildMenuUrl("ElementCheck") %>ListAndCheck Elements</a></li>
      <li><%= buildMenuUrl("AllTables") %>Full TableCount</a></li>
      <li><%= buildMenuUrl("CountTables") %>Group TableCount</a></li>
      <li><%= buildMenuUrl("CountAssets") %>Count Assets per Site</a></li>
      <li><%= buildMenuUrl("Indices") %>Full Index List</a></li>
      <li><%= buildMenuUrl("StorageCheck") %>Disk Storage Check</a></li>
  </ul>
  <h2>Security Audit</h2>
  <ul class="subnav divider">
      <li><%= buildMenuUrl("Security") %>Security</a></li>
  </ul>
  <h2>Miscellaneous</h2>
  <ul class="subnav divider">
     <li><%= buildMenuUrl("DB/Menu") %>DB Menu</a></li>
     <li><%= buildMenuUrl("SE/UseSE") %>Verity ReIndex</a></li>
  </ul>
  <h2>Cleanup</h2>
  <ul class="subnav divider">
     <li><%= buildMenuUrl("AssetPub") %>AssetPublication Analyzer</a></li>
     <li><%= buildMenuUrl("Workflow/CleanWorkflow") %>Clean Workflow Tables</a></li>
     <li><%= buildMenuUrl("Publishing/ClearAssetPubList") %>Clear AssetPublishList</a></li>
     <li><%= buildMenuUrl("Publishing/ClearPubApprovalTarget") %>Clear PubHistoryPerTarget</a></li>
     <li><%= buildMenuUrl("Publishing/ClearPubApproval") %>Clear EntirePubhistory</a></li>
     <li><%= buildMenuUrl("Publishing/CleanPubhistoryFront") %>Clean Publish History</a></li>
     <li><%= buildMenuUrl("RevTrack/historyFront") %>Clean RevTrack History</a></li>
  </ul>
</div>
</cs:ftcs>
