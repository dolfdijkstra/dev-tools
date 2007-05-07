<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Audit/Default/DB/TemplateBrowser
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%!
static String[] xmlElements = new String[]{"callelement","render.getpageurl"};
class Renderer {
//	boolean inElement = false;

	StringBuffer bodyBuffy = new StringBuffer();
	StringBuffer element = null;
	String render(String body){
		StringBuffer buffy=bodyBuffy;

		for (int i=0;i<body.length();i++){
			switch (body.charAt(i)){
				case '<':
					buffy.append("&lt;");
					element= new StringBuffer();
					buffy = element;
					break;
				case '>':
					if (isSpecialTag(buffy.toString())){
						bodyBuffy.append("<span style='color:red'>");
						bodyBuffy.append(rewriteElement(buffy.toString()));
						bodyBuffy.append("</span>");
					} else {
						bodyBuffy.append(buffy);
					}					
					buffy = bodyBuffy;
					buffy.append("&gt;");
					break;
				case '\n':
					buffy.append("<br/>");
					break;
				case '\r':
					break;
				default:
					buffy.append(body.charAt(i));
			}
		}

		return bodyBuffy.toString();
	}

	boolean isSpecialTag(String element){
		String lElem = element.toLowerCase();
		boolean ret=false;
		for (int i=0;i<xmlElements.length;i++){
			if (lElem.startsWith(xmlElements[i])){
			ret=true;
			break;
			}
		}
		return ret;
	}

	String rewriteElement(String elem){
		StringBuffer b = new StringBuffer();
		int t = elem.toLowerCase().indexOf("pagename");
		if (t==-1) {
			return elem;
		} else {
			int eqs=0;
			int quote = 0;;
			for (int i= t+8;i<elem.length();i++){
				if (elem.charAt(i)=='='){
					eqs=i;
				} else if ((elem.charAt(i)=='\'' || elem.charAt(i)=='\"' ) && eqs>0 ){
					if (quote==0){
						quote=i;
					} else {
						b.append(elem.substring(0,quote));
						b.append("blah");
						b.append(elem.substring(i));
						break;
					}
				} 
			}
		}
		return b.toString();
	}
}
%><cs:ftcs
><ics:sql sql='<%= ics.ResolveVariables("select url from ElementCatalog WHERE elementname = 'Variables.ename'") %>' table="ElementCatalog" listname="element"
/><div style="font-family: Courier New; font-size: 10pt"><%= new Renderer().render(ics.ResolveVariables("element.@url"))
%></div></cs:ftcs>
