<%-- 
    Document   : logout
    Created on : 28/06/2025, 02:57:14 PM
    Author     : Windows
--%>

<%
    session.invalidate();
    response.sendRedirect("index.xhtml");
%>