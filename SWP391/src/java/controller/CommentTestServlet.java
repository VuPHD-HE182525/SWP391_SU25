package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/comment-test")
public class CommentTestServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String lessonId = request.getParameter("lessonId");
        String commentText = request.getParameter("commentText");
        
        System.out.println("=== CommentTestServlet POST ===");
        System.out.println("Action: " + action);
        System.out.println("LessonId: " + lessonId);
        System.out.println("CommentText: " + commentText);
        
        if ("addComment".equals(action) && lessonId != null) {
            System.out.println("Redirecting to lesson-view?lessonId=" + lessonId + "&comment=added");
            response.sendRedirect("lesson-view?lessonId=" + lessonId + "&comment=added");
        } else {
            System.out.println("Redirecting to course-list");
            response.sendRedirect("course-list");
        }
    }
}
