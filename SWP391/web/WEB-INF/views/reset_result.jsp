<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = (String) request.getAttribute("message");
    if (message == null) message = "Unknown result.";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Password Reset Result</title>
    <style>
        body { background: #222; color: #222; font-family: 'Inter', sans-serif; }
        .container { background: #fff; padding: 32px; border-radius: 10px; width: 350px; margin: 100px auto; box-shadow: 0 0 10px #0002; text-align: center; }
        a { background: #222; color: #fff; border: none; padding: 10px 18px; border-radius: 7px; text-decoration: none; cursor: pointer; display: inline-block; margin-top: 20px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Password Reset</h2>
    <p><%= message %></p>
    <a href="/login">Return to login</a>
</div>
</body>
</html> 