<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/LeftNav
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
        <h2>File Browser</h2>
        <ul class="subnav divider">
            <li><a href="ContentServer?pagename=Support/Verify/Files/ftcslog">FutureTense Log</a></li>
            <li><a href="ContentServer?pagename=Support/Verify/Files/go">JSP FileBrowser</a></li>
        </ul>
        <h2>General</h2>
        <ul class="subnav divider">
            <li><a href="ContentServer?pagename=Support/Verify/xml/tablelist">TableList</a></li>
            <li><a href="ContentServer?pagename=Support/Verify/xml/exportFront">DB to XML</a></li>
        </ul>
        <h2>Cluster</h2>
        <ul class="subnav divider">
            <li><a href="ContentServer?pagename=Support/Verify/Cluster/HttpSession">HttpSession</a></li>
            <li><a href="ContentServer?pagename=Support/Verify/Cluster/nodeFront">Cluster Nodes</a></li>
            <li><a href="ContentServer?pagename=Support/Verify/Cluster/CheckSyncdirTime">CheckSyncdirTime</a></li>
            <li><a href="ContentServer?pagename=Support/Verify/Cluster/LockTest">LockTest</a></li>
            <li><a href="ContentServer?pagename=Support/Verify/Cluster/ClusterTest">Basic Cluster Test</a></li>
        </ul>
        <h2>Unicode</h2>
        <ul class="subnav divider">
            <li><a href="ContentServer?pagename=Support/Verify/i18n/encoding">Unicode Form Post</a></li>
            <li><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeChart">Unicode Chart</a></li>
        </ul>
    </div>
</cs:ftcs>