<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs>Hello World <ics:getvar name="id"/><% COM.FutureTense.Cache.CacheManager.RecordItem(ics, "bogus-"+ ics.GetVar("id"));%></cs:ftcs>