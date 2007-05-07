<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/TCPI/LeftNav
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
<ics:callelement element="Support/Topnav"/>
<div class="left-column gray">
  <h2>General</h2>
  <ul class="subnav divider">
     <% String[] tables={"AssetPublication","ApprovedAssetDeps","ApprovedAssets","AssetExportData","AssetPublishList","PublishedAssets","ActiveList","CheckOutInfo"}; %>
     <li><a href='ContentServer?pagename=Support/TCPI/AP/PubQueues'>ApprovalStats</a></li>
  	 <li><a href='ContentServer?pagename=Support/TCPI/AP/ListHeld'>List HeldAssets</a></li>
  	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/CheckDates'>CheckDates</a></li>
  </ul>
  <h2>Approval</h2>
  <ul class="subnav divider">    	 
	 <li><a href='ContentServer?pagename=Support/TCPI/AP/ApprovalStats'>Approve HeldAndChanged</a></li>
  	 <li><a href='ContentServer?pagename=Support/TCPI/AP/UndoApprove'>UndoApprove</a></li>
  	 <li><a href='ContentServer?pagename=Support/TCPI/AP/ForcePublish'>ForcePublishAssets</a></li>
  </ul>
  <h2>Approval Tables</h2>  	 
  <ul class="subnav divider">
	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetsReverse'>AssetPublication Reverse</a></li>
     <% for (int i=0; i< tables.length;i++){ %>
        <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssets&tname=<%= tables[i] %>'><%= tables[i] %></a></li>
	 <% } %>
     <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetRelationTree'>AssetRelationTree</a></li>
	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountPubKeyTable'>PubKeyTable</a></li>
  </ul>
  <h2>Miscellaneous</h2>
  <ul class="subnav divider">
	 <li><a href='ContentServer?pagename=Support/TCPI/SQL/Index'>SQLScripts</a></li>
	 <li><a href='ContentServer?pagename=Support/TCPI/AP/CheckPubKeyForPublishable'>CheckPubKey ForPublishable</a></li>
	 <li><a href='ContentServer?pagename=Support/TCPI/AP/TopDependencies'>TopDependencies</a></li>
   	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetApprAndDeps'>CountAsset ApprAndDeps</a></li>
   	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/FindWrongTargetidInApprovedAssetDeps'>FindWrong TargetidInDeps</a></li>
   	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/FixWrongTargetidInApprovedAssetDeps'>FixWrong TargetidInDeps</a></li>
   	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountHeldWithoutChildren'>CountHeld WithoutChildren</a></li>
	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/CleanAssetPublishLists'>CleanAssetPublishList</a></li>
  </ul>
  <h2>Events</h2>
  <ul class="subnav divider">
	 <li><a href='ContentServer?pagename=Support/TCPI/AP/EventForm'>Current Events</a></li>
	 <li><a href='ContentServer?pagename=Support/TCPI/PubKeys/Install'>Install MovePubKeys</a></li>
	 <li><a href='ContentServer?pagename=Support/TCPI/PubKeys/UpdateBatchUI'>MovePubKeys</a></li>
	 <li><a href='ContentServer?pagename=Support/TCPI/Held/CreateEvents'>Install Held events</a></li>
	 <li><a href='ContentServer?pagename=Support/TCPI/CleanUp/Events/CreatePubKeyCleanUpEvents'>Install CleanPubKeys events</a></li>
  </ul>
</div>
</cs:ftcs>
