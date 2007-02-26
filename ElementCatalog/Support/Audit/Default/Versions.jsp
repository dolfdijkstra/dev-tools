<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Versions_2
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
<%@ page import="java.lang.reflect.*" %>

<cs:ftcs>

<!-- user code here -->

<%!

// "Product Name" - "Product Jar" - "Product Version Info Class"  - "Product Info Method" - "Is Class Method ?" - "Product Version"
//

private String []ProductInfo ={

	"Content Server", "cs.jar", "COM.FutureTense.Util.FBuild", "printBuildDate", "y", "",
	"", "sseed.jar", "com.openmarket.Satellite.Seed.BuildSeed", "printBuildDate", "y", "",
	"", "FTLDAP.jar", "COM.FutureTense.LDAP.Util.FBuildLdap", "printBuildDate", "y", "", 
	"", "framework.jar", "com.openmarket.framework.util.FBuildFramework", "printBuildDate", "y", "",
	"", "ftcsntsecurity.jar", "COM.FutureTense.NTUserGroups.Util.FBuildNTUG", "printBuildDate", "y", "", 
	"", "batch.jar", "com.openmarket.Batch.Build com.openmarket.Batch.util.BatchBuildDate", "printBuildDate", "y", "", 
	"", "ics.jar", "com.openmarket.ICS.BuildICS", "printBuildDate", "y", "",
	"", "directory.jar", "com.openmarket.directory.util.Build", "printBuildDate", "y", "", 
	"Catalog Centre", "gator.jar", "com.openmarket.gator.util.FBuildGator", "printBuildDate", "y", "",
	"", "gatorbulk.jar", "com.openmarket.gatorbulk.util.FBuildGatorBulk", "printBuildDate", "y", "",
	"", "visitor.jar", "com.openmarket.visitor.util.FBuildVisitor", "printBuildDate", "y", "",
	"", "assetframework.jar", "com.openmarket.assetframework.util.FBuildAssetFramework", "printBuildDate", "y", "", 
	"", "basic.jar", "com.openmarket.basic.util.FBuildBasic", "printBuildDate", "y", "",
	"", "cscommerce.jar", "com.openmarket.cscommerce.util.FBuildCSCommerce", "printBuildDate", "y", "", 
	"Marketing Studio", "rules.jar", "com.openmarket.rules.util.FBuildRules", "printBuildDate", "y", "", 
	"Content Centre", "xcelerate.jar", "com.openmarket.xcelerate.util.FBuildXcelerate", "a", "y", "",
	"", "sampleasset.jar", "com.openmarket.sampleasset.util.FBuildSampleAsset", "a", "y", "",
	"", "assetmaker.jar", "com.openmarket.assetmaker.util.FBuildAssetMaker", "a", "y", "", 
	"Analysis Connector", "commercedata.jar", "com/openmarket/commercedata/util/FBuildCommerceData", "printBuildDate", "y", "",
	"Database Loader", "commercedata.jar", "com/openmarket/commercedata/util/FBuildDatabaseLoader", "printBuildDate", "y", "",
	"Queue", "commercedata.jar", "com/openmarket/commercedata/util/FBuildQueue", "printBuildDate", "y", "",


	"XML Exchange", "xmles.jar", "com.openmarket.ic.webcomm.util.FBuildXMLES", "printBuildDate", "y", "", 
	"", "icutilities.jar", "com.openmarket.ic.util.FBuildICUtilities", "printBuildDate", "y", "", 
	"", "icutilities.jar", "com.openmarket.ic.util.FBuildICUtilities", "printBuildDate", "y", "",
	"", "logging.jar", "com.openmarket.logging.util.Build", "printBuildDate", "y", "",
	"", "transformer.jar", "com.openmarket.Transform.util.Build", "printBuildDate", "y", "",

	// "", "xalan.jar", "org.apache.xml.utils.DOMBuilder", "printBuildDate", "y", "",

	// "", "xerces.jar", "javax.xml.parsers.DocumentBuilder javax.xml.parsers.DocumentBuilderFactory META-INF.services.javax org.apache.html.dom.HTMLBuilder org.apache.xerces.jaxp.DocumentBuilderFactoryImpl org.apache.xerces.jaxp.DocumentBuilderImpl", "printBuildDate", "y", "", 
	"Satellite Server", "sserve.jar", "com.openmarket.Satellite.Build", "printBuildDate", "y", "",

};


private String view = null;
private String debug = null;
private String all = null;

%>

<%!

// Method that finds the version of the product loaded
// method_nums :
// 0 - String printBuildDate();
// 1 - String a();

private final static String[] METHODS = { "printBuildDate", "a"};
private final static int MAX_NUM_METHODS = METHODS.length;

