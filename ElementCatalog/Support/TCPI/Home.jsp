<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="user" uri="futuretense_cs/user.tld"%>
<%//
// Support/TCPI/Home
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
    <a href="ContentServer?pagename=Support/TCPI/Home">Login</a>
  </ul>
</div>
<div class="right-column">
<%
if (ics.GetVar("login") != null){
	ics.RemoveSSVar("username");
%>
    <user:login username='<%= ics.GetVar("username") %>' password='<%= ics.GetVar("password") %>'/>
<%
	if (ics.GetErrno() == 0){
		ics.SetSSVar("username",ics.GetVar("username"));
	}
}
%>
<% if (ics.UserIsMember("SiteGod")){ %>
	<% String[] tables={"AssetPublication","ApprovedAssetDeps","ApprovedAssets","AssetExportData","AssetPublishList","PublishedAssets","ActiveList","CheckOutInfo"}; %>
    <div class="entry-header">	
	     <h2><a href='ContentServer?pagename=Support/TCPI/AP/PubQueues'><b>ApprovalStats</b></a></h2>
	</div>
	<div class="entry">
         <p>Calculates and Displays Approval and Publish statistics for all Publish Destinations.</p>
	</div>
    <div class="entry-header">	
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/ListHeld'><b>ListHeldAssets</b></a></h2>
	</div>
	<div class="entry">
         <p>Lists Assets that are in a Held State (across all Destinations)</p>
    </div>
    <div class="entry-header">	
    	 <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CheckDates'><b>CheckDates</b></a></h2>
	</div>
	<div class="entry">
    	 <p>Verifies Asset Dates in ApprovedAssets against PublishedAssets</p>
	</div>    
    <div class="entry-header">	
	     <h2><a href='ContentServer?pagename=Support/TCPI/AP/ApprovalStats'><b>ApproveHeldAndChanged</b></a></h2>
	</div>
	<div class="entry">
	     <p>List and Approve Assets either in a Held/Changed State.</p>
	</div>
    <div class="entry-header">	
    	 <h2><a href='ContentServer?pagename=Support/TCPI/AP/UndoApprove'><b>UndoApprove</b></a></h2>
	</div>
	<div class="entry">
    	 <p>Forces Assets out of Publish Queue. If this tool is used you will need to use ApproveHeldAndChanged tool to bring back the forced assets into queue. 
               Also assets that are forced out cannot be edited in the UI until they are brought back into the queue. This tool is useful when there are thousands of assets to publish and you want to publish them in chunks.
               This tool will be removed once undoapprove in UI is implemented. Use this tool with extreme caution. 
         </p>
	</div>
    <div class="entry-header">	
    	 <h2><a href='ContentServer?pagename=Support/TCPI/AP/ForcePublish'><b>ForcePublishAssets</b></a></h2>
	</div>
	<div class="entry">
         <p>Force Publish Assets to a given Destination</p>
	</div>
    <div class="entry-header">	
	     <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetsReverse'><b>AssetPublicationReverse</b></a></h2>
	</div>
	<div class="entry">
		<p>This lists the number of missing AssetPublication table entries for assets in the database.</p>
	</div>
    	<% for (int i=0; i< tables.length;i++){ %>
         <div class="entry-header">	
              <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssets&tname=<%= tables[i] %>'><b><%= tables[i] %></b></a></h2>
         </div>
         <div class="entry">
              <p>This lists the number of missing assets in the database for table <%= tables[i] %>.</p>
         </div>
		<% } %>
    <div class="entry-header">	
	     <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetRelationTree'><b>AssetRelationTree</b></a></h2>
	</div>
	<div class="entry">
	     <p>This lists the number of missing assets in the database for table AssetRelationTree.</p>
	</div>
    <div class="entry-header">	
	     <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountPubKeyTable'><b>PubKeyTable</b></a></h2>
	</div>
	<div class="entry">
		<p>This lists the number of missing assets in the database for table PubKeyTable.</p>
	</div>
    <div class="entry-header">	
		<h2><a href='ContentServer?pagename=Support/TCPI/SQL/Index'><b>SQLScripts</b></a></h2>
	</div>
	<div class="entry">
			 <p>This is the index page to the sql scripts to be run in sqlplus</p>
	</div>
    <div class="entry-header">	
	     <h2><a href='ContentServer?pagename=Support/TCPI/AP/CheckPubKeyForPublishable'><b>CheckPubKeyForPublishable</b></a></h2>
	</div>
	<div class="entry">
		<p>This lists the content of urlkey fields of PubKeyTable for all publishable assets.</p>
	</div>
    <div class="entry-header">	
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/TopDependencies'><b>TopDependencies</b></a></h2>
	</div>
	<div class="entry">
		<p>Shows ApprovedAssets that have a lot of dependencies. <br/> Has ability to force approve assets for all targets it is currently approved.</p>
	</div>
    <div class="entry-header">	
         <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetApprAndDeps'><b>CountAssetApprAndDeps</b></a></h2>
	</div>
	<div class="entry">
    	 <p>Does a count on ApprovedAssets and ApprovedAssetDeps tables for their references.</p>
	</div>
    <div class="entry-header">	
    	 <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/FindWrongTargetidInApprovedAssetDeps'><b>FindWrongTargetidInDeps</b></a></h2>
	</div>
	<div class="entry">
    	 <p>Probably the most important utility and also the most time consuming.<br/> Checks for the referential integrity between ApprovedAssets and ApprovedAssetDeps via targetid.</p>
	</div>
    <div class="entry-header">	
    	 <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/FixWrongTargetidInApprovedAssetDeps'><b>FixWrongTargetidInDeps</b></a></h2>
	</div>
	<div class="entry">
    	 <p>Probably the most important utility and also the most time consuming.<br/> Checks for the referential integrity between ApprovedAssets and ApprovedAssetDeps via targetid.</p>
	</div>
    <div class="entry-header">	
    	 <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountHeldWithoutChildren'><b>CountHeldWithoutChildren</b></a></h2>
	</div>
	<div class="entry">
    	 <p>Checks for assets that are held by do not have any dependants.<br/>This is also an indication that the targetids do not match.</p>
	</div>
    <div class="entry-header">	
		<h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CleanAssetPublishLists'><b>CleanAssetPublishLists</b></a></h2>
	</div>
	<div class="entry">
		<p>Checks for leftover rows in the tempory publish tables. <br/>There should only be data in these tables when there are not pubsessions running.</p>
	</div>
    <div class="entry-header">	
		<h2><a href='ContentServer?pagename=Support/TCPI/AP/EventForm'><b>Current Events</b></a></h2>
	</div>
	<div class="entry">
		<p>Lists, Enables, Disables and Destroys all available Events</p>
	</div>
    <div class="entry-header">	
		<h2><a href='ContentServer?pagename=Support/TCPI/PubKeys/Install'><b>Install MovePubKeys</b></a></h2>
	</div>
	<div class="entry">
		<p>Installs the MovePubKeys event</p>
	</div>
    <div class="entry-header">	
	    <h2><a href='ContentServer?pagename=Support/TCPI/PubKeys/UpdateBatchUI'><b>MovePubKeys</b></a></h2>
	</div>
	<div class="entry">
		<p>Moves some of the PubKeyTable entries in the pubkey folder to subdirectories.</p>
	</div>
    <div class="entry-header">	
	     <h2><a href='ContentServer?pagename=Support/TCPI/Held/CreateEvents'><b>Install Held events</b></a></h2>
	</div>
	<div class="entry">
		<p>Install the events to approve Held assets</p>
	</div>
    <div class="entry-header">	
	     <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/Events/CreatePubKeyCleanUpEvents'><b>Install CleanPubKeys events</b></a></h2>
	</div>
	<div class="entry">
		<p>Install the events to cleanup the PubKey table</p>
	</div>
<% } else { %>
   <div class="entry-header">
        <ics:callelement element="Support/TCPI/LoginForm"/>
	 </div>
<% } %>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
