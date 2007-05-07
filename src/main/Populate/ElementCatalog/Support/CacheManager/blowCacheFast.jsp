<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/CacheManager/blowCacheFast
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
<%@ page import="COM.FutureTense.Util.ftStatusCode"%>
<%@ page import="COM.FutureTense.Cache.*"%>
<%@ page import="java.util.*"%>
<cs:ftcs>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/CacheManager/LeftNav"/>
<div class="right-column">
<h3><center>Delete PageCache</center></h3>
<%
String thisPage = ics.GetVar("pagename");
if (ics.GetVar("blowaway")!=null) { 
%>
<br/>
<ics:sql sql="DELETE FROM SystemPageCache" listname="blowlist" table="SystemPageCache"/>
SystemPageCache Errno: <ics:geterrno/> (-502 is ok)<br>
<ics:flushcatalog catalog="SystemPageCache"/>

<ics:sql sql="DELETE FROM SystemItemCache" listname="blowlist" table="SystemItemCache"/>
SystemItemCache Errno: <ics:geterrno/> (-502 is ok)<br>
<ics:flushcatalog catalog="SystemItemCache"/>

<ics:sql sql="SELECT defdir FROM SystemInfo WHERE tblname='SystemPageCache'" listname="defdirlist" table="SystemInfo"/>
<ics:listget listname="defdirlist" fieldname="defdir" output="xdefdir" />
<b><ics:resolvevariables name='<%= ics.GetVar("xdefdir") %>' output="defdir" delimited="true"/></b><br>
Defdir: <b><ics:getvar name="defdir"/></b><br>
<table class="altClass">
    <tr><th width="90%">Filename</th><th width="10%">Delete?</th></tr>
<%
  if (Utilities.isFolder(ics.GetVar("defdir"))==0){
  	java.util.Vector dirList = Utilities.directoryList(ics.GetVar("defdir"),"*",true, -1);
  	Enumeration enum1 = dirList.elements();
  	while(enum1.hasMoreElements()){
  		String fileName= (String)enum1.nextElement();
  		%><tr><td><%= fileName %></td><td><%= Utilities.isFile(fileName) ==0 %></td></tr><%
  		if (Utilities.isFile(fileName) ==0) {
  			Utilities.deleteFile(fileName);
  		}
  	}
  }
%>
</table>
<%} else { %>
<br/>
<ics:sql sql="SELECT count(*) as itemnum FROM SystemItemCache" listname="itemlist" table="SystemItemCache"/>
<b>Total <ics:listget listname="itemlist" fieldname="itemnum"/> SystemItemCache rows will be deleted.</b><br/>
<ics:sql sql="SELECT count(*) as pagenum FROM SystemPageCache" listname="pagelist" table="SystemPageCache"/>
<b>Total <ics:listget listname="pagelist" fieldname="pagenum"/> SystemPageCache (with filesystem data) will be deleted.</b>
<form method="POST" action='ContentServer?pagename=<%=thisPage %>'>
<b>Do you want to blow away all cache? </b>&nbsp;<input type="Submit" name="blowaway" value="BlowAway"><br/>
</form> 
<% } %>
</div>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
