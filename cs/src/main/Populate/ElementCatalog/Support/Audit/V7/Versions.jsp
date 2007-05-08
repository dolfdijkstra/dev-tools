<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%//
// Support/Audit/V7/Versions
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors" %>

<%@ page import="java.lang.reflect.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<cs:ftcs>
    
    <%!
    //*********************************************************************************
    // Member Type
    //*********************************************************************************
    private final static String kIMethod          = "InstanceMethod";
    private final static String kIVariable        = "InstanceVariable";
    private final static String kCMethod          = "ClassMethod";
    private final static String kCVariable        = "ClassVariable";
    
    public final static int BUFF_SIZE             = 512;
    
    private final static String kJVMVersion       = "JVM Version";
    private final static String kJVMTotalMemory   = "Total Memory";
    private final static String kJVMFreeMemory    = "Free Memory";
    private final static String kJVMUsedMemory    = "Used Memory";
    
    private final static String kProductNotFound  = "<b><font color=\"#191970\">JAR NOT INSTALLED/LOADED";
    private final static String kNoInfoFound      = "<b><font color=\"#191970\">INFORMATION NOT AVAILABLE";
    private final static String kSpace            = "&nbsp;";
    private final static String kDefaultView      = "3";
    private final static String kDelim            = ";";
    
    private final static int kAll       = 0xffff;
    public static boolean printExpTrace = false;
    private final static PrintStream kDefaultOutStream = System.out;
    private static PipedInputStream stdoutReader;
    
    //*********************************************************************************
    //  PRODUCT INFORMATION
    //*********************************************************************************
    private final static String[][] ProductInfo = {
        
        //  "Product Name"          "Product Jar"           "Product Version Info Class"                                Class Member name       Member Type     Product Version"
        //                                                              method/instance
        //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        {"Content Server",      "cs.jar",               "COM.FutureTense.Util.FBuild",                              "main",                 kIMethod,       ""},
        {"",                    "cs-core.jar",          "com.fatwire.cs.core.util.FBuild",                          "main",                 kIMethod,       ""},
        {"",                    "framework.jar",        "com.openmarket.framework.util.FBuild",                     "main",                 kIMethod,       ""},
        {"",                    "batch.jar",            "com.fatwire.batch.util.FBuild",                            "main",                 kIMethod,       ""},
        {"",                    "ics.jar",              "com.fatwire.ics.util.FBuild",                              "main",                 kIMethod,       ""},
        //    {"",                    "FTLDAP.jar",           "COM.fatwire.ftldap.util.FBuild",                           "main",                 kIMethod,       ""},
        //    {"",                    "ftcsntsecurity.jar",   "COM.fatwire.ftcsntsecurity.util.FBuild",                   "main",                 kIMethod,       ""},
        {"",                    "logging.jar",          "com.fatwire.logging.util.FBuild",                          "main",                 kIMethod,       ""},
        {"",                    "directory.jar",        "com.fatwire.directory.util.FBuild",                        "main",                 kIMethod,       ""},
        {"",                    "sseed.jar",            "com.fatwire.sseed.util.FBuild",                            "main",                 kIMethod,       ""},
        {"",                    "cs-portlet.jar",       "com.fatwire.cs.portals.portlet.util.FBuild",               "main",                 kIMethod,       ""},
        {"",                    "transformer.jar",      "com.fatwire.transformer.util.FBuild",                      "main",                 kIMethod,       ""},
        {"",                    "keyview.jar",          "com.openmarket.Transform.Keyview.FBuild",                  "main",                 kIMethod,       ""},
        {"",                    "alloyui.jar",          "com.fatwire.ui.util.FBuild",                                              "main",                 kIMethod,       ""},
        {"",                    "assetapi.jar",          "com.fatwire.assetapi.util.FBuild",                                "main",                 kIMethod,       ""},
        {"Content Centre",      "xcelerate.jar",        "com.openmarket.xcelerate.util.FBuild",                     "main",                 kIMethod,       ""},
        {"",                    "assetmaker.jar",       "com.openmarket.assetmaker.util.FBuild",                    "main",                 kIMethod,       ""},
        {"",                    "basic.jar",            "com.openmarket.basic.util.FBuild",                         "main",                 kIMethod,       ""},
        {"",                    "sampleasset.jar",      "com.openmarket.sampleasset.util.FBuild",                   "main",                 kIMethod,       ""},
        {"Catalog Centre",      "gator.jar",            "com.openmarket.gator.util.FBuild",                         "main",                 kIMethod,       ""},
        {"",                    "gatorbulk.jar",        "com.openmarket.gatorbulk.util.FBuild",                     "main",                 kIMethod,       ""},
        {"",                    "visitor.jar",          "com.openmarket.visitor.util.FBuild",                       "main",                 kIMethod,       ""},
        {"",                    "assetframework.jar",   "com.openmarket.assetframework.util.FBuild",                "main",                 kIMethod,       ""},
        {"",                    "basic.jar",            "com.openmarket.basic.util.FBuild",                         "main",                 kIMethod,       ""},
        {"Extensions",          "firstsite-filter.jar", "com.fatwire.firstsite.filter.util.FBuild",                 "main",                 kIMethod,       ""},
        {"",                    "firstsite-uri.jar",    "com.fatwire.firstsite.uri.util.FBuild",                    "main",                 kIMethod,       ""},
        {"",                    "flame.jar",            "com.fatwire.flame.util.FBuild",                            "main",                 kIMethod,       ""},
        {"",                    "spark.jar",            "com.fatwire.spark.util.FBuild",                            "main",                 kIMethod,       ""},
        {"Marketing Studio",    "rules.jar",            "com.openmarket.rules.util.FBuild",                         "main",                 kIMethod,       ""},
        {"",                    "catalog.jar",          "com.openmarket.catalog.util.FBuild",                       "main",                 kIMethod,       ""},
        {"Analysis Connector",  "commercedata.jar",     "com.openmarket.commercedata.util.FBuild",                  "main",                 kIMethod,       ""},
        {"",                    "cscommerce.jar",       "com.openmarket.cscommerce.util.FBuild",                    "main",                 kIMethod,       ""},
        {"Database Loader",     "commercedata.jar",     "com.openmarket.commercedata.util.FBuild",                  "main",                 kIMethod,       ""},
        {"Queue",               "commercedata.jar",     "com.openmarket.commercedata.util.FBuild",                  "main",                 kIMethod,       ""},
        {"XML Exchange",        "xmles.jar",            "com.fatwire.xmles.util.FBuild",                            "main",                 kIMethod,       ""},
        {"",                    "icutilities.jar",      "com.fatwire.icutilities.util.FBuild",                      "main",                 kIMethod,       ""},
        {"Miscellaneous",       "wl6special.jar",       "com.fatwire.wl6special.util.FBuild",                       "main",                 kIMethod,       ""},
        {"",                    "verityse.jar",         "COM.FutureTense.Search.Verity.Util.FBuildVeritySE",        "main",                 kIMethod,       ""},
        {"",                    "lucene-search.jar",         "com.fatwire.search.util.FBuild",              "main",                 kIMethod,       ""},
        {"Satellite Server",    "sserve.jar",           "com.fatwire.sserve.util.FBuild",                           "main",                 kIMethod,       ""}
    };
    
    //*****************
    // JVM information
    //*****************
    private final static String[][] JVMInfo ={
        //***************************************
        //Resource Label    Resource Value in (k)
        //***************************************
        {kJVMVersion,       kNoInfoFound},
        {kJVMTotalMemory,   kNoInfoFound},
        {kJVMFreeMemory,    kNoInfoFound},
        {kJVMUsedMemory,    kNoInfoFound},
    };
    
    private final int kProduct_rows = ProductInfo.length;
    private final static int kJVM_rows = JVMInfo.length;
    %>
    
    <%!
    // This method executes all the methods specified in class_members
    // and return the value returned by the first method that returns a non-null version string
    public String GetVersion(String class_name, String class_members, String member_types, StringBuffer error) {
        String version = null;
        String[] versions = GetVersion(class_name, class_members, member_types, true, error);
        
        if ((versions != null) && (versions.length > 0)) {
            version = versions[0];
            
            String[] versionInfo = ParseForVersion(version);
            if (versionInfo != null) {
                StringBuffer temp = new StringBuffer();
                if (versionInfo.length == 3) {
                    temp.append("Version#:&nbsp;");
                    temp.append(versionInfo[2] + "<br/>");
                    temp.append(versionInfo[1] + "<br/>");
                } else if (versionInfo.length == 2) {
                    temp.append(versionInfo[1] + "<br/>");
                }
                version = temp.toString();
            }
        }
        return version;
    }
    
    // Get the version
    //
    // If only_one_method is true we will loop over the methods
    // and return as soon as we have version information from one of the methods
    public String[] GetVersion(String class_name, String class_members, String member_types, boolean only_one_method, StringBuffer error) {
        Class[] params = null;
        Object[] values = null;
        
        if ((class_members != null) &&
                class_members.equals("main")) {
            // This is for a method taking array of Strings
            String[] param1 = {"args1", "args2", "arg3"};
            Class[] temp_params = {param1.getClass()};
            Object[] temp_values = {param1};
            
            params = temp_params;
            values = temp_values;
        }
        
        Object[] versionInfo = ExecuteMethods(class_name, class_members, member_types, kDelim, params, values, error);
        
        if (versionInfo == null) {
            return null;
        }
        
        boolean version_found = false;
        ArrayList versionList = new ArrayList();
        for (int i=0; i<versionInfo.length; i++) {
            if (versionInfo[i] == null) {
                continue;
            }
            version_found = true;
            versionList.add((String)versionInfo[i]);
            
            // We break as soon as the one of the methods passed in
            // succeeded in retrieving the version
            // ** This function can be overloaded to
            if (only_one_method) {
                break;
            }
        }
        
        if (! version_found) {
            return null;
        }
        
        String[] versionStrs = new String[versionList.size()];
        for (int i=0; i<versionList.size(); i++) {
            versionStrs[i] = (String) versionList.get(i);
        }
        // return ((String[]) versionList.toArray());
        return versionStrs;
    }
    
    /**********************************************************************************
     * This executes all the methods on the given class and returns the values returned
     * by each method in an array. Null values are returned for the methods that are not
     * members of this class or that return void
     *
     * All methods passed in should have the same signature only the names can be
     * different (This should be fixed if needed, works for now)
     *
     * HINT: If all methods are of the same type, specifying the method type once
     * for the member_types will do the job.
     ***********************************************************************************/
    public Object[] ExecuteMethods(String class_name,
            // a delimiter seperated list of method defined in this class
            String class_members,
            String member_types,
            String delim,
            Class[] params,
            Object[] values,
            StringBuffer error) {
        String version = null;
        
        // Make sure that none of the params are null
        if ((class_name == null) || (class_name.length() == 0) ||
                (class_members == null) || (class_members.length() == 0) ||
                (member_types == null) || (member_types.length() == 0)) {
            return null;
        }
        
        // Prepare the member and member_type list
        StringTokenizer m_token = new StringTokenizer(class_members, delim);
        StringTokenizer mtype_token = new StringTokenizer(member_types, delim);
        
        boolean same_m_type = false;
        String m_type_token = null;
        if (m_token.countTokens() != mtype_token.countTokens()) {
            // Assumption: All the methods passed in are of same type
            if (mtype_token.countTokens() != 1) {
                error.append("ERROR: Methods and MethodTypes count mismatched.");
                return null;
            } else {
                same_m_type = true;
                m_type_token = mtype_token.nextToken();
            }
        }
        
        // If there are multiple methods of same type then we don't
        // loop over the m_type tokens
        boolean has_ret_values = false;
        Object[] ret_values = new Object[m_token.countTokens()];
        for (int i=0; m_token.hasMoreTokens(); ) {
            String m = m_token.nextToken();
            String mtype = null;
            if (same_m_type) {
                mtype = m_type_token;
            } else {
                mtype = mtype_token.nextToken();
            }
            
            Object ret = ExecuteMethod(class_name, m, mtype,
                    params, values, true, error);
            if (ret != null) {
                has_ret_values = true;
                ret_values[i++] = ret;
            }
        }
        
        if (! has_ret_values) {
            return null;
        }
        
        return ret_values;
        
    }
    
    // Execute the method.
    private Object ExecuteMethod(String class_name,
            String class_member,
            String member_type,
            Class[] params,
            Object[] values,
            boolean captureStdout,
            StringBuffer error) {
        
        // Make sure that none of the required params are null
        if ((class_name == null) || (class_name.length() == 0) ||
                (class_member == null) || (class_member.length() == 0) ||
                (member_type == null) || (member_type.length() == 0)) {
            return null;
        }
        
        Object version = null;
        
        try {
            Class c = Class.forName(class_name);
            Object o = null;
            if (member_type.equals(kIMethod) || member_type.equals(kIVariable)) {
                o = c.newInstance();
            }
            
            Method m = null;
            Field f = null;
            Object return_val = null;
            Class return_type = null;
            
            if (member_type.equals(kIMethod) || member_type.equals(kCMethod)) {
                m = c.getMethod(class_member, params);
                
                if (captureStdout) {
                    RedirectStdout();
                }
                
                return_val = m.invoke(o, values);
                
                if (captureStdout) {
                    version = ReadStdout();
                }
                
                return_type = m.getReturnType();
            } else if (member_type.equals(kIVariable) || member_type.equals(kCVariable)) {
                f = c.getField(class_member);
                
                return_val = f.get(o);
                return_type = f.getType();
            } else {
                return null;
            }
        } catch (ClassNotFoundException e) {
            if (printExpTrace) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            if (printExpTrace) {
                e.printStackTrace();
            }
        }
        
        return version;
    }
    
    // Redirect the stdout
    private void RedirectStdout() throws Exception {
        PipedOutputStream pos = new PipedOutputStream();
        stdoutReader = new PipedInputStream(pos);
        PrintStream ps = new PrintStream(pos);
        System.setOut(ps);
    }
    
    //  This will read the contents from the stdout
    //  and closes the stream that is connected to 'System.out'
    private String ReadStdout() throws Exception {
        StringBuffer contents = new StringBuffer();
        
        byte[] buff = new byte[BUFF_SIZE];
        while (stdoutReader.available() > 0) {
            int b_read = stdoutReader.read(buff, 0, BUFF_SIZE);
            contents.append(new String(buff).substring(0,b_read));
        }
        
        System.setOut(kDefaultOutStream);
        stdoutReader.close();
        
        return contents.toString();
    }
    
    
    // Parse the version string for build and version# info.
    private String[] ParseForVersion(String versionStr) {
        if ((versionStr == null) || (versionStr.length() == 0)) {
            return null;
        }
        
        // All the names should end with a space
        String[] productList = {
            "ContentServer ", "Content Server ", "JumpStart ", "Core Library ",
            "ICS ", "Framework ", "Batch ",
            "Directory ", "Content Server LDAP ",
            "LDAP Authentication ", "NT Authentication ",
            "Content Server FTCSNTSecurity ", "Logging ",
            "Content Server Portlet ",
            "IPS Content Centre ", "Xcelerate ",
            "IPS AssetMaker ", "AssetMaker ", "Asset Maker ", "Basic ",
            "AssetFramework ", "Asset Framework ", "SampleAssets ", "Sample Assets ",
            "Catalog Centre ", "Gator ", "GatorBulk ", "Gator Bulk ",
            "FirstSite Filters ", "FirstSite URI Assembler ", "Flame ", "Spark ",
            "Rules ", "Catalog ", "Visitor ",
            "CSCommerce ", "CS Commerce ", "CommerceData ", "Commerce Data ",
            "DatabaseLoader", "Database Loader", "Queue",
            "Document Transform ","Keyview Transformer ",
            "XML Exchange Server ", "ICUtilities.jar ", "ICUtilities ",
            "Satellite Server ", "Content Server Satellite Lite ",
            "Satellite Server Sseed ", "CS-Satellite Tag Library ",
            "Search Engine ", "ContentServer Lucene Integration", 
            "Asset API definition", "Alloy UI"
        };
        
        String[] version = {"Product Name Not Found", "Build Info. NOT Found", "Version Info. NOT Found"};
        
        // Get the build information
        int buildPos = versionStr.indexOf("Build ");
        if (buildPos < 0) {
            return version;
        }
        
        // Get the bld- information
        int bldPos = versionStr.indexOf("bld-");
        if (bldPos < 0) {
            return version;
        }
        
        int datePos = versionStr.indexOf("Date: ");
        if (datePos < 0) {
            return version;
        }
        
        String buildStr = versionStr.substring(buildPos, buildPos + (datePos-buildPos) +29).trim();
        version[1] = buildStr;
        
        String bldStr = versionStr.substring(bldPos).trim();
        version[1] = "Build#: "+bldStr +"<br/>"+ buildStr;
        
        String productName = "";
        String versionNum = "";
        boolean matchFound = false;
        
        // Get the version now
        // Route: 1 (Added this for version v5.0)
        //
        // Last space position from 'Build' position
        int spacePos1 = versionStr.lastIndexOf(' ', buildPos-1);
        // Last space position from previous space
        int periodPos = versionStr.lastIndexOf('.', spacePos1-1); //this is a period not space
        int spacePos2 = versionStr.lastIndexOf(' ', periodPos-1);
        
        int newlinePos = versionStr.lastIndexOf('\n', buildPos-1);
        if (spacePos2 < newlinePos) {
            // route 1
        } else {
            String version1 = versionStr.substring(spacePos2, spacePos1).trim();
            String productname1 = versionStr.substring(newlinePos+1, spacePos2).trim();
            
            for (int i=0; i<productList.length; i++) {
                if (productList[i].trim().equals(productname1) ) {
                    matchFound = true;
                    productName = productname1;
                    versionNum = version1;
                    break;
                }
            }
        }
        
        if (! matchFound) {
            // Route: 2
            //
            // Find the first non-null line
            String line = null;
            try {
                // Read the first line to get the product info.
                BufferedReader br = new BufferedReader(new StringReader(versionStr));
                int x = 1;
                while ((line=br.readLine()) != null) {
                    line = line.trim();
                    if (line.length() > 0) {
                        break;
                    }
                }
                br.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            
            int matchIndex = -1;
            for (int i=0; i<productList.length && (line != null); i++) {
                int productNamePos = line.indexOf(productList[i]);
                if (productNamePos < 0) {
                    continue;
                }
                
                int pd_len = productName.length();
                int cur_pd_len = productList[i].length();
                
                if (pd_len < cur_pd_len) {
                    productName = productList[i];
                    matchIndex = productNamePos;
                    matchFound = true;
                } else {
                    continue;
                }
            }
            
            if (matchFound) {
                int spacePos = line.indexOf(' ', matchIndex+productName.length()+1);
                if (spacePos < 0) {
                    spacePos = line.length();
                }
                versionNum = line.substring(matchIndex+productName.length(), spacePos);
            }
        }
        
        if (matchFound) {
            version[0] = productName;
            version[2] = versionNum;
        } else {
            // Print not found
        }
        
        return version;
    }
    
    // Executes a method
    // This method gets invoked from ExecuteMethods .....//
    private Object ExecuteMethod(String class_name,
            String class_member,
            String member_type,
            Class[] params,
            Object[] values,
            StringBuffer error) {
        
        // Make sure that none of the required params are null
        if ((class_name == null) || (class_name.length() == 0) ||
                (class_member == null) || (class_member.length() == 0) ||
                (member_type == null) || (member_type.length() == 0)) {
            return null;
        }
        
        Object version = null;
        
        try {
            Class c = Class.forName(class_name);
            Object o = null;
            if (member_type.equals(kIMethod) || member_type.equals(kIVariable)) {
                o = c.newInstance();
            }
            
            Method m = null;
            Field f = null;
            Object return_val = null;
            Class return_type = null;
            
            if (member_type.equals(kIMethod) || member_type.equals(kCMethod)) {
                m = c.getMethod(class_member, params);
                return_val = m.invoke(o, values);
                return_type = m.getReturnType();
            } else if (member_type.equals(kIVariable) || member_type.equals(kCVariable)) {
                f = c.getField(class_member);
                return_val = f.get(o);
                return_type = f.getType();
    /* } else if (member_type.equals (kCMethod)) {
    } else if (member_type.equals (kCVariable)) {
     */ } else {
                return null;
     }
            
            version = ConvertToString(return_val, return_type);
        } catch (ClassNotFoundException e) {
            if (printExpTrace) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            if (printExpTrace) {
                e.printStackTrace();
            }
        }
        
        return version;
    }
    
    private String ConvertToString(Object return_val, Class return_type) {
        if ((return_val == null) || (return_type == null)) {
            return null;
        }
        
        String versionStr = null;
        
        if (return_type == Void.TYPE) {
            
        } else if (return_type == new String().getClass()) {
            versionStr = (String) return_val;
        } else {
            versionStr = (String) return_val;
        }
        
        return versionStr;
    }
    
    // Display System arch, cpu and processor info
    private static String getSysInfo() {
        StringBuffer sb = new StringBuffer();
        if(System.getProperty("os.arch").equals("sparc")){
            try {
                Runtime rt = Runtime.getRuntime();
                Process proc = rt.exec("uname -X");
                try {
                    proc.waitFor();
                } catch(InterruptedException ie) {
                    System.out.println("Exception is " + ie);
                }
                InputStream stdin = proc.getInputStream();
                InputStreamReader isr = new InputStreamReader(stdin);
                BufferedReader br = new BufferedReader(isr);
                String line1 = null;
                sb.append("<pre>");
                while ((line1 = br.readLine()) != null)
                    sb.append(line1+"\n");
                sb.append("</pre>");
            } catch (Throwable t1) {
                t1.printStackTrace();
            }
        } else if(System.getProperty("os.arch").equals("i386")){
            try {
                Runtime rt = Runtime.getRuntime();
                Process proc = rt.exec("cat /proc/cpuinfo");
                try {
                    proc.waitFor();
                } catch(InterruptedException ie) {
                    System.out.println("Exception is " + ie);
                }
                InputStream stdin = proc.getInputStream();
                InputStreamReader isr = new InputStreamReader(stdin);
                BufferedReader br = new BufferedReader(isr);
                String line1 = null;
                sb.append("<pre>");
                while ((line1 = br.readLine()) != null)
                    sb.append(line1+"\n");
                sb.append("</pre>");
            } catch (Throwable t1) {
                t1.printStackTrace();
            }
        } else if(System.getProperty("os.arch").equals("ppc") || System.getProperty("os.arch").equals("Power")){
            try {
                Runtime rt = Runtime.getRuntime();
                Process proc = rt.exec("lscfg | grep proc");
                try {
                    proc.waitFor();
                } catch(InterruptedException ie) {
                    System.out.println("Exception is " + ie);
                }
                InputStream stdin = proc.getInputStream();
                InputStreamReader isr = new InputStreamReader(stdin);
                BufferedReader br = new BufferedReader(isr);
                String line1 = null;
                sb.append("<pre>");
                while ((line1 = br.readLine()) != null)
                    sb.append(line1+"\n");
                sb.append("</pre>");
            } catch (Throwable t1) {
                t1.printStackTrace();
            }
        }
        /****************************************************
         * Uncomment this section to get cpu information on windows
         ****************************************************
        else if (System.getProperty("os.arch").equals("x86")) {
            try {
                Runtime rt = Runtime.getRuntime();
                String command = "msinfo32 /report "+System.getProperty("java.io.tmpdir")+"\\"+"sysinfo.txt";
                System.out.println(command);
                Process proc = rt.exec(command);
                try {
                    proc.waitFor();
                } catch(InterruptedException ie) {
                    System.out.println("Exception is " + ie);
                }
                File sysfile = new File(System.getProperty("java.io.tmpdir")+"\\"+"sysinfo.txt");
                InputStream fread = new FileInputStream(sysfile);
                BufferedReader in = new BufferedReader(new InputStreamReader(fread, "UTF-16"));
                String line2 = null;
                sb.append("<pre>");
                while ((line2 = in.readLine()) != null) {
                    if (line2.equals("[Hardware Resources]"))
                        return sb.toString();
                    else
                        sb.append(line2+"\n");
                }
                sb.append("<pre>");
                in.close();
            } catch (Throwable t2) {
                t2.printStackTrace();
            }
        }
        ****************************************************/
        else {
             sb.append("<pre>"+System.getProperty("os.name")+"\n"+System.getProperty("os.arch")+"\n"+System.getProperty("os.version")+"</pre>");
        }
        return sb.toString();
    }
    %>
    
    <%
    // Fill in the JVM runtime information .....
    long free_mem = 0L;
    long total_mem = 0L;
    int got_req_values = -2;
    int used_mem_index = -1;
    
    for (int i=0, j=0; i<kJVM_rows; i++) {
        if (JVMInfo[i][j].equals(kJVMVersion)) {
            JVMInfo[i][j+1] = java.lang.System.getProperty("java.version");
        } else if (JVMInfo[i][j].equals(kJVMTotalMemory)) {
            total_mem = Runtime.getRuntime().totalMemory();
            JVMInfo[i][j+1] = String.valueOf(total_mem);
            got_req_values++;
        } else if (JVMInfo[i][j].equals(kJVMFreeMemory)) {
            free_mem = Runtime.getRuntime().freeMemory();
            JVMInfo[i][j+1] = String.valueOf(free_mem);
            got_req_values++;
        } else if (JVMInfo[i][j].equals(kJVMUsedMemory)) {
            used_mem_index = i;
        } else {
            continue;
        }
    }
    
    if ((got_req_values == 0) && (used_mem_index > 0)) {
        JVMInfo[used_mem_index][1] = String.valueOf(total_mem - free_mem);
    }
    
    // This will find all the products that are loaded/installed into the memory.
    for (int i=0; i<kProduct_rows; i++) {
        boolean err = false;
        int j = 0;
        int cols = ProductInfo[i].length;
        
        String product_name = ProductInfo[i][j];
        if ((product_name.length() == 0) || (product_name ==null)) {
            ProductInfo[i][j] = kSpace;
        }
        
        String product_jar = null;
        if (++j < cols) {
            product_jar = ProductInfo[i][j];
        } else {
            err = true;
        }
        
        String product_class = null;
        if (++j < cols) {
            product_class   = ProductInfo[i][j];
        } else {
            err = true;
        }
        
        String product_methods = null;
        if (++j < cols) {
            product_methods = ProductInfo[i][j];
        } else {
            err = true;
        }
        
        String method_types = null;
        if (++j < cols) {
            method_types    = ProductInfo[i][j];
        } else {
            err = true;
        }
        
        String product_version = null;
        if (++j < cols) {
            product_version = ProductInfo[i][j];
        } else {
            err = true;
        }
        
        if (!err) {
            // update the version info for this product
            StringBuffer errors = new StringBuffer();
            String version = GetVersion(product_class, product_methods, method_types, errors);
            if (version == null) {
                ProductInfo[i][j] = kProductNotFound;
            } else {
                ProductInfo[i][j] = version;
            }
        }
    }
    %>
    
    <!--
--
--
-- RENDER THE PAGE NOW .............
--
--
-->
    
    <h3>System Information</h3>
    <table class="altClass" style="width:50%">
        <tr> 
        <td><%= getSysInfo() %>
        <tr>
    </table><br/>
    
    <h3>JVM Process Information</h3>
    <table class="altClass" style="width:50%">
        <tr> 
            <th>Resource Name</th>
            <th>Resource Value</th> 
        </tr>
        <%
        for (int i=0; i<kJVM_rows; i++) {
            int j = 0;
            int cols = JVMInfo[i].length;
            
            if (JVMInfo[i][cols-1].equals(kProductNotFound)) {
                continue;
            }
            
            out.println("<tr>");
            out.println("\t<td>" + JVMInfo[i][j] + "</td>");
            out.println("\t<td>" + JVMInfo[i][++j] + "</td>");
            out.println("</tr>");
        }
        %>
    </table>
    <br/>
    
    <%--  Print the product info. table --%>
    <h3><center>Product Information</center></h3>
    
    Total Rows: <%= kProduct_rows %>
    <table class="altClass">
        <%
        out.println("<tr>");
        out.println("\t<th> Product Name </th>");
        out.println("\t<th> Jar File </th>");
        //out.println ("\t<th> Build Class </th>");
        out.println("\t<th> Version </th>");
        out.println("</tr>");
        
        for (int i=0; i<kProduct_rows; i++) {
            int j = 0;
            int cols = ProductInfo[i].length;
            
            out.println("<tr>");
            out.println("\t<td><b><font color=\"#191970\">" + ProductInfo[i][j] + "</font></b></td>");
            out.println ("\t<td>" + ProductInfo[i][j+1] + "</td>");
        //out.println ("\t<td>" + ProductInfo[i][j + 2] + "</td>");
        out.println ("\t<td>" + ProductInfo[i][cols-1] + "</td>");
        out.println ("</tr>");
        }
        %>
    </table>
    
</cs:ftcs>
