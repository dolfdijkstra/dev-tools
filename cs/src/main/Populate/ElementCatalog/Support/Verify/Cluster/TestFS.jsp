<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
//
// Support/Verify/Cluster/TestFS
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="java.util.*"
%><%!

String hostname="unknown";
public void jspInit(){
    try {
       hostname = java.net.InetAddress.getLocalHost().getHostName();
    } catch (java.net.UnknownHostException e){}
}

%><cs:ftcs><satellite:link pagename="Support/prototype" satellite="true" /><%
%><script type="text/javascript" src='<%=ics.GetVar("referURL")%>'></script>
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<h3>File System Test</h3>
<p>This tool tests the performance of the shared file systems and compares the results against FatWire lab tests. The results of the tests will give an indication of the relative performance of the shared file system. This is most useful when tuning various NFS settings.</p>
<div id="message" style="display: none"><img src="js/dojox/image/resources/images/loading.gif"/><b id="messageText">Running File System Tests. Please wait...</b></div>
<div id="controlPanel"><input id="controlButton" type="button" value="Start FileSystemTest" onClick="submitTest();"/></div>
<div id="visualization"></div>
<script type="text/javascript">if (typeof google == 'undefined'){  $('visualization').remove();}</script>

<table id="resultsTable" style="visibility: hidden"><tr><th>Environment</th><th colspan="4">Current</th><th colspan="4">FatWire Lab</th></tr><tr><th>Test</th><th>min</th><th>max</th><th>average</th><th>total</th><th>min</th><th>max</th><th>average</th><th>total</th></tr></table>
<div id="labelInstruction" style='display: none'>
The letters in the labels on the graph or table mean the following: <ul><li>t: number of concurrent threads</li><li>f: number of files created,read and deleted</li><li>s: the size of each file in bytes</li><li>r: the number of times a file is read.</li><li>-typer: the type of the folder.</li></ul>
t10-f100-s1024-r100-data, means that 10 threads each create 100 files of 1024 bytes, read those files 100 times and then delete the files from the 'data' folder.
The Average time reported is the average time that a thread takes to complete the operation of 100 files creating, reading 100 times, and then deleting.
The different folder types are:
<ul>
<li>local: the servlet context temp folder.</li>
<li>sync: usedisksync folder from futuretense.ini.</li>
<li>data: the MungoBlobs or ccurl folder.</li>
<li>spc: the SystemPageCache folder.</li>
</ul>
</div>
<script type="text/javascript">
var sampleResult = [
{"thread":10,"files":10,"size":100,"reads":1,"min":15,"max":95,"avg":27,"total":278},
{"thread":10,"files":10,"size":100,"reads":10,"min":17,"max":29,"avg":19,"total":190},
{"thread":10,"files":10,"size":1024,"reads":1,"min":11,"max":12,"avg":11,"total":114},
{"thread":10,"files":10,"size":1024,"reads":10,"min":18,"max":30,"avg":19,"total":197},
{"thread":10,"files":10,"size":102400,"reads":1,"min":69,"max":74,"avg":71,"total":710},
{"thread":10,"files":10,"size":102400,"reads":10,"min":82,"max":89,"avg":84,"total":844},

{"thread":25,"files":10,"size":100,"reads":1,"min":15,"max":26,"avg":17,"total":430},
{"thread":25,"files":10,"size":1024,"reads":10,"min":18,"max":29,"avg":19,"total":475},
{"thread":25,"files":10,"size":102400,"reads":1,"min":68,"max":75,"avg":70,"total":1767},


{"thread":50,"files":10,"size":100,"reads":1,"min":11,"max":28,"avg":15,"total":772},
{"thread":100,"files":10,"size":100,"reads":1,"min":10,"max":51,"avg":12,"total":1223},


{"thread":25,"files":10,"size":100,"reads":10,"min":17,"max":20,"avg":18,"total":454},
{"thread":50,"files":10,"size":100,"reads":10,"min":17,"max":28,"avg":18,"total":907},

{"thread":100,"files":10,"size":100,"reads":10,"min":17,"max":22,"avg":18,"total":1813},
{"thread":25,"files":10,"size":1024,"reads":1,"min":10,"max":24,"avg":12,"total":302},
{"thread":50,"files":10,"size":1024,"reads":1,"min":10,"max":23,"avg":11,"total":579},
{"thread":100,"files":10,"size":1024,"reads":1,"min":10,"max":21,"avg":11,"total":1164},
{"thread":50,"files":10,"size":1024,"reads":10,"min":18,"max":29,"avg":19,"total":958},
{"thread":100,"files":10,"size":1024,"reads":10,"min":18,"max":35,"avg":19,"total":1914}
];
/*
{"thread":10,"files":100,"size":1024,"reads":10,"min":176,"max":200,"avg":184,"total":1847},
{"thread":10,"files":100,"size":100,"reads":1,"min":103,"max":144,"avg":111,"total":1114},
{"thread":25,"files":100,"size":1024,"reads":10,"min":175,"max":204,"avg":182,"total":4563},

{"thread":50,"files":10,"size":102400,"reads":1,"min":70,"max":78,"avg":72,"total":3625},
{"thread":100,"files":10,"size":102400,"reads":1,"min":69,"max":84,"avg":72,"total":7226},

{"thread":25,"files":100,"size":100,"reads":1,"min":100,"max":158,"avg":109,"total":2732},
{"thread":50,"files":100,"size":100,"reads":1,"min":92,"max":134,"avg":105,"total":5251},
{"thread":100,"files":100,"size":100,"reads":1,"min":95,"max":138,"avg":102,"total":10256},
{"thread":10,"files":100,"size":100,"reads":10,"min":172,"max":186,"avg":177,"total":1774},
{"thread":25,"files":100,"size":100,"reads":10,"min":171,"max":197,"avg":180,"total":4518},
{"thread":50,"files":100,"size":100,"reads":10,"min":170,"max":208,"avg":179,"total":8992},
{"thread":100,"files":100,"size":100,"reads":10,"min":171,"max":203,"avg":179,"total":17965},
{"thread":10,"files":100,"size":1024,"reads":1,"min":104,"max":127,"avg":111,"total":1112},
{"thread":25,"files":100,"size":1024,"reads":1,"min":104,"max":125,"avg":111,"total":2792},
{"thread":50,"files":100,"size":1024,"reads":1,"min":102,"max":152,"avg":110,"total":5510},
{"thread":100,"files":100,"size":1024,"reads":1,"min":100,"max":138,"avg":108,"total":10870},
{"thread":50,"files":100,"size":1024,"reads":10,"min":170,"max":211,"avg":183,"total":9186},
{"thread":100,"files":100,"size":1024,"reads":10,"min":167,"max":213,"avg":186,"total":18637},

{"thread":10,"files":100,"size":102400,"reads":1,"min":707,"max":814,"avg":722,"total":7227},
{"thread":25,"files":100,"size":102400,"reads":1,"min":706,"max":899,"avg":745,"total":18641},
{"thread":50,"files":100,"size":102400,"reads":1,"min":702,"max":951,"avg":764,"total":38248},
{"thread":100,"files":100,"size":102400,"reads":1,"min":705,"max":895,"avg":769,"total":76973},
{"thread":25,"files":10,"size":102400,"reads":10,"min":80,"max":86,"avg":83,"total":2084},
{"thread":50,"files":10,"size":102400,"reads":10,"min":82,"max":104,"avg":86,"total":4300},
{"thread":100,"files":10,"size":102400,"reads":10,"min":81,"max":109,"avg":86,"total":8649},
{"thread":10,"files":100,"size":102400,"reads":10,"min":823,"max":876,"avg":847,"total":8475},
{"thread":25,"files":100,"size":102400,"reads":10,"min":778,"max":994,"avg":856,"total":21403},
{"thread":50,"files":100,"size":102400,"reads":10,"min":771,"max":1029,"avg":857,"total":42862},
{"thread":100,"files":100,"size":102400,"reads":10,"min":770,"max":1010,"avg":840,"total":84033},

{"thread":10,"files":10,"size":1048476,"reads":1,"min":630,"max":770,"avg":672,"total":6729},
{"thread":25,"files":10,"size":1048476,"reads":1,"min":624,"max":749,"avg":675,"total":16885},
{"thread":50,"files":10,"size":1048476,"reads":1,"min":624,"max":774,"avg":652,"total":32613},
{"thread":100,"files":10,"size":1048476,"reads":1,"min":622,"max":742,"avg":663,"total":66368},
{"thread":10,"files":100,"size":1048476,"reads":1,"min":6291,"max":8051,"avg":7073,"total":70739},
{"thread":25,"files":100,"size":1048476,"reads":1,"min":7100,"max":7992,"avg":7289,"total":182228},
{"thread":50,"files":100,"size":1048476,"reads":1,"min":7084,"max":8499,"avg":7336,"total":366834},
{"thread":100,"files":100,"size":1048476,"reads":1,"min":7026,"max":8670,"avg":7334,"total":733445},
{"thread":10,"files":10,"size":1048476,"reads":10,"min":719,"max":788,"avg":733,"total":7331},
{"thread":25,"files":10,"size":1048476,"reads":10,"min":716,"max":782,"avg":740,"total":18511},
{"thread":50,"files":10,"size":1048476,"reads":10,"min":711,"max":893,"avg":759,"total":37994},
{"thread":100,"files":10,"size":1048476,"reads":10,"min":704,"max":911,"avg":751,"total":75186},
{"thread":10,"files":100,"size":1048476,"reads":10,"min":7213,"max":8085,"avg":7352,"total":73523},
{"thread":25,"files":100,"size":1048476,"reads":10,"min":7226,"max":8625,"avg":7432,"total":185810},
{"thread":50,"files":100,"size":1048476,"reads":10,"min":7145,"max":8900,"avg":7468,"total":373407},
{"thread":100,"files":100,"size":1048476,"reads":10,"min":7131,"max":8710,"avg":7431,"total":743182}
];
*/
var state=0;
var data;
var test = {
    version:'1.0',
    timestamp: new Date(),
    hostname:'<%=hostname %>',
    session: window.session,
    cs_environment: window.csEnv,
    results: []
};

