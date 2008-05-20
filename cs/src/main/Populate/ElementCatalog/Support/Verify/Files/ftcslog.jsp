<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/PropFiles
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
<%!
    public static void clearLog(String filename)
    {
        //prepend char to log
        try{
            PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(filename,false)));
            pw.println("==============================");
            pw.println("Log Cleared from Support Tools");
            pw.println("==============================");  
            pw.close();
        }
        catch (IOException e) {
            e.printStackTrace();        
        }
    } 
%><cs:ftcs><%
String resource = getServletContext().getRealPath("/WEB-INF/classes/commons-logging.properties");
if (resource !=null && new File(resource).exists()){
	
	Properties props = new Properties(); 
	props.load(new FileInputStream(resource));
	String logfile = props.getProperty("logging.file");
	
	out.println("LogFile location: <b>"+ logfile+"</b><br/><br/>");
	if ("true".equals(ics.GetVar("clearlog"))) { 
		  clearLog(logfile); 
		  ics.SetVar("clearlog","false"); 
	} 
	if ("yes".equals(ics.GetVar("full"))) { 
		%><pre><%= Utilities.readFile(logfile) %></pre><% 
	} else { 
		%><pre><%    
		RandomAccessFile file = new RandomAccessFile(logfile, "r");
		long filelength = file.length();            
		long filepointer = filelength - Long.parseLong(ics.GetVar("dbytes"));

		if (Integer.parseInt(Long.toString(filepointer)) < 0) {
			Utilities.readFile(logfile);
		} else {   
			file.seek( filepointer );
			String line = file.readLine();
			int count = 0;
			while( line != null )
			{
			   line = file.readLine();
			   if (line != null )
				out.println( line );
			   count++;
			}
			out.println("\nTotal Lines: <b>"+ count+"</b>");
			file.close();
		}
		%></pre><%
	}
} else {
	%>Could not find the location of the log file.<%
}
%></cs:ftcs>
