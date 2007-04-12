<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="javax.naming.*"
%><%@ page import="java.sql.*"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><%@ page import="javax.sql.*"
%><%@ page import="java.net.*"
%><%@ page import="java.io.*"
%><%@ page import="javax.servlet.*"
%><%@ page import="javax.servlet.http.*"
%><cs:ftcs>
<ics:callelement element="Support/general"/>
<%! private static void printTableOpen(JspWriter out) throws Exception
{
 out.print("<table class=\"altClass\">");
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
 out.print ("<th colspan=\"2\">");
     out.print(sValue);
 out.print("</th>");
 out.print("</tr>");
}   
%>
 
<%! private static void printTableRow(JspWriter out, String sName, String sValue) throws Exception
{
 out.print("<tr>");
  out.print("<td>");
    out.print(sName);
  out.print("</td>");
  out.print("<td>");
    out.print(addNewline(sValue));
  out.print("</td>");
 out.print("</tr>");
}
%>

<%! private static String addNewline(String abc) {                   
	if (abc!=null) {
		if(abc.indexOf(' ')!=-1)
			return abc;
		else {
			int len = abc.length();
			if (len < 75)
				return abc;
	
			StringBuffer newstr = new StringBuffer(len+(len/75));
			for(int i=0, j=0; i < len; i++) {
				newstr.append(abc.charAt(i));
				j++;
				if(j ==75) {
					newstr.append('\n');
					j=0;
				}
			}
			return newstr.toString();
		}
	}
	return null;
} 
%>
	
<%! private static void printInitParameters(ServletContext context, JspWriter out) throws Exception
{ 
    printTableSectionTitle(out,"Context init parameters");
    java.util.Enumeration enum1 = context.getInitParameterNames();
    while (enum1.hasMoreElements()) {
        String key = (String)enum1.nextElement();
        String value = (String) context.getInitParameter(key);
        printTableRow(out, key, value); 
    } 
}
private static void printAttributes(ServletRequest request, ServletContext context, JspWriter out) throws Exception
{
    printTableSectionTitle(out,"Context attributes");
    java.util.Enumeration enum2 = context.getAttributeNames();
    try {
        while (enum2.hasMoreElements()) 
        {
            String key = (String) enum2.nextElement();
            Object value = (Object) context.getAttribute(key);
            printTableRow(out, key, value.toString()); 
        }
    } catch (Exception e) {
        //do something...
    }

    printTableSectionTitle(out,"Request attributes");
    java.util.Enumeration e = request.getAttributeNames();
    while (e.hasMoreElements()) {
        String key = (String)e.nextElement();
        Object value =  request.getAttribute(key);
        if (value==null) {
            value="NULL";
        }
        printTableRow(out, key, value.toString()); 
    } 
}
%> 
 
<%! private static void printSystemProperties(JspWriter out) throws Exception
{
    printTableSectionTitle(out,"<a name=\"SystemP\"></a>System Properties");
    Properties pSystem = System.getProperties();
    java.util.Set en_pNames = new java.util.TreeMap(pSystem).keySet();
    for (java.util.Iterator itor = en_pNames.iterator();itor.hasNext();)
    {
        String sPropertyName = (String) itor.next();
        String sPropertyValue = pSystem.getProperty(sPropertyName) ;
        printTableRow(out, sPropertyName, sPropertyValue); 
    }
}   
%> 
 
