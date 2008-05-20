<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%
//
// Support/ApplicationPage
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<ics:callelement element="Support/general"/><body>
<ics:callelement element="Support/Topnav"/><div class="content">
<ics:setvar name="errno" value="0" /><ics:callelement element='<%= ics.GetVar("pagename") %>'/></div>
<ics:callelement element="Support/Footer"/></body>
</html>
</cs:ftcs>