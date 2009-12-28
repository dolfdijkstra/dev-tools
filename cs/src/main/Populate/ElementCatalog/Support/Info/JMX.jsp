<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Info/JMX
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="java.util.*"
%><%@ page import="java.io.IOException"
%><%@ page import="javax.servlet.jsp.JspWriter"
%><%@ page import="javax.management.*"
%><%@ page import="java.lang.management.ManagementFactory"
%><%@ page import="javax.management.openmbean.CompositeData"
%><%@ page import="javax.management.openmbean.TabularData"
%><%@ page import="javax.management.openmbean.CompositeType"
%><%!
private MBeanServer mBeanServer = null;

public void jspInit() {
    // Retrieve the MBean server
      if( MBeanServerFactory.findMBeanServer(null).size() > 0 ) {
         mBeanServer=(MBeanServer)MBeanServerFactory.findMBeanServer(null).get(0);
      } else {
         mBeanServer = ManagementFactory.getPlatformMBeanServer();
      }

}

public void jspDestroy() {

    mBeanServer = null;
}

void getAttribute(JspWriter writer, String onameStr, String att) throws IOException {
    try {
        ObjectName oname = new ObjectName(onameStr);
        Object value = mBeanServer.getAttribute(oname, att);
        writer.println("OK - Attribute get '" + onameStr + "' - " + att
                + "= " + escape(value.toString()));
    } catch (Exception ex) {
        writer.println("Error - " + ex.toString());
    }
}


void listBeans( JspWriter writer, String qry , String pagename) throws IOException
{

    Set names = null;
    try {
        names=mBeanServer.queryNames(new ObjectName(qry), null);
        writer.println("<p>OK - Number of results: " + names.size());
        writer.println("</p>");
    } catch (Exception e) {
        writer.println("Error - " + e.toString());
        return;
    }

    TreeSet<ObjectName> n = new TreeSet<ObjectName>(new Comparator<ObjectName>(){
         public int compare(ObjectName o1, ObjectName o2){
             return o1.toString().compareTo(o2.toString());
         }
         public boolean    equals(Object obj){
            return false;
         }
       });
    n.addAll(names);

    int bid=0;
    boolean display= n.size() < 20;//!"*:*".equals(qry);
    writer.print("<ol style=\"margin-top:0\">");
    for( Iterator<ObjectName> it= n.iterator(); it.hasNext();) {
        ObjectName oname=it.next();
        bid++;
        writer.print("<li><a style=\"display:block\" href=\"ContentServer?pagename="+ pagename +"&qry=" + java.net.URLEncoder.encode(oname.toString()) +"\"");
        if (!display) writer.print(" onmouseover=\"document.getElementById('bean"+bid+"').style.display='inline'\" onmouseout=\"document.getElementById('bean"+bid+"').style.display='none'\"");
        writer.print("><b>" + oname.toString() +"</b></a>");
        writer.println("<ul id=\"bean"+bid+"\" style=\"list-style-position:inside"+(!display? ";display:none": "")+"\">");

        try {
            MBeanInfo minfo=mBeanServer.getMBeanInfo(oname);
            String code=minfo.getClassName();
            if ("org.apache.commons.modeler.BaseModelMBean".equals(code)) {
                code=(String)mBeanServer.getAttribute(oname, "modelerType");
            }
            writer.print("<li>modelerType: " + code);
            writer.println("</li>");
            MBeanAttributeInfo attrs[]=minfo.getAttributes();
            Object value=null;

            for( int i=0; i< attrs.length; i++ ) {
                if( ! attrs[i].isReadable() ) continue;
                if( ! isSupported( attrs[i].getType() )) continue;
                String attName=attrs[i].getName();
                if( "modelerType".equals( attName)) continue;
                if( attName.indexOf( "=") >=0 ||
                        attName.indexOf( ":") >=0 ||
                        attName.indexOf( " ") >=0 ) {
                    continue;
                }

                try {
                    value=mBeanServer.getAttribute(oname, attName);
                } catch( Throwable t) {
                    log("Error getting attribute " + oname +
                        " " + attName + " " + t.toString());
                    continue;
                }
                if( value==null ) continue;
                writer.print("<li><i>"+attName + "</i>: ");
                printValue(writer,value);
                writer.println("</li>");
            }
        } catch (Exception e) {
            // Ignore
        }
        writer.println("</ul></li>");
    }
    writer.println("</ol>");

}
    private void printValue(JspWriter writer,Object value) throws IOException{
        if (value==null) return;
        if (value instanceof CompositeData) {
            printComp(writer,(CompositeData) value);
        } else if (value instanceof TabularData) {
            printTab(writer,(TabularData) value);
        } else if(value.getClass().isArray()){
            if (CompositeData.class.isAssignableFrom(value.getClass().getComponentType()) || TabularData.class.isAssignableFrom(value.getClass().getComponentType())){
                writer.print("<ul>" );
                for (Object o: (Object[])value){
                    writer.print("<li>");
                    printValue(writer,o);
                    writer.print("</li>");
                }
                writer.print("</ul>");
            } else {
                String valueString= String.valueOf(Arrays.asList((Object[])value)) ;
                writer.print("<span style=\"white-space:pre\">");
                writer.print(escape(valueString));
                writer.print("</span>");
            }
        } else {
            String valueString= value.toString();
            writer.print("<span style=\"white-space:pre\">");
            writer.print(escape(valueString));
            writer.print("</span>");

        }

    }

    private  void printTab(JspWriter writer,TabularData td) throws IOException {
        Set<String> keys=td.getTabularType().getRowType().keySet();

        writer.write("<table>");
        writer.write("<tr>");
        for (String key:keys){
            writer.write("<th>");
            writer.write(escape(key));
            writer.write("</th>");
        }
        writer.write("</tr>");
        for (Object o : td.values()) {
            if (o instanceof CompositeData) {
                CompositeData cd=(CompositeData) o;
                writer.write("<tr>");
                for (String key:keys){
                    writer.write("<td>");
                    printValue(writer,cd.get(key));
                    writer.write("</td>");
                }
                writer.write("</tr>");
            }
        }
        writer.write("</table>");
    }

    private void printComp(JspWriter writer,CompositeData cd) throws IOException {

        CompositeType ct = cd.getCompositeType();
        writer.print("<ul>");
        for (String key : ct.keySet()) {
            writer.print("<li><i>"+key + "</i>: ");
            printValue(writer,cd.get(key));
            writer.print("</li>");
        }
        writer.print("</ul>");
    }


