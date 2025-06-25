<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Subject, java.util.List, model.Lesson, model.Comment" %>
<%
    Subject subject = (Subject) request.getAttribute("subject");
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<Comment> comments = (List<Comment>) request.getAttribute("comments");
    Lesson currentLesson = (Lesson) request.getAttribute("currentLesson");
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= subject.getName() %> - Subject View</title>
    <style>
        .container { display: flex; }
        .main { flex: 3; padding: 20px; }
        .sidebar { flex: 1; background: #f5f5f5; padding: 20px; }
        .video-player { width: 100%; max-width: 700px; }
        .lesson-list { list-style: none; padding: 0; }
        .lesson-list li { margin-bottom: 10px; }
        .info { margin: 10px 0; }
        .comments { margin-top: 30px; }
        .thumbnail { width: 200px; height: auto; margin-bottom: 10px; }
    </style>
</head>
<body>
<div class="container">
    <div class="main">
        <h2><%= subject.getName() %></h2>
        <img class="thumbnail" src="<%= subject.getThumbnailUrl() %>" alt="Thumbnail">
        <video class="video-player" controls src="<%= (currentLesson != null ? currentLesson.getVideoUrl() : subject.getVideoUrl()) %>"></video>
        <div class="info">
            <p><b>Rating:</b> <%= subject.getRating() %> ⭐</p>
            <p><b>Students:</b> <%= subject.getStudents() %></p>
            <p><b>Duration:</b> <%= subject.getDuration() %> hours</p>
            <p><b>Last updated:</b> <%= subject.getLastUpdated() %></p>
            <p><b>Language:</b> <%= subject.getLanguage() %></p>
        </div>
        <div class="comments">
            <h3>Comments</h3>
            <form method="post" action="addComment">
                <textarea name="content" rows="3" cols="60" placeholder="Your comment here"></textarea><br>
                <button type="submit">Submit</button>
            </form>
            <ul>
                <% if (comments != null) for (Comment c : comments) { %>
                    <li><b>User <%= c.getUserId() %>:</b> <%= c.getContent() %> <i>(<%= c.getCreatedAt() %>)</i></li>
                <% } %>
            </ul>
        </div>
    </div>
    <div class="sidebar">
        <h3>Lessons</h3>
        <ul class="lesson-list">
            <% if (lessons != null) for (Lesson lesson : lessons) { %>
                <li>
                    <a href="subjectView?subjectId=<%= subject.getId() %>&lessonId=<%= lesson.getId() %>">
                        <%= lesson.getTitle() %>
                    </a>
                </li>
            <% } %>
        </ul>
    </div>
</div>
</body>
</html> 