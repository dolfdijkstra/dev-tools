<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Info/JMX
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="java.util.*"
%><%@ page import="java.io.IOException"
%><%@ page import="javax.servlet.jsp.JspWriter"
%><%@ page import="javax.management.MBeanServer"
%><%@ page import="javax.management.*"
%><%@ page import="java.lang.management.ManagementFactory"
%><%!
private MBeanServer mBeanServer = null;
// --------------------------------------------------------- Public Methods


/**
 * Initialize this servlet.
 */
public void jspInit() {
    // Retrieve the MBean server
    mBeanServer = ManagementFactory.getPlatformMBeanServer();
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
    Iterator<ObjectName> it= n.iterator();
    int bid=0;
    boolean display= n.size() < 20;//!"*:*".equals(qry);
    writer.print("<ol style=\"margin-top:0\">");
    while( it.hasNext()) {
        ObjectName oname=it.next();
        bid++;
        writer.print("<li><a style=\"display:block\" href=\"ContentServer?pagename="+ pagename +"&qry=" + oname.toString() +"\"");
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
                String valueString=value.getClass().isArray() ? String.valueOf(Arrays.asList((Object[])value)) : value.toString();
                writer.print("<li><i>"+attName + "</i>: <span style=\"white-space:pre\">" + escape(valueString));
                writer.println("</span></li>");
            }
        } catch (Exception e) {
            // Ignore
        }
        writer.println("</ul></li>");
    }
    writer.println("</ol>");

}

String escape(String value){
    return org.apache.commons.lang.StringEscapeUtils.escapeHtml(value);
}

String escapeX(String value) {
    // The only invalid char is \n
    // We also need to keep the string short and split it with \nSPACE
    // XXX TODO
    int idx=value.indexOf( "\n" );
    if( idx < 0 ) return value;

    int prev=0;
    StringBuilder sb=new StringBuilder();
    while( idx >= 0 ) {
        appendHead(sb, value, prev, idx);

        sb.append( "\\n\n ");
        prev=idx+1;
        if( idx==value.length() -1 ) break;
        idx=value.indexOf('\n', idx+1);
    }
    if( prev < value.length() )
        appendHead( sb, value, prev, value.length());
    return sb.toString();
}

private void appendHead( StringBuilder sb, String value, int start, int end) {
    if (end < 1) return;

    int pos=start;
    while( end-pos > 78 ) {
        sb.append( value.substring(pos, pos+78));
        sb.append( "\n ");
        pos=pos+78;
    }
    sb.append( value.substring(pos,end));
}

boolean isSupported( String type ) {
    return true;
}
%><cs:ftcs><%


%><div><form style="border:0; margin: 0;display:inline" name="query" action="ContentServer" method="GET"><input type="hidden" name="pagename" value='<ics:getvar name="pagename"/>'/>
      Query: <input type="text" name="qry" size="50" value='<%= ics.GetVar("qry") !=null? ics.GetVar("qry"): "*:*" %>'/> (<a href='ContentServer?pagename=<ics:getvar name="pagename"/>'>'*:*'</a> for all jmx beans)
    </form><%
if( mBeanServer==null ) {
    out.println("Error - No mbean server");

}else {
    String[] domains = mBeanServer.getDomains();
    Arrays.sort(domains);
    %>domains: <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&qry=java.lang:*'>'java.lang:*'</a><%
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
%></div></cs:ftcs>