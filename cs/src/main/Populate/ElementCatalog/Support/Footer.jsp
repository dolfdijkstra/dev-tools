<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Footer
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
<cs:ftcs>
<script language="JavaScript">
    var clsName = 'altClass';
    var rowcolor1 = '#FFFFFF';
    var rowcolor2 = '#EDEDED';
    var rows, arow;
    var tables = document.getElementsByTagName("table");
    var rowCount = 0;
    for(var i=0;i<tables.length;i++) {
        if(tables.item(i).className == clsName) {
            atable = tables.item(i);
            rows = atable.getElementsByTagName("tr");
            for(var j=0;j<rows.length;j++) {
                arow = rows.item(j);
                if(arow.nodeName == "TR") {
                    if(rowCount % 2) {
                        arow.style.backgroundColor = rowcolor1;
                    } else {
                        arow.style.backgroundColor = rowcolor2;
                    }
                    rowCount++;
                }
            }
            rowCount = 0;
        }
    }
</script>
<div class="spacer">&nbsp;</div>
<div class="footer gray">
     <table width="100%" style="border:none"><tr>
            <td width="25%" style="text-transform:none;border-bottom:none"><p>Copyright &copy;2006 FatWire Corporation.  All Rights Reserved.</p></td>
	        <td width="25%" style="text-align:right;border-bottom:none"><p>Version 3.1</p></td>
     </tr></table>     
</div>
</cs:ftcs>
