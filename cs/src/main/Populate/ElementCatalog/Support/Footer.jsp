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
var tables = document.getElementsByTagName("table");
for(var t=0;t<tables.length;t++) {
	if(tables[t].className == clsName) {

		var tableBodies = tables[t].getElementsByTagName("tbody");
		// Loop through these tbodies
		for (var i = 0; i < tableBodies.length; i++) {
			// Take the tbody, and get all it's rows
			var tableRows = tableBodies[i].getElementsByTagName("tr");
			// Loop through these rows
			// Start at 1 because we want to leave the heading row untouched
			for (var j = 1; j < tableRows.length; j++) {
				// Check if j is even, and apply classes for both possible results
				if ( (j % 2) == 0  ) {
					tableRows[j].className += " even";
				} else {
					tableRows[j].className += " odd";
				}
			}
		}
	}
}
</script>
<div class="spacer">&nbsp;</div>
<div class="footer gray">
     <table width="100%" style="border:none"><tr>
            <td width="25%" style="text-transform:none;border-bottom:none"><p>Copyright &copy;2008 FatWire Corporation.  All Rights Reserved.</p></td>
	        <td width="25%" style="text-align:right;border-bottom:none"><p>Version 3.3</p></td>
     </tr></table>     
</div>
</cs:ftcs>
