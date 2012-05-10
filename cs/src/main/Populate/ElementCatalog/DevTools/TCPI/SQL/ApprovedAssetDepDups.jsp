<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// DevTools/TCPI/SQL/ApprovedAssetDepDups
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
<ics:callelement element="DevTools/TCPI/SQL/SQLScriptHeader">
    <ics:argument name="scriptname" value="ApprovedAssetDepDups"/>
</ics:callelement>

<ics:sql sql="SELECT DISTINCT targetid FROM ApprovedAssetDeps" table="ApprovedAssetDeps" listname="targets" limit="-1"/>
<ics:listloop listname="targets">
  <ics:callelement element="DevTools/TCPI/SQL/LastPubFix">
      <ics:argument name="targetid"  value='<%= ics.ResolveVariables("targets.targetid") %>' />
  </ics:callelement>
</ics:listloop>
<ics:callelement element="DevTools/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>