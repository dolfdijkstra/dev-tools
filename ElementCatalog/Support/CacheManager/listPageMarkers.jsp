<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// CacheManager/listPageMarkers
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
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%!

private static final String PAGE_MARKER="com.fatwire.satellite.page";
private static final String PAGE_MARKER_START="<" + PAGE_MARKER +" ";
private static final String PAGE_MARKER_END="/" + PAGE_MARKER +">";

private static final String BLOB_MARKER="com.fatwire.satellite.blob";
private static final String BLOB_MARKER_START="<" + BLOB_MARKER +" ";
private static final String BLOB_MARKER_END="/" + BLOB_MARKER +">";

private static String[] listMarkers(String body){
	//in jdk 1.4 we would do Sting.split("<page.*/page>");
	//here we have the joy to implement this ourselves.

	int tStart = 0;
	int tEnd = 0;
	java.util.List list = new java.util.ArrayList();
	while ((tStart= body.indexOf(PAGE_MARKER_START,tEnd)) != -1){ 
	if ((tEnd = body.indexOf(PAGE_MARKER_END,tStart)) > -1){
	list.add(body.substring(tStart+PAGE_MARKER_START.length(),tEnd));
		}
	}
	tStart = 0;
	tEnd = 0;

	while ((tStart= body.indexOf(BLOB_MARKER_START,tEnd)) != -1){ 
    	    if ((tEnd = body.indexOf(BLOB_MARKER_END,tStart)) > -1){
	        list.add(body.substring(tStart+BLOB_MARKER_START.length(),tEnd));
	    }
	}
	
	return (String[])list.toArray(new String[0]);
}
%>
<cs:ftcs>
<%
String pageBody = ics.GetVar("pagebody");
String[] markers= listMarkers(pageBody);
if (markers.length !=0) {
%>
    <p><b>Page/Blob Markers Found!</b></p>
    <% for (int i=0; i<markers.length;i++){ %>
        <%= Integer.toString(i+1) %>: <%= markers[i] %><br/>
    <% } %>
<% } %>
</cs:ftcs>
