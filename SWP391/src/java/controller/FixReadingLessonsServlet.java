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

@WebServlet("/fix-reading-lessons")
public class FixReadingLessonsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Fix Reading Lessons</title>");
        out.println("<style>body{font-family:Arial;margin:20px;} .success{color:green;} .error{color:red;} .info{color:blue;} table{border-collapse:collapse;width:100%;} th,td{border:1px solid #ddd;padding:8px;text-align:left;}</style>");
        out.println("</head><body>");
        out.println("<h2>🔧 Fix Reading Lessons Database</h2>");
        
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
            
            // Step 2: Clean up existing reading lessons
            out.println("<h3>🧹 Cleaning up existing reading lessons...</h3>");
            String deleteSql = "DELETE FROM lessons WHERE course_id = 1 AND type = 'reading' AND title LIKE 'Reading:%'";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
            int deletedCount = deleteStmt.executeUpdate();
            out.println("<p class='info'>🗑️ Deleted " + deletedCount + " old reading lessons</p>");
            deleteStmt.close();
            
            // Step 3: Reset video lesson orders
            out.println("<h3>🔄 Resetting video lesson orders...</h3>");
            String resetSql1 = "UPDATE lessons SET lesson_order = 1 WHERE course_id = 1 AND id = 1";
            String resetSql2 = "UPDATE lessons SET lesson_order = 2 WHERE course_id = 1 AND id = 2";
            
            PreparedStatement resetStmt1 = conn.prepareStatement(resetSql1);
            PreparedStatement resetStmt2 = conn.prepareStatement(resetSql2);
            
            int reset1 = resetStmt1.executeUpdate();
            int reset2 = resetStmt2.executeUpdate();
            
            out.println("<p class='info'>📝 Reset video lesson orders: " + (reset1 + reset2) + " lessons updated</p>");
            
            resetStmt1.close();
            resetStmt2.close();
            
            // Step 4: Add reading lessons
            out.println("<h3>➕ Adding new reading lessons...</h3>");
            
            // Reading Lesson 1
            String lesson1Content = "<h2>Active Listening Fundamentals</h2>" +
                "<p>Active listening is a crucial skill in effective communication. It involves fully concentrating, understanding, responding, and remembering what is being said.</p>" +
                
                "<h3>Key Components of Active Listening</h3>" +
                "<ul>" +
                "<li><strong>Give Full Attention:</strong> Focus completely on the speaker without distractions</li>" +
                "<li><strong>Show That You are Listening:</strong> Use body language and verbal cues to demonstrate engagement</li>" +
                "<li><strong>Provide Feedback:</strong> Reflect on what you have heard to ensure understanding</li>" +
                "<li><strong>Defer Judgment:</strong> Allow the speaker to finish before forming opinions</li>" +
                "<li><strong>Respond Appropriately:</strong> Give thoughtful responses that show comprehension</li>" +
                "</ul>" +
                
                "<div class=\"bg-blue-50 p-4 rounded-lg my-4\">" +
                "<h4 class=\"font-semibold text-blue-800 mb-2\">💡 Quick Tip</h4>" +
                "<p class=\"text-blue-700\">Practice the \"mirror technique\" - repeat back what you heard in your own words to confirm understanding.</p>" +
                "</div>" +
                
                "<h3>Practice Exercise</h3>" +
                "<p>Try this with a partner:</p>" +
                "<ol>" +
                "<li>One person speaks for 2 minutes about a topic they care about</li>" +
                "<li>The other practices active listening techniques</li>" +
                "<li>The listener summarizes what they heard</li>" +
                "<li>Switch roles and discuss the experience</li>" +
                "</ol>";
            
            String insertSql1 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, parent_lesson_id, content_file_path, content_type, estimated_time, content_text) VALUES (1, 'Reading: Active Listening Fundamentals', NULL, 3, 1, 'reading', NULL, '/content/active_listening.html', 'reading', 15, ?)";
            PreparedStatement stmt1 = conn.prepareStatement(insertSql1);
            stmt1.setString(1, lesson1Content);
            int result1 = stmt1.executeUpdate();
            
            if (result1 > 0) {
                out.println("<p class='success'>✅ Added: Reading: Active Listening Fundamentals</p>");
            }
            
            // Reading Lesson 2
            String lesson2Content = "<h2>Effective Communication Skills</h2>" +
                "<p>Communication is the foundation of all human relationships. Developing strong communication skills can improve your personal and professional life significantly.</p>" +
                
                "<h3>The Communication Process</h3>" +
                "<p>Effective communication involves several key elements:</p>" +
                "<ul>" +
                "<li><strong>Sender:</strong> The person initiating the communication</li>" +
                "<li><strong>Message:</strong> The information being conveyed</li>" +
                "<li><strong>Medium:</strong> The channel through which the message is sent</li>" +
                "<li><strong>Receiver:</strong> The person receiving the message</li>" +
                "<li><strong>Feedback:</strong> The response from the receiver</li>" +
                "</ul>" +
                
                "<div class=\"bg-green-50 p-4 rounded-lg my-4\">" +
                "<h4 class=\"font-semibold text-green-800 mb-2\">🎯 Key Insight</h4>" +
                "<p class=\"text-green-700\">Communication is not just about speaking - it's about being understood and understanding others.</p>" +
                "</div>" +
                
                "<h3>Verbal vs Non-Verbal Communication</h3>" +
                "<p>Studies show that 55% of communication is body language, 38% is tone of voice, and only 7% is actual words.</p>";
            
            String insertSql2 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, parent_lesson_id, content_file_path, content_type, estimated_time, content_text) VALUES (1, 'Reading: Effective Communication Skills', NULL, 4, 1, 'reading', NULL, '/content/communication_skills.html', 'reading', 20, ?)";
            PreparedStatement stmt2 = conn.prepareStatement(insertSql2);
            stmt2.setString(1, lesson2Content);
            int result2 = stmt2.executeUpdate();
            
            if (result2 > 0) {
                out.println("<p class='success'>✅ Added: Reading: Effective Communication Skills</p>");
            }
            
            // Reading Lesson 3
            String lesson3Content = "<h2>Emotional Intelligence in Communication</h2>" +
                "<p>Emotional Intelligence (EI) is the ability to understand and manage your own emotions, as well as recognize and respond appropriately to others' emotions.</p>" +
                
                "<h3>The Four Components of Emotional Intelligence</h3>" +
                
                "<h4>1. Self-Awareness</h4>" +
                "<p>Understanding your own emotions and their impact on others.</p>" +
                "<ul>" +
                "<li>Recognize your emotional triggers</li>" +
                "<li>Understand your strengths and weaknesses</li>" +
                "<li>Practice mindfulness and self-reflection</li>" +
                "</ul>" +
                
                "<h4>2. Self-Management</h4>" +
                "<p>The ability to control and redirect disruptive emotions and impulses.</p>" +
                
                "<div class=\"bg-purple-50 p-4 rounded-lg my-4\">" +
                "<h4 class=\"font-semibold text-purple-800 mb-2\">🧠 Research Insight</h4>" +
                "<p class=\"text-purple-700\">People with high emotional intelligence earn an average of $29,000 more per year than those with low emotional intelligence.</p>" +
                "</div>";
            
            String insertSql3 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, parent_lesson_id, content_file_path, content_type, estimated_time, content_text) VALUES (1, 'Reading: Emotional Intelligence in Communication', NULL, 5, 1, 'reading', NULL, '/content/emotional_intelligence.html', 'reading', 18, ?)";
            PreparedStatement stmt3 = conn.prepareStatement(insertSql3);
            stmt3.setString(1, lesson3Content);
            int result3 = stmt3.executeUpdate();
            
            if (result3 > 0) {
                out.println("<p class='success'>✅ Added: Reading: Emotional Intelligence in Communication</p>");
            }
            
            // Step 5: Update remaining video lessons
            String updateVideoSql = "UPDATE lessons SET lesson_order = lesson_order + 3 WHERE course_id = 1 AND type = 'video' AND lesson_order > 2";
            PreparedStatement updateStmt = conn.prepareStatement(updateVideoSql);
            int updateResult = updateStmt.executeUpdate();
            out.println("<p class='info'>📝 Updated " + updateResult + " video lesson orders</p>");
            
            // Step 6: Show final result
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
            
            // Cleanup
            stmt1.close();
            stmt2.close();
            stmt3.close();
            updateStmt.close();
            finalRs.close();
            finalStmt.close();
            conn.close();
            
            out.println("<div style='margin-top:20px; padding:15px; background-color:#d4edda; border:1px solid #c3e6cb; border-radius:5px;'>");
            out.println("<h4 style='color:#155724; margin:0 0 10px 0;'>✅ Operation Completed Successfully!</h4>");
            out.println("<p style='margin:0;'>Reading lessons have been added to Section 2. You can now:</p>");
            out.println("<ul style='margin:5px 0;'>");
            out.println("<li><a href='lesson-view?lessonId=1' target='_blank'>Test Lesson View</a></li>");
            out.println("<li><a href='course-details?id=1' target='_blank'>View Course Details</a></li>");
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