private String GetVersion (String class_name, 
					String method_name, 
					String class_method,
					int method_num) {

	LogMessage ("Invoked - GetVersion (" + class_name + ", " + method_name + ", " + class_method + ", " + method_num + ");");

	String version = null;
	
	if ((class_name == null) || (class_name.length() == 0) || 
	    (method_name == null) || (method_name.length() == 0) ||
	    (class_method == null) || (class_method.length() == 0)) {
		return null;
	}

	String method = method_name;
	if ((method_num != 0) && (method_num <= METHODS.length)) {
		method = METHODS[method_num - 1];
	} 

	try {
		Class c = Class.forName (class_name);
				
		Method m = c.getMethod(method, null);
		
		if (class_method.equals("y")) {
			LogMessage ("Invoking the class method");
			version = (String) m.invoke (null, null);
		} else {
			LogMessage ("Invoking the instance method");
			Object o = c.newInstance();
			version = (String) m.invoke (o, null);
		}				
	} catch (ClassNotFoundException e) {
		version = "<font color=#ff0000>NOT INSTALLED/LOADED</font>";
	}catch (java.lang.NoSuchMethodException e) {
		if ((method_num+1) <= MAX_NUM_METHODS) {			
			version = GetVersion (class_name, method_name, class_method, (method_num + 1));
		} else {
			version = "METHOD '" + method_name + "' NOT FOUND in '" + class_name;
		}
	} catch (Exception e) {
		e.printStackTrace();
		version = "ERROR : Look at the stack trace in log";
	}

	return version;
}


private void LogMessage (String msg) {
	LogMessage (msg, "debug");
}

private void LogMessage (String msg, String type) {
	if (debug != null) {
		System.out.println ("DEBUG : " + msg);
	}
}

%>

<%


// Various query options supported 
view = ics.GetVar ("view");
all = ics.GetVar ("all");
debug = ics.GetVar ("debug");

if (debug == null) {
	System.out.println ("DEBUG Enabled ? NO");
} else {
	System.out.println ("DEBUG Enabled ? YES");
}

LogMessage ("VIEW : " + view);
LogMessage ("ALL : " + all);
LogMessage ("DEBUG : " + debug);

if ((view == null) || (Integer.parseInt(view) > 4)) {
	view = "1";
}

if (all == null) {
	all = null;
}

if (debug == null) {
	debug = null;
}


int len = ProductInfo.length;

for (int i=0; i<len; i+=6) {
	boolean err = false;
	int j = 0;

	String product_name 		= ProductInfo[i];

	String product_jar = null;
	if ((i+ ++j) <= len) {
		product_jar	= ProductInfo[i+j];
	} else {
		err	= true;
		out.println ("ERROR : jar not provided for : " + product_name);
	}

	String product_class = null;
	if ((i+ ++j) <= len) {
		product_class	= ProductInfo[i+j];
	} else {
		err	= true;
		out.println ("ERROR : class not provided for : " + product_name);
	}

	String product_method = null;
	if ((i+ ++j) <= len) {
		product_method	= ProductInfo[i+j];
	} else {
		err	= true;
		out.println ("ERROR : method not provided for : " + product_name);
	}

	String is_class_method = null;
	if ((i+ ++j) <= len) {
		is_class_method	= ProductInfo[i+j];
	} else {
		err	= true;
		out.println ("ERROR : is class method not provided for : " + product_name);
	}

	String product_version = null;
	if ((i+ ++j) <= len) {
		product_version	= ProductInfo[i+j];			
	} else {
		err	= true;
		out.println ("ERROR : version object not initialized for : " + product_name);
	}

	if (! err) {
		// update the version info for this product
		ProductInfo[i+j] = GetVersion (product_class, product_method, is_class_method, 0);
	}
}

%>

<HEAD>
<TITLE> Installed Products Info.</TITLE>
</HEAD>
<BODY>

<!-- Print the product info. table -->
<H1 align="center"> PRODUCT VERSIONS INFO.</H1>
<BR/>Total # Rows : <%= len/6 %>
<table border=1 width="100%" bgcolor=CCCCCC bordercolor=000000>


<tr>

<%
	if (view.equals("1") || view.equals("3") || view.equals("4")) {
		out.print ("<th> Product Name </th>");		
	} 
	
	if (view.equals("1") || view.equals ("2") || view.equals("4")) {		
		out.print ("<th> Jar File </th>");		
	}

	if (view.equals("1") || view.equals ("2") || view.equals("3")) {		
		out.print ("<th> Version </th>");
	}
	
%>

</tr>

<%
// VIEW 1 : product name - product jar - product build info
// VIEW 2 : product jar - product build info
// VIEW 3 : product name - product build info
// VIEW 4 : product name - product jar

for (int i=0; i<len; i+=6) {		
	out.print ("<tr>");

	if (view.equals("1") || view.equals("3") || view.equals("4")) {
		out.print ("<td>" + ProductInfo[i] + "</td>");		
	} 
	
	if (view.equals("1") || view.equals ("2") || view.equals("4")) {		
		out.print ("<td>" + ProductInfo[i+1] + "</td>");		
	}

	if (view.equals("1") || view.equals ("2") || view.equals("3")) {		
		out.print ("<td>" + ProductInfo[i+5] + "</td>");
	}

	out.print ("</tr>");
}	
%>

</table>
<B><font color=#0000ff size=2 weight=900>by <I><a href="mailto:krishna.gorthi@divine.com">Krishna Gorthi</a></I> </font></B>

</BODY>

</cs:ftcs>

