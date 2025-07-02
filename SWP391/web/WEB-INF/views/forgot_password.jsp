<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Forgot Password</title>
        <style>
            body {
                background: whitesmoke;
                color: #222;
                font-family: 'Inter', sans-serif;
            }
            .container {
                background: #fff;
                padding: 32px;
                border-radius: 10px;
                width: 350px;
                margin: 100px auto;
                box-shadow: 0 0 10px #0002;
            }
            label, input, select {
                display: block;
                width: 100%;
                margin-bottom: 16px;
            }
            input[type="email"], select {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            .actions {
                display: flex;
                gap: 16px;
            }
            button, a {
                background: #222;
                color: #fff;
                border: none;
                padding: 10px 18px;
                border-radius: 7px;
                text-decoration: none;
                cursor: pointer;
            }
            a {
                background: none;
                color: #222;
                text-decoration: underline;
                padding: 0;
            }
            .error {
                color: red;
                margin-bottom: 10px;
            }
            .info {
                color: #666;
                font-size: 14px;
                margin-bottom: 16px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Forgot Password</h2>
            <% String error = (String) request.getAttribute("error"); if (error != null) { %>
            <div class="error"><%= error %></div>
            <% } %>
            <form action="/forgot-password-process" method="POST">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required />
                
                <label for="expiryTime">Reset Link Expiry Time</label>
                <select id="expiryTime" name="expiryTime" required>
                    <option value="1">1 hour</option>
                    <option value="3" selected>3 hours</option>
                    <option value="6">6 hours</option>
                    <option value="12">12 hours</option>
                    <option value="24">24 hours</option>
                </select>
                <div class="info">Choose how long the reset link should remain valid. The link will expire after the selected time.</div>
                
                <div class="actions">
                    <button type="submit">Reset Password</button>
                    <a href="/login">Return to login</a>
                </div>
            </form>
        </div>
    </body>
</html> 