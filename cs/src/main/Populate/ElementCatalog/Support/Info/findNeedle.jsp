<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="javax.sql.*" %>
<cs:ftcs>
<ics:callelement element="Support/stylecss"/>
<%! private static void printTableOpen(JspWriter out) throws Exception
{
	out.print("<table class=\"altClass\" width=\"552\">");
}   
%>
<%! private static void printTableClose(JspWriter out) throws Exception
{
	out.print("</table>");	
}   
%>
<%! private static void printTableSectionTitle(JspWriter out, String sValue) throws Exception
{
	out.print("<tr>");	
	out.print("<th colspan=\"2\">");
	    out.print(sValue);
	out.print("</td>");
	out.print("</tr>");
}   
%>
<%! private static void printTableRow(JspWriter out, String sName, String sValue) throws Exception
{
	out.print("<tr>");
		out.print("<td width=\"220\">");
				out.print(sName);
		out.print("</td>");
		out.print("<td width=\"332\">");
				out.print(sValue);
		out.print("</td>");
	out.print("</tr>");
}
%>
<%! private static void printTableRow(JspWriter out, Vector vRow) throws Exception
{
	out.print("<tr>");
	int iSize = vRow.size();
	for (int i=0;i<iSize;i++)
	{
		out.print("<td width=\"220\">");
		    out.print((String) vRow.elementAt(i));
		out.print("</td>");
	}
	out.print("</tr>");
}
%>
<%! private static void printTableFromVector(Vector vInput, JspWriter out) throws Exception
{
	printTableOpen(out);
	int size 	=	vInput.size();
	for(int i=0; i < size ; i++)
	{
		Vector vRow	=	(Vector) vInput.elementAt(i);
		printTableRow(out, vRow);
	}
	printTableClose(out);
}
%>

<%! public  Connection _getConnection(String sDBURL,  String sUser, String sPasswd, String sDriver) throws SQLException, ClassNotFoundException
    {
        Class Driver = Class.forName(sDriver);
        Connection conn = DriverManager.getConnection(sDBURL, sUser, sPasswd);   
        System.out.println("Connection succesful !");
        return conn;
    }
%>
  
<%! public  Vector _getOracleTableNames (Statement stmt) throws SQLException
    {
        String sSQL         =   "select tname from tab";
	return _execSQLQuery(stmt, sSQL);
    }
%>  

<%! public static Vector _execSQLQuery (Statement s1, String sSQL) throws SQLException
{
	return(_execSQLQuery(s1,sSQL,true));
}
%>

<%! public static Vector _execSQLQuery (Statement s1, String sSQL, boolean metadata) throws SQLException
{
        ResultSet rs            = s1.executeQuery(sSQL);
        ResultSetMetaData rsmd  = rs.getMetaData();
        int numberOfColumns     = rsmd.getColumnCount();      
        String sColumnValue     = "";
        String sColumnName      = "";
        Vector vret             = new Vector();
        Vector vRsmd            = new Vector();
        
	if(metadata==true)
	{
		for (int j=1;j<(numberOfColumns+1);j++)
		{
			  sColumnName = rsmd.getColumnName(j);                    
			  vRsmd.addElement(sColumnName);
		}
		vret.addElement(vRsmd);
	}
        
    	while(rs.next())
    	{
	        Vector vRow		= new Vector();
		for (int j=1;j<(numberOfColumns+1);j++)
		{
			sColumnValue = rs.getString(j);
			if ( null!=sColumnValue )
			{
			    vRow.addElement(sColumnValue );
			}
			else
			{
			    vRow.addElement("nul");
			}
		}
		vret.addElement(vRow);
    	}
		rs.close();
		//System.out.println(vret.toString());
		return vret;
}
%>

<%! private static Connection getConnection(String connectString) throws Exception
{
    Connection connection   	=   	null;
    InitialContext      ic 	= 	new InitialContext();     
    DataSource ds 		= 	(DataSource) ic.lookup(connectString);
    connection 			= 	ds.getConnection();
    return connection;
}   
%>

<%! private static void printMetaData(Connection connection, JspWriter out) throws Exception
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

<%! private static void printAssetTypes(JspWriter out, Statement stmt) throws Exception
{
    String sSQL		=	"Select count(*) as \"Total number of AssetTypes\" from AssetType";
    Vector vTables	=	_execSQLQuery(stmt, sSQL);
    printTableFromVector(vTables,out);
    
    sSQL		=	"Select assettype, description from AssetType order by AssetType";
    vTables.clear();
    vTables	=	_execSQLQuery(stmt, sSQL);
    printTableFromVector(vTables,out);
}  
%>

<%! private static Vector countTableRow(JspWriter out, Statement stmt, String sTableName) throws Exception
{
    Vector vRetRow	=	new Vector();
    String sSQL		=	"Select count(*) as \"" + sTableName + "\" from " + sTableName ;
    Vector vOutput	=	_execSQLQuery(stmt, sSQL);
    vRetRow.addElement(((Vector) vOutput.elementAt(0)).elementAt(0));
    vRetRow.addElement(((Vector) vOutput.elementAt(1)).elementAt(0));
    return vRetRow;
}  
%>

<%! private static Vector countTableRows(JspWriter out, Statement stmt, Vector vTableNames) throws Exception
{
	Vector vRet	=	new Vector();
	for(int i=0;i<vTableNames.size();i++)
	{	
		Vector vTableNameRow	=	(Vector) vTableNames.elementAt(i);
		vRet.addElement(countTableRow(out,stmt,(String) vTableNameRow.elementAt(0)));
	}
	return vRet;
}  
%>

<%! private static void printTableCount(JspWriter out, Statement stmt, String sSQL) throws Exception
{
    Vector vTableCount = countTableRows(out, stmt, _execSQLQuery(stmt, sSQL, false));
    printTableFromVector(vTableCount,out);	
}
%>

<%
try
{
    String sSQL 	= 	ics.GetVar("sql");
    String sUpdate 	= 	ics.GetVar("update");       
    if(null==sSQL)
    {
	sSQL		=	"Select * from AssetType";
    }
	
    String connectString		=  	ics.GetProperty("cs.dsn");
    Connection connection 		= 	getConnection(connectString);
    Statement stmt             	=   connection.createStatement();


    printAssetTypes(out,stmt);
    printTableCount(out,stmt,"select tname from tab");

    stmt.close();
    connection.close();
}
catch (Exception ex)
{
 out.println(ex.toString());
 ex.printStackTrace();
}
%>
<ics:callelement element="Support/Footer"/>
</cs:ftcs>