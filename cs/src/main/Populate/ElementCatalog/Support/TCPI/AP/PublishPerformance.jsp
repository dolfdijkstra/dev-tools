<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="COM.FutureTense.Util.*"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><cs:ftcs><script type="text/javascript" src="http://www.google.com/jsapi"></script>
<center><h3>Publish Sessions Elapsed Time</h3></center>
<input type='button' value='Refresh' onclick='return fetchData()' />
<div id="table_div"></div>
<script type="text/javascript">
var table ;
var sort;

if (typeof google != 'undefined'){
    google.load("visualization", "1", {packages:["table"]});
    google.setOnLoadCallback(drawTable);
}else {
    document.location="ContentServer?pagename=Support/Home";
}
function drawTable() {
    table = new google.visualization.Table(document.getElementById('table_div'));
    google.visualization.events.addListener(table, 'sort',
      function(event) {
        sort = [{column: event.column, desc: !event.ascending}];
      });

    fetchData();
}
    function fetchData() {
        var query = new google.visualization.Query('ContentServer?pagename=Support/TCPI/AP/PublishPerformanceJson');
        // Send the query with a callback function.
        query.send(handleQueryResponse);
        return true;
        }
        function handleQueryResponse(response) {
        if (response.isError()) {
          alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
          return;
        }

        var data = response.getDataTable();

        if (sort) {
               data.sort(sort);

        }
        var options = {allowHtml: true,showRowNumber: true};
        table.draw(data, options);
 }

</script>
</cs:ftcs>