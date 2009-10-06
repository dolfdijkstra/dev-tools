<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs><hr/><%
int max = Integer.parseInt(ics.GetVar("max"));
%>
created: <b><%= new java.util.Date() %></b>&nbsp;<%= ics.genID(true) %><br>
a:<b><%= ics.GetVar("a") %></b><br>
max:<b><%= ics.GetVar("max") %></b><br>
level:<b><%= ics.GetVar("level") %></b><br>
page: <b><%= ics.pageURL() %></b><br>
<hr/>
<satellite:link pagename='<%= ics.GetVar("pagename") %>' outstring="url_self"><%
  %><satellite:parameter name="a" value='<%= ics.GetVar("a") %>'/><%
  %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
  %><satellite:parameter name="level" value='<%= ics.GetVar("level") %>'/><%
  %><satellite:parameter name="ft_ss" value='true'/><%
%></satellite:link><%
%><a href='<%= ics.GetVar("url_self") %>'>a=<%= ics.GetVar("a") %></a><br/>
<%
int a = Integer.parseInt(ics.GetVar("a"));
int level = Integer.parseInt(ics.GetVar("level"))-1;

for (int i=a; i<=max && level > 0;i++){
    %><satellite:page pagename='<%= ics.GetVar("pagename") %>'><%
      %><satellite:parameter name="a" value='<%= Integer.toString(i) %>'/><%
      %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
      %><satellite:parameter name="level" value="1"/><%
    %></satellite:page>
<%
}

%></cs:ftcs>
