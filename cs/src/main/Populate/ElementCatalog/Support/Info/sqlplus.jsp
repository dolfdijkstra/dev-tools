<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld" 
%><%@ taglib prefix="time" uri="futuretense_cs/time.tld" 
%><%@ page import="javax.naming.*" 
%><%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<cs:ftcs>
<%
	String sSQL = ics.GetVar("sql");
	if(null==sSQL || "".equals(sSQL)) {
        sSQL = "SELECT tblname,acl FROM SystemInfo ORDER BY UPPER(tblname)";
	}
%>    

<form action="ContentServer" name=sqlplus>
<input type='hidden' name='pagename' value='<%=ics.GetVar("pagename")%>'/>
<table style="border:none">
	<tr><td width="10%" style="border:none;text-align:right"><b>Enter SQL :</b></td><td style="border:none"><textarea name="sql" cols="102" rows="10" ><%=sSQL%></textarea></td></tr>
	<tr><td width="10%" style="border:none"></td><td style="border:none">&nbsp;<input type=submit value=Query name=button></td></tr>
</table>  
</form>
<hr/>
<time:set name="sqltime"/>  
<%
    Connection connection =	null;
    try
    {
        String connectString = Utilities.replaceAll(ics.GetProperty("cs.dbconnpicture"), "$dsn", ics.GetProperty("cs.dsn"));
        connection 	=  getConnection(connectString);
        out.print("<br>");     
        out.print("Executing: " + sSQL);
        out.print("<br>");      
        Statement s3 = connection.createStatement(); 
        if(sSQL.toLowerCase().trim().startsWith("select"))
        {
        	getResult(sSQL, s3, out);	
        }
        else
        {
        	execute(sSQL, s3, out);
        }
        s3.close();
    }
    catch (Exception ex)
    {
        out.println(ex.toString());
        ex.printStackTrace();
    }
    finally
    {
    	if (connection!=null){
        	connection.close();
        }
    }
%>
<br/><b>Took <font color="blue"><time:get name="sqltime"/></font> ms to execute</b>
</cs:ftcs>
<%! private static void getResult(String sSQL, Statement s1, JspWriter out) throws Exception
{
    String sColName = "";
    String sName = "";
    ResultSet rs = s1.executeQuery(sSQL);
    ResultSetMetaData rsmd = rs.getMetaData();
    int numberOfColumns = rsmd.getColumnCount();
    int rowcount=0;
    out.print("<table class=\"altClass\">");
    out.print("<tr>");
    for (int j=1;j<(numberOfColumns+1);j++)
    {
        out.print("<th>");
        sColName = rsmd.getColumnName(j);                    
        out.print(sColName);
        out.print("</th>");                      
    }
    out.print("</tr>");            
    while(rs.next())
    {
      rowcount++;
      out.print("<tr>");
      for (int j=1;j<(numberOfColumns+1);j++)
      {
        out.print("<td>");
        if(rsmd.getColumnType(j)==Types.CLOB)
        {
           String sBuffer  = "";
           try
           {
             BufferedReader in = new BufferedReader  (rs.getCharacterStream(j));
             for( String str = in.readLine(); str != null; str =  in.readLine() )
                  sBuffer += str;
             out.print(sBuffer);
           }
           catch(Exception ex)
           {
             out.print("null");
           }
        }
        else
        {
            sName = rs.getString(j);
            
            if(null==sName){
                out.print("null");
            } else {
                out.print(sName);
            }
        }
        out.print("</td>");                
      }
     out.print("</tr>");           
    }
    rs.close();
    out.print("</table>");
    out.print("<b>Total RowCount: "+ rowcount+"</b>"); 
}   

private static void execute(String sSQL, Statement s1, JspWriter out) throws Exception
{
       s1.execute(sSQL);
}   
 
private static DataSource ds=null;
private synchronized static Connection getConnection(String connectString) throws Exception
{
    Connection connection = null;
    if (ds == null){
	    InitialContext ic = new InitialContext();     
	    ds = (DataSource) ic.lookup(connectString);
    }
    connection = ds.getConnection();
    return connection;
}   
private static void printMetaData(Connection connection, JspWriter out) throws Exception
{
    DatabaseMetaData dmd 	= 	connection.getMetaData();
    out.println("JDBC Driver URL\t:" + dmd.getURL());
    out.println("<br>");       
    out.println("JDBC Driver Version\t:");
    out.println("\t" + dmd.getDriverName() + " " + dmd.getDriverVersion() +  "<br>");
    out.println("Database Server Information	:");
    out.println("\t" + dmd.getDatabaseProductName() + dmd.getDatabaseProductVersion());
    out.println("<br>");     
    out.println("<br>");  

}  
%>