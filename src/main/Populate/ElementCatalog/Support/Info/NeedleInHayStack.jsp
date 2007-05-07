<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="oracle.jdbc.driver.*" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>

<cs:ftcs>
<%!
public class Pair implements Serializable
{
    public Object _first    = null;
    public Object _second   = null;

    public Pair()
    {}

    public Pair( Object first, Object second )
    { _set( first, second ); }

    public Pair( int first, int second )
    { _set( new Integer(first), new Integer(second) ); }
        
    public Pair( String first, Object second )
    { _set( first, second ); }

    private void _set( Object first, Object second )
    {
        _first  = first;
        _second = second;
    }

    public Object _getFirst()
    {
        return  _first;
    }
        
    public Object _getSecond()
    {
        return  _second;            
    }

    public String toString()
    {
        return  new String(_first + "=" + _second);            
    }


}    
%>



<%!
    public  void _writeClob (oracle.sql.CLOB clob, String sData) throws SQLException, IOException
    {
        // write the array of character data to a CLOB
        Writer writer = clob.getCharacterOutputStream();
        writer.write(sData.toCharArray());
        writer.flush();
        writer.close();
    }
%>


<%!

    public  String _readClob (Clob clob) throws SQLException, IOException
    {
        String stemp    =   "";
        Reader char_stream = clob.getCharacterStream();
        char [] char_array = new char [10];
        int chars_read = char_stream.read (char_array);
        return char_stream.toString();
    }
%>

<%!

    public  void _execSQL (Statement stmt, String sSQL) throws SQLException
    {
        System.out.println(sSQL);
        boolean b1 = stmt.execute(sSQL);
    }
%>
   
<%!	
    public  OracleResultSet _getRS (Statement stmt, String sSQL) throws SQLException
    {
        System.out.println(sSQL);
        OracleResultSet rs        =   (OracleResultSet) stmt.executeQuery(sSQL);
   	    return rs;
    }
  %>
 	
   
<%!	
    private  String _getString()
	{
	    StringBuffer sb = new StringBuffer();
	    for( int i = 0; i< 10; i++ )
	        sb.append("a");
        System.out.println( "DATA SIZE : " + sb.length() );
	    return sb.toString();    
	}       	
%>

<%!
    public  void _set( PreparedStatement ps, int at, Object value ) throws SQLException
    { 
        if( null == value )
            ps.setNull(at, Types.LONGVARCHAR);
        else
        {   
            String  val = (String)value;
            ps.setCharacterStream( at, new StringReader(val), val.length() );
        }
    }   	
%>

<%!   	
    public  Connection _getConnection(String sDBURL,  String sUser, String sPasswd, String sDriver) throws SQLException, ClassNotFoundException
    {
        Class Driver = Class.forName(sDriver);
        Connection conn = DriverManager.getConnection(sDBURL, sUser, sPasswd);   
        System.out.println("Connection succesful !");
        return conn;
    }
  %>
  
   
<%! 
    public  Vector _getDBIDs (Statement stmt, String sTableName) throws SQLException
    {
        Vector vDBIDs       =   new Vector();
        System.out.println(sTableName);
        String sSQL         =   "select UEDBID from " + sTableName ;
        ResultSet rs        =   stmt.executeQuery(sSQL);
	    while(rs.next())
   	    {
		    vDBIDs.addElement(new Integer(rs.getInt("UEDBID")));
   	    }
   	    rs.close();
   	    return vDBIDs;
    }
%>
   
<%! 
    public  HashMap _getDBIDs (Statement stmt, Vector vTableNames) throws SQLException
    {
        HashMap hmret     =   new HashMap();
   	    for(int i=0;i<vTableNames.size();i++)
   	    {
   	        String sTableName   =   vTableNames.elementAt(i).toString();
   	        Vector vDBIDs        =   _getDBIDs(stmt, sTableName);
   	        hmret.put(sTableName, vDBIDs);
   	    }
   	    return hmret;
    }
  %>
  
   
