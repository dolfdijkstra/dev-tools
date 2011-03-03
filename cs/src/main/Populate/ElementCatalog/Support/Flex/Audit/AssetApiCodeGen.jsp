<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Flex/Audit/AssetApiCodeGen
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="com.fatwire.assetapi.common.AssetAccessException"%>
<%@ page import="com.fatwire.assetapi.def.*"%>
<%@ page import="com.fatwire.system.Session"%>
<%@ page import="com.fatwire.system.SessionFactory"%>
<cs:ftcs>
<%
        Session s = SessionFactory.getSession(ics);
        AssetTypeDefManager mgr = (AssetTypeDefManager) s.getManager(com.fatwire.assetapi.def.AssetTypeDefManager.class
                .getName());
        PrintWriter o = new PrintWriter(out);
        String ats = ics.GetVar("assettype");


        if(ats !=null){
             for (String at : ats.split(";")){
                  String[] p = at.split(":");
                  String a = p[0];
                  String st = p.length==2?p[1]:null;
                  try {
                      %><pre><%
                      AssetTypeDef def = mgr.findByName(a, st);
                      if(def != null) {
                          String what = ics.GetVar("what");
                          if("assetapicode".equals(what)){
                              printAssetTypeDefCode(o, def);
                          } else if("def".equals(what)){
                              printAssetTypeDef(o, def);
                          } else {
                              %>Not implemented yet<%
                          }
                      }
                    } catch (Exception e){
                        o.println(e.getMessage() + " on "+ a +"/"+st);
                        e.printStackTrace(o);
                    }

                    %></pre><%
              }

        }

%><form method="POST" action="ContentServer">
<input type="radio" name="what" value="def" <%= "def".equals(ics.GetVar("what"))? "checked='checked'":"" %>/> Print Definition
<input type="radio" name="what" value="assetapicode" <%= "assetapicode".equals(ics.GetVar("what"))? "checked='checked'":"" %>/> AssetApi Code Generation
<input type="radio" name="what" value="gsfjspcode" <%= "gsfjspcode".equals(ics.GetVar("what"))? "checked='checked'":"" %>/> GSF JSP Code Generation
<input type="radio" name="what" value="gsfjavacode" <%= "gsfjavacode".equals(ics.GetVar("what"))? "checked='checked'":"" %>/> GSF Java Code Generation<br />
<input type="submit" value="submit"/>
<br/>
<% for (String assetType : mgr.getAssetTypes())
        {
            for (String subtype : mgr.getSubTypes(assetType))
            {
                %><input type="checkbox" name="assettype" value="<%=assetType%>:<%=subtype%>" /><%=assetType%> / <%=subtype%><br/><%
            }
            try {
              AssetTypeDef def = mgr.findByName(assetType, null);
              if(!def.getProperties().getIsFlexAsset()){
                  %><input type="checkbox" name="assettype" value="<%=assetType%>" /><%=assetType%><br/><%
              }
            } catch (Exception e){
                o.println(e.getMessage());
                e.printStackTrace(o);
            }
        }
         %></select>
    <input type="hidden" name="pagename"  value='<%= ics.GetVar("pagename")  %>'/>
    <input type="submit" value="submit"/>
</form><%

