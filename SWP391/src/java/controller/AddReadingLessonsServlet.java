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

@WebServlet("/add-reading-lessons")
public class AddReadingLessonsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Add Reading Lessons Demo</title></head><body>");
        out.println("<h2>Adding Reading Lessons Demo</h2>");
        
        try {
            Connection conn = DBContext.getConnection();
            
            // Check if reading lessons already exist
            String checkSql = "SELECT COUNT(*) as count FROM lessons WHERE course_id = 1 AND type = 'reading' AND title LIKE 'Reading:%'";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt("count") > 0) {
                out.println("<p style='color: orange;'>Reading lessons already exist in the database.</p>");
                
                // Show existing reading lessons
                String showSql = "SELECT id, title, lesson_order, estimated_time FROM lessons WHERE course_id = 1 AND type = 'reading' ORDER BY lesson_order";
                PreparedStatement showStmt = conn.prepareStatement(showSql);
                ResultSet showRs = showStmt.executeQuery();
                
                out.println("<h3>Existing Reading Lessons:</h3>");
                out.println("<ul>");
                while (showRs.next()) {
                    out.println("<li>ID: " + showRs.getInt("id") + " - " + showRs.getString("title") + 
                               " (Order: " + showRs.getInt("lesson_order") + ", Time: " + showRs.getInt("estimated_time") + " min)</li>");
                }
                out.println("</ul>");
                
                showRs.close();
                showStmt.close();
            } else {
                out.println("<p>Adding reading lessons...</p>");
                
                // Add reading lesson 1: Active Listening Fundamentals
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
                    
                    "<h3>Benefits of Active Listening</h3>" +
                    "<p>Active listening helps build trust, reduces conflicts, and improves relationships. It is essential in professional settings, personal relationships, and educational environments.</p>" +
                    
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
                    "</ol>" +
                    
                    "<h3>Common Barriers to Active Listening</h3>" +
                    "<ul>" +
                    "<li><strong>Distractions:</strong> Phone, noise, multitasking</li>" +
                    "<li><strong>Prejudgment:</strong> Forming opinions before hearing the full message</li>" +
                    "<li><strong>Emotional Reactions:</strong> Getting defensive or upset</li>" +
                    "<li><strong>Mental Preparation:</strong> Thinking about your response instead of listening</li>" +
                    "</ul>" +
                    
                    "<h3>Techniques for Better Listening</h3>" +
                    "<ul>" +
                    "<li><strong>Paraphrasing:</strong> \"What I hear you saying is...\"</li>" +
                    "<li><strong>Asking Questions:</strong> \"Can you help me understand...\"</li>" +
                    "<li><strong>Summarizing:</strong> \"Let me make sure I understand the main points...\"</li>" +
                    "<li><strong>Reflecting Feelings:</strong> \"It sounds like you're feeling...\"</li>" +
                    "</ul>";
                
                String insertSql1 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, parent_lesson_id, content_file_path, content_type, estimated_time, content_text) VALUES (1, 'Reading: Active Listening Fundamentals', NULL, 3, 1, 'reading', NULL, '/content/active_listening.html', 'reading', 15, ?)";
                PreparedStatement stmt1 = conn.prepareStatement(insertSql1);
                stmt1.setString(1, lesson1Content);
                int result1 = stmt1.executeUpdate();
                
                if (result1 > 0) {
                    out.println("<p style='color: green;'>✅ Added: Reading: Active Listening Fundamentals</p>");
                }
                
                // Add reading lesson 2: Communication Skills
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
                    
                    "<h3>Verbal Communication</h3>" +
                    "<p>Your words carry power. Here are tips for effective verbal communication:</p>" +
                    "<ul>" +
                    "<li>Choose your words carefully</li>" +
                    "<li>Speak clearly and at an appropriate pace</li>" +
                    "<li>Use positive language</li>" +
                    "<li>Be concise and to the point</li>" +
                    "<li>Ask clarifying questions</li>" +
                    "</ul>" +
                    
                    "<h3>Non-Verbal Communication</h3>" +
                    "<p>Studies show that 55% of communication is body language, 38% is tone of voice, and only 7% is actual words.</p>" +
                    "<ul>" +
                    "<li><strong>Body Language:</strong> Posture, gestures, facial expressions</li>" +
                    "<li><strong>Eye Contact:</strong> Shows engagement and sincerity</li>" +
                    "<li><strong>Tone of Voice:</strong> Conveys emotion and attitude</li>" +
                    "<li><strong>Personal Space:</strong> Respect cultural and individual boundaries</li>" +
                    "</ul>";
                
                String insertSql2 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, parent_lesson_id, content_file_path, content_type, estimated_time, content_text) VALUES (1, 'Reading: Effective Communication Skills', NULL, 4, 1, 'reading', NULL, '/content/communication_skills.html', 'reading', 20, ?)";
                PreparedStatement stmt2 = conn.prepareStatement(insertSql2);
                stmt2.setString(1, lesson2Content);
                int result2 = stmt2.executeUpdate();
                
                if (result2 > 0) {
                    out.println("<p style='color: green;'>✅ Added: Reading: Effective Communication Skills</p>");
                }
                
                // Add reading lesson 3: Emotional Intelligence
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
                    "<ul>" +
                    "<li>Think before you speak</li>" +
                    "<li>Stay calm under pressure</li>" +
                    "<li>Adapt to change positively</li>" +
                    "</ul>" +
                    
                    "<div class=\"bg-purple-50 p-4 rounded-lg my-4\">" +
                    "<h4 class=\"font-semibold text-purple-800 mb-2\">🧠 Research Insight</h4>" +
                    "<p class=\"text-purple-700\">People with high emotional intelligence earn an average of $29,000 more per year than those with low emotional intelligence.</p>" +
                    "</div>" +
                    
                    "<h3>Developing Emotional Intelligence</h3>" +
                    "<p>EI can be developed through practice and conscious effort:</p>" +
                    
                    "<h4>Daily Practices:</h4>" +
                    "<ul>" +
                    "<li><strong>Emotional Check-ins:</strong> Ask yourself \"How am I feeling?\" throughout the day</li>" +
                    "<li><strong>Pause Before Reacting:</strong> Take a breath before responding to emotional situations</li>" +
                    "<li><strong>Practice Empathy:</strong> Try to see situations from others' perspectives</li>" +
                    "<li><strong>Seek Feedback:</strong> Ask trusted friends or colleagues about your emotional responses</li>" +
                    "</ul>";
                
                String insertSql3 = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, parent_lesson_id, content_file_path, content_type, estimated_time, content_text) VALUES (1, 'Reading: Emotional Intelligence in Communication', NULL, 5, 1, 'reading', NULL, '/content/emotional_intelligence.html', 'reading', 18, ?)";
                PreparedStatement stmt3 = conn.prepareStatement(insertSql3);
                stmt3.setString(1, lesson3Content);
                int result3 = stmt3.executeUpdate();
                
                if (result3 > 0) {
                    out.println("<p style='color: green;'>✅ Added: Reading: Emotional Intelligence in Communication</p>");
                }
                
                // Update lesson orders for existing video lessons
                String updateSql = "UPDATE lessons SET lesson_order = lesson_order + 3 WHERE course_id = 1 AND lesson_order >= 3 AND type = 'video'";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                int updateResult = updateStmt.executeUpdate();
                
                out.println("<p style='color: blue;'>📝 Updated " + updateResult + " video lesson orders</p>");
                
                stmt1.close();
                stmt2.close();
                stmt3.close();
                updateStmt.close();
            }
            
            // Show all lessons after operation
            out.println("<h3>All Lessons in Course 1:</h3>");
            String allLessonsSql = "SELECT id, title, lesson_order, type, content_type, estimated_time FROM lessons WHERE course_id = 1 ORDER BY lesson_order";
            PreparedStatement allStmt = conn.prepareStatement(allLessonsSql);
            ResultSet allRs = allStmt.executeQuery();
            
            out.println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
            out.println("<tr><th>ID</th><th>Title</th><th>Order</th><th>Type</th><th>Content Type</th><th>Time (min)</th></tr>");
            
            while (allRs.next()) {
                out.println("<tr>");
                out.println("<td>" + allRs.getInt("id") + "</td>");
                out.println("<td>" + allRs.getString("title") + "</td>");
                out.println("<td>" + allRs.getInt("lesson_order") + "</td>");
                out.println("<td>" + allRs.getString("type") + "</td>");
                out.println("<td>" + (allRs.getString("content_type") != null ? allRs.getString("content_type") : "N/A") + "</td>");
                out.println("<td>" + allRs.getInt("estimated_time") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            allRs.close();
            allStmt.close();
            rs.close();
            checkStmt.close();
            conn.close();
            
            out.println("<p style='color: green; font-weight: bold;'>✅ Operation completed successfully!</p>");
            out.println("<p><a href='lesson-view?lessonId=1'>Go to Lesson View</a> | <a href='course-details?id=1'>Go to Course Details</a></p>");
            
        } catch (SQLException e) {
            out.println("<p style='color: red;'>❌ Database error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
} 