<%! 
    public  Vector _getDataTablesFromMDID (Statement stmt) throws SQLException
    {
        Vector vDataTables  =   new Vector();
        String sSQL         =   "select UETABLENAME from UEMDIDDATA order by UETABLENAME";
        ResultSet rs        =   stmt.executeQuery(sSQL);
	    while(rs.next())
   	    {
		    vDataTables.addElement("UE" + rs.getString("UETABLENAME") + "DATA");
   	    }
   	    rs.close();
   	    return vDataTables;
    }
%>
   
<%! 
    public  Vector _getDataTablesFromDB (Statement stmt) throws SQLException
    {
        Vector vDataTables  =   new Vector();
        String sSQL         =   "select name from sysibm.systables where name like \'UE%DATA\' order by name";
        ResultSet rs        =   stmt.executeQuery(sSQL);
	    while(rs.next())
   	    {
		    vDataTables.addElement(rs.getString("name"));
   	    }
   	    rs.close();
   	    return vDataTables;
    }
%>


<%!
    public  HashMap _getColumns(DatabaseMetaData dbmd, Vector vTables) throws SQLException
    {
        HashMap hmret     =   new HashMap();
   	    for(int i=0;i<vTables.size();i++)
   	    {
   	        String sTableName   =   vTables.elementAt(i).toString();
   	        Vector vCols        =   _getColumns(dbmd, sTableName, "", false);
   	        hmret.put(sTableName, vCols);
   	    }
   	    return hmret;
    }
%>    

<%!
    public  Vector _getColumns(DatabaseMetaData dbmd, String sTableName) throws SQLException
    {
        Vector vret  =   new Vector();
        //ResultSet rs   = dbmd.getColumns( null, dbmd.getUserName(), sTableName.toUpperCase(), null );
        ResultSet rs   = dbmd.getColumns( null, dbmd.getUserName(), sTableName, null );
        while(rs.next())
        {
            vret.add(rs.getString("COLUMN_NAME"));
        }
        System.out.println(sTableName + ":" + vret.toString());
        return vret;
    }
  %>
  

<%!
    public  Vector _getColumns(DatabaseMetaData dbmd, String sTableName, String sType, boolean bNull) throws SQLException
    {
        Vector vCols  =   new Vector();
        Vector vTypes  =   new Vector();
        Vector vSizes  =   new Vector();
        Vector vNulls  =   new Vector();
        
        Vector vRet     =   new Vector();
        
        ResultSet rs   = dbmd.getColumns( null, dbmd.getUserName(), sTableName, null );
        while(rs.next())
        {
            vCols.add(rs.getString("COLUMN_NAME"));
            vTypes.add(rs.getString("DATA_TYPE"));
            vSizes.add(rs.getString("COLUMN_SIZE"));
            vNulls.add(rs.getString("IS_NULLABLE"));
        }
        
        for (int i=0;i<vTypes.size();i++)
        {
            if(vTypes.elementAt(i).equals("3")&&(vSizes.elementAt(i).equals("38")))
            {
                if(!vNulls.elementAt(i).equals("YES"))
                {
                    vRet.addElement(vCols.elementAt(i));                    
                }
                else
                {
                    vRet.addElement(vCols.elementAt(i)+ " (NULLS)");                    
                }
            }
        }
        
        System.out.println(sTableName + ":" + vRet.toString());
        return vRet;
    }
%>    
    
<%!
    public  void _printDBIDsIntoFile(HashMap hm, String sFileNameWithPath) throws Exception
    {
        StringBuffer sb1    =    new StringBuffer();
        Iterator ikeys = hm.keySet().iterator();
        while (ikeys.hasNext())
        {
            String sTableName = (String) ikeys.next();
            Vector vDBIDs      = (Vector) hm.get(sTableName);
            sb1.append(sTableName + "|" + vDBIDs.size() + "|" + _VectorToString(vDBIDs) + "\n");
            //System.out.println();
            //_printVector(vDBIDs);
        }
        _createFile(sFileNameWithPath + System.currentTimeMillis() + ".txt",sb1.toString());
    }
%>

