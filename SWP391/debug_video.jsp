<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Video Debug Test</title>
</head>
<body>
    <h1>Video Debug Test</h1>
    
    <h2>Test 1: Direct video path</h2>
    <video controls width="400">
        <source src="${pageContext.request.contextPath}/uploads/videos/lesson1.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <p>URL: ${pageContext.request.contextPath}/uploads/videos/lesson1.mp4</p>
    
    <h2>Test 2: Alternative path</h2>
    <video controls width="400">
        <source src="uploads/videos/lesson1.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <p>URL: uploads/videos/lesson1.mp4</p>
    
    <h2>Test 3: Context path info</h2>
    <p>Context Path: ${pageContext.request.contextPath}</p>
    <p>Request URL: ${pageContext.request.requestURL}</p>
    
    <h2>Test 4: Try accessing video directly</h2>
    <p><a href="${pageContext.request.contextPath}/uploads/videos/lesson1.mp4" target="_blank">Click to open video directly</a></p>
</body>
</html> 