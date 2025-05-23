<%-- 
    Document   : home
    Created on : May 23, 2025, 8:45:56 AM
    Author     : Kaonashi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/includes/header.jsp" />
        <h2>${message}</h2>
        <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    </body>
</html>
