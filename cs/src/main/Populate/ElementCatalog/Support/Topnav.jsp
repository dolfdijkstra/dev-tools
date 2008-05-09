<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Topnav
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><% 
    String hostname = null;
    try {
        hostname = java.net.InetAddress.getLocalHost().getHostName();
    } catch (java.net.UnknownHostException e){}
    String serverport = Integer.toString(request.getServerPort());
    java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss z"); 
%><div id="logo">
        <table width="100%"><tr>
                <td width="25%"><%=ics.GetSSVar("username")%> at <%= hostname%>:<%= serverport%></td>
                <td width="50%"><p>Fatwire Corporation Support Tools</p></td>
                <td width="25%" style="text-align:right"><%= df.format(new java.util.Date())%></td>
        </tr></table>           
    </div>
    <div id="nav-bg">
        <div id="nav">
                <ul>
                    <li><a href="ContentServer?pagename=Support/Home">HOME</a></li>
                    <% if (ics.UserIsMember("SiteGod")){
                    %><li><a href="ContentServer?pagename=Support/Info/collectInfo">INFO</a></li>
                    <li><a href="ContentServer?pagename=Support/Audit/Home">SYSTEM</a></li>
                    <li><a href="ContentServer?pagename=Support/TCPI/Home">APPROVAL</a></li>
                    <li><a href="ContentServer?pagename=Support/CacheManager/Home">CACHE</a></li>
                    <li><a href="ContentServer?pagename=Support/Flex/Home">FLEX</a></li>
                    <li><a href="ContentServer?pagename=Support/Verify/Home">MISC</a></li>
                    <li><a href="ContentServer?pagename=Support/Log4J/Log4J">LOG4J</a></li>
                    <!--li><a href="ContentServer?pagename=Support/LDAP/Integrate">LDAP</a></li -->
                    <li><a href="ContentServer?pagename=Support/Info/sqlplus">SQLPLUS</a></li>
                    <%
                    	}
                    %><li><a href="ContentServer?pagename=Support/Logout">LOGOUT</a></li>                
                </ul>
	    </div>
    </div>
    <div class="spacer">&nbsp;</div><br/>
</cs:ftcs>
