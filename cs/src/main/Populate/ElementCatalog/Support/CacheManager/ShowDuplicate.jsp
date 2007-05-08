<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/CacheManager/ShowDuplicate
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
<%@ page import="java.util.*"%>
<cs:ftcs>

<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<center><h3>Cached Pages</h3></center>
<%!
static class PageInfo {
    int count = 0;
    String qrystr = null;
    PageInfo(int i, String s) {
        count = i;
        qrystr = s;
    }
}

static class Rearrange implements Comparator {
    public int compare(Object obj1, Object obj2) {
        PageInfo pi1 = (PageInfo)obj1;
	PageInfo pi2 = (PageInfo)obj2;
	Integer a = new Integer(pi1.count);
	Integer b = new Integer(pi2.count);
	return a.compareTo(b);
   }
}

private LinkedHashMap sortMapByValue(HashMap tosort, boolean asc) {
    List mapKeys = new ArrayList(tosort.keySet());
    List mapValues = new ArrayList(tosort.values());
    
    Collections.sort(mapValues, new Rearrange());
    Collections.sort(mapKeys);

    if (!asc) 
	Collections.reverse(mapValues);
    
    LinkedHashMap sorted = new LinkedHashMap();
    Iterator valueIt = mapValues.iterator();
    while (valueIt.hasNext()) {
        Object val = valueIt.next();
        Iterator keyIt = mapKeys.iterator();
        while (keyIt.hasNext()) {
            Object key = keyIt.next();
            if (tosort.get(key).toString().equals(val.toString())) {
                tosort.remove(key);
                mapKeys.remove(key);
                sorted.put(key, val);
                break;
            }
        }
    }
    return sorted;
}

private String parseQuery(String qry) {
    Map conqry = new HashMap();
    conqry.put("pagename", "--");	
    conqry.put("c", "--");
    conqry.put("cid", "--");
    conqry.put("p", "--");
    conqry.put("context", "--");
    conqry.put("rendermode", "--");
    conqry.put("ft_ss", "--");
    conqry.put("other", "--");    
    conqry.put("seid", "--");    
    conqry.put("site", "--");    
    conqry.put("siteid", "--");    

        
    String[] parsed = qry.split("&");
    for (int j=0; j<parsed.length; j++) {
        String[] cparse = parsed[j].split("=");
	if (cparse[0].equals("pagename") || cparse[0].equals("c") || cparse[0].equals("cid") || cparse[0].equals("p") || cparse[0].equals("context") || cparse[0].equals("rendermode") || cparse[0].equals("ft_ss") || cparse[0].equals("seid") || cparse[0].equals("site") || cparse[0].equals("siteid"))
	    conqry.put(cparse[0], cparse[1]);
	else {
	    String op = (String)conqry.get("other");
	    if(op!="--")	
	    	conqry.put("other", op+"&"+cparse[0]+"="+cparse[1]);
	    else 
		conqry.put("other", cparse[0]+"="+cparse[1]);
	}    
    }

    String qrystring = "<b>";
    qrystring += "<td width=\"25%\" nowrap=\"true\">"+conqry.get("pagename")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("c")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("cid")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("p")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("context")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("rendermode")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("ft_ss")+"</td>";
    qrystring += "<td width=\"15%\" nowrap=\"true\">"+conqry.get("other")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("seid")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("site")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("siteid")+"</td>";
    qrystring += "</b>";
    conqry.clear();
    
    return qrystring;
}

private String reportExcess(PageInfo pd) {
    String dupages = null;
    String[] pinfo = pd.qrystr.split(",");

    dupages = "<td>Found "+pd.count+" identical urlpage: <br/>"+"<a href='ContentServer?pagename=Support/CacheManager/listPagename&pname="+pinfo[0]+"&mode=detail'>"+pinfo[0]+"</a></td>";
    
    dupages += "<td><table cellspacing=\"1px\" bgcolor=\"#CCFF99\" width=\"100%\">";
    dupages += "<tr><th>pageid</th><th>pagelet</th><th>c</th><th>cid</th><th>p</th><th>context</th><th>rendermode</th><th>ft_ss</th><th>other params</th><th>seid</th><th>site</th><th>siteid</th>";
    int j = 1; 
    while(j<pinfo.length) {
        dupages += "<tr><td width=\"10%\"><a href='ContentServer?pagename=Support/CacheManager/listItemsByPage&pid="+pinfo[j]+"'>"+pinfo[j]+"</a></td>";
        j += 1; 
        dupages += parseQuery(pinfo[j])+"</tr>";
        j += 1;
    }
    dupages += "</table></td>";

    return dupages;
}
%>
<%
Map counter = new HashMap();
StringBuffer errstr = new StringBuffer();
String query = "select id, pagename, urlqry, urlpage from systempagecache order by pagename";
IList results = ics.SQL("SystemPageCache", query, null, -1, true, errstr);
int rows = results.numRows();

out.print("...........Total "+rows+" Cached Pages...........");
for (int i = 1; i <= rows; i++) {
    results.moveTo(i);
    String pagebody = results.getFileString("urlpage");
    String pgbody = Integer.toString(pagebody.hashCode());

    PageInfo pi = (PageInfo)counter.get(pgbody);

    if (pi == null) {
        pi = new PageInfo(1, results.getValue("pagename")+","+results.getValue("id")+","+results.getFileString("urlqry"));
        counter.put(pgbody,pi);
    }
    else {
        pi.count = (pi.count+1);
        pi.qrystr = (pi.qrystr+","+results.getValue("id")+","+results.getFileString("urlqry"));
    }
}

Map sortall = sortMapByValue((HashMap)counter, false);
out.print("<table class=\"altClass\">");
out.print("<tr><th>DuplicatePages</th><th>PageID - QueryDetails</th></tr>");
for (Iterator it = sortall.entrySet().iterator(); it.hasNext();) {
    Map.Entry me = (Map.Entry)it.next();
    PageInfo pi = (PageInfo)me.getValue();
    if (pi.count > 1) {
        out.print("<tr>");
        out.print(reportExcess(pi));
        out.print("</tr>");
    }
}
out.print("</table>");
counter.clear();
%>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
