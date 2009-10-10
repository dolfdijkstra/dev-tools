<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="COM.FutureTense.Util.*" %>
<%@ page import="COM.FutureTense.Cache.*"%>
<%@ page import="java.util.*"%>
<cs:ftcs><h3><center>Flush SatelliteServer Cache</center></h3>
<%
String thisPage = ics.GetVar("pagename");
if (ics.GetVar("expire")!=null) {
    Set<Satellite> satellites = Satellite.getAll(ics);
    for (Satellite s:satellites){
        out.write(s.satelliteServerUrl());
        out.write(": ");
        ftStatusCode status = CacheHelper.postRefresh(new Satellite[] {s}, Satellite.FLUSHALL_COMMAND, null);
        out.write(status !=null? String.valueOf(status.getResult()):"unknown");
        out.write("<br/>");
    }
} else {

%><form method="POST" action='ContentServer?pagename=<%=thisPage %>'>
<b>Do you want to flush all Satellite Server caches? </b>&nbsp;<input type="Submit" name="expire" value="Expire"><br/>
</form>
<% } %></cs:ftcs>