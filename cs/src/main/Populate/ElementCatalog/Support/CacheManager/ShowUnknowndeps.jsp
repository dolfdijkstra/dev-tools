<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/CacheManager/ShowUnknowndeps
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
<center><h3>Unknowndeps Pages</h3></center>
<ics:sql sql='select distinct sc.id as pagename, count(sp.pagename) as num from SystemPageCache sp, SystemItemCache sc where sp.id = sc.page and sc.id like \'unknowndeps%\' group by sc.id order by num desc' listname='unknownlist' table='SystemItemCache'/>
<% int total = 0; %>
<ics:listloop listname="unknownlist">
    <% total += Integer.parseInt(ics.ResolveVariables("unknownlist.num")); %>
</ics:listloop>
There are total <%= total %> unknowdeps pages...
<table class='altClass'>
    <tr><th>Nr</th><th>pagename</th><th>count</th></tr>
    <% int i=1; %>
    <ics:listloop listname='unknownlist'>
      <tr>
        <td><%= i++ %></td>
        <td>
        <satellite:link>
          <satellite:parameter name='pagename' value='Support/CacheManager/listByItemPost'/>
        </satellite:link>
        <a href='<%= ics.GetVar("referURL")+"&idlist="+ics.ResolveVariables("unknownlist.pagename")%>'><ics:resolvevariables name="unknownlist.pagename"/></a>
        </td>        
        <td><ics:listget listname='unknownlist' fieldname='num'/></td>
      </tr>
    </ics:listloop>
</table>
</cs:ftcs>
