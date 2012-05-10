<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Audit/Dispatcher
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><%
String cmd = ics.GetVar("cmd");

String versionSpecificElementName = "Support/Audit/V7/" + cmd;
String defaultElementName = "Support/Audit/Default/" + cmd;
String elementName = null;

if (ics.IsElement(versionSpecificElementName)) {
	elementName = versionSpecificElementName;
} else if (ics.IsElement(defaultElementName)) {
	elementName = defaultElementName;
}

if (elementName != null) {
	%><!-- Calling: <%= elementName %> -->
	<ics:callelement element='<%= elementName %>' /><%
} else {
	%>No version(<%= version %>) element and no default element found for command: "<%= cmd %>" <%
}
%></cs:ftcs>