String escape(String value){
    return value==null?"":org.apache.commons.lang.StringEscapeUtils.escapeHtml(value);
}


boolean isSupported( String type ) {
    return true;
}
%><cs:ftcs><%

    for (MBeanServer s: MBeanServerFactory.findMBeanServer(null)){
        out.write(String.valueOf(s.getDefaultDomain()));
        out.write("<br/>");
    }


%><form style="border:0; margin: 0;display:inline" name="query" action="ContentServer" method="GET"><input type="hidden" name="pagename" value='<ics:getvar name="pagename"/>'/>
      Query: <input type="text" name="qry" size="50" value='<%= ics.GetVar("qry") !=null? ics.GetVar("qry"): "*:*" %>'/> (<a href='ContentServer?pagename=<ics:getvar name="pagename"/>'>'*:*'</a> for all jmx beans)
    </form><%
if( mBeanServer==null ) {
    out.println("Error - No mbean server");

}else {

    String[] domains = mBeanServer.getDomains();
    Arrays.sort(domains);
    %>domains: <%
    for (String domain : domains){
        %> <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&qry=<%= domain %>:*'>'<%=domain%>:*'</a><%
    }
    String qry=ics.GetVar("get");
    if( qry!= null ) {
        String name=ics.GetVar("att");
        getAttribute( out, qry, name );
    }else {
        qry=ics.GetVar("qry");
        if( qry == null ) {
            qry = "*:*";
        }

        listBeans( out, qry ,ics.GetVar("pagename"));
    }
}
%></cs:ftcs>