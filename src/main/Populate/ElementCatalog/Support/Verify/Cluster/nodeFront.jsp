<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/nodeFront
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
<ics:callelement element="Support/Verify/LeftNav"/>
<div class="right-column">
<p>Please fill in number of ClusterNodes in your environment</p>
<form method="POST" action="ContentServer">
  Number of Nodes: <input type="text" name="numofnodes" size="20"></p>
  <p><input type="submit" value="Submit" name="B1">
     <input type="reset" value="Reset" name="B2"></p>
  <input type="hidden" value="Support/Verify/Cluster/nodeselect" name="pagename">
</form>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
