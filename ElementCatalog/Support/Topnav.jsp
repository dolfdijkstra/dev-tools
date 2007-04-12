<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Topnav
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
<% 
String hostname = null;
try {
    hostname = java.net.InetAddress.getLocalHost().getHostName();
} catch (java.net.UnknownHostException e){}
String serverport = Integer.toString(request.getServerPort());
java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss z"); 
%>
	<div id="logo">
	    <b><font size="4">Fatwire Corporation Support Tools</font></b>
	    <table width="100%" style="border:none"><tr>
	            <td width="25%" style="text-transform:none;border-bottom:none"><b><font color="white" size="2"><%=ics.GetSSVar("username")%> at <%= hostname%>:<%= serverport%></font></b></td>
	            <td width="25%" style="text-align:right;border-bottom:none"><b><font color="white" size="2"><%= df.format(new java.util.Date())%></font></b></td>
	    </tr></table>           
	</div>
    <div id="nav-bg">
        <div id="nav">
            <b>
                <ul>
                    <li><a href="ContentServer?pagename=Support/Info/collectInfo">HOME</a></li>
                    <li><a href="ContentServer?pagename=Support/Audit/Home">SYSTEM</a></li>
                    <li><a href="ContentServer?pagename=Support/TCPI/Home">APPROVAL</a></li>
                    <li><a href="ContentServer?pagename=Support/CacheManager/Home">CACHE</a></li>
                    <li><a href="ContentServer?pagename=Support/Flex/Home">FLEX</a></li>
                    <li><a href="ContentServer?pagename=Support/Verify/Home">MISC</a></li>
                    <li><a href="ContentServer?pagename=Support/LDAP/Integrate">LDAP</a></li>
                    <li><a href="ContentServer?pagename=Support/Info/sqlplus">SQLPLUS</a></li>
                </ul>
            </b>
        </div>
    </div>
    <div class="spacer">&nbsp;</div><br/>
</cs:ftcs>