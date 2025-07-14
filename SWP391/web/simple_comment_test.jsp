<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Comment Test</title>
</head>
<body>
    <h1>Comment Test</h1>
    
    <h2>Comment Form</h2>
    <form action="lesson-view" method="post">
        <input type="hidden" name="action" value="addComment">
        <input type="hidden" name="lessonId" value="1">
        <textarea name="commentText" placeholder="Your comment">Test comment</textarea>
        <button type="submit">Submit</button>
    </form>
    
    <h2>Test URL</h2>
    <p><a href="lesson-view?lessonId=1">Go to Lesson 1</a></p>
</body>
</html> 