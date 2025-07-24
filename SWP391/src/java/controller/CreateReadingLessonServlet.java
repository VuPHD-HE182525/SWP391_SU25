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
import java.sql.ResultSet;

@WebServlet("/create-reading-lesson")
public class CreateReadingLessonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            response.setContentType("text/html;charset=UTF-8");
            
            // Check if reading lesson already exists
            String checkSql = "SELECT COUNT(*) FROM lessons WHERE course_id = 1 AND type = 'reading'";
            
            try (Connection conn = DBContext.getConnection(); 
                 PreparedStatement ps = conn.prepareStatement(checkSql)) {
                
                ResultSet rs = ps.executeQuery();
                rs.next();
                int count = rs.getInt(1);
                
                if (count > 0) {
                    response.getWriter().println("<h2>Reading lesson already exists!</h2>");
                    response.getWriter().println("<p>Found " + count + " reading lesson(s) for course 1.</p>");
                    response.getWriter().println("<a href='lesson-view?lessonId=1'>Go to Lesson View</a>");
                    return;
                }
            }
            
            // Create reading lesson
            String insertSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, parent_lesson_id) VALUES (1, 'Reading: Active Listening Fundamentals', NULL, 3, 1, 'reading', NULL)";
            
            try (Connection conn = DBContext.getConnection(); 
                 PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                
                int rowsInserted = ps.executeUpdate();
                
                if (rowsInserted > 0) {
                    ResultSet generatedKeys = ps.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int readingLessonId = generatedKeys.getInt(1);
                        
                        // Try to update with content fields if they exist
                        try {
                            String updateSql = "UPDATE lessons SET content_type = 'reading', estimated_time = 15 WHERE id = ?";
                            PreparedStatement updatePs = conn.prepareStatement(updateSql);
                            updatePs.setInt(1, readingLessonId);
                            updatePs.executeUpdate();
                        } catch (Exception e) {
                            // Content fields might not exist, that's OK
                        }
                        
                        response.getWriter().println("<h2>Success!</h2>");
                        response.getWriter().println("<p>Reading lesson created with ID: " + readingLessonId + "</p>");
                        response.getWriter().println("<p>Title: Reading: Active Listening Fundamentals</p>");
                        response.getWriter().println("<p>Type: reading</p>");
                        response.getWriter().println("<p>Course ID: 1</p>");
                        response.getWriter().println("<p>Lesson Order: 3</p>");
                        response.getWriter().println("<br><a href='lesson-view?lessonId=" + readingLessonId + "'>View Reading Lesson</a>");
                        response.getWriter().println("<br><a href='lesson-view?lessonId=1'>Test Navigation from Video 1</a>");
                        response.getWriter().println("<br><a href='lesson-view?lessonId=2'>Test Navigation from Video 2</a>");
                    }
                } else {
                    response.getWriter().println("<h2>Error!</h2>");
                    response.getWriter().println("<p>Failed to create reading lesson.</p>");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h2>Error!</h2>");
            response.getWriter().println("<p>Exception: " + e.getMessage() + "</p>");
        }
    }
} 