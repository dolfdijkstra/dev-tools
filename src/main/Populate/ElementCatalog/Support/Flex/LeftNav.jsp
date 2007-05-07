<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Flex/LeftNav
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
<ics:callelement element="Support/Topnav"/>
<div class="left-column gray">
  <h2>Display</h2>
  <ul class="subnav divider">
      <li><a href="ContentServer?pagename=Support/Flex/Audit/ShowDefinitionTree">ShowDefinitionTree</a></li>
      <li><a href="ContentServer?pagename=Support/Flex/Audit/ShowDefinitionsFront">ShowDefinitions</a></li>
      <li><a href="ContentServer?pagename=Support/Flex/Audit/ShowParentsFront">ShowParents</a></li>
  </ul>
  <h2>Count</h2>
  <ul class="subnav divider">
      <li><a href="ContentServer?pagename=Support/Flex/Audit/CountDefinitionsFront">CountDefinitions</a></li>
      <li><a href="ContentServer?pagename=Support/Flex/Audit/CountAttributesFront">CountAttributes</a></li>
      <li><a href="ContentServer?pagename=Support/Flex/Audit/ShowMissingAttributesFront">ShowMissingAttributes</a></li>
  </ul>
</div>
</cs:ftcs>
