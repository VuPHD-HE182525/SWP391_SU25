<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="DAO.LessonDAO, model.Lesson" %>

<!DOCTYPE html>
<html>
<head>
    <title>Lesson Debug</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug { background: #f0f0f0; border: 1px solid #ccc; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .error { background: #ffe6e6; border: 1px solid red; padding: 10px; margin: 10px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>🔍 Lesson Debug</h1>
    
    <%
        String lessonIdParam = request.getParameter("lessonId");
        if (lessonIdParam == null) lessonIdParam = "5"; // Default to lesson 5
        
        try {
            int lessonId = Integer.parseInt(lessonIdParam);
            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.getLessonById(lessonId);
            
            if (lesson != null) {
    %>
    
    <div class="debug">
        <h3>✅ Lesson <%= lessonId %> Data:</h3>
        <p><strong>ID:</strong> <%= lesson.getId() %></p>
        <p><strong>Name:</strong> <%= lesson.getName() %></p>
        <p><strong>Type:</strong> <%= lesson.getType() %></p>
        <p><strong>Status:</strong> <%= lesson.isStatus() %></p>
        <p><strong>Subject ID:</strong> <%= lesson.getSubjectId() %></p>
        <p><strong>Video Link:</strong> <%= lesson.getVideoLink() %></p>
        <p><strong>Video Link Empty?</strong> <%= lesson.getVideoLink() == null || lesson.getVideoLink().trim().isEmpty() %></p>
    </div>
    
    <% if (lesson.getVideoLink() != null && !lesson.getVideoLink().trim().isEmpty()) { %>
        <div class="debug">
            <h3>🎥 Video Test:</h3>
            <p><strong>Video Path:</strong> <%= lesson.getVideoLink() %></p>
            <video controls style="width: 400px;">
                <source src="<%= lesson.getVideoLink() %>" type="video/mp4">
                Your browser does not support the video tag.
            </video>
            <p><strong>Full URL:</strong> <code>http://localhost:9999<%= lesson.getVideoLink() %></code></p>
        </div>
    <% } else { %>
        <div class="error">
            <h3>❌ No Video Link</h3>
            <p>Lesson <%= lessonId %> doesn't have a video link set.</p>
        </div>
    <% } %>
    
    <%
            } else {
    %>
    
    <div class="error">
        <h3>❌ Lesson Not Found</h3>
        <p>Lesson ID <%= lessonId %> not found in database.</p>
    </div>
    
    <%
            }
        } catch (Exception e) {
    %>
    
    <div class="error">
        <h3>❌ Error Loading Lesson</h3>
        <p><strong>Error:</strong> <%= e.getMessage() %></p>
    </div>
    
    <%
        }
    %>
    
    <!-- Test other lessons -->
    <div class="debug">
        <h3>🔗 Test Other Lessons:</h3>
        <a href="?lessonId=5">Lesson 5 (AI)</a> | 
        <a href="?lessonId=10">Lesson 10 (Java)</a> | 
        <a href="?lessonId=1">Lesson 1</a> | 
        <a href="?lessonId=2">Lesson 2</a>
    </div>
    
    <!-- Navigation -->
    <div style="margin-top: 30px;">
        <a href="lesson-view?lessonId=<%= lessonIdParam %>">← Back to Lesson View</a> | 
        <a href="admin-video-transcripts.jsp">Admin Dashboard</a>
    </div>

</body>
</html> 