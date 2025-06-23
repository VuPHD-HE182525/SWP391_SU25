<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register for Subject</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        .register-container {
            background: #fff;
            max-width: 420px;
            margin: 48px auto;
            padding: 32px 28px;
            border-radius: 12px;
            box-shadow: 0 4px 24px #ddd;
        }
        h2 { text-align: center; margin-bottom: 24px; }
        label { display: block; margin-top: 16px; font-weight: bold; }
        input, select {
            width: 100%;
            padding: 8px 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1em;
        }
        .btn-register {
            margin-top: 24px;
            width: 100%;
            background: #e74c3c;
            color: #fff;
            border: none;
            padding: 10px 0;
            border-radius: 4px;
            font-weight: bold;
            font-size: 1.1em;
            cursor: pointer;
        }
        .btn-register:hover { background: #c0392b; }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Register for Subject</h2>
        <form method="post" action="RegisterSubjectServlet">
            <input type="hidden" name="subjectId" value="${param.id}" />
            <label>Choose Package</label>
            <select name="packageId" required>
                <c:forEach var="pkg" items="${packages}">
                    <option value="${pkg.id}">${pkg.name} - $${pkg.salePrice} (${pkg.duration} months)</option>
                </c:forEach>
            </select>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <!-- User is logged in, show info as read-only or hidden -->
                    <input type="hidden" name="fullName" value="${sessionScope.user.fullName}" />
                    <input type="hidden" name="email" value="${sessionScope.user.email}" />
                    <input type="hidden" name="mobile" value="${sessionScope.user.mobile}" />
                    <input type="hidden" name="gender" value="${sessionScope.user.gender}" />
                    <div style="margin-top:18px; color:#444;">
                        <b>Name:</b> ${sessionScope.user.fullName}<br/>
                        <b>Email:</b> ${sessionScope.user.email}<br/>
                        <b>Mobile:</b> ${sessionScope.user.mobile}<br/>
                        <b>Gender:</b> ${sessionScope.user.gender}
                    </div>
                </c:when>
                <c:otherwise>
                    <label>Full Name</label>
                    <input type="text" name="fullName" required />
                    <label>Email</label>
                    <input type="email" name="email" required />
                    <label>Mobile</label>
                    <input type="text" name="mobile" required />
                    <label>Gender</label>
                    <select name="gender" required>
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </c:otherwise>
            </c:choose>
            <button type="submit" class="btn-register">Register</button>
        </form>
    </div>
</body>
</html> 