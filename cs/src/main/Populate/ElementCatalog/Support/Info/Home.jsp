<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Info/Home
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs>
    <div class="entry-header">
        <h2><a href="ContentServer?pagename=Support/Info/collectInfo">Collect Info</a></h2>
    </div>
    <div class="entry">                                        
        <p>Collects information about the runtime environment like versions, ini files etc.</p>
    </div>
    <div class="entry-header">
        <h2><a href="ContentServer?pagename=Support/Info/sqlplus">Database Query Tool</a></h2>
    </div>
    <div class="entry">                                        
        <p>Connects directly to the database to run sql statements
        </p>
    </div>
    <div class="entry-header">
        <h2><a href="ContentServer?pagename=Support/Info/ThreadDump">Thread Dump</a></h2>
    </div>
    <div class="entry">                                        
        <p>Prints out a thread dump (without object lock information.</p>
    </div>
    <div class="entry-header">
        <h2><a href="ContentServer?pagename=Support/Info/SendEmail">Send Email</a></h2>
    </div>
    <div class="entry">                                        
        <p>Test program to send a email.</p>
    </div>

</cs:ftcs>
