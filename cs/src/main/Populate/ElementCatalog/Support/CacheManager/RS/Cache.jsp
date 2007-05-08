<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/CacheManager/RS/Cache
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="COM.FutureTense.Util.*" %>
<%@ page import="com.fatwire.cs.core.cache.RuntimeCacheStats" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%! 
    String getTimeDiff(Date first, Date last){
        if (first == null || last == null) return "unknown";
        return getTimeDiff(first.getTime(),last);
    }
    String getTimeDiff(long first, Date last){
        if (last == null) return "unknown";
        long diff = last.getTime() - first;
        if (diff < 60000) {
            int sec = (int)(diff/1000);
            return Integer.toString(sec) +" sec";
        } else {
            int sec = (int)(diff/(1000*60)); 
            return Integer.toString(sec) +" min";
        }
    }
    String getLengthString(long time){
        Long tt = new Long(time);
        if (tt.intValue() < 0) return "eternal";
	if (tt.intValue() < 1000) {
	    return Long.toString(time)+" ms";
	} else if (tt.intValue() < 60000) {
  	    return Long.toString(time/1000)+" sec";
	} else {
            return Long.toString(time/(1000*60)) +" min";
	}
    }
%>
<cs:ftcs><html>
<ics:callelement element="Support/general"/>
<body>
<ics:callelement element="Support/Topnav"/>
<div id="content">
<center><h3>Resultset Cache Profiler</h3></center>
  <table class="altClass">
      <tr>
          <th>Nr</th>
          <th>Name</th>
          <th>Size</th>
          <th>Hits</th>
          <th>Misses</th>
          <th>Removed Num</th>
          <th>Clear Num</th>
          <th>Max Count</th>
          <th>Created Date</th>
          <th>Last Changed</th>
          <th>Last Flush</th>
          <th>Life time</th>
          <th>Expire WhenEmpty</th>
          <th>ItemsExpire WhenEmpty</th>
          <th>INotify Objects</th>
      </tr><%
      DateFormat df = new SimpleDateFormat("yy/MM/dd HH:mm:ss");
      Date now = new Date();
      Set hashes = ftTimedHashtable.getAllCacheNames();
      int i=1;
      for (Iterator itor = hashes.iterator(); itor.hasNext();){
      String key = (String)itor.next();
      %><tr><td><%= Integer.toString(i++) %></td><%
      %><td><a href="ContentServer?pagename=Support/CacheManager/RS/CachedItems&key=<%=key %>"><%= key %></a></td><%
      ftTimedHashtable ht = ftTimedHashtable.findHash(key);
      if (ht != null) {
          RuntimeCacheStats stats = ht.getRuntimeStats();
          %><td style="text-align:right;white-space: nowrap"><%= ht.size() %></td><%
          %><td style="text-align:right;white-space: nowrap"><%= stats.getHits()%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= stats.getMisses()%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= stats.getRemoveCount()%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= stats.getClearCount()%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= ht.getCapacity() %></td><%
          %><td style="text-align:right;white-space: nowrap"><%= df.format(stats.getCreatedDate())%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= getTimeDiff(stats.getLastPrunedDate(), now)%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= getTimeDiff(stats.getLastFlushedDate(),now)%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= getLengthString(ht.getTimeout())%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= ht.getCacheExpiresWhenEmpty()%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= ht.getCacheItemsExpireWhenIdle()%></td><%
          %><td style="text-align:right;white-space: nowrap"><%= stats.hasINotifyObjects() %></td><%
      } else {
      %><td colspan="11">not found</td><%
      }
          %></tr>
      <% }  %>
  </table>
<br/>
<ul class="subnav">
    <li><b>Name: </b>name of the key of the table</li>
    <li><b>Size: </b>number of entries in the cache for this table</li>
    <li><b>Hits: </b>number of times a cached object is requested from cache and was in cache</li>
    <li><b>Misses: </b>number of times a cached object is requested from cache and was NOT in cache</li>
    <li><b>RemovedNum: </b>number of items removed from cache, either by time based expiration, LRU or because an item was removed due to IList.flush() for instance.</li>
    <li><b>ClearNum: </b>number of times the who table is cleared. The happens on any update on the table or by catalog.flush().</li>
    <li><b>MaxCount: </b>maximum number of items in the cache. This seems not a hard limit because I have seen BlobServer go above it's max. (cc.$tablename$CSz)</li>
    <li><b>LinkedTables: </b>number of linked tables to the table. Any flush of this table will trigger a flush on other tables too.</li>
    <li><b>IdleCount: </b>number of times this table is checked for idleness and was found idle. After two times this check an idle table will be removed from 'cache'.</li>
    <li><b>CreatedDate: </b>time ftTimedhashtable was created. </li>
    <li><b>LastChanged: </b>last time this table was changed. I doubt that this value is correct or meaning full</li>
    <li><b>LastFlush: </b>last time this table was flush. I doubt that this value is correct or meaningfull.</li>
    <li><b>Lifetime: </b>lifetime of the items in cache (cc.$tablename$Timeout)</li>
    <li><b>ExpireWhenEmpty: </b>should this ftTimedHashtable be removed from 'cache' if it is idle (for two times as explained above).</li>
    <li><b>Idle: </b>is it idle</li>
    <li><b>INotifyObjects: </b>does it have INotifyObjects. INotifyObjects are object that need to notify other objects when they expire.</li>
    <br/>
    
    <li>To use this tool the most interesting numbers are<br/>
    1) A high number of ClearNum. This means a lot of flushes of the table<br/>
    2) Hits compared to misses and hit count in total.<br/>
    3) Size compared to MaxSize. If size is at maxsize and remove num is growing you might want to enlarge the cache size in futuretense.ini.</li>
</ul>
<ics:callelement element="Support/Footer"/>
</div>
</body></html>
</cs:ftcs>
