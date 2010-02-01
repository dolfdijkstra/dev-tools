<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%!
private String csVersion="unknown";
private String csEnv="var csEnv ={";

public void jspInit(){
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
ics.SetVar("st_version","3.7.1");
%><satellite:link pagename='Support/css' satellite="true" outstring="cssURL" ><satellite:argument name="v" value="22"/></satellite:link><%
%><satellite:link pagename='Support/prototype' satellite="true" outstring="prototypeURL" ><satellite:argument name="v" value="1.6.1"/></satellite:link><%
%><head>
<title><ics:getvar name="pagename"/></title>
<meta http-equiv="Pragma" content="no-cache"/><%
%><link rel="stylesheet" href='<%=ics.GetVar("cssURL")%>' type="text/css" media="screen"/>
</head>
<script type="text/javascript">
var began_loading = new Date().getTime();
<%=csEnv %>
var session={<%
    {
    String[] names=new String[]{"username"};
    for (int i=0,j=0; i< names.length;i++ ){
      Object o = session.getAttribute(names[i]);
      if (o instanceof String || o instanceof Number){
        %><%= j++>0 ?",":""%><%
        %><%= "'"+ names[i] +"': '"+ o +"'" %><%
      }
    }
    }
%>};


function hitLoadSensor(){
  var elapsed_loading= new Date().getTime() - began_loading;
  var server_elapsed = parseInt(window.elapsed/1000);
  document.getElementById("elapsed").innerHTML = "loaded in " + server_elapsed + "/"+ elapsed_loading +"ms";
  var pl = 'l=' + escape(self.location) + '&t=' + (elapsed) + '&e=' + window.elapsed;
  <% if(ics.GetSSVar("supporttools.beacon") ==null){
      ics.SetSSVar("supporttools.beacon","1");
      %>pl +='&n.os='+navigator.oscpu;
  pl +='&n.acn='+navigator.appCodeName;
  pl +='&n.ap='+navigator.appName;
  pl +='&n.av='+navigator.appVersion;
  pl +='&n.p='+navigator.platform;
  if (window.screen.availHeight){
    pl +='&s.ad=' +window.screen.availHeight +','+window.screen.availWidth;
  }
  pl +='&s.cd='+ window.screen.colorDepth;
  pl +='&s.d='+ window.screen.height +','+window.screen.width;
  pl +='&v=<%= ics.GetVar("st_version") %>';
  <%
    for (String s : new String[]{ "java.runtime.version","java.version","java.vm.version","os.arch","os.name","os.version"}){
        %>pl +='&<%=s %>=<%=java.net.URLEncoder.encode(System.getProperty(s))%>';
        <%
    }
    %>pl +='&ws.info=<%= java.net.URLEncoder.encode(getServletConfig().getServletContext().getServerInfo()) %>';
    <%
    Runtime rt = Runtime.getRuntime();
    java.text.NumberFormat formatter = java.text.NumberFormat.getNumberInstance(java.util.Locale.US);
    %>pl +='&mem.max=<%= formatter.format( rt.maxMemory()) %>';
    pl +='&mem.total=<%= formatter.format(rt.totalMemory()) %>';
    pl +='&mem.free=<%= formatter.format( rt.freeMemory()) %>';
    pl +='&os.proc=<%= Integer.toString(rt.availableProcessors()) %>';
    pl +='&cs.version=<%= java.net.URLEncoder.encode(csVersion) %>';
<%} %>
  var sensor = new Image();
  sensor.onerror = loadError;
  sensor.src = location.protocol +'//fwsupporttools.appspot.com/beacon/load?pl=' + escape(pl) +'&oid=<%=ics.GetVar("pagename")%>';
  /*in case the image fails, we should shut off the sensor app */
  function loadError(msg,url,line)
  {
      //sensor.onerror=null;
      <satellite:link pagename="Support/sensorMiss" satellite="false" />
      //sensor.src='<%=ics.GetVar("referURL")%>';
      return true
  }
}

function hitUnLoadSensor(){
 var sensor = new Image();
 sensor.src = "beacon/unload?u=' + escape(self.location) + '&r=" + escape(anchor.href)+ '&t=' + ((new Date()).getTime() - began_loading);
}

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

addEvent(window, 'load', hitLoadSensor);

//addEvent(window, 'unload', hitUnLoadSensor);
</script>
<% ics.RemoveVar("referURL");%></cs:ftcs>