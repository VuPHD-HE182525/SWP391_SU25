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

@WebServlet("/reorganize-courses")
public class ReorganizeCoursesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Reorganize Courses</title>");
        out.println("<style>body{font-family:Arial;margin:20px;} .success{color:green;} .error{color:red;} .info{color:blue;} table{border-collapse:collapse;width:100%;} th,td{border:1px solid #ddd;padding:8px;text-align:left;} .course1{background-color:#e3f2fd;} .course2{background-color:#f3e5f5;}</style>");
        out.println("</head><body>");
        out.println("<h2>🔄 Reorganize Courses & Lessons</h2>");
        
        try {
            Connection conn = DBContext.getConnection();
            
            // Step 1: Show current state
            out.println("<h3>📊 Current State:</h3>");
            String currentSql = "SELECT id, title, lesson_order, type, content_type, course_id, video_url FROM lessons ORDER BY course_id, lesson_order";
            PreparedStatement currentStmt = conn.prepareStatement(currentSql);
            ResultSet currentRs = currentStmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Title</th><th>Course ID</th><th>Order</th><th>Type</th><th>Video URL</th><th>Status</th></tr>");
            
            while (currentRs.next()) {
                String rowClass = currentRs.getInt("course_id") == 1 ? "course1" : "course2";
                out.println("<tr class='" + rowClass + "'>");
                out.println("<td>" + currentRs.getInt("id") + "</td>");
                out.println("<td>" + currentRs.getString("title") + "</td>");
                out.println("<td>" + currentRs.getInt("course_id") + "</td>");
                out.println("<td>" + currentRs.getInt("lesson_order") + "</td>");
                out.println("<td>" + currentRs.getString("type") + "</td>");
                out.println("<td>" + (currentRs.getString("video_url") != null ? currentRs.getString("video_url") : "N/A") + "</td>");
                out.println("<td><a href='lesson-view?lessonId=" + currentRs.getInt("id") + "' target='_blank'>Test</a></td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            currentRs.close();
            currentStmt.close();
            
            // Step 2: Clean up and reorganize
            out.println("<h3>🧹 Reorganizing lessons...</h3>");
            
            // Clear existing lessons first
            String deleteSql = "DELETE FROM lessons WHERE course_id IN (1, 2)";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
            int deletedCount = deleteStmt.executeUpdate();
            out.println("<p class='info'>🗑️ Deleted " + deletedCount + " old lessons</p>");
            deleteStmt.close();
            
            // Course 1: Communication Skills (AI videos + reading lessons)
            out.println("<h4>📚 Adding Course 1: Communication Skills</h4>");
            
            // Course 1 - Video Lessons
            String[] course1Videos = {
                "AI 1.mp4", "AI 2.mp4", "AI 3.mp4", "AI 4.mp4", "AI in Early Childhood.mp4"
            };
            String[] course1VideoTitles = {
                "Introduction to AI Communication", "AI in Business Communication", 
                "Advanced AI Techniques", "Practical AI Applications", "AI in Early Learning"
            };
            
            for (int i = 0; i < course1Videos.length; i++) {
                String insertVideoSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_type, estimated_time) VALUES (1, ?, ?, ?, 1, 'video', 'video', ?)";
                PreparedStatement videoStmt = conn.prepareStatement(insertVideoSql);
                videoStmt.setString(1, course1VideoTitles[i]);
                videoStmt.setString(2, course1Videos[i]);
                videoStmt.setInt(3, i + 1);
                videoStmt.setInt(4, 15 + (i * 3)); // 15, 18, 21, 24, 27 minutes
                
                int result = videoStmt.executeUpdate();
                if (result > 0) {
                    out.println("<p class='success'>✅ Added: " + course1VideoTitles[i] + "</p>");
                }
                videoStmt.close();
            }
            
            // Course 1 - Reading Lessons
            String[] readingTitles = {
                "Reading: Active Listening Fundamentals",
                "Reading: Effective Communication Skills", 
                "Reading: Emotional Intelligence in Communication"
            };
            
            String[] readingContent = {
                "<h2>Active Listening Fundamentals</h2><p>Active listening is a crucial skill in effective communication. It involves fully concentrating, understanding, responding, and remembering what is being said.</p><h3>Key Components of Active Listening</h3><ul><li><strong>Give Full Attention:</strong> Focus completely on the speaker without distractions</li><li><strong>Show That You are Listening:</strong> Use body language and verbal cues to demonstrate engagement</li><li><strong>Provide Feedback:</strong> Reflect on what you have heard to ensure understanding</li><li><strong>Defer Judgment:</strong> Allow the speaker to finish before forming opinions</li><li><strong>Respond Appropriately:</strong> Give thoughtful responses that show comprehension</li></ul>",
                
                "<h2>Effective Communication Skills</h2><p>Communication is the foundation of all human relationships. Developing strong communication skills can improve your personal and professional life significantly.</p><h3>The Communication Process</h3><p>Effective communication involves several key elements:</p><ul><li><strong>Sender:</strong> The person initiating the communication</li><li><strong>Message:</strong> The information being conveyed</li><li><strong>Medium:</strong> The channel through which the message is sent</li><li><strong>Receiver:</strong> The person receiving the message</li><li><strong>Feedback:</strong> The response from the receiver</li></ul>",
                
                "<h2>Emotional Intelligence in Communication</h2><p>Emotional Intelligence (EI) is the ability to understand and manage your own emotions, as well as recognize and respond appropriately to others' emotions.</p><h3>The Four Components of Emotional Intelligence</h3><h4>1. Self-Awareness</h4><p>Understanding your own emotions and their impact on others.</p><ul><li>Recognize your emotional triggers</li><li>Understand your strengths and weaknesses</li><li>Practice mindfulness and self-reflection</li></ul>"
            };
            
            for (int i = 0; i < readingTitles.length; i++) {
                String insertReadingSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_file_path, content_type, estimated_time, content_text) VALUES (1, ?, NULL, ?, 1, 'reading', '/content/reading" + (i+1) + ".html', 'reading', ?, ?)";
                PreparedStatement readingStmt = conn.prepareStatement(insertReadingSql);
                readingStmt.setString(1, readingTitles[i]);
                readingStmt.setInt(2, course1Videos.length + i + 1); // After video lessons
                readingStmt.setInt(3, 15 + (i * 3)); // 15, 18, 21 minutes
                readingStmt.setString(4, readingContent[i]);
                
                int result = readingStmt.executeUpdate();
                if (result > 0) {
                    out.println("<p class='success'>✅ Added: " + readingTitles[i] + "</p>");
                }
                readingStmt.close();
            }
            
            // Course 2: Presentation and Public Speaking
            out.println("<h4>🎤 Adding Course 2: Presentation and Public Speaking</h4>");
            
            String[] course2Videos = {
                "lesson1.mp4", "lesson2.mp4", "lesson3.mp4", "lesson4.mp4", "lesson5.mp4",
                "java 1.mp4", "java 2.mp4", "java.mp4", "Understanding Engineering Drawings.mp4"
            };
            String[] course2VideoTitles = {
                "Presentation Basics", "Structuring Your Presentation", "Visual Design Principles", 
                "Delivery Techniques", "Handling Q&A Sessions", "Technical Presentations - Part 1", 
                "Technical Presentations - Part 2", "Advanced Java Concepts", "Engineering Communication"
            };
            
            for (int i = 0; i < course2Videos.length; i++) {
                String insertVideoSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_type, estimated_time) VALUES (2, ?, ?, ?, 1, 'video', 'video', ?)";
                PreparedStatement videoStmt = conn.prepareStatement(insertVideoSql);
                videoStmt.setString(1, course2VideoTitles[i]);
                videoStmt.setString(2, course2Videos[i]);
                videoStmt.setInt(3, i + 1);
                videoStmt.setInt(4, 12 + (i * 2)); // 12, 14, 16, 18... minutes
                
                int result = videoStmt.executeUpdate();
                if (result > 0) {
                    out.println("<p class='success'>✅ Added: " + course2VideoTitles[i] + "</p>");
                }
                videoStmt.close();
            }
            
            // Course 2 - Reading Lessons
            String[] course2ReadingTitles = {
                "Reading: Presentation Planning",
                "Reading: Public Speaking Confidence"
            };
            
            String[] course2ReadingContent = {
                "<h2>Presentation Planning</h2><p>Effective presentations start with thorough planning. This involves understanding your audience, defining clear objectives, and structuring your content logically.</p><h3>Key Planning Steps</h3><ul><li><strong>Audience Analysis:</strong> Understand who you're presenting to</li><li><strong>Objective Setting:</strong> Define what you want to achieve</li><li><strong>Content Organization:</strong> Structure your message logically</li><li><strong>Time Management:</strong> Plan your timing carefully</li></ul>",
                
                "<h2>Public Speaking Confidence</h2><p>Building confidence in public speaking is essential for effective presentations. This involves preparation, practice, and managing anxiety.</p><h3>Building Confidence</h3><ul><li><strong>Thorough Preparation:</strong> Know your material inside and out</li><li><strong>Practice Regularly:</strong> Rehearse your presentation multiple times</li><li><strong>Manage Anxiety:</strong> Use breathing techniques and positive visualization</li><li><strong>Start Small:</strong> Begin with smaller audiences and build up</li></ul>"
            };
            
            for (int i = 0; i < course2ReadingTitles.length; i++) {
                String insertReadingSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_file_path, content_type, estimated_time, content_text) VALUES (2, ?, NULL, ?, 1, 'reading', '/content/course2_reading" + (i+1) + ".html', 'reading', ?, ?)";
                PreparedStatement readingStmt = conn.prepareStatement(insertReadingSql);
                readingStmt.setString(1, course2ReadingTitles[i]);
                readingStmt.setInt(2, course2Videos.length + i + 1); // After video lessons
                readingStmt.setInt(3, 20 + (i * 5)); // 20, 25 minutes
                readingStmt.setString(4, course2ReadingContent[i]);
                
                int result = readingStmt.executeUpdate();
                if (result > 0) {
                    out.println("<p class='success'>✅ Added: " + course2ReadingTitles[i] + "</p>");
                }
                readingStmt.close();
            }
            
            // Step 3: Show final result
            out.println("<h3>🎉 Final Result:</h3>");
            String finalSql = "SELECT id, title, lesson_order, type, content_type, course_id, estimated_time FROM lessons ORDER BY course_id, lesson_order";
            PreparedStatement finalStmt = conn.prepareStatement(finalSql);
            ResultSet finalRs = finalStmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Course</th><th>Title</th><th>Order</th><th>Type</th><th>Time</th><th>Test</th></tr>");
            
            while (finalRs.next()) {
                String rowClass = finalRs.getInt("course_id") == 1 ? "course1" : "course2";
                String courseName = finalRs.getInt("course_id") == 1 ? "Communication Skills" : "Presentation & Public Speaking";
                
                out.println("<tr class='" + rowClass + "'>");
                out.println("<td>" + finalRs.getInt("id") + "</td>");
                out.println("<td>" + courseName + "</td>");
                out.println("<td>" + finalRs.getString("title") + "</td>");
                out.println("<td>" + finalRs.getInt("lesson_order") + "</td>");
                out.println("<td>" + finalRs.getString("type") + "</td>");
                out.println("<td>" + finalRs.getInt("estimated_time") + " min</td>");
                out.println("<td><a href='lesson-view?lessonId=" + finalRs.getInt("id") + "' target='_blank' class='success'>🚀 Test</a></td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            finalRs.close();
            finalStmt.close();
            conn.close();
            
            // Summary
            out.println("<div style='margin-top:20px; padding:15px; background-color:#d4edda; border:1px solid #c3e6cb; border-radius:5px;'>");
            out.println("<h4 style='color:#155724; margin:0 0 10px 0;'>✅ Reorganization Complete!</h4>");
            out.println("<p style='margin:0;'><strong>Course 1 (Communication Skills):</strong> 5 video lessons + 3 reading lessons</p>");
            out.println("<p style='margin:0;'><strong>Course 2 (Presentation & Public Speaking):</strong> 9 video lessons + 2 reading lessons</p>");
            out.println("<ul style='margin:5px 0;'>");
            out.println("<li><a href='course-details?id=1' target='_blank'>View Course 1</a></li>");
            out.println("<li><a href='course-details?id=2' target='_blank'>View Course 2</a></li>");
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