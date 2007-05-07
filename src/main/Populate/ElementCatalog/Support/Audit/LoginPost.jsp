<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="user" uri="futuretense_cs/user.tld" %>
<%//
// Support/Audit/LoginPost
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
String redir = "Support/Audit/Home";
if (ics.GetVar("login") != null){
	ics.RemoveSSVar("username");
%>
    <user:login username='<%= ics.GetVar("username") %>'  password='<%= ics.GetVar("password") %>'/>
<%
	if (ics.GetErrno() == 0){
        //ics.SetSSVar("activesession","true");
		ics.SetSSVar("username",ics.GetVar("username"));
		redir = "Support/Audit/Home";
	}
}
if (ics.UserIsMember("SiteGod")){
%>
    <ics:callelement element="Support/Audit/Home"/>
<% } else { %>
    <meta http-equiv="refresh" content='0;URL=ContentServer?pagename=<%= redir %>'>
<% } %>
</cs:ftcs>