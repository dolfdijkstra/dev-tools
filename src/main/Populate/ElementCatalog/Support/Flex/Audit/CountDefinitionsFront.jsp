<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Flex/Audit/CountDefinitionsFront
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
%><cs:ftcs>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Flex/LeftNav"/>
<div class="right-column">
<ics:callelement element="Support/Flex/Audit/AssetTypeForm">
    <ics:argument name="PostPage" value="CountDefinitions"/>
</ics:callelement>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
