<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// DevTools/TCPI/SQL/DropIndexes
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" %>
<cs:ftcs>
<ics:callelement element="DevTools/TCPI/SQL/SQLScriptHeader">
	<ics:argument name="scriptname" value="dropindexes"/>
</ics:callelement>
<ics:sql sql="SELECT index_name AS indexname FROM user_indexes WHERE index_name LIKE 'I\_FW\_INDT\_%' escape '\\'" table="SystemInfo" listname="LstIndexes"/>
<ics:listloop listname="LstIndexes">
DROP INDEX <ics:resolvevariables name="LstIndexes.indexname"/>;
</ics:listloop>

<ics:callelement element="DevTools/TCPI/SQL/SQLScriptFooter"/>

</cs:ftcs>
