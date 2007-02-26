<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/CacheManager/LeftNav
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<div class="left-column gray">
  <h2>Display Cache</h2>
  <ul class="subnav divider">
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/list'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>List CS/SS Cache</a>
    </li>
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/listPagename'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>CS Cache Inventory</a>
    </li>
    <li>      
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/SelectItems'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Asset Page Reference</a>
    </li>
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/ShowUnknowndeps'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Show Unkowndeps</a>
    </li>
  </ul>
  <h2>Flush Cache</h2>
  <ul class="subnav divider">
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/flushByItem'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Flush By Item</a>
    </li>
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/flushByArg'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Flush By Name-Value</a>
    </li>
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/flushByDate'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Flush By Date</a>
    </li>
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/FlushTables'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Flush Tables</a>
    </li>      
  </ul>
  <h2>Profiler</h2>
  <ul class="subnav divider">
    <li>  
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/RS/Cache'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Resultset Cache Profiler</a>
    </li>
  </ul>
  <h2>Use Tools below with caution</h2>
  <ul class="subnav divider">
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/ShowDuplicate'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Show Duplicate Pages</a>
    </li>
    <li>    
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/ShowInvalidRows'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>PageCache Tables</a>
    </li>
    <li>
      <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/blowCacheFast'/>
      </satellite:link>
      <a href='<%= ics.GetVar("referURL") %>'>Blow Away All Cache</a>
    </li>
   </ul>      
</div>
</cs:ftcs>
