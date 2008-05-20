<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Audit/Menu
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%!
String buildMenuUrl(String cmd){
return "<a href=\"ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=" + cmd + "\">";
}
%>
<cs:ftcs>
<div class="entry-header">
     <h2><a href="ContentServer?pagename=Support/Info/collectInfo">Version Check</a></h2>
</div>
<div class="entry">
     <p>Useful to check build date and buid version number to make sure the latest release is installed.<br/>
            Displays following information: 
                <ul>
                    <li>Displays CPU information of the machine hosting CS</li>
                    <li>Displays JVM information of the CS running appserver</li>
                    <li>Recursively looks for all CS jars deployed in webapp displaying the build number and created date.</li>
                </ul>
       </p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("PropFiles") %>Configuration Files</a></h2>
</div>
<div class="entry">     
     <p>Displays all Content Server configuration files (includes both *.ini and *.properties files). Useful to check if system is configured properly.</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("GetVars") %>ContentServer Variables</a></h2>
</div>
<div class="entry">          
     <p>Displays all active Content Server variables. Useful for a general system audit</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("SysVariables") %>System Variables</a></h2>
</div>
<div class="entry">               
     <p>Displays all java System Properties. Useful for a general system audit</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("ElementCheck") %>ListAndCheck Elements</a></h2>
</div>
<div class="entry">                    
     <p>Displays list of all elements in ElementCatalog. Useful to see how many elements are currently in system. <br/>
            Also checks if url column files exist on Disk. If file does not exist it gives an option to use an existing element or create a zero byte element. Useful when system goes out of sync due to system crash or disk failure.</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("AllTables") %>Full TableCount</a></h2>
</div>
<div class="entry">                    
    <p>Counts rows for all tables in Systeminfo grouped by systable column. Useful for a general system audit.<br/>
        Other usages: 
        <ul>
            <li>Useful for database caching entries in the configuration file (futuretense.ini)</li>
            <li>Url columns of tables other than elementcatalog can be verified (if file exists on disk or not)</li>
        </ul>
    </p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("CountTables") %>Group TableCount</a></h2>
</div>
<div class="entry">                    
    <p>Counts rows for all tables in Systeminfo grouped by Content Server's subsystem (namely assetframework, approval, publish, workflow, engage, etc.,). Useful for a general system audit.<br/>
        Other usages: 
        <ul>
            <li>Useful for database caching entries in the configuration file (futuretense.ini)</li>
            <li>Url columns of tables other than elementcatalog can be verified (if file exists on disk or not)</li>
        </ul>
    </p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("CountAssets") %>Count Assets per Site</a></h2>
</div>
<div class="entry">                    
     <p>Counts the number of assets per Site per AssetType.</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("AssetPub") %>AssetPublication Analyzer</a></h2>
</div>
<div class="entry">                         
     <p>Analyzes AssetPublication table looking for Orphan Assets, Duplicates or Bad Publications. Useful to clean up the database.</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("Indices") %>Full Index List</a></h2>
</div>
<div class="entry">                              
     <p>Lists all indexes that are used by the tables managed by Content Server. Useful for gathering system statistics</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("StorageCheck") %>Disk Storage Check</a></h2>
</div>
<div class="entry">                              
     <p>Displays Disk Storage used/unused Space details</p>
</div>
<div class="entry-header">
     <h2><%= buildMenuUrl("Security") %>Security</a></h2>
</div>
<div class="entry">                                   
     <p>This utility provides a listing of all standard/utility URLs where access restrictions should be considered, plus a listing of all standard user names and password.</p>
     <p><b>It is strongly recommended that access to URLs are restricted and that all standard passwords are changed before going live.</b></p>
</div>
<ics:callelement element='Support/Audit/Dispatcher' >
	<ics:argument name="cmd" value="VersionMenu" />
</ics:callelement>
</table>
</cs:ftcs>
