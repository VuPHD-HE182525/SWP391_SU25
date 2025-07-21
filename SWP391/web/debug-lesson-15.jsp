<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Lesson 15</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug { background: #f0f0f0; padding: 10px; margin: 10px 0; border: 1px solid #ccc; }
        .error { background: #ffeeee; color: red; }
        .success { background: #eeffee; color: green; }
    </style>
</head>
<body>
    <h1>Debug Lesson 15 - Active Listening</h1>
    
    <div class="debug">
        <h3>Request Parameters:</h3>
        <p>Lesson ID: <%= request.getParameter("lessonId") %></p>
        <p>Current URL: <%= request.getRequestURL() %>?<%= request.getQueryString() %></p>
    </div>
    
    <div class="debug">
        <h3>Session Info:</h3>
        <p>User: <%= session.getAttribute("user") != null ? "Logged in" : "Not logged in" %></p>
        <p>Session ID: <%= session.getId() %></p>
    </div>
    
    <div class="debug">
        <h3>Lesson Object:</h3>
        <c:choose>
            <c:when test="${currentLesson != null}">
                <div class="success">
                    <p>Lesson found!</p>
                    <p>ID: ${currentLesson.id}</p>
                    <p>Name: ${currentLesson.name}</p>
                    <p>Type: ${currentLesson.type}</p>
                    <p>Content Type: ${currentLesson.contentType}</p>
                    <p>Content File Path: ${currentLesson.contentFilePath}</p>
                    <p>Estimated Time: ${currentLesson.estimatedTime}</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="error">
                    <p>No lesson object found in request attributes!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <div class="debug">
        <h3>Test Fallback Content:</h3>
        <c:if test="${currentLesson.id == 15 or param.lessonId == '15'}">
            <div class="success">
                <h4>Active Listening Fundamentals</h4>
                <p>This is the fallback content for lesson 15.</p>
                <ul>
                    <li>Give Full Attention</li>
                    <li>Show That You are Listening</li>
                    <li>Provide Feedback</li>
                    <li>Defer Judgment</li>
                    <li>Respond Appropriately</li>
                </ul>
            </div>
        </c:if>
    </div>
    
    <div class="debug">
        <h3>Actions:</h3>
        <p><a href="lesson-view?lessonId=15">Go to Lesson View (ID 15)</a></p>
        <p><a href="lesson-view?lessonId=1">Go to Lesson View (ID 1)</a></p>
        <p><a href="course-list">Back to Course List</a></p>
    </div>
    
    <div class="debug">
        <h3>All Request Attributes:</h3>
        <%
            java.util.Enumeration<String> attrs = request.getAttributeNames();
            while(attrs.hasMoreElements()) {
                String attrName = attrs.nextElement();
                Object attrValue = request.getAttribute(attrName);
                out.println("<p>" + attrName + ": " + attrValue + "</p>");
            }
        %>
    </div>
</body>
</html>
