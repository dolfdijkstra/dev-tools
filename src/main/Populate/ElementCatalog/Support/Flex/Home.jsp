<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="user" uri="futuretense_cs/user.tld"%>
<%//
// Support/Flex/Home
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>

<div class="left-column gray">
  <ul class="subnav divider">
    <a href="ContentServer?pagename=Support/Flex/Home">Login</a>
  </ul>
</div>
<div class="right-column">
<%
if (ics.GetVar("login") != null){
	ics.RemoveSSVar("username");
%>
    <user:login username='<%= ics.GetVar("username") %>' password='<%= ics.GetVar("password") %>'/>
<%
	if (ics.GetErrno() == 0){
		ics.SetSSVar("username",ics.GetVar("username"));
	}
}
%>

<% if (ics.UserIsMember("SiteGod")){ %>
    <div class="entry-header">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/ShowDefinitionTree"><b>ShowDefinitionTree</b></a></h2>
    </div>
    <div class="entry">
         <p>Displays parent definitions with their heirarchy and attributes on each, useful for a quick overview.</p>
    </div>
    <div class="entry-header">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/ShowDefinitionsFront"><b>ShowDefinitions</b></a></h2>
    </div>
    <div class="entry">
         <p>Displays the basic structure of an assettype with its definition, associated parents (immediate) and attributes.</p>
    </div>
    <div class="entry-header">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/ShowParentsFront"><b>ShowParents</b></a></h2>
    </div>
    <div class="entry">
         <p>Displays all parents of a given assettype with associated data of attributes and other parent inforamtion.</p>
    </div>
    <div class="entry-header">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/CountDefinitionsFront"><b>CountDefinitions</b></a></h2>
    </div>
    <div class="entry">
         <p>Counts total number of assets for a given definition.</p>
    </div>
    <div class="entry-header">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/CountAttributesFront"><b>CountAttributes</b></a></h2>
    </div>
    <div class="entry">
         <p>Counts total usage of attributes for a given assettype.</p>
    </div>
    <div class="entry-header">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/ShowMissingAttributesFront"><b>ShowMissingAttributes</b></a></h2>
    </div>
    <div class="entry">
         <p>For a given assetype, displays how many assets do not have all the required attributes.</p>
    </div>    
<% } else { %>
   <div class="entry-header">
	      <ics:callelement element="Support/Flex/LoginForm"/>
   </div>
<% } %>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
