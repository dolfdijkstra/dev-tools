<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="time" uri="futuretense_cs/time.tld" %>

<%//
// Support/Performance/PageIntensive
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
<time:set name="mystamp" />
<%
boolean cached = "true".equals(ics.GetVar("cached"));
String pagename="Support/Performance/SimplePageToCall";
if (cached) pagename="Support/Performance/SimpleCachedPageToCall";

for (int i=0;i<Integer.parseInt(ics.GetVar("number"));i++){
%>
<satellite:page>
	 	 <satellite:parameter name='pagename' value='<%= pagename %>'/>
</satellite:page>
<%}%>
<br><br>
<time:get name="mystamp" /> ms<br>
</cs:ftcs>