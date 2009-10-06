<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs>Hello World<render:logdep cid='<%= ics.GetVar("id") %>' c="Bogus"/></cs:ftcs>