%>
<%!
    private void printAssetTypeDefCode(PrintWriter out, AssetTypeDef def)
    {
        if (def == null)
            return;
        if (def.getSubtype() == null && def.getProperties().getIsFlexAsset())
        {
            return;
        }
        String s = def.getSubtype() == null ? "" : def.getSubtype() + "/";

        out.print(def.getName() + "/" + s + "Detail");
        out.print("   // description: " + def.getDescription() + "'");
        out.print(" plural: '" + def.getPlural() + "'");
        out.print(" canbechild: " + def.getCanBeChild() + "");
        AssetTypeDefProperties p = def.getProperties();
        out.print(" canAddSubtypes: " + p.getCanAddSubtypes());
        String type = p.getIsAssetmakerAsset() ? "AssetmakerAsset" : "Unknown Type";
        if (p.getIsCoreAsset())
            type = "CoreAsset";
        if (p.getIsFlexAsset())
            type = "FlexAsset";
        out.print(" type: '" + type + "'");
        out.println(" nameMustUnique: " + p.getIsNameMustUnique());

        printAttributesCode(out,def);
        //printParentDefs(out, def);
        //printAssocations(out, def);
        out.println();
        out.println();
    }
    private void printAssetTypeDef(PrintWriter out, AssetTypeDef def)
    {
        if (def == null)
            return;
        if (def.getSubtype() == null && def.getProperties().getIsFlexAsset())
        {
            return;
        }
        String s = def.getSubtype() == null ? "" : def.getSubtype() + "/";

        out.print(def.getName() + "/" + s);
        out.print("   // description: " + def.getDescription() + "'");
        out.print(" plural: '" + def.getPlural() + "'");
        out.print(" canbechild: " + def.getCanBeChild() + "");
        AssetTypeDefProperties p = def.getProperties();
        out.print(" canAddSubtypes: " + p.getCanAddSubtypes());
        String type = p.getIsAssetmakerAsset() ? "AssetmakerAsset" : "Unknown Type";
        if (p.getIsCoreAsset())
            type = "CoreAsset";
        if (p.getIsFlexAsset())
            type = "FlexAsset";
        out.print(" type: '" + type + "'");
        out.println(" nameMustUnique: " + p.getIsNameMustUnique());

        printAttributes(out, def);
        printParentDefs(out, def);
        printAssocations(out, def);
        out.println();
        out.println();
    }

    private void printParentDefs(PrintWriter out, AssetTypeDef cdef)
    {
        List<AttributeDef> parents = cdef.getParentDefs();
        if (parents != null)
        {
            out.println("parents: ");
            for (AttributeDef a : parents)
            {
                out.println("name: " + a.getName());
                out.println("description: " + a.getDescription());
                out.println("type: " + a.getType());
                out.println("mandatory: " + a.isDataMandatory());
                out.println("meta: " + a.isMetaDataAttribute());

                AttributeDefProperties p = a.getProperties();
                out.println("multiple: " + p.getMultiple());
                out.println("ordinal: " + p.getOrdinal());
                out.println("required: " + p.getRequired());
                out.println("size: " + p.getSize());
                out.println("allow embedded: " + p.isAllowEmbeddedLinks());
                out.println("derived: " + p.isDerivedFlexAttribute());
                out.println("inherited: " + p.isInheritedFlexAttribute());

            }
        }

    }

    private void printAssocations(PrintWriter out, AssetTypeDef def)
    {
        List<AssetAssociationDef> assocs = def.getAssociations();
        if (assocs != null && !assocs.isEmpty())
        {
            out.println("associations: ");
            for (AssetAssociationDef assoc : assocs)
            {
                out.println("assoc name: " + assoc.getName());
                out.println("description: " + assoc.getDescription());
                out.println("multiple: " + assoc.isMultiple());
                out.println("legalChildAssetTypes: " + assoc.getLegalChildAssetTypes());
                out.println("childAssetType: " + assoc.getChildAssetType());
                out.println("subTypes: " + assoc.getSubTypes());
                out.println();
            }
        }

    }

    private void printAttributes(PrintWriter out, AssetTypeDef def)
    {

        List<AttributeDef> attributes = def.getAttributeDefs();
        if (attributes != null)
        {
            out.println("attributes: ");

            for (AttributeDef a : attributes)
            {

                out.print("name: " + a.getName());
                out.print(" description: " + a.getDescription());
                out.print(" type: " + a.getType());
                out.print(" mandatory: " + a.isDataMandatory());
                out.print(" meta: " + a.isMetaDataAttribute());

                AttributeDefProperties p = a.getProperties();
                out.print(" size: " + p.getSize());
                out.print(" allow embedded: " + p.isAllowEmbeddedLinks());
                out.print(" derived: " + p.isDerivedFlexAttribute());
                out.print(" inherited: " + p.isInheritedFlexAttribute());

                out.print(" multiple: " + p.getMultiple());
                out.print(" ordinal: " + p.getOrdinal());
                out.println(" required: " + p.getRequired());
            }
        }
    }
    static Set<String> KEYWORDS = new HashSet<String>(Arrays
            .asList(("abstract,assert,boolean,break,byte,case,catch,char,class,const,continue"
                    + ",default,do,double,else,enum,extends,final,finally,float"
                    + ",for,goto,if,implements,import,instanceof,int,interface,long,native,new,"
                    + "ackage,private,protected,public,return,short,static,strictfp,super,switch,"
                    + "synchronized,this,throw,throws,transient,try,void,volatile,while").split(",")));

    private String toVarName(String name)
    {
        if (KEYWORDS.contains(name))
            return name + "_";
        return name.replace("-", "_");
    }


    private void printAttributesCode(PrintWriter o, AssetTypeDef def)
    {
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);



        out.println("//sample copy/past code");
        out.println("public void do"+ def.getName()+(def.getSubtype()!=null?"_" + def.getSubtype():"")+"(ICS ics) throws AssetNotExistException, AssetAccessException {");
        out.println();
        out.println("    Session ses = SessionFactory.getSession(ics);");
        out.println("    AssetDataManager mgr = (AssetDataManager) ses.getManager(AssetDataManager.class.getName());");
        out.println("    AssetId id = new AssetIdImpl(ics.GetVar(\"c\"), Long.parseLong(ics.GetVar(\"cid\")));");
        out.println("    Iterable<AssetData> assets = mgr.read(Collections.singletonList(id));");

        out.println("    for (AssetData asset : assets) {");
        out.println("");

        List<AttributeDef> attributes = def.getAttributeDefs();
        if (attributes != null)
        {
            out.println("        // attributes: ");
            out.println("        AttributeData attribute = null;");

            for (AttributeDef a : attributes)
            {
                AttributeTypeEnum t = a.getType();
                String cast = toCastType(t);
                String name = toVarName(a.getName());
                out.println("       attribute = asset.getAttributeData(\"" + a.getName() + "\", "
                        + a.isMetaDataAttribute() + ");");
                out.println("       if (attribute != null){");
                out.println("            // type = " + t+ ", valueCount = " + a.getProperties().getValueCount() );
                boolean singleValued = AttributeDefProperties.ValueCount.SINGLE.equals( a.getProperties().getValueCount() );
                if (singleValued){
                   out.println("           " + cast + " " + name + " = (" + cast + ")attribute.getData();");
                } else {
                    out.println("           List<?> "  + name + " = attribute.getDataAsList();");
                }
                if (a.getProperties().getMultiple() != null)
                {
                    out.println("           multiple " + a.getProperties().getMultiple());

                }
                //List<?> valueList = attribute.getDataAsList();
                //for (Object o : valueList)
                //{

                //}
                switch (t)
                {
                case BLOB:
                case URL:
                    out.println("           BlobAddress address = " + name + ".getBlobAddress();");
                    out.println("           String blobcol = address.getColumnName();");
                    out.println("           Object blobid = address.getIdentifier();");
                    out.println("           String idcol = address.getIdentifierColumnName();");
                    out.println("           String blobtable = address.getTableName();");
                    out.println("           //InputStream stream = " + name + ".getBinaryStream();");
                    break;

                }

                out.println("        }");
            }
            out.println("    }");
            out.println("}");
            o.print(org.apache.commons.lang.StringEscapeUtils.escapeHtml(sw.toString()));
        }
    }
    String toCastType(AttributeTypeEnum t)
    {

        switch (t)
        {
        case INT:
            return "Integer";
        case FLOAT:
            return "Double";
        case STRING:
            return "String";
        case LONG:
            return "Long";
        case DATE:
            return "Date";
        case MONEY:
            return "Double";
        case LARGE_TEXT:
            return "String";
        case ASSET:
            return "AssetId";
        case ASSETREFERENCE:
            return "AssetId";
        case BLOB:
            return "BlobObject";
        case URL:
            return "BlobObject";
        case ARRAY:
            return "List<?>";
        case STRUCT:
            return "Map<?,?>";
        case LIST:
            return "List<?>";
        case ONEOF:
            return "Object";
        }
        throw new IllegalArgumentException("Don't know about " + t);
    }

%>

</cs:ftcs>