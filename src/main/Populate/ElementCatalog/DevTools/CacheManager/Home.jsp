<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs>
<div class="low-risk">
<ul class="entry-header">
    <li class="read-only">
        <satellite:link pagename="DevTools/CacheManager/PageCacheSummary"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>PageCacheSummary</a></h2>
        <p>Provides some graphs on page cache, like time to live and when pages where initially cached.</p>
    </li>
    <li class="read-only">
        <satellite:link pagename="DevTools/CacheManager/RS/CacheVisualizationTable"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Resultset Cache Profiler</a></h2>
        <p>Provides detailed information about the resultcaches (memory based cache), when created, how many times a cache is accessed or removed, last time checked and other details</p>
    </li>
</ul>
</div>
<div class="medium-risk">
<ul class="entry-header">
    <li class="with-care">
        <satellite:link pagename="DevTools/CacheManager/listPagename"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Detail Inventory View of ContentServer Cache</a></h2>

        Lists all Content Server cache based on pagename (displayed as count(pagename) desc.) <br/>
            Other Usages:
            <ul>
                <li>Navigation into each cached page and listing all pages based on same pagename (query string differs)</li>
                <li>Find if duplicate pages are cached</li>
            </ul>
    </li>
    <li class="with-care">
        <satellite:link pagename="DevTools/CacheManager/SelectItems"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Find which Pages an Asset is Referenced</a></h2>

        <p>Find Content Server cached pages where a particular asset is referenced. Cached pages can be listed for either flushing or navigation into pages for furthur investigation.</p>
    </li>
    <li class="with-care">
        <satellite:link pagename="DevTools/CacheManager/ShowUnknowndeps"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Show Unkowndeps Pages</a></h2>

        <p>Displays all unkowndeps from all cached pages in Content Server (listed in descending order based on pagename). Navigation into pages is available for furthur investigation.</p>
    </li>

</ul>
</div>
<div class="high-risk">
<ul class="entry-header">
    <li class="dangerous">
        <satellite:link pagename="DevTools/CacheManager/list"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>List Pages in ContentServer and CSSatellite Caches</a></h2>

        <p>Lists all Content Server cache and also all cache on Satellite Server listed in SystemSatellite table. Depends on the choices selected.
        May take long time to list if too many number of pages are cached.</p>
    </li>
    <li class="dangerous">
        <satellite:link pagename="DevTools/CacheManager/flushByItem"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Flush Pages by Item</a></h2>
        <p>Flush cache from Content Server and Satellite Server/s based on an item/assetid (depends on the choices selected). A single/group of items (comma seperated) can be flushed from cache. <br/>
         Item id that needs to be flushed has a special format, it has to be <b>asset-assetid:assettype (asset-123939289229:Product)</b>.
        </p>
    </li>
    <li class="dangerous">
        <satellite:link pagename="DevTools/CacheManager/flushByArg"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Flush Pages by Name-Value Pair</a></h2>
        <p>Flush cache from Content Server and Satellite Server/s based on name-value pair (depends on the choices selected).<br/>
        A typical name-value pair would be pagename=DevTools/Home. All pages with DevTools/Home will be flushed from cache.
        </p>
    </li>
    <li class="dangerous">
        <satellite:link pagename="DevTools/CacheManager/flushByDate"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Flush Pages by Date of Page/Item</a></h2>
        <p>Flush cache from Content Server and Satellite Server/s based on cached date (depends on the choices selected).</p>
    </li>
    <li class="dangerous">
        <satellite:link pagename="DevTools/CacheManager/FlushTables"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Flush Tables</a></h2>
        <p>Wipes out all resultset cache (memory cache) for a particular table (multiple tables can be selected for flush)</p>
    </li>
    <li class="dangerous">
        <satellite:link pagename='DevTools/CacheManager/FlushCaches'/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Flush Caches</a></h2>
        <p>Wipes out a memory cache. This is different than the FlushTables function in two ways. FlushCached function is not cluster aware, it only flushed caches on this JVM. I can flush other caches than the onces for a database table.</p>
    </li>
    <li class="dangerous">
        <satellite:link pagename="DevTools/CacheManager/ShowDuplicate"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Show Duplicate Pages</a></h2>
        <p>For a given pagename, if multiple pages are cached a hash of each page is compared against same name page and displayed as duplicates. Pages displayed may not necessarily be duplicates they might vary in query string params which needs to be investigated.</p>
    </li>
    <li class="dangerous">
        <satellite:link pagename="DevTools/Audit/Default/SystemPageCacheCheck"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>PageCache Tables</a></h2>
        <p>Recursively goes through all cached pages in SystemPageCache table and looks for missing url columns. If found, gives a choice to user to delete. This delete does not flush any resultset cache (memory) or satellite cache, if they already exist.</p>
    </li>
    <li class="dangerous">
        <satellite:link pagename="DevTools/CacheManager/ExpireCacheFast"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>Expire All Cache</a></h2>
        <p>expires all permanent cache in SystemPageCache and SystemItemCache tables. Total number of rows in both tables is displayed to user before proceeding furthur with confirmation.</p>
    </li>
    <li class="dangerous">
        <satellite:link pagename="DevTools/CacheManager/SSFlush"/>
        <h2><a href='<%= ics.GetVar("referURL") %>'>SSFlush</a></h2>
        <p>Flush cache from all registered Satellite Servers.</p>
    </li>

</ul>
</div>
</cs:ftcs>
