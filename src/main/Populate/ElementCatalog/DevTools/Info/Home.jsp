<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// DevTools/Info/Home
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<div class="low-risk">
<ul class="entry-header">
    <li class="read-only">
        <h2><a href="ContentServer?pagename=DevTools/Info/collectInfo">Collect Info</a></h2>
        <p>Collects information about the runtime environment like versions, ini files etc.</p>
    </li>
    <li class="read-only">
        <h2><a href="ContentServer?pagename=DevTools/Info/ThreadDump">Thread Dump</a></h2>
        <p>Prints out a thread dump</p>
    </li>
    <li class="read-only">
        <h2><a href="ContentServer?pagename=DevTools/Info/ThreadDump&extended=true&regex=.*&state=RUNNABLE">Thread Dump Full</a></h2>
        <p>Prints out a thread dump with some more options to filter  on thread name and thread state.</p>
    </li>
    <li class="read-only">
        <h2><a href="ContentServer?pagename=DevTools/Info/JMX">JMX</a></h2>
        <p>Shows JMX beans and their attribute values</p>
    </li>
    <% if (org.apache.commons.lang.SystemUtils.IS_OS_UNIX) {%>
    <li class="read-only">
        <h2><a href="ContentServer?pagename=DevTools/Info/UNIX">UNIX</a></h2>
        <p>Shows some low level UNIX info, like /proc/cpuinfo</p>
    </li>
    <%}%>
    <li class="read-only">
        <h2><a href="ContentServer?pagename=DevTools/Info/SendEmail">Send Email</a></h2>
        <p>Test program to send a email.</p>
    </li>

</ul>
</div>
<div class="medium-risk">
&nbsp;</div>
<div class="high-risk">
<ul class="entry-header">
    <li class="dangerous">
        <h2><a href="ContentServer?pagename=DevTools/Info/sqlplus">Database Query Tool</a></h2>
        <p>Connects directly to the database to run sql statements
        </p>
    </li>

</ul>
</div>

</cs:ftcs>
