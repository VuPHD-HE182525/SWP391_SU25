package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBContext;

@WebServlet("/check-database")
public class CheckDatabaseServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Database Check</title>");
        out.println("<style>body{font-family:Arial;margin:20px;} .success{color:green;} .error{color:red;} .info{color:blue;} table{border-collapse:collapse;width:100%;} th,td{border:1px solid #ddd;padding:8px;text-align:left;} .working{background-color:#e8f5e8;} .broken{background-color:#ffeaea;}</style>");
        out.println("</head><body>");
        out.println("<h2>🔍 Database Connection & Lessons Check</h2>");
        
        try {
            // Test 1: Database Connection
            out.println("<h3>📡 Database Connection Test:</h3>");
            Connection conn = DBContext.getConnection();
            if (conn != null && !conn.isClosed()) {
                out.println("<p class='success'>✅ Database connection: OK</p>");
            } else {
                out.println("<p class='error'>❌ Database connection: FAILED</p>");
                return;
            }
            
            // Test 2: Check all lessons
            out.println("<h3>📚 All Lessons in Database:</h3>");
            String allLessonsSql = "SELECT id, title, lesson_order, type, content_type, estimated_time, course_id FROM lessons ORDER BY course_id, lesson_order";
            PreparedStatement allStmt = conn.prepareStatement(allLessonsSql);
            ResultSet allRs = allStmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Title</th><th>Course ID</th><th>Order</th><th>Type</th><th>Content Type</th><th>Time</th><th>Status</th></tr>");
            
            boolean hasLessons = false;
            while (allRs.next()) {
                hasLessons = true;
                int lessonId = allRs.getInt("id");
                String rowClass = (lessonId == 1) ? "working" : "";
                
                out.println("<tr class='" + rowClass + "'>");
                out.println("<td><strong>" + lessonId + "</strong></td>");
                out.println("<td>" + allRs.getString("title") + "</td>");
                out.println("<td>" + allRs.getInt("course_id") + "</td>");
                out.println("<td>" + allRs.getInt("lesson_order") + "</td>");
                out.println("<td>" + allRs.getString("type") + "</td>");
                out.println("<td>" + (allRs.getString("content_type") != null ? allRs.getString("content_type") : "N/A") + "</td>");
                out.println("<td>" + allRs.getInt("estimated_time") + "</td>");
                out.println("<td><a href='lesson-view?lessonId=" + lessonId + "' target='_blank'>Test</a></td>");
                out.println("</tr>");
            }
            
            if (!hasLessons) {
                out.println("<tr><td colspan='8' class='error'>No lessons found in database!</td></tr>");
            }
            out.println("</table>");
            
            // Test 3: Check course_id = 1 lessons specifically
            out.println("<h3>🎯 Course 1 Lessons (Target Course):</h3>");
            String course1Sql = "SELECT id, title, lesson_order, type, content_type FROM lessons WHERE course_id = 1 ORDER BY lesson_order";
            PreparedStatement course1Stmt = conn.prepareStatement(course1Sql);
            ResultSet course1Rs = course1Stmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Title</th><th>Order</th><th>Type</th><th>Content Type</th><th>Test Link</th></tr>");
            
            boolean hasCourse1Lessons = false;
            while (course1Rs.next()) {
                hasCourse1Lessons = true;
                int lessonId = course1Rs.getInt("id");
                String type = course1Rs.getString("type");
                String bgColor = "reading".equals(type) ? "#e8f5e8" : "#f0f8ff";
                
                out.println("<tr style='background-color:" + bgColor + ";'>");
                out.println("<td><strong>" + lessonId + "</strong></td>");
                out.println("<td>" + course1Rs.getString("title") + "</td>");
                out.println("<td>" + course1Rs.getInt("lesson_order") + "</td>");
                out.println("<td>" + type + "</td>");
                out.println("<td>" + (course1Rs.getString("content_type") != null ? course1Rs.getString("content_type") : "N/A") + "</td>");
                out.println("<td><a href='lesson-view?lessonId=" + lessonId + "' target='_blank' class='success'>🚀 Test Lesson " + lessonId + "</a></td>");
                out.println("</tr>");
            }
            
            if (!hasCourse1Lessons) {
                out.println("<tr><td colspan='6' class='error'>No lessons found for course_id = 1!</td></tr>");
            }
            out.println("</table>");
            
            // Test 4: Database schema check
            out.println("<h3>🏗️ Database Schema Check:</h3>");
            String schemaSql = "DESCRIBE lessons";
            PreparedStatement schemaStmt = conn.prepareStatement(schemaSql);
            ResultSet schemaRs = schemaStmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>Column</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th></tr>");
            
            while (schemaRs.next()) {
                out.println("<tr>");
                out.println("<td>" + schemaRs.getString("Field") + "</td>");
                out.println("<td>" + schemaRs.getString("Type") + "</td>");
                out.println("<td>" + schemaRs.getString("Null") + "</td>");
                out.println("<td>" + (schemaRs.getString("Key") != null ? schemaRs.getString("Key") : "") + "</td>");
                out.println("<td>" + (schemaRs.getString("Default") != null ? schemaRs.getString("Default") : "NULL") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Cleanup
            allRs.close();
            allStmt.close();
            course1Rs.close();
            course1Stmt.close();
            schemaRs.close();
            schemaStmt.close();
            conn.close();
            
            // Summary
            out.println("<div style='margin-top:20px; padding:15px; background-color:#d4edda; border:1px solid #c3e6cb; border-radius:5px;'>");
            out.println("<h4 style='color:#155724; margin:0 0 10px 0;'>📋 Summary & Recommendations:</h4>");
            
            if (hasCourse1Lessons) {
                out.println("<p class='success'>✅ Course 1 has lessons - you can test them using the links above</p>");
                out.println("<p class='info'>💡 Try starting with the lowest lesson ID that works</p>");
            } else {
                out.println("<p class='error'>❌ No lessons found for course_id = 1</p>");
                out.println("<p class='info'>💡 You may need to run the add reading lessons servlet first</p>");
            }
            
            out.println("<ul style='margin:5px 0;'>");
            out.println("<li><a href='simple-add-reading' target='_blank'>Add Reading Lessons</a></li>");
            out.println("<li><a href='course-details?id=1' target='_blank'>View Course Details</a></li>");
            out.println("</ul>");
            out.println("</div>");
            
        } catch (SQLException e) {
            out.println("<p class='error'>❌ Database error: " + e.getMessage() + "</p>");
            out.println("<p class='info'>Error details: " + e.getClass().getSimpleName() + "</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p class='error'>❌ General error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
} 