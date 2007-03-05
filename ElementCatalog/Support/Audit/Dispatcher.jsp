<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Dispatcher
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
String cmd = ics.GetVar("cmd");

String version = ics.GetProperty("ft.version");
String majorVersion = version.substring(0,1); // this will kill use above version 9.

String versionSpecificElementName = "Support/Audit/V" + majorVersion + "/" + cmd;
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
%>
</cs:ftcs>

