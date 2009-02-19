<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="deliverytype" uri="futuretense_cs/deliverytype.tld" %>
<%//
// Support/TCPI/AP/UndoApprove
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
<%@ page import="java.net.*"%>
<cs:ftcs>
<script language="JavaScript">
function checkall () {
    var obj = document.forms[0].elements[0];
    var formCnt = obj.form.elements.length;
    for (i=0; i<formCnt; i++) {
      if (obj.form.elements[i].name == "apprundo")  {
         if (obj.form.elements[i].checked)
                obj.form.elements[i].checked=false;
         else
            obj.form.elements[i].checked=true;
      }
    }
}
</script>
<center><h3>Overview of Publishable Assets</h3></center>
<%
  String thisPage = ics.GetVar("pagename");
  String ptid = ics.GetVar("ptid");
  String ptname = ics.GetVar("ptname");
  String atype = ics.GetVar("atype");
  String upassets = ics.GetVar("apprundo");
%>

<% if (ics.GetVar("ptid")==null) { %>
    <ics:setvar name="errno" value="0"/>
    <ics:selectto table="PubTarget" listname="pubTgts" what="id,name,type"/>
    <ics:if condition='<%= ics.GetErrno()==0%>'>
    <ics:then>
    <b>Select a Publish Destination:</b>
    <ul class="subnav">
    <ics:listloop listname="pubTgts">
        <deliverytype:load name="dtype" objectid='<%= ics.ResolveVariables("pubTgts.type")%>'/>
        <deliverytype:get name="dtype" field="name" output="dname"/>
        <li>
        <a href='ContentServer?pagename=Support/TCPI/AP/UndoApprove&ptid=<ics:resolvevariables name="pubTgts.id"/>&ptname=<ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)'>
        <ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)</a>
        </li>
    </ics:listloop>
    </ul>
    </ics:then>
    <ics:else>
        No Destinations Available
    </ics:else>
    </ics:if>
