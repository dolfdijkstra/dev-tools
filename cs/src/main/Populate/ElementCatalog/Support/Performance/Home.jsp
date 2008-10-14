<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Performance/Home
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
    <a href="ContentServer?pagename=Support/Perfomance/Home">Login</a>
  </ul>
</div>
<div class="right-column">
<center><h4>Performance Menu Page</h4></center>
<table class="altClass">

<tr><td>
	<satellite:link>
  		<satellite:parameter name="pagename" value="Support/Performance/SimpleJSP"/>
	</satellite:link>
<a href='<ics:getvar name="referURL"/>'>SimpleJSP</a>
</td></tr>
<tr><td>
	<satellite:link>
  		<satellite:parameter name="pagename" value="Support/Performance/SimpleJSPCached"/>
	</satellite:link>
<a href='<ics:getvar name="referURL"/>'>SimpleJSPCached</a>
</td></tr>

<tr><td>
	<satellite:link>
  		<satellite:parameter name="pagename" value="Support/Performance/SimpleStatic"/>
	</satellite:link>
<a href='<ics:getvar name="referURL"/>'>SimpleStatic</a>
</td></tr>
<tr><td>
	<satellite:link>
  		<satellite:parameter name="pagename" value="Support/Performance/LongRunning"/>
	</satellite:link>
<a href='<ics:getvar name="referURL"/>'>LongRunning</a>
</td></tr>
<tr><td>
	<satellite:link>
  		<satellite:parameter name="pagename" value="Support/Performance/BigPage"/>
	</satellite:link>
<a href='<ics:getvar name="referURL"/>'>BigPage</a>
</td></tr>
<tr><td>
	<satellite:link>
  		<satellite:parameter name="pagename" value="Support/Performance/CallElementIntensive"/>
	</satellite:link>
<a href='<ics:getvar name="referURL"/>'>CallElementIntensive</a>
</td></tr>
<tr><td>
	<satellite:link>
  		<satellite:parameter name="pagename" value="Support/Performance/PageIntensive"/>
	</satellite:link>
<a href='<ics:getvar name="referURL"/>'>PageIntensive</a>
</td></tr>
<tr><td>
	<satellite:link>
  		<satellite:parameter name="pagename" value="Support/Performance/CPUIntensive"/>
	</satellite:link>
<a href='<ics:getvar name="referURL"/>'>CPUIntensive</a>
</td></tr>
</table>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