<%!
    public  void _printStringVector_HashMap_IntoFile(HashMap hm, String sFileNameWithPath) throws Exception
    {
        StringBuffer sb1    =    new StringBuffer();
        Iterator ikeys = hm.keySet().iterator();
        while (ikeys.hasNext())
        {
            String sTableName = (String) ikeys.next();
            sb1.append(sTableName);
            
            Vector vDBIDs      = (Vector) hm.get(sTableName);
            for(int i=0;i<vDBIDs.size();i++)
            {
             sb1.append("|" + vDBIDs.elementAt(i));
            }
            sb1.append("|" + "\n");
        }
        _createFile(sFileNameWithPath + System.currentTimeMillis() + ".txt",sb1.toString());
    }
%>


<%!
    public  String _VectorToString(Vector v)
    {
        StringBuffer sb =   new StringBuffer();
        for(int i=0;i<v.size();i++)
        {
            sb.append(v.elementAt(i) + ", ");   
        }
        return sb.toString();
    }
%>

<%!
    public  Vector _getDB2UETableNames (Statement stmt) throws SQLException
    {
        String sSQL         =   "select name from sysibm.systables where name like \'UE%\'";
   	    return _getTableNames(stmt, sSQL);
    }
%>  
  
<%!
    public  Vector _getDB2TableNames (Statement stmt) throws SQLException
    {
        String sSQL         =   "select name from sysibm.systables";
   	    return _getTableNames(stmt, sSQL);
    }
%>

<%!
    public  Vector _getSybaseTableNames (Statement stmt) throws SQLException
    {
        String sSQL         =   "SELECT name FROM sysobjects WHERE type = 'U'order by name ";
        Vector vTables         =   _getTableNames(stmt, sSQL);
   	    
        vTables.remove("migrate_remote_fks_list");
        vTables.remove("migrate_remote_table_list");        
        vTables.remove("migrate_sql_defn");        
        vTables.remove("ml_connection_script");        
        vTables.remove("ml_script");        
        vTables.remove("ml_script_version");        
        vTables.remove("ml_scripts_modified");        
        vTables.remove("ml_subscription");        
        vTables.remove("ml_table");        
        vTables.remove("ml_table_script");        
        vTables.remove("ml_user");        
        vTables.remove("rs_lastcommit");        
        vTables.remove("rs_threads");        
        vTables.remove("ul_file");   
        vTables.remove("ul_referenced_column");   
        vTables.remove("ul_referenced_table");   
        vTables.remove("ul_statement");   
        vTables.remove("ul_variable");   
   	    
   	    return vTables;
    }
  %>  
    
<%!
    public  Vector _getDB2TableNamesNoLog (Statement stmt) throws SQLException
    {
        String sSQL         =   "select name from sysibm.systables where name like \'UE%\' and (name not like \'UE%LOG\') or (name not like \'UETABLEINDEX\')";
   	    return _getTableNames(stmt, sSQL);
   	}
%>    

<%!
    public  Vector _getOracleTableNames (Statement stmt) throws SQLException
    {
        String sSQL         =   "select tname from tab";
   	    return _getTableNames(stmt, sSQL);
    }
%>  
  
<%!
    public  Vector _getOracleUETableNames (Statement stmt) throws SQLException
    {
        String sSQL         =   "select tname from tab where tname like \'UE%\'";
   	    return _getTableNames(stmt, sSQL);
    }
%>  
  
<%!
    public  Vector _getTableNames (Statement stmt, String sSQL) throws SQLException
    {
        ResultSet rs        =   stmt.executeQuery(sSQL);
        Vector vTableNames  =   new Vector();
	    while(rs.next())
   	    {
		    //vTableNames.addElement(rs.getString("TNAME"));
		    vTableNames.addElement(rs.getString(1));
   	    }
   	    rs.close();
   	    return vTableNames;
    }
%>    

