<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Video Debug Test</title>
</head>
<body>
    <h1>Video Debug Test</h1>
    
    <h2>Test 1: Using /uploads/ path</h2>
    <video controls width="400">
        <source src="${pageContext.request.contextPath}/uploads/videos/lesson1.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <p>URL: ${pageContext.request.contextPath}/uploads/videos/lesson1.mp4</p>
    
    <h2>Test 2: Using VideoServlet /video/ path</h2>
    <video controls width="400">
        <source src="${pageContext.request.contextPath}/video/lesson1.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <p>URL: ${pageContext.request.contextPath}/video/lesson1.mp4</p>
    
    <h2>Test 3: Direct relative path</h2>
    <video controls width="400">
        <source src="uploads/videos/lesson1.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <p>URL: uploads/videos/lesson1.mp4</p>
    
    <h2>Test 4: Context path info</h2>
    <p>Context Path: ${pageContext.request.contextPath}</p>
    <p>Request URL: ${pageContext.request.requestURL}</p>
    <p>Server Name: ${pageContext.request.serverName}</p>
    <p>Server Port: ${pageContext.request.serverPort}</p>
    
    <h2>Test 5: Direct links</h2>
    <p><a href="${pageContext.request.contextPath}/uploads/videos/lesson1.mp4" target="_blank">Open via /uploads/ path</a></p>
    <p><a href="${pageContext.request.contextPath}/video/lesson1.mp4" target="_blank">Open via VideoServlet</a></p>
    <p><a href="uploads/videos/lesson1.mp4" target="_blank">Open via relative path</a></p>
</body>
</html> 