<%@ page contentType="text/html; charset=utf-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs>
<ul class="entry-header">
<li class="read-only"><h2><satellite:link pagename="Support/Performance/Standard/Home"/><a href='<ics:getvar name="referURL"/>'>Standardized Tests</a></h2>
<p>A set of standardized tests, together with an poor mans test script</p></li>
<li class="read-only"><h2><satellite:link pagename="Support/Performance/SimpleJSP"/><a href='<ics:getvar name="referURL"/>'>SimpleJSP</a></h2>
<p>A very simple element</p></li>
<li class="read-only"><h2><satellite:link pagename="Support/Performance/SimpleJSPCached"/><a href='<ics:getvar name="referURL"/>'>SimpleJSPCached</a></h2>
<p>Same element, now cached</p></li>
<li class="read-only"><h2><satellite:link pagename="Support/Performance/SimpleStatic"/><a href='<ics:getvar name="referURL"/>'>SimpleStatic</a></h2>
<p>A static element (not xml or jsp)</p></li>
<li class="with-care"><h2><satellite:link pagename="Support/Performance/LongRunning"/><a href='<ics:getvar name="referURL"/>'>LongRunning</a></h2>
<p>A jsp simulation a long running i/o waiting element, to see what it means that a thread is blocked by IO or other threads.Default parameter waitTime=2500.</p></li>
<li class="read-only"><h2><satellite:link pagename="Support/Performance/BigPage"/><a href='<ics:getvar name="referURL"/>'>BigPage</a></h2>
<p>A big page, default parameter size=9</li>
<li class="read-only"><h2><satellite:link pagename="Support/Performance/CallElementIntensive"/><a href='<ics:getvar name="referURL"/>'>CallElementIntensive</a></h2>
<p>A page with lot's of call element calls, default parameter number=20</p></li>
<li class="read-only"><h2><satellite:link pagename="Support/Performance/PageIntensive"/><a href='<ics:getvar name="referURL"/>'>PageIntensive</a></h2>
<p>A page with lots of &lt;satellte:page&gt; calls, default parameter cache=false&amp;number=20. With cache is true a cached inner pagelet will be called, otherwise an uncached.</p></li>
<li class="with-care"><h2><satellite:link><satellite:parameter name="pagename" value="Support/Performance/CPUIntensive"/></satellite:link><a href='<ics:getvar name="referURL"/>'>CPUIntensive</a></h2>
<p>A cpu intensive page, cpu is stress by some simple calculations.</p></li>
</ul></cs:ftcs>
