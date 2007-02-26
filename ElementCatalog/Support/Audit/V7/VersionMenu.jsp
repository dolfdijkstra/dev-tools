<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/V7/VersionMenu
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
<%!
String buildMenuUrl(String cmd){
return "<a href=\"ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=" + cmd + "\">";
}
%>
<cs:ftcs>
<div class="entry-header">
     <h2><%= buildMenuUrl("DB/Menu") %>DB Menu</a></h2>
</div>
<div class="entry">                                        
     <p>Checks DB integrity. Runs database queries to find out consistency of the system which are normally not available through Content Server UI.</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("SE/UseSE") %>Verity ReIndex</a></h2>
</div>
<div class="entry">                                        
     <p>Destroys and creates Verity searchengine index. Useful when bulk indexing needs to be done on multiple attributes.</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("Workflow/CleanWorkflow") %>Clean Workflow Tables</a></h2>
</div>
<div class="entry">                                        
    <p>Clears Finished Workflow History. Useful when workflow history becomes unmanageable and requires maintainance.<br/>
           Note: This tool does not backup any history, once history is deleted it is lost for ever.
    </p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("Publishing/ClearAssetPubList") %>Clear AssetPublishList</a></h2>
</div>
<div class="entry">                                             
     <p>Displays count of assets published for all publish sessions finished/incomplete so far. Usually AssetPublishList is cleaned up after a successful publish but there might be times 
            when a publish is incomplete or failed due to other reasons and records are left out in this table (these are no longer used and uses up db space as well as disk space)<br/>
            This tool deletes all non-running publish session records from this table.</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("Publishing/ClearPubApprovalTarget") %>Clear PubHistoryPerTarget</a></h2>
</div>
<div class="entry">
    <p>Displays count of assets approved and published so far to a particular destination and recursively deletes all data for a specific target. Useful when you want to start-over with a particular destination.</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("Publishing/ClearPubApproval") %>Clear EntirePubHistory</a></h2>
</div>
<div class="entry">                                             
    <p>Displays count of assets approved and published so far to any destination and recursively deletes all data.</p>
</div>
<!-- experimental 
<div class="entry-header">
     <h2><%= buildMenuUrl("Publishing/CleanPubhistoryFront") %>Clean Publish History</a></h2>
</div>
<div class="entry">                                             
    <p>Displays publish history per destination and gives options to delete publish history.</p>
</div>
-->
</cs:ftcs>