<%!
    public Vector _findNeedle(Statement s1, String sTableName, String sNeedle) throws SQLException
    {
        System.out.println("Processing table " + sTableName  + " ...");
        String sSQL             = "select * from " + sTableName ;        
        ResultSet rs            = s1.executeQuery(sSQL);
        ResultSetMetaData rsmd  = rs.getMetaData();
        int numberOfColumns     = rsmd.getColumnCount();      
        String sColumnValue     = "";
        String sColumnName      = "";
        Vector vret             = new Vector();
            
	    while(rs.next())
	    {
         	for (int j=1;j<(numberOfColumns+1);j++)
            {
        		if(rsmd.getColumnType(j)==Types.CLOB) 
        		{
        			sColumnValue  = "";
				    try 
				    {
				        BufferedReader in = new BufferedReader (rs.getCharacterStream(j));
				        for( String str = in.readLine(); str != null; str = in.readLine() ) 
				            sColumnValue += str; 
		 		    }
				    catch(Exception ex) 
				    {
				            sColumnValue = ""; 
				    }
				}
				else
				{
				    sColumnValue = rs.getString(j);
				}
				
				//System.out.println(sColumnValue);
					
				if ( null!=sColumnValue && sColumnValue.indexOf(sNeedle)>-1)
				{
				    vret.addElement(new Pair( rsmd.getColumnName(j), sColumnValue ));
				    //vret.addElement(rsmd.getColumnName(j));
				}
			}
		}
		rs.close();
		return vret;
	}
%>
	
<%!
    public  HashMap _findNeedle(Statement s1, Vector vTables, String sNeedle) throws SQLException
    {
        HashMap hmret   =   new HashMap();
        for(int i=0; i<vTables.size();i++)
        {
            String sTableName   =   (String) vTables.elementAt(i);
            long lstart         =   System.currentTimeMillis();
            Vector vtemp        =   _findNeedle(s1, sTableName, sNeedle);
            long ldiff          =   System.currentTimeMillis() - lstart;
            System.out.println("Time taken for table scan is " + ldiff + " milliseconds ");
            System.out.println("");
            if(vtemp.size()>0)
            {
                hmret.put(sTableName, vtemp);
            }
        }
        return hmret;
    }
%>
	
<%!
    public  void _createFile(String sFileName, String sData) throws Exception
    {
        FileOutputStream fos1 = new  FileOutputStream(sFileName);
        DataOutputStream dos1 = new DataOutputStream(fos1);
        dos1.writeBytes(sData);
        dos1.close();
        fos1.close();
    }
%>

<%
try
{

    //String connectString =ics.GetProperty("cs.dsn");
    String connectString	=  "EatonSource";
    String sTIMESTAMP =ics.GetProperty("cc.datetime");
    out.println("DATETIME is :" + sTIMESTAMP);

    Connection connection   =   null;
    System.out.println("<br> Connecting with :" + connectString + "<br>");
    InitialContext	ic = new InitialContext();	
    //DataSource ds = (DataSource) ic.lookup(connectString);
    DataSource ds = (DataSource) ic.lookup("BayerSource");
    connection = ds.getConnection();
    DatabaseMetaData dmd = connection.getMetaData();
    out.println("<br>");        
    out.println("JDBC Driver Information:");
    out.println("<br>");
    out.println("\t" + dmd.getDriverName() + " " + dmd.getDriverVersion() +  "<br/> " + dmd.getURL());
    out.println("<br>");	    
    out.println("Database Information:");
    out.println("<br>");	    
    out.println("\t" + dmd.getDatabaseProductName() + dmd.getDatabaseProductVersion());
    out.println("<br>");	    
    out.print("Driver  DriverName()  :" + dmd.getDriverName()  + "<BR>");

        Statement stmt          =   connection.createStatement();
        Vector vTables      =   _getOracleTableNames(stmt);
        HashMap   hm            =   _findNeedle(stmt, vTables , "1046125721219");        
        _printResults(hm, out);
	stmt.close();
	connection.close();

}
catch (Exception ex)
{
 out.println(ex.toString());
 ex.printStackTrace();
}
%>

    
<%!
    public  void _printResults(HashMap hm, JspWriter out) throws Exception
    {
        Iterator ikeys = hm.keySet().iterator();
        while (ikeys.hasNext())
        {
            String sTableName = (String) ikeys.next();
            out.println("<br/><br/>");            
            out.println("Found in column " + hm.get(sTableName)  + " in table " + sTableName);
        }
    }
%>


<%!
    public  void _printResults(String sTableName, Vector vCols, JspWriter  out) throws Exception
    {
        out.println("Found in column(s) " + vCols.toString() + " in table " + sTableName);
    }
%>

</cs:ftcs>


