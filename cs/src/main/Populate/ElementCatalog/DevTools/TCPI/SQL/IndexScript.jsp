<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// DevTools/TCPI/SQL/IndexScript
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>

<ics:callelement element="DevTools/TCPI/SQL/SQLScriptHeader">
	<ics:argument name="scriptname" value="index"/>
</ics:callelement>

<ics:callelement element="DevTools/TCPI/SQL/AssetIndexes"/>
<ics:callelement element="DevTools/TCPI/SQL/FlexAssetDefs"/>
<ics:callelement element="DevTools/TCPI/SQL/FlexAssets"/>
<ics:callelement element="DevTools/TCPI/SQL/FlexGroupDefs"/>
<ics:callelement element="DevTools/TCPI/SQL/FlexGroups"/>
<ics:callelement element="DevTools/TCPI/SQL/TemporaryIndexes"/>

<ics:callelement element="DevTools/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>
