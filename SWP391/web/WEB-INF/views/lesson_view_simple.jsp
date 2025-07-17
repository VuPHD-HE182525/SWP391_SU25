<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lesson View - Simple</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .video-container { margin: 20px 0; }
        video { width: 100%; max-width: 800px; }
        .error { color: red; background: #ffe6e6; padding: 10px; border: 1px solid red; margin: 10px 0; }
        .info { color: blue; background: #e6f3ff; padding: 10px; border: 1px solid blue; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>Lesson View - Debug Mode</h1>
    
    <!-- Debug Information -->
    <div class="info">
        <h3>Debug Info:</h3>
        <p>Current Lesson ID: ${currentLesson != null ? currentLesson.id : 'NULL'}</p>
        <p>Current Lesson Name: ${currentLesson != null ? currentLesson.name : 'NULL'}</p>
        <p>Current User ID: ${currentUser != null ? currentUser.id : 'NULL'}</p>
        <p>Course: ${course != null ? course.title : 'NULL'}</p>
    </div>
    
    <!-- Video Player -->
    <c:if test="${currentLesson != null}">
        <div class="video-container">
            <h2>${currentLesson.name}</h2>
            
            <c:choose>
                <c:when test="${not empty currentLesson.videoUrl}">
                    <video controls>
                        <source src="${currentLesson.videoUrl}" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                    <p>Video URL: ${currentLesson.videoUrl}</p>
                </c:when>
                <c:when test="${not empty currentLesson.videoLink}">
                    <video controls>
                        <source src="${currentLesson.videoLink}" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                    <p>Video Link: ${currentLesson.videoLink}</p>
                </c:when>
                <c:otherwise>
                    <div class="error">
                        <p>No video available for this lesson.</p>
                        <p>videoUrl: ${currentLesson.videoUrl}</p>
                        <p>videoLink: ${currentLesson.videoLink}</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
    
    <!-- Error if no lesson -->
    <c:if test="${currentLesson == null}">
        <div class="error">
            <h3>Error: No lesson data found</h3>
            <p>currentLesson is null</p>
        </div>
    </c:if>
    
    <!-- Simple Comments Section -->
    <div style="margin-top: 30px;">
        <h3>Comments</h3>
        
        <c:if test="${currentUser != null}">
            <form action="lesson-view" method="post" style="margin: 20px 0;">
                <input type="hidden" name="action" value="addComment">
                <input type="hidden" name="lessonId" value="${currentLesson != null ? currentLesson.id : ''}">
                <textarea name="commentText" placeholder="Add a comment..." rows="3" style="width: 100%; max-width: 600px;"></textarea><br>
                <button type="submit" style="margin-top: 10px;">Add Comment</button>
            </form>
        </c:if>
        
        <div>
            <c:forEach items="${comments}" var="comment">
                <div style="border: 1px solid #ddd; padding: 15px; margin: 10px 0; background: #f9f9f9;">
                    <strong>${comment.userFullName != null ? comment.userFullName : 'Unknown User'}</strong>
                    <p>${comment.commentText != null ? comment.commentText : 'No comment text'}</p>
                    <small>Posted: ${comment.createdAt != null ? comment.createdAt : 'Unknown time'}</small>
                    
                    <!-- Simple edit/delete for comment owner -->
                    <c:if test="${comment.userId == currentUser.id}">
                        <div style="margin-top: 10px;">
                            <form action="lesson-view" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="deleteComment">
                                <input type="hidden" name="lessonId" value="${currentLesson.id}">
                                <input type="hidden" name="commentId" value="${comment.id}">
                                <button type="submit" onclick="return confirm('Delete this comment?')">Delete</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
            
            <c:if test="${empty comments}">
                <p>No comments yet.</p>
            </c:if>
        </div>
    </div>
    
    <!-- Navigation -->
    <div style="margin-top: 30px;">
        <a href="course-list">← Back to Courses</a>
    </div>

</body>
</html> 