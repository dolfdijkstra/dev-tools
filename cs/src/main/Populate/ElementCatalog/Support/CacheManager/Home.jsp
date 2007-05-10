<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="user" uri="futuretense_cs/user.tld"%>
<%//
// Support/Flex/Home
//
// INPUT
//
// OUTPUT
//
%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
    <ics:callelement element="Support/general"/>
    <div id="content">
        <ics:callelement element="Support/Topnav"/>
        
        <% if (ics.UserIsMember("SiteGod")){ %>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/list'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>List Pages in ContentServer and CSSatellite Caches</b></a></h2>
        </div>
        <div class="entry">
            <p>Lists all Content Server cache and also all cache on Satellite Server listed in SystemSatellite table. Depends on the choices selected.
            May take long time to list if too many number of pages are cached.</p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/listPagename'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Detail Inventory View of ContentServer Cache</b></a></h2>
        </div>
        <div class="entry">
            <p>Lists all Content Server cache based on pagename (displayed as count(pagename) desc.) <br/>
                Other Usages:
                <ul style="margin-left=20px;">
                    <li>Navigation into each cached page and listing all pages based on same pagename (query string differs)</li>
                    <li>Find if duplicate pages are cached</li>
                </ul>
            </p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/SelectItems'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Find which Pages an Asset is Referenced</b></a></h2>
        </div>
        <div class="entry">
            <p>Find Content Server cached pages where a particular asset is referenced. Cached pages can be listed for either flushing or navigation into pages for furthur investigation.</p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/ShowUnknowndeps'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Show Unkowndeps Pages</b></a></h2>
        </div>
        <div class="entry">
            <p>Displays all unkowndeps from all cached pages in Content Server (listed in descending order based on pagename). Navigation into pages is available for furthur investigation.</p>
        </div>
        <div class="entry-header"> 
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/flushByItem'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Flush Pages by Item</b></a></h2>
        </div>
        <div class="entry">
            <p>Flush cache from Content Server and Satellite Server/s based on an item/assetid (depends on the choices selected). A single/group of items (comma seperated) can be flushed from cache. <br/>
                  Item id that needs to be flushed has a special format, it has to be <b>asset-assetid:assettype</b> (asset-123939289229:Product).
            </p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/flushByArg'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Flush Pages by Name-Value Pair</b></a></h2>
        </div>
        <div class="entry">
            <p>Flush cache from Content Server and Satellite Server/s based on name-value pair (depends on the choices selected).<br/>
                  A typical name-value pair would be pagename=Support/Home. All pages with Support/Home will be flushed from cache.
            </p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/flushByDate'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Flush Pages by Date of Page/Item</b></a></h2>
        </div>
        <div class="entry">
            <p>Flush cache from Content Server and Satellite Server/s based on cached date (depends on the choices selected).</p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/FlushTables'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Flush Tables</b></a></h2>
        </div>
        <div class="entry">
            <p>Wipes out all resultset cache (memory cache) for a particular table (multiple tables can be selected for flush)</p>
        </div>  
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/RS/Cache'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Resultset Cache Profiler</b></a></h2>
        </div>
        <div class="entry">
            <p>Provides detailed information about the resultcaches (memory based cache), when created, how many times a cache is accessed or removed, last time checked and other details</p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/ShowDuplicate'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Show Duplicate Pages</b></a></h2>
        </div>
        <div class="entry">
            <p>For a given pagename, if multiple pages are cached a hash of each page is compared against same name page and displayed as duplicates. Pages displayed may not necessarily be duplicates they might vary in query string params which needs to be investigated.</p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/ShowInvalidRows'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>PageCache Tables</b></a></h2>
        </div>
        <div class="entry">
            <p>Recursively goes through all cached pages in SystemPageCache table and looks for missing url columns. If found, gives a choice to user to delete. This delete does not flush any resultset cache (memory) or satellite cache, if they already exist.<br/>
                  Recursively goes through all items in SystemItemCache table and looks for any items missing owner pages in SystemPageCache table. If found, gives a choice to user to delete.  This delete does not flush any resultset cache (memory) or satellite cache, if they already exist.
            </p>
        </div>
        <div class="entry-header">
            <satellite:link>
                <satellite:parameter name='pagename' value='Support/CacheManager/blowCacheFast'/>
            </satellite:link>
            <h2><a href='<%= ics.GetVar("referURL") %>'><b>Blow Away All Cache</b></a></h2>
        </div>
        <div class="entry">
            <p>Blows away all permanent cache in SystemPageCache and SystemItemCache tables. Total number of rows that will be deleted in both tables is displayed to user before proceeding furthur with confirmation.</p>
        </div>  
        <% } else { %>
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
        <% } %>
        <ics:callelement element="Support/Footer"/>
    </div>
</cs:ftcs>