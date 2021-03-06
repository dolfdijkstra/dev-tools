<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// DevTools/Audit/DispatcherFront
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><%
String cmd = ics.GetVar("cmd");

String defaultElementName = "DevTools/Audit/Default/" + cmd;
String elementName = null;

if (ics.IsElement(defaultElementName)) {
	elementName = defaultElementName;
}

if (elementName != null) {
	%><!-- Calling: <%= elementName %> -->
	<ics:callelement element='<%= elementName %>' /><%
} else {
	%>No element found for command: "<%= cmd %>" <%
}
%></cs:ftcs>
