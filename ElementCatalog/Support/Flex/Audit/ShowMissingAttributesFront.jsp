<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Flex/Audit/ShowMissingAttributesFront
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<satellite:tag>
	 	 <satellite:parameter name='type' value='open'/>
</satellite:tag>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<ics:callelement element="Support/Flex/Audit/AssetTypeForm">
    <ics:argument name="PostPage" value="MissingAttributes"/>
</ics:callelement>
<ics:callelement element="Support/Footer"/>
</div>
<satellite:tag>
	 	 <satellite:parameter name='type' value='closed'/>
</satellite:tag>
</cs:ftcs>
