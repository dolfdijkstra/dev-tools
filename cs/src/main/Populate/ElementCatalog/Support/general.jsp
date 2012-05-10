<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%!
private String csEnv="var csEnv ={";

public void jspInit(){
    String csVersion="unknown";
    try {
        final COM.FutureTense.Util.FBuild bb = new COM.FutureTense.Util.FBuild();
        String v = bb.version();
        String[] x= v.split("[\r\n]");
        if (x.length >1){
            csVersion = x[x.length-1];
        }else {
            csVersion=v;
        }
    } catch(Throwable t){
    }
    try {
        csEnv +="cs_version:'"+csVersion +"',";

        for (String s : new String[]{ "java.runtime.version","java.version","java.vm.version","os.arch","os.name","os.version"}){
            csEnv += s.replace(".","_") +":'"+ System.getProperty(s) +"',";
        }
        Runtime rt = Runtime.getRuntime();
        csEnv +="os_proc: "+ Integer.toString(rt.availableProcessors()) +",";
        csEnv += "ws_info:'"+ getServletConfig().getServletContext().getServerInfo() +"'};";
    } catch(Throwable t){
        csEnv="var csEnv ={};";
    }


}
%><cs:ftcs><%
ics.SetVar("st_version","3.8.2");
%><satellite:link pagename='Support/css' satellite="true" outstring="cssURL" ><satellite:argument name="v" value='<%= ics.isCacheable("Support/css")?"27": Long.toString(System.currentTimeMillis()) %>'/></satellite:link><%
%><satellite:link pagename='Support/prototype' satellite="true" outstring="prototypeURL" ><satellite:argument name="v" value="1.6.1"/></satellite:link><%
%><head><script type="text/javascript">var began_loading = new Date().getTime();</script>
<title><ics:getvar name="pagename"/></title>
<meta http-equiv="Pragma" content="no-cache"/><%
%><link rel="stylesheet" href='<%=ics.GetVar("cssURL")%>' type="text/css" media="screen"/>
<script type="text/javascript"><%=csEnv %>

function addEvent(obj, evType, fn){
 if (obj.addEventListener){
   obj.addEventListener(evType, fn, false);
   return true;
 } else if (obj.attachEvent){
   var r = obj.attachEvent("on"+evType, fn);
   return r;
 } else {
   return false;
 }
}
</script>
</head>
<% ics.RemoveVar("referURL");ics.RemoveVar("cssURL");%></cs:ftcs>