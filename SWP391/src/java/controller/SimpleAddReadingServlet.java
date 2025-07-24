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

@WebServlet("/simple-add-reading")
public class SimpleAddReadingServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Simple Add Reading Lessons</title>");
        out.println("<style>body{font-family:Arial;margin:20px;} .success{color:green;} .error{color:red;} .info{color:blue;} table{border-collapse:collapse;width:100%;} th,td{border:1px solid #ddd;padding:8px;text-align:left;}</style>");
        out.println("</head><body>");
        out.println("<h2>📚 Simple Add Reading Lessons</h2>");
        
        try {
            Connection conn = DBContext.getConnection();
            
            // Step 1: Show current state
            out.println("<h3>📊 Current Database State:</h3>");
            String currentSql = "SELECT id, title, lesson_order, type, content_type, estimated_time FROM lessons WHERE course_id = 1 ORDER BY lesson_order";
            PreparedStatement currentStmt = conn.prepareStatement(currentSql);
            ResultSet currentRs = currentStmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Title</th><th>Order</th><th>Type</th><th>Content Type</th><th>Time</th></tr>");
            int totalLessons = 0;
            int readingLessons = 0;
            
            while (currentRs.next()) {
                totalLessons++;
                if ("reading".equals(currentRs.getString("type"))) {
                    readingLessons++;
                }
                out.println("<tr>");
                out.println("<td>" + currentRs.getInt("id") + "</td>");
                out.println("<td>" + currentRs.getString("title") + "</td>");
                out.println("<td>" + currentRs.getInt("lesson_order") + "</td>");
                out.println("<td>" + currentRs.getString("type") + "</td>");
                out.println("<td>" + (currentRs.getString("content_type") != null ? currentRs.getString("content_type") : "N/A") + "</td>");
                out.println("<td>" + currentRs.getInt("estimated_time") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            out.println("<p class='info'>📈 Total lessons: " + totalLessons + " | Reading lessons: " + readingLessons + "</p>");
            
            currentRs.close();
            currentStmt.close();
            
            // Step 2: Add reading lessons (without content_text)
            if (readingLessons == 0) {
                out.println("<h3>➕ Adding reading lessons...</h3>");
                
                // Reading Lesson 1
                String insertSql1 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_file_path, content_type, estimated_time) VALUES (1, 'Reading: Active Listening Fundamentals', NULL, 3, 1, 'reading', '/content/active_listening.html', 'reading', 15)";
                PreparedStatement stmt1 = conn.prepareStatement(insertSql1);
                int result1 = stmt1.executeUpdate();
                
                if (result1 > 0) {
                    out.println("<p class='success'>✅ Added: Reading: Active Listening Fundamentals</p>");
                }
                
                // Reading Lesson 2
                String insertSql2 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_file_path, content_type, estimated_time) VALUES (1, 'Reading: Communication Skills', NULL, 4, 1, 'reading', '/content/communication_skills.html', 'reading', 20)";
                PreparedStatement stmt2 = conn.prepareStatement(insertSql2);
                int result2 = stmt2.executeUpdate();
                
                if (result2 > 0) {
                    out.println("<p class='success'>✅ Added: Reading: Communication Skills</p>");
                }
                
                // Reading Lesson 3
                String insertSql3 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_file_path, content_type, estimated_time) VALUES (1, 'Reading: Emotional Intelligence', NULL, 5, 1, 'reading', '/content/emotional_intelligence.html', 'reading', 18)";
                PreparedStatement stmt3 = conn.prepareStatement(insertSql3);
                int result3 = stmt3.executeUpdate();
                
                if (result3 > 0) {
                    out.println("<p class='success'>✅ Added: Reading: Emotional Intelligence</p>");
                }
                
                stmt1.close();
                stmt2.close();
                stmt3.close();
            } else {
                out.println("<p class='info'>📝 Reading lessons already exist (" + readingLessons + " found)</p>");
            }
            
            // Step 3: Show final result
            out.println("<h3>🎉 Final Database State:</h3>");
            String finalSql = "SELECT id, title, lesson_order, type, content_type, estimated_time FROM lessons WHERE course_id = 1 ORDER BY lesson_order";
            PreparedStatement finalStmt = conn.prepareStatement(finalSql);
            ResultSet finalRs = finalStmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Title</th><th>Order</th><th>Type</th><th>Content Type</th><th>Time</th></tr>");
            int finalTotal = 0;
            int finalReading = 0;
            
            while (finalRs.next()) {
                finalTotal++;
                if ("reading".equals(finalRs.getString("type"))) {
                    finalReading++;
                }
                String rowClass = "reading".equals(finalRs.getString("type")) ? " style='background-color:#e8f5e8;'" : "";
                out.println("<tr" + rowClass + ">");
                out.println("<td>" + finalRs.getInt("id") + "</td>");
                out.println("<td>" + finalRs.getString("title") + "</td>");
                out.println("<td>" + finalRs.getInt("lesson_order") + "</td>");
                out.println("<td>" + finalRs.getString("type") + "</td>");
                out.println("<td>" + (finalRs.getString("content_type") != null ? finalRs.getString("content_type") : "N/A") + "</td>");
                out.println("<td>" + finalRs.getInt("estimated_time") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            out.println("<p class='success'>🎯 Final result: " + finalTotal + " total lessons | " + finalReading + " reading lessons</p>");
            
            finalRs.close();
            finalStmt.close();
            conn.close();
            
            out.println("<div style='margin-top:20px; padding:15px; background-color:#d4edda; border:1px solid #c3e6cb; border-radius:5px;'>");
            out.println("<h4 style='color:#155724; margin:0 0 10px 0;'>✅ Operation Completed!</h4>");
            out.println("<p style='margin:0;'>Reading lessons added successfully. Test now:</p>");
            out.println("<ul style='margin:5px 0;'>");
            out.println("<li><a href='lesson-view?lessonId=1' target='_blank'>Go to Lesson View</a></li>");
            out.println("<li><a href='course-details?id=1' target='_blank'>Go to Course Details</a></li>");
            out.println("</ul>");
            out.println("</div>");
            
        } catch (SQLException e) {
            out.println("<p class='error'>❌ Database error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p class='error'>❌ Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
} 