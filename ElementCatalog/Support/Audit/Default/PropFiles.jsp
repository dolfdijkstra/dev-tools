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
class IniFileFilter implements java.io.FileFilter {
    public boolean accept(File f) {
        if(f != null) {
            if(f.isDirectory()) {
                return false;
            }
            String extension = getExtension(f);
            if(extension != null && ("ini".equals(extension) || "properties".equals(extension))) {
                return true;
            }
        }
        return false;
    }

    private String getExtension(File f) {
        if(f != null) {
            String filename = f.getName();
            int i = filename.lastIndexOf('.');
            if(i>0 && i<filename.length()-1) {
                return filename.substring(i+1).toLowerCase();
            };
        }
        return null;
    }
}
%>
<cs:ftcs>
<h3>Content Server Property Files</h3>
<%
    String inipath = Utilities.osSafeSpec(getServletContext().getInitParameter("inipath"));
    File[] inifiles = new File(inipath).listFiles(new IniFileFilter());
    java.util.Arrays.sort(inifiles);
%>

<a href="ContentServer?pagename=<%= ics.GetVar("pagename") %>&iniprop=all&cmd=PropFiles">DisplayAll</a>
<table class="altClass" style="width:40%">
    <tr><th align="left">Property File</th></tr>
    <% for (int i=0; i<inifiles.length;i++){ %>
        <tr><td><a href="ContentServer?pagename=<%= ics.GetVar("pagename") %>&iniprop=<%=inifiles[i].getName() %>&cmd=PropFiles"><%=inifiles[i].getName() %></a></td></tr>
    <% } %>
</table>

<%
   String root = request.getRequestURI();	
   String croot1 = root.substring(root.indexOf("/"));
   String croot2 = root.substring(root.lastIndexOf("/"));
   String contextroot = null;
   if (croot1.equals(croot2)) 
      contextroot = "/";   
   else 
      contextroot = root.substring(root.indexOf("/"), root.lastIndexOf("/"));
   String realpath = request.getRealPath(contextroot);      
   String resources = realpath.substring(0, realpath.lastIndexOf(Utilities.osSafeSpec("/"))) + "/WEB-INF/classes";
   String proppath = Utilities.osSafeSpec(resources);   
   File[] propfiles = new File(proppath).listFiles(new IniFileFilter());
   java.util.Arrays.sort(propfiles);
%>
<br/><a href="ContentServer?pagename=<%= ics.GetVar("pagename") %>&prop=all&cmd=PropFiles">DisplayAll</a>
<table class="altClass" style="width:40%">
    <tr><th align="left">Property File</th></tr>
    <% for (int i=0; i<propfiles.length; i++){ %>
        <tr><td><a href="ContentServer?pagename=<%= ics.GetVar("pagename") %>&prop=<%=propfiles[i].getName() %>&cmd=PropFiles"><%=propfiles[i].getName() %></a></td></tr>
    <% } %>
</table>
<%
String iniprop = ics.GetVar("iniprop");
String prop = ics.GetVar("prop");
%>
<br/><br/><table class="altClass" style="width:60%">
<% if(iniprop != null) { %>
    <h3><b><%= iniprop%></b></h3>
<%
    Properties props = new Properties();
    if ("all".equals(iniprop)){
        for (int i=0;i<inifiles.length; i++){
            props.load(new FileInputStream(inifiles[i]));
        }
    } else {
        props.load(new FileInputStream(new File(inipath,iniprop)));
    }
    Set keySet = new TreeSet(props.keySet());
%>
    <tr><th align="left">Property</th><th>Value</th></tr>
    <%
    for(Iterator e=keySet.iterator(); e.hasNext();) {
        String key = (String)e.next();
        String value = props.getProperty(key);
    %>
    <tr><td width="20%"><%= key%></td><td width="80%"><%= value%></td></tr>
    <% } %>
<%
}
else if(prop != null) {
%>
    <h3><b><%= prop%></b></h3>
<%
    Properties props = new Properties();
    if ("all".equals(prop)){
        for (int i=0;i<propfiles.length;i++){
            props.load(new FileInputStream(propfiles[i]));
        }
    } else {
        props.load(new FileInputStream(new File(proppath,prop)));
    }
    Set keySet = new TreeSet(props.keySet());
%>
    <tr><th align="left">Property</th><th>Value</th></tr>
    <%
    for(Iterator e=keySet.iterator(); e.hasNext();) {
        String key = (String)e.next();
        String value = props.getProperty(key);
    %>
    <tr><td width="20%"><%= key%></td><td width="80%"><%= value%></td></tr>
    <% } %>
<% } else { %>
    <tr><td>
    Nothing to display
    </td></tr>
<% } %>
</table>
</cs:ftcs>
