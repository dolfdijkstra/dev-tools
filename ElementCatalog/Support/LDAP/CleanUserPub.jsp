<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>

<%@ page import="com.openmarket.directory.StaticFactory"%>

<cs:ftcs>

<%
StringBuffer errStr = new StringBuffer(); 
String sql = "select username as username, id as id from UserPublication"; 
IList userlist = ics.SQL("UserPublication",sql, null, -1, true, errStr);

if (userlist.hasData())
{
    for (int i=1;i<userlist.numRows();i++)
    {
        userlist.moveTo(i);
        String orig = userlist.getValue("username");
        String clean = StaticFactory.newName(ics, userlist.getValue("username")).clean(ics);
        if (!orig.equals(clean))
        {
            FTValList args = new FTValList(); 
            args.setValString("ftcmd","updaterow");
            args.setValString("tablename","UserPublication");
            args.setValString("id",userlist.getValue("id"));
            args.setValString("username",StaticFactory.newName(ics, userlist.getValue("username")).clean(ics));
            ics.CatalogManager(args);
            out.print("<b color=\"#FF0000\">didnt match - cleaning</b> ");
            out.print(ics.GetErrno()+"<br/>");
        }		
    }
}
%>

</cs:ftcs>