var chart;
var folderTypes = ['local','data','spc','sync'];
if (typeof google != 'undefined'){
    google.load('visualization', '1', {packages: ['columnchart']});
    google.setOnLoadCallback(drawChart);
} else {
    state=1;
}

function drawChart() {
    state=1;
    // Create the visualization.
    chart = new google.visualization.ColumnChart($('visualization'));
    data = new google.visualization.DataTable();
    data.addColumn('string', 'Test','test');
    data.addColumn('number', 'Average','avg');
    data.addColumn('number', 'Lab Average','avg-lab');
}


function stopTest(){
    if(state !=2) return;
    state=3;
    $('message').style.visibility='hidden';
    $('controlButton').style.display='none';


}
function submitTest(){
    if (state !=1) return;
    test.timestamp = new Date();
    state=2;
    if (typeof google != 'undefined'){
        $('visualization').style.width='90%'
        $('visualization').style.height='300px';
    }

    $('message').style.visibility='visible';
    $('message').style.display='block';
    $('labelInstruction').style.display='block';

    var button = $('controlButton');
    button.value="Stop File System Test";
    button.onclick=stopTest;

    runTest(0,0);
    return true;
    function runTest(i,j){
        if (state!=2) return;
        var mytest = sampleResult[i];
        var label= 't' + mytest.thread +'-f'+mytest.files + '-s' + mytest.size + '-r'+mytest.reads +'-'+folderTypes[j];

        $('messageText').firstChild.textContent='Running File System Test ('+ (i + (j * sampleResult.length) )  + ' of ' + (sampleResult.length * folderTypes.length) +'): ' +label +'. Please wait...';

        $('message').style.visibility='visible';
        $('resultsTable').style.visibility='visible';
        new Ajax.Request('ContentServer', {
          method: 'get',
          parameters: {pagename:'Support/Verify/Cluster/FileSystemTest',numThreads: mytest.thread, numFiles: mytest.files,fileSize: mytest.size,numReads:mytest.reads,type:folderTypes[j]},
          onSuccess: function(response){
               var result = response.responseText.evalJSON();
               test.results[test.results.length]=result;


               var row= [{v: label},
               {v: result.averageTime}, {v: mytest.avg}];
               if (typeof data != 'undefined'){
                    data.addRow(row);
                    // Draw the visualization.
                    chart.draw(data, null);
               }
               addTableRow(i,label,mytest,result);
               i++;
               if (i >= sampleResult.length) {i=0;++j;}
               if (j < folderTypes.length) {runTest(i,j);} else { finishTest();}

          },
          onFailure: function(){ alert('Something went wrong...') }

        });
    }

    function finishTest(){
        state=3;
        $('message').style.display='none';
        //$('controlButton').style.display='none';
        $('controlButton').value="Upload test results to the SupportTools web site for data collection and comparision.";
        $('controlButton').onclick = upload;
        function upload(){
            //$('controlButton').disabled=true;//onclick=null;
            var form = document.createElement('form');
            form.action=location.protocol +'//fwsupporttools.appspot.com/upload/fstest';
            form.enctype='application/x-www-form-urlencoded';
            form.method='post';
            var inputelement = document.createElement('input');
            inputelement.type='hidden';
            inputelement.name='payload';
            inputelement.value=Object.toJSON(test);
            form.appendChild(inputelement);
            $('controlButton').parentNode.appendChild(form);
            form.submit();
            //alert (Object.toJSON(test)); all we need is to send this to supporttools website
        }

    }
    function addTableRow(rownum,label,mytest,result){
        var tr = $('resultsTable').insertRow($('resultsTable').firstChild.rows.length);
        tr.insertCell(0).appendChild( document.createTextNode(label) );
        tr.insertCell(1).appendChild( document.createTextNode('' + result.minTime));
        tr.insertCell(2).appendChild( document.createTextNode('' + result.maxTime));
        tr.insertCell(3).appendChild( document.createTextNode('' + result.averageTime));
        tr.insertCell(4).appendChild( document.createTextNode('' + result.totalTime));
        tr.insertCell(5).appendChild( document.createTextNode('' + mytest.min));
        tr.insertCell(6).appendChild( document.createTextNode('' + mytest.max));
        tr.insertCell(7).appendChild( document.createTextNode('' + mytest.avg));
        tr.insertCell(8).appendChild( document.createTextNode('' + mytest.total));

    }

}

</script>
</cs:ftcs>