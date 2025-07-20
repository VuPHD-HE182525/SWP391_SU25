package controller;

import DAO.LessonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Lesson;
import utils.DBContext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/fix-database")
public class FixDatabaseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h1>Database Fix Tool</h1>");
        
        try {
            // Check if lesson 5 exists
            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson5 = lessonDAO.getLessonById(5);
            
            if (lesson5 == null) {
                response.getWriter().println("<p style='color:red;'>❌ Lesson 5 NOT FOUND</p>");
                response.getWriter().println("<a href='fix-database?action=create5'>🔧 Click to CREATE Lesson 5</a><br>");
            } else {
                response.getWriter().println("<p style='color:green;'>✅ Lesson 5 EXISTS</p>");
                response.getWriter().println("<p>Title: " + lesson5.getName() + "</p>");
                response.getWriter().println("<p>Video: " + lesson5.getVideoLink() + "</p>");
                
                if (lesson5.getVideoLink() == null || !lesson5.getVideoLink().contains("AI")) {
                    response.getWriter().println("<a href='fix-database?action=fix5'>🔧 Click to FIX Video Link</a><br>");
                }
            }
            
            // Check lesson 10
            Lesson lesson10 = lessonDAO.getLessonById(10);
            if (lesson10 == null) {
                response.getWriter().println("<p style='color:red;'>❌ Lesson 10 NOT FOUND</p>");
                response.getWriter().println("<a href='fix-database?action=create10'>🔧 Click to CREATE Lesson 10</a><br>");
            } else {
                response.getWriter().println("<p style='color:green;'>✅ Lesson 10 EXISTS</p>");
                response.getWriter().println("<p>Title: " + lesson10.getName() + "</p>");
                response.getWriter().println("<p>Video: " + lesson10.getVideoLink() + "</p>");
            }
            
            response.getWriter().println("<hr>");
            response.getWriter().println("<h3>Test Links:</h3>");
            response.getWriter().println("<a href='lesson-view?lessonId=5' target='_blank'>📺 Test Lesson 5</a><br>");
            response.getWriter().println("<a href='lesson-view?lessonId=10' target='_blank'>📺 Test Lesson 10</a><br>");
            response.getWriter().println("<a href='debug-lesson.jsp?lessonId=5' target='_blank'>🔍 Debug Lesson 5</a><br>");
            
        } catch (Exception e) {
            response.getWriter().println("<p style='color:red;'>ERROR: " + e.getMessage() + "</p>");
        }
        
        response.getWriter().println("</body></html>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        response.setContentType("text/html;charset=UTF-8");
        
        try (Connection conn = DBContext.getConnection()) {
            
            if ("create5".equals(action)) {
                String sql = "INSERT INTO lessons (id, course_id, title, video_url, lesson_order, status, type) VALUES (5, 2, 'Lesson 1: What is AI?', '/video/AI 1.mp4', 1, 1, 'video')";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.executeUpdate();
                    response.getWriter().println("<h1>✅ Lesson 5 Created Successfully!</h1>");
                }
            } else if ("fix5".equals(action)) {
                String sql = "UPDATE lessons SET video_url = '/video/AI 1.mp4', title = 'Lesson 1: What is AI?' WHERE id = 5";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.executeUpdate();
                    response.getWriter().println("<h1>✅ Lesson 5 Fixed Successfully!</h1>");
                }
            } else if ("create10".equals(action)) {
                String sql = "INSERT INTO lessons (id, course_id, title, video_url, lesson_order, status, type) VALUES (10, 1, 'Lesson 2: Variables and Data Types', '/video/java 2.mp4', 2, 1, 'video')";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.executeUpdate();
                    response.getWriter().println("<h1>✅ Lesson 10 Created Successfully!</h1>");
                }
            }
            
            response.getWriter().println("<a href='fix-database'>🔄 Check Again</a>");
            
        } catch (Exception e) {
            response.getWriter().println("<h1>❌ Error: " + e.getMessage() + "</h1>");
        }
    }
} 