<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="deliverytype" uri="futuretense_cs/deliverytype.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList" %>
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
      if (obj.form.elements[i].name == "remPub")  {
         if (obj.form.elements[i].checked)
                obj.form.elements[i].checked=false;
         else
            obj.form.elements[i].checked=true;
      }
    }
}

//function for checking if the asset selected is a deletion
function checkVoided() {

  var obj = document.forms[0].elements[0];
  var formCnt = obj.form.elements.length;
  var cont = true;
  var deletions = "";

  //loops for all checkboxes with id set to "VO"
  for (i=0; i<formCnt; i++) {

    if (obj.form.elements[i].name == "remPub")  {
      if (obj.form.elements[i].checked && obj.form.elements[i].id == "VO")
          deletions = deletions + obj.form.elements[i].value + "\n";
    }
  }

  if (deletions != "")
      cont = (prompt("WARNING!\n\n" + "The following assets are asset deletions:\n\n" + deletions + "\nYou will not be able to publish this deletion if you remove it from the publish queue.\n\nPlease type in \"YES\" if you are absolutely sure you would like to proceed with this:") == "YES");

  return cont;

}

</script>
<h3>Remove Assets from Publish Queue</h3>

<%-- Setting up variables --%>
<%
  String thisPage = ics.GetVar("pagename");
  String removePub = ics.GetVar("remPub");
%>
     <ics:clearerrno/>
    <ics:selectto table="PubTarget" listname="pubTgts" what="id,name,type"/>
    <ics:if condition='<%= ics.GetErrno()==0%>'>
    <ics:then>
    <b>Select a Publish Destination:</b>
    <ul class="subnav">
    <ics:listloop listname="pubTgts">
        <deliverytype:load name="dtype" objectid='<%= ics.ResolveVariables("pubTgts.type")%>'/>
        <deliverytype:get name="dtype" field="name" output="dname"/>
        <li>
        <a href='ContentServer?pagename=<%= thisPage %>&targetid=<ics:resolvevariables name="pubTgts.id"/>'>
        <ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)</a>
        </li>
    </ics:listloop>
    </ul>
    </ics:then>
    <ics:else>
        No Destinations Available
    </ics:else>
    </ics:if>
