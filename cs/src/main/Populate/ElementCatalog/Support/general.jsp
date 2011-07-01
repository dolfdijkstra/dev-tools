<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs><%
ics.SetVar("st_version","3.8.1");
%><satellite:link pagename='Support/css' satellite="true" outstring="cssURL" ><satellite:argument name="v" value='<%= ics.isCacheable("Support/css")?"27": Long.toString(System.currentTimeMillis()) %>'/></satellite:link><%
%><satellite:link pagename='Support/prototype' satellite="true" outstring="prototypeURL" ><satellite:argument name="v" value="1.6.1"/></satellite:link><%
%><head><script type="text/javascript">var began_loading = new Date().getTime();</script>
<title><ics:getvar name="pagename"/></title>
<meta http-equiv="Pragma" content="no-cache"/><%
%><link rel="stylesheet" href='<%=ics.GetVar("cssURL")%>' type="text/css" media="screen"/>
</head>
<% ics.RemoveVar("referURL");ics.RemoveVar("cssURL");%></cs:ftcs>