<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
//
// DevTools/Topnav
//
// INPUT
//
// OUTPUT
//
%><%!
private org.apache.commons.logging.Log log = org.apache.commons.logging.LogFactory.getLog("com.fatwire.logging.cs");
%><cs:ftcs><%

    String hostname = null;
    try {
        hostname = java.net.InetAddress.getLocalHost().getHostName();
    } catch (java.net.UnknownHostException e){}
    String serverport = Integer.toString(request.getServerPort());
    java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss z");
%><div id="logo">
        <table width="100%" class="logo"><tr>
                <td width="25%" class="logo"><%=ics.GetSSVar("username")%> at <%= hostname%>:<%= serverport%></td>
                <td width="50%" class="logo"><p class="logo">Oracle WebCenter Sites Developers Tools</p></td>
                <td width="25%"  class="logo" style="text-align:right"><%= df.format(new java.util.Date())%></td>
        </tr></table>
    </div>
    <div id="nav-bg">
        <div id="nav">
                <ul>
                    <li><a href="ContentServer?pagename=DevTools/Home">HOME</a></li>
                    <% if (ics.UserIsMember("SiteGod")){
                        %><li><a href="ContentServer?pagename=DevTools/Info/Home">INFO</a></li>
                        <li><a href="ContentServer?pagename=DevTools/Audit/Home">SYSTEM</a></li>
                        <li><a href="ContentServer?pagename=DevTools/TCPI/Home">APPROVAL</a></li>
                        <li><a href="ContentServer?pagename=DevTools/CacheManager/Home">CACHE</a></li>
                        <li><a href="ContentServer?pagename=DevTools/Assets/Home">ASSETS</a></li>
                        <li><a href="ContentServer?pagename=DevTools/Flex/Home">FLEX</a></li>
                        <li><a href="ContentServer?pagename=DevTools/Verify/Home">MISC</a></li>
                        <% if (log instanceof org.apache.commons.logging.impl.Log4JLogger){ %>
                        <li><a href="ContentServer?pagename=DevTools/Log4J/Log4J">LOG4J</a></li>
                        <%} else {%>
                        <li><a href="ContentServer?pagename=DevTools/Log4J/Info">LOG4J</a></li>
                        <%}%>
                        <li><a href="ContentServer?pagename=DevTools/Performance/Home">PERFORMANCE</a></li>
                        <li><a href="ContentServer?pagename=DevTools/Logout">LOGOUT</a></li>
                        <%
                        }
                    %>
                </ul>
                <div id="elapsed"></div>
        </div>
    </div>
</cs:ftcs>