<%! private static void printRequestDetails(JspWriter out, ServletConfig config, javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws Exception
{
    printTableSectionTitle(out,"Servlet Information");
    printTableRow(out, "Current URL",   HttpUtils.getRequestURL(request).toString());
    printTableRow(out, "Query String",   request.getQueryString());
    printTableRow(out, "Servlet Name",   config.getServletName());
    printTableRow(out, "Protocol",    request.getProtocol().trim());
    printTableRow(out, "Scheme",    request.getScheme());
    printTableRow(out, "WebServer Name",   request.getServerName());
    printTableRow(out, "WebServer Port",   "" + request.getServerPort());
    printTableRow(out, "WebServer Info",   config.getServletContext().getServerInfo());
    printTableRow(out, "WebServer Remote Addr",  request.getRemoteAddr());
    printTableRow(out, "WebServer Remote Host",  request.getRemoteHost());
    printTableRow(out, "Character Encoding",  request.getCharacterEncoding());
    printTableRow(out, "Content Length",   "" + request.getContentLength());
    printTableRow(out, "Content Type",   request.getContentType());
    printTableRow(out, "WebServer Locale",   request.getLocale().toString());
    printTableRow(out, "Default Response Buffer",  "" + response.getBufferSize());
    printTableRow(out, "Request Is Secure",  "" + request.isSecure());
    printTableRow(out, "Auth Type",   request.getAuthType());
    printTableRow(out, "HTTP Method",   request.getMethod());
    printTableRow(out, "Remote User",   request.getRemoteUser());
    printTableRow(out, "Request URI",   request.getRequestURI());
    printTableRow(out, "Context Path",  request.getContextPath());
    printTableRow(out, "Servlet Path",   request.getServletPath());
    printTableRow(out, "Path Info",   request.getPathInfo());
    printTableRow(out, "Path Trans",   request.getPathTranslated());
}   
%> 
 
<%! private static void printRequestParameters(JspWriter out, javax.servlet.http.HttpServletRequest request) throws Exception
{
    printTableSectionTitle(out,"Parameter names in this request");
    StringBuffer sbOut = new StringBuffer();
    java.util.Enumeration e2 = request.getParameterNames();
    while (e2.hasMoreElements()) 
    {
        String key = (String)e2.nextElement();
        String[] values = request.getParameterValues(key);
        for(int i = 0; i < values.length; i++) 
        {
            sbOut.append(values[i] + " ");
        }
        printTableRow(out, key, sbOut.toString()); 
    }
}   
%>
 
<%! private static void printRequestCookies(JspWriter out, javax.servlet.http.HttpServletRequest request) throws Exception
{
    printTableSectionTitle(out,"Cookies in this request");
    Cookie[] cookies = request.getCookies();
    if(null!=cookies)
    {
        for (int i = 0; i < cookies.length; i++) 
        {
          Cookie cookie = cookies[i];
          printTableRow(out, cookie.getName(), cookie.getValue()); 
        }
    }
}   
%>
 
<%! private static void printSessionInfo(JspWriter out, javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpSession session) throws Exception
{
    SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss.sss zzz" );
    printTableSectionTitle(out,"Session information in this request");
    printTableRow(out, "Requested Session Id",     "" + request.getRequestedSessionId()); 
    printTableRow(out, "Current Session Id",     "" + session.getId()); 
    printTableRow(out, "Session Created Time",     "" + sdf.format(new java.util.Date((session.getCreationTime())))); 
    printTableRow(out, "Session Last Accessed Time",   "" + sdf.format(new java.util.Date((session.getLastAccessedTime()))));  
    printTableRow(out, "Session Max Inactive Interval Seconds",  "" + session.getMaxInactiveInterval()); 
    
    printTableSectionTitle(out,"Session scoped attributes");
    java.util.Enumeration names = session.getAttributeNames();
    while (names.hasMoreElements()) 
    {
        String name = (String) names.nextElement();
        printTableRow(out, name, session.getAttribute(name).toString()); 
    }
}   
%>
 
<%! private static void printRequestHeaders(JspWriter out, javax.servlet.http.HttpServletRequest request) throws Exception
{
    printTableSectionTitle(out,"<a name=\"RequestH\"></a>Request headers");
    java.util.Enumeration e1 = request.getHeaderNames();
    while (e1.hasMoreElements()) 
    {
        String key = (String)e1.nextElement();
        String value = request.getHeader(key);
        printTableRow(out, key, value); 
    }
}   
%>
 
<%! private static Connection getConnection(String connectString) throws Exception
{
    Connection connection = null;
    InitialContext ic = new InitialContext();     
    DataSource ds = (DataSource) ic.lookup(connectString);
    connection = ds.getConnection();
    return connection;
}   
%>
 
<%! private static Connection getConnection(String connectString, JspWriter out, String sUser, String sPasswd) throws Exception
{
    printTableSectionTitle(out,"Connecting");
    Connection connection = null;
    InitialContext ic = new InitialContext();     
    
    try
    {
        DataSource ds   =  (DataSource) ic.lookup(connectString);
        printTableRow(out, "Connecting with ", connectString);       
        connection   =  ds.getConnection();
    }
    catch (Exception ex)
    {
        printTableRow(out, "Failed to connect with cs.dsn", ex.toString()); 
    } 
    return connection;
}   
%>
 
<%! private static void printDBMetaData(Connection connection, JspWriter out) throws Exception
{
     printTableSectionTitle(out,"Database Information");
     DatabaseMetaData dmd  =  connection.getMetaData();
     printTableRow(out, "JDBC Driver URL", dmd.getURL()); 
     printTableRow(out, "JDBC Driver Version", dmd.getDriverName() + " " + dmd.getDriverVersion()); 
     printTableRow(out, "Database Server Information", dmd.getDatabaseProductName() + dmd.getDatabaseProductVersion()); 
}  
%>
 
<%! private static void printVMInfo(JspWriter out) throws Exception
{
    printTableSectionTitle(out,"Java VM Information");
    Runtime rt = Runtime.getRuntime();
    //printTableRow(out, "Max Memory", "" + rt.maxMemory() + " bytes"); 
    printTableRow(out, "Total Memory", "" + rt.totalMemory() + " bytes"); 
    printTableRow(out, "Free Memory", "" + rt.freeMemory() + " bytes"); 
}  
%>
 
<%! private static void printCurrentDate(JspWriter out) throws Exception
{
    SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss.sss zzz" );
    printTableSectionTitle(out,"Current Date");
    printTableRow(out, "Date", sdf.format(new java.util.Date())); 
}  
%>
 
<%! private static void printResponseHeaders(JspWriter out, javax.servlet.http.HttpServletRequest request) throws Exception
{
    //String sQueryString = URLEncoder.encode("pagename", "UTF-8") + "=" + URLEncoder.encode(request.getParameter("pagename"), "UTF-8");
    //String sURL = HttpUtils.getRequestURL(request).toString() + "?" + sQueryString;
    String sURL = HttpUtils.getRequestURL(request).toString();
    System.out.println(sURL);
    URL url = new URL(sURL);
    URLConnection conn = url.openConnection();
    
    printTableSectionTitle(out,"Response Headers");
    
    // List all the response headers from the server.
    // Note: The first call to getHeaderFieldKey() will implicit send
    // the HTTP request to the server.
    for (int i=0; ; i++) 
    {
        String headerName = conn.getHeaderFieldKey(i);
        String headerValue = conn.getHeaderField(i);
              
        if (headerName == null && headerValue == null) 
        {
            // No more headers
            break;
        }
        if (headerName == null) 
        {
            headerName = "HTTP version "; 
            // The header value contains the server's HTTP version
        }
        printTableRow(out, headerName , headerValue); 
    }
    
    // Get the response
    BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    String line;
    while ((line = rd.readLine()) != null) {
        // Process line...
    }
    rd.close();         
}
%> 
 
<%! private static void printAddresses(JspWriter out) throws Exception
{
    printTableSectionTitle(out,"AppServer DNS Names and IP Addresses");
    
    InetAddress local = InetAddress.getLocalHost();
    InetAddress [] localList = local.getAllByName(local.getHostName());
    
    for (int i=0; i<localList.length; i++) 
    {
        String sHostName = ((InetAddress) localList[i]).getHostName();
        String sHostIP = ((InetAddress) localList[i]).toString();
        printTableRow(out, sHostName , sHostIP); 
    }
}  
%>
 
<%! private static void printClassFolder(JspWriter out) throws Exception
{
    printTableSectionTitle(out,"ContentServer deployment folder");
    Class csClass = COM.FutureTense.Servlet.SContentServer.class;
    printTableRow(out, "SContentServer loaded from" ,  csClass.getResource("SContentServer.class").toString()); 
}  
%>
 
<%! private static void printCurrentThreadGroup(JspWriter out) throws Exception
{
    printTableSectionTitle(out,"<a name=\"Threads\"></a>Threads in the current thread group");
    
    Thread current  = Thread.currentThread();
    printTableRow(out, "Current Thread" , current.toString()); 
    ThreadGroup tgCurrent  = current.getThreadGroup();
    // double the current active count to be very safe
    int sizeEstimate = tgCurrent.activeCount() * 2;
    Thread[] threadList = new Thread[sizeEstimate];
    int size = tgCurrent.enumerate(threadList);
    for ( int i = 0; i < size; i++ ) 
    {
     printTableRow(out, "Thread" + i , threadList[i].toString()); 
    }
}  
%>
 
<%! private static void printAllThreads(JspWriter out) throws Exception
{
    printTableSectionTitle(out,"All the threads in the java VM");
    ThreadGroup group =     Thread.currentThread().getThreadGroup();
    ThreadGroup rootGroup = null;
 
    // traverse the tree to the root group
    while ( group != null ) 
    {
        rootGroup = group;
        group = group.getParent();
    }
    
    // double the current active count to be very safe
    int sizeEstimate = rootGroup.activeCount() * 2;
    Thread[] threadList1 = new Thread[sizeEstimate];
    
    int size = rootGroup.enumerate(threadList1);
    
    for ( int i = 0; i < size; i++ ) 
    {
        printTableRow(out, "Thread" + i , threadList1[i].toString()); 
    }
}  
%>

<% ServletContext context = getServletConfig().getServletContext() ; %>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<% if (ics.UserIsMember("SiteGod")){ %>
<div class="content">
<% 
 Connection connection = null;
 try
 {
  String sFormat = ics.GetProperty(ftMessage.propDBConnPicture);
 
  //---
  // Use default if nothing specified
  if (!Utilities.goodString(sFormat))
  {
   sFormat = "jdbc/$dsn";
  }
  //java.lang.String source, java.lang.String what, java.lang.String with)
  String connectString = Utilities.replaceAll(sFormat, ftMessage.connpicturesub, ics.GetProperty("cs.dsn"));
    
  //String connectString = ics.GetProperty("cs.dsn");
  String sUser  =  ics.GetProperty("cs.privuser");
  String sPasswd  =  ics.GetProperty("cs.privpassword");
  
  printTableOpen(out);
  try {
  connection  =  getConnection(connectString, out, sUser, sPasswd);
  printCurrentDate(out);
  printDBMetaData(connection, out);
  }finally {
  	if (connection !=null){
 		 connection.close();
 	 }
  }
  printVMInfo(out);
  printRequestDetails(out,config,request, response);
  printSessionInfo(out,request, session);
  printRequestParameters(out,request);
  printAttributes(request,context, out);
  printRequestCookies(out, request);
  printRequestHeaders(out,request);
  printSystemProperties(out);
  printInitParameters(context, out);
  printCurrentThreadGroup(out);
  printAllThreads(out);
  printClassFolder(out);
  printAddresses(out);
  
  printTableClose(out);
  
 }
 catch (Exception ex)
 {
     out.println(ex.toString());
     ex.printStackTrace();
 } 
%>
</div>
<% } else { %>
    <div class="left-column">
      <h2>Categories</h2>
      <ul class="subnav divider">
        <li><a href="http://www.fatwire.com" class="Fatwire">Fatwire</a></li>								
      </ul>
      <h2>Recent Entries</h2>
      <ul class="subnav divider">
        <li><a href="http://www.fatwire.com/cs/Satellite/NewsITNewsPage_US.html">News</a></li>
      </ul>
      <h2>Fatwire Support</h2>
      <ul class="subnav divider">
        <li><a href="http://www.fatwire.com/support/">Support</a></li>
      </ul>
    </div>

   <div class="right-column">      
      <div class="entry">
           <h3>General Information</h3> 
           <p>The Content Server Support Tools are intended for use by experienced users with SiteGod privileges to assist in audit, cleanup, help diagnose and resolve problems. These tools can be customized by end users to their need.</p>      
           <div class="entry-header">
                <ics:callelement element="Support/Login"/>
           </div>
      </div>
   </div>
<% } %>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
