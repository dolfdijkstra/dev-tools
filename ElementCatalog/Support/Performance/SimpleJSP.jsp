<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Performance/simple
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<satellite:tag>
    <satellite:parameter name="type" value ="open"/>
</satellite:tag>

<html>
<head>
<title>Simple performance test</title>
</head>
</body>
This is a simple jsp page
</body>
</html>
<satellite:tag>
    <satellite:parameter name="type" value ="closed"/>
</satellite:tag>

</cs:ftcs>