<% } else { %>
    <ics:clearerrno/>
    <% if (upassets!=null) {
        java.util.StringTokenizer tz = new java.util.StringTokenizer(upassets,";");
        while (tz.hasMoreTokens()) {
            String token = tz.nextToken();
            ics.SetVar("uid", token.substring(0,token.lastIndexOf(",")));
    %>
            <ics:sql sql='<%= ics.ResolveVariables("update ApprovedAssets set tstate=\'C\' where assetid=Variables.uid and assettype=\'Variables.atype\' and targetid=Variables.ptid")%>' table="ApprovedAssets" listname="uplist1"/>
            <ics:flushcatalog catalog="ApprovedAssets"/>
            <ics:clearerrno/>

            <ics:sql sql='<%= ics.ResolveVariables("update PubKeyTable set newkey=\'D\' where newkey=\'N\' and assetid=Variables.uid and targetid=Variables.ptid")%>' table="PubKeyTable" listname="uplist2"/>
            <ics:flushcatalog catalog="PubKeyTable"/>
            <ics:clearerrno/>
        <% } %>
    <% } %>
    <h3><%= ics.GetVar("ptname")%></h3><br/>
    <ics:flushcatalog catalog="ApprovedAssets"/>
    <ics:flushcatalog catalog="PubKeyTable"/>
    <ics:flushcatalog catalog="PublishedAssets"/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT count(assetid) as num, assettype FROM (SELECT PubKeyTable.assetid as assetid, ApprovedAssets.assettype as assettype FROM PubKeyTable,PublishedAssets,ApprovedAssets WHERE PubKeyTable.id=PublishedAssets.pubkeyid AND PubKeyTable.targetid=Variables.ptid AND ApprovedAssets.targetid=Variables.ptid AND EXISTS(SELECT 1 FROM ApprovedAssets t0 WHERE PublishedAssets.assetid=t0.assetid AND t0.targetid=Variables.ptid AND (PublishedAssets.assetversion!=t0.assetversion OR PublishedAssets.assetdate<t0.assetdate)) AND EXISTS(SELECT 1 FROM ApprovedAssets t1 WHERE PubKeyTable.assetid=t1.assetid AND t1.targetid=Variables.ptid AND t1.tstate=\'A\' AND t1.locked=\'F\') AND PubKeyTable.assetid=ApprovedAssets.assetid UNION SELECT PubKeyTable.assetid as assetid,t2.assettype as assettype FROM PubKeyTable,ApprovedAssets t2 WHERE newkey!=\'D\' AND t2.targetid=Variables.ptid AND t2.tstate=\'A\' AND t2.locked=\'F\' AND PubKeyTable.assetid=t2.assetid AND PubKeyTable.targetid=Variables.ptid) foo GROUP BY assettype ORDER BY assettype")%>' table='PubKeyTable' listname='tlist'/>
    <% int total = 0; %>
    <ics:listloop listname="tlist">
        <% total += Integer.parseInt(ics.ResolveVariables("tlist.num")); %>
    </ics:listloop>
    <%= total %> items are ready for publish....
    <table class="altClass" sytle="width:50%">
        <tr><th>Nr</th><th>assettype</th><th>total</th></tr>
        <% int i=1; %>
        <ics:listloop listname="tlist">
        <tr>
            <td><%= i++ %></td>
            <td>
            <a href='<%= ics.ResolveVariables("ContentServer?pagename=Variables.pagename&ptid=Variables.ptid&ptname=Variables.ptname&atype=tlist.assettype")%>'>
                <ics:listget listname="tlist" fieldname="assettype"/>
            </a>
            </td>
            <td><ics:listget listname="tlist" fieldname="num"/></td>
        </tr>
        </ics:listloop>
    </table>
    <% if (ics.GetVar("atype")!=null) { %>
        <hr/><h4><%= ics.GetVar("atype")%></h4>
        <ics:flushcatalog catalog='<%= ics.GetVar("atype")%>'/>
        <ics:flushcatalog catalog="ApprovedAssets"/>
        <ics:flushcatalog catalog="PubKeyTable"/>
        <ics:flushcatalog catalog="PublishedAssets"/>
        <form method="POST" action='ContentServer?pagename=<%=thisPage %>&ptid=<%=ptid%>&ptname=<%=ptname%>&atype=<%=atype%>'>
        <a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>
        &nbsp;<input type="Submit" name="undo" value="UndoApprove"><br/><br/>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT assetid, name, updateddate, updatedby, state FROM (SELECT ta.id as assetid,ta.name as name,ta.updateddate as updateddate,ta.updatedby as updatedby,ApprovedAssets.state as state FROM PubKeyTable,PublishedAssets,ApprovedAssets,Variables.atype ta WHERE PubKeyTable.id=PublishedAssets.pubkeyid AND PubKeyTable.targetid=Variables.ptid AND ApprovedAssets.targetid=Variables.ptid AND EXISTS(SELECT 1 FROM ApprovedAssets t0 WHERE PublishedAssets.assetid=t0.assetid AND t0.targetid=Variables.ptid AND (PublishedAssets.assetversion!=t0.assetversion OR PublishedAssets.assetdate<t0.assetdate)) AND EXISTS(SELECT 1 FROM ApprovedAssets t1 WHERE PubKeyTable.assetid=t1.assetid AND t1.targetid=Variables.ptid AND t1.tstate=\'A\' AND t1.locked=\'F\') AND PubKeyTable.assetid=ApprovedAssets.assetid AND ApprovedAssets.assettype=\'Variables.atype\' AND PubKeyTable.assetid=ta.id AND ta.status!=\'VO\' UNION SELECT tb.id as assetid,tb.name as name,tb.updateddate as updateddate,tb.updatedby as updatedby,t2.state as state FROM PubKeyTable,ApprovedAssets t2,Variables.atype tb WHERE newkey!=\'D\' AND t2.targetid=Variables.ptid AND t2.tstate=\'A\' AND t2.locked=\'F\' AND PubKeyTable.assetid=t2.assetid AND PubKeyTable.targetid=Variables.ptid AND t2.assettype=\'Variables.atype\' AND PubKeyTable.assetid=tb.id AND tb.status!=\'VO\') foo ORDER BY assetid")%>' table='PubKeyTable' listname='talist'/>
        <table class="altClass">
            <tr><th>undo</th><th>Nr</th><th>assetid</th><th>name</th><th>updateddate</th><th>updatedby</th><th>state</th></tr>
            <% i=1; %>
            <ics:listloop listname="talist">
            <tr>
                <td><input name="apprundo" type="checkbox" value='<ics:listget listname="talist" fieldname="assetid"/>,'/></td>
                <td><%= i++ %></td>
                <td><ics:listget listname="talist" fieldname="assetid"/></td>
                <td><ics:listget listname="talist" fieldname="name"/></td>
                <td><ics:listget listname="talist" fieldname="updateddate"/></td>
                <td><ics:listget listname="talist" fieldname="updatedby"/></td>
                <td><ics:listget listname="talist" fieldname="state"/></td>
            </tr>
            </ics:listloop>
        </table>
        <br/><a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>
        &nbsp;<input type="Submit" name="undo" value="UndoApprove">
        </form>
    <% } %>
<% } %>
</cs:ftcs>
