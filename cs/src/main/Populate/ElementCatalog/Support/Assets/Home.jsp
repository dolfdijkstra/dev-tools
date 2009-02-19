<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/Assets/Home
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
    <div class="entry-header">
         <h2><a href='ContentServer?pagename=Support/Assets/BulkSaveAssets'><b>BulkSaveAssets</b></a></h2>
    </div>
    <div class="entry">
         <p>Allows to bulk load, save or void assets based on a entered query.</p>
    </div>
    <div class="entry-header">
         <h2><a href='ContentServer?pagename=Support/Assets/checkAssets'><b>checkAssets</b></a></h2>
    </div>
    <div class="entry">
         <p>Checks for assets integrity.</p>
         <ul>
         <li>Checks to see if table exists in the DB</li>
         <li>Compares column length with values in ADF (or futuretense.ini if it is a flex asset)</li>
         <li>Does an &lt;asset:load&gt; and &lt;asset:scatter&gt;</li>
         <li>Checks for a corresponding SitePlanTree row for Page assets</li>
         <li>Checks for corresponding ElementCatalog row for CSElement, Template, and SiteEntry</li>
         <li>Checks for corresponding SiteCatalog row for SiteEntry and Templates</li>
         <li>Checks for corresponding MungoBlob row (or _Mungo)</li>
         <li>Checks for missing files</li>
         </ul>

    </div>




</cs:ftcs>