<% if (ics.GetVar("targetid")!=null) { %>
    <ics:clearerrno/>

    <%-- If assets have been selected, remove these from this target's publish queue --%>
    <% if (removePub!=null) { %>

      <%
        java.util.StringTokenizer tz = new java.util.StringTokenizer(removePub,";");
        int counter=1000;
        while (tz.hasMoreTokens()) {
          String token = tz.nextToken();
          ics.SetVar("atype", token.substring(0, token.indexOf(":")));
          ics.SetVar("uid", token.substring(token.indexOf(":")+1));
          counter++;
      %>

      <%-- Inserts a row into the ApprovalQueue table for the particular asset to be removed --%>
      <ics:catalogmanager>
                  <ics:argument name="ftcmd" value="addrow"/>
                  <ics:argument name="tablename" value="ApprovalQueue"/>
                  <ics:argument name="cs_ordinal" value='<%= Integer.toString(counter) %>'/>
                  <ics:argument name="cs_assettype" value='<%= ics.GetVar("atype") %>'/>
                  <ics:argument name="cs_assetid" value='<%= ics.GetVar("uid") %>'/>
                  <ics:argument name="cs_optype" value='C'/>
                  <ics:argument name="cs_voided" value='F'/>
      </ics:catalogmanager>
      <%  } %>
      <%-- Trigger the removal of the asset in the ApprovalQueue --%>
      <%
        FTValList args = new FTValList();
        String output = null;

        args.setValString("TARGET",ics.GetVar("targetid"));
        args.setValString("VARNAME","heldAssetsCount");

        output = ics.runTag("APPROVEDASSETS.COUNTHELDASSETS", args);
      %>
      <ics:clearerrno/>

    <% } %>

    <%-- Displays all assets currently in the publish queue --%>
    <ics:setvar name="id" value='<%= ics.GetVar("targetid") %>'/>
    <ics:selectto table="PubTarget" listname="pubTgts" what="id,name,type" where="id" />
    <ics:if condition='<%= ics.GetErrno()==0%>'>
    <ics:then>
            <deliverytype:load name="dtype" objectid='<%= ics.ResolveVariables("pubTgts.type")%>'/>
        <deliverytype:get name="dtype" field="name" output="dname"/>
      <h3><%= ics.ResolveVariables("pubTgts.name (Variables.dname)")%></h3><br/>
      </ics:then>
    </ics:if>
    <ics:flushcatalog catalog="ApprovalQueue"/>
    <ics:flushcatalog catalog="PubKeyTable"/>
    <ics:flushcatalog catalog="PublishedAssets"/>
    <ics:flushcatalog catalog="ApprovedAssets"/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT DISTINCT PublishedAssets.assetid AS assetid, PublishedAssets.assettype AS assettype, ApprovedAssets.tstate AS tstate FROM PubKeyTable,PublishedAssets,ApprovedAssets WHERE PubKeyTable.id=PublishedAssets.pubkeyid AND PubKeyTable.targetid=Variables.targetid AND ApprovedAssets.assetid=PublishedAssets.assetid AND ApprovedAssets.targetid=Variables.targetid AND EXISTS (SELECT 'x' FROM ApprovedAssets t0 WHERE PublishedAssets.assetid=t0.assetid AND t0.targetid=Variables.targetid AND (PublishedAssets.assetversion!=t0.assetversion OR PublishedAssets.assetdate<t0.assetdate)) AND EXISTS (SELECT 'x' FROM ApprovedAssets t1 WHERE PubKeyTable.assetid=t1.assetid AND t1.targetid=Variables.targetid AND t1.tstate='A' AND t1.locked='F') UNION SELECT t2.assetid AS assetid, t2.assettype AS assettype, t2.tstate AS tstate FROM PubKeyTable,ApprovedAssets t2 WHERE newkey!='D' AND t2.targetid=Variables.targetid AND (t2.tstate='A' OR t2.tstate='H') AND t2.locked='F' AND PubKeyTable.assetid=t2.assetid AND PubKeyTable.targetid=Variables.targetid")%>' table='PubKeyTable' listname='tlist'/>

    <form method="POST" action='ContentServer?pagename=<%=thisPage %>&targetid=<%=ics.GetVar("targetid")%>' onsubmit="return checkVoided();">
    <%
      int held = 0, appr = 0;
    %>

    Total number of assets ready for publish: <%= ics.GetList("tlist").numRows() %><br/>
    <br/>
    <table class="altClass" sytle="width:50%">
        <tr><th>Remove <input type="checkbox" onclick="return checkall()"/></th><th>State</th><th>Asset ID</th><th>Asset Type</th><th>Asset Name</th><th>Asset Description</th></tr>

        <ics:listloop listname="tlist">

          <ics:listget listname="tlist" fieldname="assetid" output="assetID" />
          <ics:listget listname="tlist" fieldname="assettype" output="assetType" />
          <ics:listget listname="tlist" fieldname="tstate" output="state" />

          <%-- get asset's name and description --%>
          <ics:sql sql='<%= ics.ResolveVariables("SELECT name, description, status FROM Variables.assetType WHERE id=Variables.assetID") %>' table='<%= ics.GetVar("assetType") %>' listname="anamelist" />

          <ics:listget listname="anamelist" fieldname="name" output="assetName" />
          <ics:listget listname="anamelist" fieldname="description" output="assetDesc" />

          <%-- counts the number of held assets and approved assets --%>
          <%
          if (ics.GetVar("state").equals("H"))
            held++;
          else
            appr++;
          %>

          <tr>
            <td><input type="checkbox" name="remPub" value='<%= ics.GetVar("assetType") + ":" + ics.GetVar("assetID") %>' id='<ics:listget listname="anamelist" fieldname="status" />' /></td>
            <td><%= ics.GetVar("state") %></td>
            <td><%= ics.GetVar("assetID") %></td>
            <td><%= ics.GetVar("assetType") %></td>
            <td><%= ics.GetVar("assetName") %></td>
            <td><%= ics.GetVar("assetDesc") %></td>
          </tr>
        </ics:listloop>
    </table>
    <br/>
    Number of held assets: <%= held %><br/>
    Number of approved assets: <%= appr %><br/>
    <input type="submit"/>
    </form>
<% } %>
</cs:ftcs>
