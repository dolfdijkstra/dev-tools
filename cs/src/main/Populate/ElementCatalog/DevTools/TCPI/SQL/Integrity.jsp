<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// DevTools/TCPI/SQL/Integrity
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" %><cs:ftcs>
<ics:callelement element="DevTools/TCPI/SQL/SQLScriptHeader">
	<ics:argument name="scriptname" value="integrity"/>
</ics:callelement>

<ics:callelement element="DevTools/TCPI/SQL/DelDups">
	<ics:argument name="tablename" value="AssetPublication"/>
	<ics:argument name="keys"      value="assetid;pubid"/>
</ics:callelement>


<ics:callelement element="DevTools/TCPI/SQL/Flex/Attributes"/>
<ics:callelement element="DevTools/TCPI/SQL/Flex/FlexGroupDefs"/>
<ics:callelement element="DevTools/TCPI/SQL/Flex/FlexGroups"/>
<ics:callelement element="DevTools/TCPI/SQL/Flex/FlexAssetDefs"/>
<ics:callelement element="DevTools/TCPI/SQL/Flex/FlexAssets"/>

<ics:callelement element="DevTools/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>
