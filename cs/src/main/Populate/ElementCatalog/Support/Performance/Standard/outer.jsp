<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs><%
String style=ics.GetVar("style");
int cb = Long.valueOf(System.currentTimeMillis()%5).intValue();
if (ics.GetVar("cb") !=null){
    cb= Integer.parseInt(ics.GetVar("cb"));
}
int runs=1000;
if (ics.GetVar("runs") !=null){
    runs= Integer.parseInt(ics.GetVar("runs"));
}

%>
<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="style" value='<%= style %>' />
  <render:argument name="cb" value="<%= Integer.toString(cb) %>"/>
  <render:argument name="runs" value="<%= Integer.toString(runs) %>"/>
</render:getpageurl>
<a href='<%=ics.GetVar("theURL")%>'>reload</a><br/>

<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="style" value='<%= style %>' />
  <render:argument name="cb" value="<%= Integer.toString(Long.valueOf(System.currentTimeMillis()%5).intValue()) %>"/>
  <render:argument name="runs" value="<%= Integer.toString(runs) %>"/>
</render:getpageurl>
<a href='<%=ics.GetVar("theURL")%>'>random cb value</a><br/>

<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="style" value="element"/>
  <render:argument name="cb" value="<%= Integer.toString(cb) %>"/>
  <render:argument name="runs" value="<%= Integer.toString(runs) %>"/>
</render:getpageurl>
<a href='<%=ics.GetVar("theURL")%>'>element style</a><br/>
<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="style" value="embedded"/>
  <render:argument name="cb" value="<%= Integer.toString(cb) %>"/>
  <render:argument name="runs" value="<%= Integer.toString(runs) %>"/>
</render:getpageurl>
<a href='<%=ics.GetVar("theURL")%>'>embedded style</a><br/>
<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="style" value="pagelet"/>
  <render:argument name="cb" value="<%= Integer.toString(cb) %>"/>
  <render:argument name="runs" value="<%= Integer.toString(runs) %>"/>
</render:getpageurl>

<a href='<%=ics.GetVar("theURL")%>'>pagelet style</a><br/>
<%
if ("element".equals(style)){
    for (int i=0; i< runs; i++){
        %><render:callelement elementname="Support/Performance/Standard/simple" scoped="local"><render:argument name="id" value="<%= Integer.toString(i) %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/></render:callelement><br/><%
    }
} else if ("embedded".equals(style)){
    for (int i=0; i< runs; i++){
        %><render:contentserver pagename="Support/Performance/Standard/simple"><render:argument name="id" value="<%= Integer.toString(i) %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/></render:contentserver><br/><%
    }
}else {
    for (int i=0; i< runs; i++){
        %><render:satellitepage pagename="Support/Performance/Standard/simple"><render:argument name="id" value="<%= Integer.toString(i) %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/></render:satellitepage><br/><%
    }
}
%></cs:ftcs>