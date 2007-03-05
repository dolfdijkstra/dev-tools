<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="deliverytype" uri="futuretense_cs/deliverytype.tld" %>
<%//
// Support/TCPI/AP/ForcePublish
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
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/TCPI/LeftNav"/>
<div class="right-column">
<center><h4>Force Publish to a Destination</h4></center>

<ics:if condition='<%= ics.GetVar("forcepub")!=null %>'>
<ics:then>
    <h4><ics:getvar name="tname"/></h4>
    <ics:sql sql='<%= "select id,assetid from pubkeytable where targetid="+ics.GetVar("targ")+" order by id"%>' listname="pktlist" table="PubKeyTable"/>
    <table class="altClass">
    <tr><th>assetid</th><th>PubkeyTable?</th><th>ApprovedAssets?</th><th>ApprovedAssetDeps?</th></tr>
    <ics:listloop listname="pktlist">
    <tr>
        <td><ics:resolvevariables name="pktlist.assetid"/></td>
        <ics:sql sql='<%="UPDATE PubKeyTable SET NEWKEY=\'N\' WHERE id ="+ics.ResolveVariables("pktlist.id")%>' listname="pktuplist" table="PubKeyTable"/>
        <td><ics:geterrno/></td>
        <ics:sql sql='<%="UPDATE ApprovedAssets SET LASTASSETVERSION=NULL,LASTASSETVOIDED=NULL,LASTASSETDATE=NULL WHERE assetid="+ics.ResolveVariables("pktlist.assetid")%>' listname="aauplist" table="ApprovedAssets"/>
        <td><ics:geterrno/></td>
        <ics:sql sql='<%="SELECT id FROM ApprovedAssets WHERE assetid="+ics.ResolveVariables("pktlist.assetid")%>' listname="aaid" table="ApprovedAssets"/>
        <ics:sql sql='<%="UPDATE ApprovedAssetdeps SET LASTPUB=\'F\' WHERE ownerid="+ics.ResolveVariables("aaid.id")%>' listname="aduplist" table="ApprovedAssetdeps"/>
        <td><ics:geterrno/></td>
    </tr>
    </ics:listloop>
    </table>
<ics:flushcatalog catalog="PubKeyTable"/>
<ics:flushcatalog catalog="ApprovedAssets"/>
<ics:flushcatalog catalog="ApprovedAssetDeps"/>
<br/>
</ics:then>
</ics:if>

<ics:if condition='<%=ics.GetVar("force").equals("view")%>'>
<ics:then>
    <h4><ics:getvar name="tname"/></h4>
    <form method="POST" action='ContentServer?pagename=<%= ics.GetVar("pagename") %>&targ=<%= ics.GetVar("targ") %>&tname=<%= ics.GetVar("tname") %>'>
    <b>Do you want to force publish all assets published to <ics:getvar name="tname"/>? <br/>
    </b>&nbsp;<input type="Submit" name="forcepub" value="ForcePublish"><br/>
    </form> 
</ics:then>
<ics:else>
    <%
       FTValList args = new FTValList();
       String output = null;
    %>
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
        <a href='ContentServer?pagename=Support/TCPI/AP/ForcePublish&force=view&targ=<ics:resolvevariables name="pubTgts.id"/>&tname=<ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)'> <ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)</a>
        </li>
    </ics:listloop>
    </ul>
    </ics:then>
    <ics:else>
        No Destinations Available
    </ics:else>
    </ics:if>
</ics:else>
</ics:if>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
