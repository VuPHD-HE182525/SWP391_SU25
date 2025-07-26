<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Logout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h3>Test Logout Functionality</h3>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <div class="alert alert-success">
                                    <h5>✅ User is logged in!</h5>
                                    <p><strong>Name:</strong> ${sessionScope.user.fullName}</p>
                                    <p><strong>Email:</strong> ${sessionScope.user.email}</p>
                                    <p><strong>Role:</strong> ${sessionScope.user.role}</p>
                                </div>
                                
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">
                                        🚪 Test Logout
                                    </a>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                                        🏠 Go to Home
                                    </a>
                                    <a href="${pageContext.request.contextPath}/lesson-view?lessonId=1" class="btn btn-info">
                                        📚 Go to Lesson (test from different page)
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning">
                                    <h5>⚠️ No user logged in</h5>
                                    <p>Please login first to test logout functionality.</p>
                                </div>
                                
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                        🔑 Go to Login
                                    </a>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                                        🏠 Go to Home
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
