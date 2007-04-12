<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/cleanPubHistory
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
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>

<%!
public boolean delete(String file) {
    boolean success = (new File(file)).delete();
    if (!success) {
        // Deletion failed
    }
    return success;
}

%>

<cs:ftcs>
    
    <H3 align="center">PubSessions deleted </H3>
    <table class="altClass">
        <tr>
            <th>Pubsession</th>
            <th>Deleted?</th>
        </tr>
        <%
        String inipath = Utilities.osSafeSpec(ics.getIServlet().getServlet().getServletConfig().getInitParameter("inipath"));
        String var=ics.GetVar("var").trim();
        String workfolder;
        String pfile=inipath+"/batch.ini";
        Properties p = new Properties();
        FileInputStream fis =  new FileInputStream(Utilities.osSafeSpec(pfile));
        p.load(fis);
        fis.close();
        workfolder = p.getProperty("request.folder");
        if (workfolder.charAt(0)=='.') {
            workfolder=workfolder.substring(1);
        }
        boolean isNum;
        try {
            float i=Float.parseFloat(var);
            isNum=true;
        } catch (NumberFormatException e) {
            isNum=false;
            
        }
        if (isNum==true) {
            String s1="DELETE FROM PubSession WHERE id="+var;
            String s2="DELETE FROM PubMessage WHERE cs_sessionid="+var;
            String s3="DELETE FROM PubContext WHERE cs_sessionid="+var;
        %>
        <ics:sql sql='<%= s1 %>' table="PubSession" listname="temp1" limit="-1"/>
        <ics:sql sql='<%= s2 %>' table="PubMessage" listname="temp2" limit="-1"/>
        <ics:sql sql='<%= s3 %>' table="PubContext" listname="temp3" limit="-1"/>
        <tr>
            <td>
                <%= var %>
            </td>
            <%
            String filepath=System.getProperty("user.dir")+workfolder+var+"Output.html";
            if (!delete(filepath)) {
                //failure
            %>
            <td>
                failed
            </td>
            <%
            } else {
                //success
            %>
            <td>
                success
            </td>
            <%
            }
            
        }
        if (isNum==false) {
            if (var.equals("all"))  //do all
            {
                String s="SELECT id from PubSession";
            %>
            <ics:sql sql='<%= s %>' table="PubSession" listname="temp" limit="-1"/>
            <%
            IList list=ics.GetList("temp");
            //int i=list.currentRow();
            int i=1;
            if (!list.hasData()) {
            %><td>There is no pub sessions</td>
            <td></td><td></td><%
            } else {
                while (i<=list.numRows()) {
                    list.moveTo(i);
                    String sid=list.getValue("id");
                    String s1="DELETE FROM PubSession WHERE id="+sid;
                    String s2="DELETE FROM PubMessage WHERE cs_sessionid="+sid;
                    String s3="DELETE FROM PubContext WHERE cs_sessionid="+sid;
                    i++;
            
            %>
            <ics:sql sql='<%= s1 %>' table="PubSession" listname="temp1" limit="1"/>
            <ics:sql sql='<%= s2 %>' table="PubMessage" listname="temp2" limit="1"/>
            <ics:sql sql='<%= s3 %>' table="PubContext" listname="temp3" limit="1"/>
            <tr>
                <td>
                    <%= sid %>
                </td>
                <%
                String filepath=System.getProperty("user.dir")+workfolder+sid+"Output.html";
                if (!delete(filepath)) {
                    //failure
                %>
                <td>
                    failed
                </td>
            </tr>
            <%
                } else {
                    //success
            %>
            <td>
                success
            </td>
        </tr>
        <%
                }
                }
            }
            } else  //do date
            {
                try {
                    String s="SELECT id FROM PubSession WHERE cs_sessiondate < '"+var+"'";
        %>
        <ics:sql sql='<%= s %>' table="PubSession" listname="temp" limit="-1"/>
        <%
        IList list=ics.GetList("temp");
        //int i=list.currentRow();
        int i=1;
        if (!list.hasData()) {
        %><td>There is no pub sessions</td>
        <td></td><td></td><%
        } else {
            while (i<=list.numRows()) {
                
                list.moveTo(i);
                String sid=list.getValue("id");
                String s1="DELETE FROM PubSession WHERE id="+sid;
                String s2="DELETE FROM PubMessage WHERE cs_sessionid="+sid;
                String s3="DELETE FROM PubContext WHERE cs_sessionid="+sid;
                i++;
        %>
        <ics:sql sql='<%= s1 %>' table="PubSession" listname="temp1" limit="1"/>
        <ics:sql sql='<%= s2 %>' table="PubMessage" listname="temp2" limit="1"/>
        <ics:sql sql='<%= s3 %>' table="PubContext" listname="temp3" limit="1"/>
        <tr>
            <td>
                <%= sid %>
            </td>
            <%
            String filepath=System.getProperty("user.dir")+workfolder+sid+"Output.html";
            if (!delete(filepath)) {
                //failure
            %>
            <td>
                failed
            </td>
        </tr>
        <%
            } else {
                //success
        %>
        <td>
            success
        </td>
        </tr>
        <%
            }
            }
        }
                } catch (IllegalArgumentException e) {
        %>
        <td>No data</td><td></td>
        </tr>
        <%
                }
            }
        }
        
        %>
    </table>
</cs:ftcs>
