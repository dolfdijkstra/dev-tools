<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%
// Support/Flex/Audit/ShowDefinitions
//
// INPUT
//      assettype
// OUTPUT
//      none -- renders to the screen
%>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<h3>Template Definitions</h3>

<p>This pages lists the template definitions for <b><ics:getvar name="assettype"/></b> assettype, attributes defined and how many assets are using this template definition</p>

<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate, assetattr, \'flextemplateid\' as tid, assetgroup FROM FlexAssetTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexAssetTypes" listname="types"/>

<%-- **** if no rows returned, assume it is a flex parent (probably not a good assumption!) --%>
<% if (ics.GetErrno() ==-101){ %>
    <ics:clearerrno/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate, assetattr, \'flexgrouptemplateid\' as tid FROM FlexGroupTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexGroupTypes" listname="types"/>
    <ics:clearerrno/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate FROM FlexGroupTypes WHERE assettype = \'Variables.assettype\' ") %>'  table="FlexGroupTypes" listname="fgt"/>
<% } else { %>
    <ics:clearerrno/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate FROM FlexTmplTypes WHERE assettype = \'types.assettemplate\' ") %>'  table="FlexTmplTypes" listname="fgt"/>
<% } %>

<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT d.name AS defname, d.id FROM types.assettemplate d WHERE d.status != \'VO\' ORDER BY d.name") %>' table='<%= ics.ResolveVariables("types.assettemplate") %>' listname="templates"/>

<table class="altClass" width="100%">
    <tr>
      <th>Definition</th>
      <th><ics:resolvevariables name="types.assetattr"/></th>
    </tr>
    <ics:listloop listname="templates">
    <tr>
        <td width="250" valign="top">
            <b><ics:resolvevariables name="templates.defname"/> </b>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) AS num FROM Variables.assettype WHERE types.tid = templates.id AND status != \'VO\'") %>' table='<%= ics.ResolveVariables("Variables.assettype") %>' listname="assetcount"/>
            (<ics:resolvevariables name="assetcount.num"/>)
        </td>
        <td>
            <ics:clearerrno/>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT da.ownerid, a.name as aname, a.attributetype as attreditorid, a.status as status, da.attributeid, da.requiredflag as required, da.ordinal as ordinal, ae.type, ae.assettypename as atname, ae.valuestyle FROM types.assettemplate_TAttr da, types.assetattr a, types.assetattr_Extension ae WHERE a.id=ae.ownerid AND da.ownerid = templates.id AND a.id = da.attributeid ORDER BY ordinal, a.name") %>' table='<%= ics.ResolveVariables("types.assettemplate_TAttr") %>' listname="templateattributes"/>

            <%// ***** Don't render the parents if there are none to render ***** %>
            <% if (ics.GetErrno() !=-101){ %>
                <ics:clearerrno/>
                <ics:sql sql='<%= ics.ResolveVariables("SELECT ownerid, productgrouptemplateid, requiredflag as required, multipleflag as multiple FROM types.assettemplate_TGroup WHERE templateattributes.ownerid=ownerid ") %>' table='<%= ics.ResolveVariables("types.assettemplate_TGroup") %>' listname="parentlist1" />

                <table cellspacing="0">
                    <tr>
                        <th width="10%">Req?</th>
                        <th width="30%">Parent Name</th>
                        <th width="20%"></th>
                        <th width="20%">Multi?</th>
                        <th width="20%"></th>
                    </tr>
                    <ics:listloop listname="parentlist1">
                        <tr>

                                <ics:clearerrno/>
                                <ics:sql sql='<%= ics.ResolveVariables("SELECT name FROM fgt.assettemplate WHERE id = parentlist1.productgrouptemplateid ") %>' table='<%= ics.ResolveVariables("fgt.assettemplate") %>' listname="parentname" />

                                <% if ("T".equals(ics.ResolveVariables("parentlist1.required"))){ %>
                                    <td width="10">*</td>

                                    <td width="200"><font color="red"><ics:resolvevariables name="parentname.name"/></font></td>
                                <% } else { %>
                                    <td width="10"></td>
                                    <td width="200"><ics:resolvevariables name="parentname.name"/></td>
                                <% } %>
                                      <td></td>
                                <td>
                                    <% if ("T".equals(ics.ResolveVariables("parentlist1.multiple"))){ %>
                                        M
                                    <% } else { %>
                                        S
                                    <% } %>
                                </td>
                                <td></td>
                        </tr>
                    </ics:listloop>
                </table>
            <% } else { %>
                No flex parents for this definition.
            <% } %>

            <br/>

            <table cellspacing="0">
                 <tr>
                      <th width="10%">Req?</th>
                      <th width="30%">Attr Name</th>
                      <th width="20%">Attr Type</th>
                      <th width="20%">Multi?</th>
                      <th width="20%">Attr Editor</th>
                 </tr>
                <ics:listloop listname="templateattributes">
                    <tr>
                        <% if ("T".equals(ics.ResolveVariables("templateattributes.required"))){ %>
                            <td width="10">*</td><td width="200"><font color="red"><ics:resolvevariables name="templateattributes.aname"/></font></td>
                        <% } else { %>
                            <td width="10"></td><td width="200"><ics:resolvevariables name="templateattributes.aname"/></td>
                        <% } %>
                        <td width="30">
                            <% if ("asset".equals(ics.ResolveVariables("templateattributes.type"))){ %>
                            <ics:resolvevariables name="templateattributes.type"/> (<ics:resolvevariables name="templateattributes.atname"/>)
                        <% } else { %>
                            <ics:resolvevariables name="templateattributes.type"/>
                        <% } %>
                        </td>
                        <td width="10"><ics:resolvevariables name="templateattributes.valuestyle"/></td>
                        <td width="30">
                            <% if ( (ics.ResolveVariables("templateattributes.attreditorid") != null) && (ics.ResolveVariables("templateattributes.attreditorid").length() > 0)) { %>
                                <ics:sql sql='<%= ics.ResolveVariables("SELECT id, name FROM AttrTypes WHERE templateattributes.attreditorid = id") %>' table='AttrTypes' listname="AttributeEditor"/>
                                <ics:resolvevariables name="AttributeEditor.name"/>
                            <% } else { %>
                                &nbsp;
                            <% } %>
                        </td>
                        <ics:clearerrno/>
                    </tr>
                </ics:listloop>
            </table>

        </td>
        <ics:clearerrno/>
    </tr>
    </ics:listloop>
</table>
</cs:ftcs>
