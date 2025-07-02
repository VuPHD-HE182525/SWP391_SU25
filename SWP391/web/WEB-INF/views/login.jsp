<%-- 
    Document   : login
    Created on : May 25, 2025, 3:29:43 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
             body {
                background-color: white;
                color: #000;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            .card {
                padding: 2rem;
                border-radius: 10px;
                height: 45vh;
            
            }
            .card a{
                color: black;
            }
            .btn-dark {
                width: 100%;
            }
        </style>
    </head>
    <body>
        <div class="card shadow w-100" style="max-width: 400px;">
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required />
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required />
                </div>
                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= error %>
                </div>
                <% } %>
                <button type="submit" class="btn btn-dark">Log In</button>
            </form>
            <div class="mt-3">
                <a href="/forgot-password">Reset password</a><br>
                Don’t have an account? <a href="${pageContext.request.contextPath}/view/register.jsp">Register</a>
            </div>
        </div>
    </body>
</html>
