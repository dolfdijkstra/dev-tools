<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// Support/Audit/V5/SE/UseSE
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
<script language="JavaScript">
function checkall () {
	var obj = document.forms[0].elements[0];
	var formCnt = obj.form.elements.length;
	for (i=0; i<formCnt; i++) {
        if (obj.form.elements[i].name == "seindex")  {
            if (obj.form.elements[i].checked)
    			obj.form.elements[i].checked=false;
             else
                obj.form.elements[i].checked=true;
        }
	}
}
</script>
<center><h3>Verity SearchEngine Reindex</h3></center>
<%
   String thisPage = ics.GetVar("pagename");
   String cmd = ics.GetVar("cmd");
   String assetattrs = ics.GetVar("seindex");
   if (assetattrs!=null) {
%>
    <table class="altClass">
        <tr><th>Attribute</th><th>AttrId</th><th>Destroy?</th><th>Create?</th></tr>
<%
       java.util.StringTokenizer tz = new java.util.StringTokenizer(assetattrs,";");
       while (tz.hasMoreTokens()) {
           String token = tz.nextToken();
           String attrid = token.substring(0,token.lastIndexOf(","));
           String attrtype = token.substring(token.lastIndexOf(",")+1);
%>        
        <tr>
        <td><%= attrtype%></td>
        <td><%= attrid%></td>
        <ics:clearerrno/>
        <asset:load name="myAttr" objectid='<%= attrid %>' type='<%= attrtype %>' editable='true'/>
        <asset:set  name="myAttr" field="enginename" value="" />
        <asset:set  name="myAttr" field="charsetname" value="" />
        <asset:save name="myAttr"/>
        <td><ics:geterrno/></td>
        <ics:clearerrno/>        
        <asset:set  name="myAttr" field="enginename" value="verity" />
        <asset:set  name="myAttr" field="charsetname" value="englishx" />
        <asset:save name="myAttr"/>
        <td><ics:geterrno/></td>
        </tr>
    <% } %>
    </table>
<% } %>

<ics:clearerrno/>
<ics:sql sql="SELECT distinct assetattr FROM FlexAssetTypes ORDER BY assetattr" table="FlexAssetTypes" listname="attributes"/>
<form method="POST" action='ContentServer?pagename=<%=thisPage %>&cmd=<%=cmd%>'>
<a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>
&nbsp;<input type="Submit" name="Index" value="ReIndex"><br/><br/>
<table class="altClass">
<tr><th>&nbsp;</th><th>AttrName</th><th>Type</th><th>Publication</th><th>SearchEngine</th></tr>
<ics:listloop listname="attributes">
    <tr><td colspan="5"><b>Attribute: <font color="blue"><ics:listget listname="attributes" fieldname="assetattr"/></font></b></td></tr>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT t.id,t.name,te.type,te.enginename,pb.name as pubname FROM attributes.assetattr t, attributes.assetattr_Extension te, AssetPublication ap, Publication pb WHERE t.id=te.ownerid AND t.id=ap.assetid AND ap.pubid=pb.id ORDER BY pubname") %>' table='<%= ics.ResolveVariables("attributes.assetattr_Extension") %>' listname="assettypeattrs"/>
    <% if (ics.GetList("assettypeattrs").hasData()) { %>
        <ics:listloop listname="assettypeattrs">
        <tr>                      
            <td align="right"><input name="seindex" type="checkbox" value='<ics:resolvevariables name="assettypeattrs.id"/>,<ics:resolvevariables name="attributes.assetattr"/>'/></td>
            <td><ics:listget listname="assettypeattrs" fieldname="name"/></td>
            <td><ics:listget listname="assettypeattrs" fieldname="type"/></td>
            <td><ics:listget listname="assettypeattrs" fieldname="pubname"/></td>
            <td><ics:listget listname="assettypeattrs" fieldname="enginename"/></td>
        </tr>
        </ics:listloop>
    <% } %>
</ics:listloop>
</table>
<br/><a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>
&nbsp;<input type="Submit" name="Index" value="ReIndex">
</form>
</cs:ftcs>
