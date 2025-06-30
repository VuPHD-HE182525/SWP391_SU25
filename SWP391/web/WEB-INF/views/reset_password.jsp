<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String token = request.getParameter("token");
    if (token == null) token = (String) request.getAttribute("token");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <style>
        body { background: #222; color: #222; font-family: 'Inter', sans-serif; }
        .container { background: #fff; padding: 32px; border-radius: 10px; width: 350px; margin: 100px auto; box-shadow: 0 0 10px #0002; }
        label, input { display: block; width: 100%; margin-bottom: 16px; }
        input[type="password"] { padding: 8px; border: 1px solid #ccc; border-radius: 5px; }
        .actions { display: flex; gap: 16px; }
        button, a { background: #222; color: #fff; border: none; padding: 10px 18px; border-radius: 7px; text-decoration: none; cursor: pointer; }
        a { background: none; color: #222; text-decoration: underline; padding: 0; }
        .error { color: red; margin-bottom: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Reset Password</h2>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>
    <form action="ResetPasswordServlet" method="post">
        <input type="hidden" name="token" value="<%= token != null ? token : "" %>" />
        <label for="password">New Password</label>
        <input type="password" id="password" name="password" required />
        <label for="confirm">Confirm New Password</label>
        <input type="password" id="confirm" name="confirm" required />
        <div class="actions">
            <button type="submit">Reset Password</button>
            <a href="/login">Return to login</a>
        </div>
    </form>
</div>
</body>
</html> 