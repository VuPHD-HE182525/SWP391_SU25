<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Lesson, model.User, model.Course, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lesson Debug</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug { background: #f0f0f0; border: 1px solid #ccc; padding: 10px; margin: 10px 0; }
        .error { background: #ffe6e6; border: 1px solid red; padding: 10px; margin: 10px 0; }
        video { width: 100%; max-width: 600px; }
    </style>
</head>
<body>
    <h1>Lesson View - Ultra Simple Debug</h1>
    
    <%
        // Get attributes from request
        Lesson currentLesson = (Lesson) request.getAttribute("currentLesson");
        User currentUser = (User) request.getAttribute("currentUser");
        Course course = (Course) request.getAttribute("course");
        List comments = (List) request.getAttribute("comments");
    %>
    
    <div class="debug">
        <h3>Debug Information:</h3>
        <p><strong>Current Lesson:</strong> 
            <% if (currentLesson != null) { %>
                ID = <%= currentLesson.getId() %>, Name = <%= currentLesson.getName() %>
            <% } else { %>
                NULL
            <% } %>
        </p>
        
        <p><strong>Current User:</strong> 
            <% if (currentUser != null) { %>
                ID = <%= currentUser.getId() %>, Name = <%= currentUser.getFullName() %>
            <% } else { %>
                NULL
            <% } %>
        </p>
        
        <p><strong>Course:</strong> 
            <% if (course != null) { %>
                ID = <%= course.getId() %>, Title = <%= course.getTitle() %>
            <% } else { %>
                NULL
            <% } %>
        </p>
        
        <p><strong>Comments:</strong> 
            <% if (comments != null) { %>
                Count = <%= comments.size() %>
            <% } else { %>
                NULL
            <% } %>
        </p>
    </div>
    
    <% if (currentLesson != null) { %>
        <h2>Lesson: <%= currentLesson.getName() %></h2>
        
        <div style="margin: 20px 0;">
            <h3>Video Player</h3>
            
                         <% 
                 String videoLink = currentLesson.getVideoLink();
             %>
             
             <p><strong>Video Link:</strong> <%= videoLink %></p>
             
             <% if (videoLink != null && !videoLink.isEmpty()) { %>
                <video controls>
                    <source src="<%= videoLink %>" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
            <% } else { %>
                <div class="error">
                    <p>No video available for this lesson.</p>
                </div>
            <% } %>
        </div>
        
        <!-- Simple comment form -->
        <% if (currentUser != null) { %>
            <h3>Add Comment</h3>
            <form action="lesson-view" method="post">
                <input type="hidden" name="action" value="addComment">
                <input type="hidden" name="lessonId" value="<%= currentLesson.getId() %>">
                <textarea name="commentText" rows="3" style="width: 100%; max-width: 500px;" placeholder="Your comment..."></textarea><br>
                <button type="submit" style="margin-top: 10px;">Submit Comment</button>
            </form>
        <% } %>
        
    <% } else { %>
        <div class="error">
            <h3>Error: No lesson found!</h3>
            <p>currentLesson is null - check servlet and database</p>
        </div>
    <% } %>
    
    <div style="margin-top: 30px;">
        <a href="course-list">← Back to Course List</a>
    </div>
    
</body>
</html> 