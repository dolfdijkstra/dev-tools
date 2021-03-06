<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// DevTools/Performance/BigPage
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
<html>
<head>
<title>Performance Big Page</title>
</head>
<body>
<%
int size =1;
String sizeStr = ics.GetVar("size"); //size in kB
if (sizeStr != null) {
	size = Integer.parseInt(sizeStr);
}
for (int i=0; i< size; i++){
%>
<h2>Page Caching Overview</h2>
<p>An effective page caching strategy allows your site to perform well and influences your hardware design by relieving load on Content Server and the database. 
The Content Server product family contains two products that cache web pages:</p>
<ul>
<li>Content Server, which caches pages either on disk or in Java memory<p>
<li>Content Server Satellite, which caches pages on remote servers<p>
</ul>
<p>For optimum performance on the delivery server, use the caching capabilities of both products in tandem.</p>
<h3> Content Server Page Caching </h3>
<p>divine recommends that you cache your pages based on the following two principles:</p>
<ul>
<li>Cache most pages<p>
<li>Use uncached pages only where necessary<p>
</ul>
<p>The caches contain the pagelets, which contain HTTP headers and body content
that are generated when elements are evaluated by Content Server. 
<p>divine recommends that you design your pages so that 75-90% of the content can be cached. 
You should cache as many componants as you can.</p>
<% }
%>
</body>
</html>
</cs:ftcs>