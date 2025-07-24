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

@WebServlet("/complete-fix")
public class CompleteFixServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Complete Database Fix</title>");
        out.println("<style>body{font-family:Arial;margin:20px;} .success{color:green;} .error{color:red;} .info{color:blue;} table{border-collapse:collapse;width:100%;} th,td{border:1px solid #ddd;padding:8px;text-align:left;}</style>");
        out.println("</head><body>");
        out.println("<h2>🔧 Complete Database Fix</h2>");
        
        try {
            Connection conn = DBContext.getConnection();
            
            // Step 1: Complete cleanup - remove ALL lessons first
            out.println("<h3>🧹 Complete Cleanup:</h3>");
            String deleteAllLessons = "DELETE FROM lessons";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteAllLessons);
            int deletedCount = deleteStmt.executeUpdate();
            out.println("<p class='info'>🗑️ Deleted " + deletedCount + " ALL lessons</p>");
            deleteStmt.close();
            
            // Step 2: Ensure subjects exist
            out.println("<h3>📚 Ensuring Subjects:</h3>");
            String insertSubject1 = "INSERT INTO subjects (id, name, description, thumbnail_url, category_id, status, is_featured) VALUES (1, 'Communication & Soft Skills', 'Master essential communication skills including active listening, emotional intelligence, and effective interpersonal communication.', '/uploads/images/subject1.png', 1, 'active', 1) ON DUPLICATE KEY UPDATE name=VALUES(name)";
            PreparedStatement subj1Stmt = conn.prepareStatement(insertSubject1);
            subj1Stmt.executeUpdate();
            out.println("<p class='success'>✅ Subject 1: Communication & Soft Skills</p>");
            subj1Stmt.close();
            
            String insertSubject2 = "INSERT INTO subjects (id, name, description, thumbnail_url, category_id, status, is_featured) VALUES (2, 'Presentation & Public Speaking', 'Develop confident presentation skills, public speaking techniques, and professional communication abilities.', '/uploads/images/subject2.jpg', 1, 'active', 1) ON DUPLICATE KEY UPDATE name=VALUES(name)";
            PreparedStatement subj2Stmt = conn.prepareStatement(insertSubject2);
            subj2Stmt.executeUpdate();
            out.println("<p class='success'>✅ Subject 2: Presentation & Public Speaking</p>");
            subj2Stmt.close();
            
            // Step 3: Ensure courses exist
            out.println("<h3>🎓 Ensuring Courses:</h3>");
            String insertCourse1 = "INSERT INTO courses (id, subject_id, expert_id, title, description, thumbnail_url, brief_info) VALUES (1, 1, 1, 'Communication & Soft Skills Essentials', 'Comprehensive course covering active listening, emotional intelligence, and effective communication strategies for personal and professional success.', '/uploads/images/subject1.png', 'Learn essential communication skills through AI-powered lessons and interactive reading materials.') ON DUPLICATE KEY UPDATE title=VALUES(title)";
            PreparedStatement course1Stmt = conn.prepareStatement(insertCourse1);
            course1Stmt.executeUpdate();
            out.println("<p class='success'>✅ Course 1: Communication & Soft Skills Essentials</p>");
            course1Stmt.close();
            
            String insertCourse2 = "INSERT INTO courses (id, subject_id, expert_id, title, description, thumbnail_url, brief_info) VALUES (2, 2, 1, 'Presentation and Public Speaking Mastery', 'Master the art of presentations and public speaking with practical lessons covering planning, delivery, and confidence building techniques.', '/uploads/images/subject2.jpg', 'Develop confident presentation skills through comprehensive video lessons and practical exercises.') ON DUPLICATE KEY UPDATE title=VALUES(title)";
            PreparedStatement course2Stmt = conn.prepareStatement(insertCourse2);
            course2Stmt.executeUpdate();
            out.println("<p class='success'>✅ Course 2: Presentation and Public Speaking Mastery</p>");
            course2Stmt.close();
            
            // Step 4: Ensure packages exist (required by CourseDAO)
            out.println("<h3>📦 Ensuring Packages:</h3>");
            String insertPackage1 = "INSERT INTO packages (id, course_id, package_name, original_price, sale_price, duration_months, status) VALUES (1, 1, 'Basic Communication Package', 99.99, 49.99, 3, 'active') ON DUPLICATE KEY UPDATE package_name=VALUES(package_name)";
            PreparedStatement pkg1Stmt = conn.prepareStatement(insertPackage1);
            pkg1Stmt.executeUpdate();
            out.println("<p class='success'>✅ Package 1 for Course 1</p>");
            pkg1Stmt.close();
            
            String insertPackage2 = "INSERT INTO packages (id, course_id, package_name, original_price, sale_price, duration_months, status) VALUES (2, 2, 'Advanced Presentation Package', 129.99, 79.99, 6, 'active') ON DUPLICATE KEY UPDATE package_name=VALUES(package_name)";
            PreparedStatement pkg2Stmt = conn.prepareStatement(insertPackage2);
            pkg2Stmt.executeUpdate();
            out.println("<p class='success'>✅ Package 2 for Course 2</p>");
            pkg2Stmt.close();
            
            // Step 5: Add Course 1 lessons (Communication Skills)
            out.println("<h3>📚 Adding Course 1 Lessons:</h3>");
            
            // Course 1 Videos
            String[] course1Videos = {"AI 1.mp4", "AI 2.mp4", "AI 3.mp4", "AI 4.mp4", "AI in Early Childhood.mp4"};
            String[] course1VideoTitles = {"Introduction to AI Communication", "AI in Business Communication", "Advanced AI Techniques", "Practical AI Applications", "AI in Early Learning"};
            
            for (int i = 0; i < course1Videos.length; i++) {
                String insertVideoSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_type, estimated_time) VALUES (1, ?, ?, ?, 1, 'video', 'video', ?)";
                PreparedStatement videoStmt = conn.prepareStatement(insertVideoSql);
                videoStmt.setString(1, course1VideoTitles[i]);
                videoStmt.setString(2, course1Videos[i]);
                videoStmt.setInt(3, i + 1);
                videoStmt.setInt(4, 15 + (i * 3));
                videoStmt.executeUpdate();
                out.println("<p class='success'>✅ " + course1VideoTitles[i] + "</p>");
                videoStmt.close();
            }
            
            // Course 1 Reading lessons
            String[] readingTitles = {"Reading: Active Listening Fundamentals", "Reading: Effective Communication Skills", "Reading: Emotional Intelligence in Communication"};
            String[] readingContent = {
                "<h2>Active Listening Fundamentals</h2><p>Active listening is a crucial skill in effective communication. It involves fully concentrating, understanding, responding, and remembering what is being said.</p><h3>Key Components of Active Listening</h3><ul><li><strong>Give Full Attention:</strong> Focus completely on the speaker without distractions</li><li><strong>Show That You are Listening:</strong> Use body language and verbal cues to demonstrate engagement</li><li><strong>Provide Feedback:</strong> Reflect on what you have heard to ensure understanding</li><li><strong>Defer Judgment:</strong> Allow the speaker to finish before forming opinions</li><li><strong>Respond Appropriately:</strong> Give thoughtful responses that show comprehension</li></ul>",
                "<h2>Effective Communication Skills</h2><p>Communication is the foundation of all human relationships. Developing strong communication skills can improve your personal and professional life significantly.</p><h3>The Communication Process</h3><p>Effective communication involves several key elements:</p><ul><li><strong>Sender:</strong> The person initiating the communication</li><li><strong>Message:</strong> The information being conveyed</li><li><strong>Medium:</strong> The channel through which the message is sent</li><li><strong>Receiver:</strong> The person receiving the message</li><li><strong>Feedback:</strong> The response from the receiver</li></ul>",
                "<h2>Emotional Intelligence in Communication</h2><p>Emotional Intelligence (EI) is the ability to understand and manage your own emotions, as well as recognize and respond appropriately to others' emotions.</p><h3>The Four Components of Emotional Intelligence</h3><h4>1. Self-Awareness</h4><p>Understanding your own emotions and their impact on others.</p><ul><li>Recognize your emotional triggers</li><li>Understand your strengths and weaknesses</li><li>Practice mindfulness and self-reflection</li></ul>"
            };
            
            for (int i = 0; i < readingTitles.length; i++) {
                String insertReadingSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_file_path, content_type, estimated_time, content_text) VALUES (1, ?, NULL, ?, 1, 'reading', '/content/reading" + (i+1) + ".html', 'reading', ?, ?)";
                PreparedStatement readingStmt = conn.prepareStatement(insertReadingSql);
                readingStmt.setString(1, readingTitles[i]);
                readingStmt.setInt(2, course1Videos.length + i + 1);
                readingStmt.setInt(3, 15 + (i * 3));
                readingStmt.setString(4, readingContent[i]);
                readingStmt.executeUpdate();
                out.println("<p class='success'>✅ " + readingTitles[i] + "</p>");
                readingStmt.close();
            }
            
            // Step 6: Add Course 2 lessons (Presentation & Public Speaking)
            out.println("<h3>🎤 Adding Course 2 Lessons:</h3>");
            
            String[] course2Videos = {"lesson1.mp4", "lesson2.mp4", "lesson3.mp4", "lesson4.mp4", "lesson5.mp4", "java 1.mp4", "java 2.mp4", "java.mp4", "Understanding Engineering Drawings.mp4"};
            String[] course2VideoTitles = {"Presentation Basics", "Structuring Your Presentation", "Visual Design Principles", "Delivery Techniques", "Handling Q&A Sessions", "Technical Presentations - Part 1", "Technical Presentations - Part 2", "Advanced Java Concepts", "Engineering Communication"};
            
            for (int i = 0; i < course2Videos.length; i++) {
                String insertVideoSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_type, estimated_time) VALUES (2, ?, ?, ?, 1, 'video', 'video', ?)";
                PreparedStatement videoStmt = conn.prepareStatement(insertVideoSql);
                videoStmt.setString(1, course2VideoTitles[i]);
                videoStmt.setString(2, course2Videos[i]);
                videoStmt.setInt(3, i + 1);
                videoStmt.setInt(4, 12 + (i * 2));
                videoStmt.executeUpdate();
                out.println("<p class='success'>✅ " + course2VideoTitles[i] + "</p>");
                videoStmt.close();
            }
            
            // Course 2 Reading lessons
            String[] course2ReadingTitles = {"Reading: Presentation Planning", "Reading: Public Speaking Confidence"};
            String[] course2ReadingContent = {
                "<h2>Presentation Planning</h2><p>Effective presentations start with thorough planning. This involves understanding your audience, defining clear objectives, and structuring your content logically.</p><h3>Key Planning Steps</h3><ul><li><strong>Audience Analysis:</strong> Understand who you're presenting to</li><li><strong>Objective Setting:</strong> Define what you want to achieve</li><li><strong>Content Organization:</strong> Structure your message logically</li><li><strong>Time Management:</strong> Plan your timing carefully</li></ul>",
                "<h2>Public Speaking Confidence</h2><p>Building confidence in public speaking is essential for effective presentations. This involves preparation, practice, and managing anxiety.</p><h3>Building Confidence</h3><ul><li><strong>Thorough Preparation:</strong> Know your material inside and out</li><li><strong>Practice Regularly:</strong> Rehearse your presentation multiple times</li><li><strong>Manage Anxiety:</strong> Use breathing techniques and positive visualization</li><li><strong>Start Small:</strong> Begin with smaller audiences and build up</li></ul>"
            };
            
            for (int i = 0; i < course2ReadingTitles.length; i++) {
                String insertReadingSql = "INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, content_file_path, content_type, estimated_time, content_text) VALUES (2, ?, NULL, ?, 1, 'reading', '/content/course2_reading" + (i+1) + ".html', 'reading', ?, ?)";
                PreparedStatement readingStmt = conn.prepareStatement(insertReadingSql);
                readingStmt.setString(1, course2ReadingTitles[i]);
                readingStmt.setInt(2, course2Videos.length + i + 1);
                readingStmt.setInt(3, 20 + (i * 5));
                readingStmt.setString(4, course2ReadingContent[i]);
                readingStmt.executeUpdate();
                out.println("<p class='success'>✅ " + course2ReadingTitles[i] + "</p>");
                readingStmt.close();
            }
            
            // Step 7: Verify everything
            out.println("<h3>🎉 Final Verification:</h3>");
            String verifySql = "SELECT c.id as course_id, c.title as course_title, COUNT(l.id) as lesson_count, COUNT(p.id) as package_count FROM courses c LEFT JOIN lessons l ON c.id = l.course_id LEFT JOIN packages p ON c.id = p.course_id WHERE c.id IN (1, 2) GROUP BY c.id, c.title ORDER BY c.id";
            PreparedStatement verifyStmt = conn.prepareStatement(verifySql);
            ResultSet verifyRs = verifyStmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>Course ID</th><th>Course Title</th><th>Lessons</th><th>Packages</th><th>Test</th></tr>");
            
            while (verifyRs.next()) {
                out.println("<tr>");
                out.println("<td>" + verifyRs.getInt("course_id") + "</td>");
                out.println("<td>" + verifyRs.getString("course_title") + "</td>");
                out.println("<td>" + verifyRs.getInt("lesson_count") + "</td>");
                out.println("<td>" + verifyRs.getInt("package_count") + "</td>");
                out.println("<td><a href='course-details?id=" + verifyRs.getInt("course_id") + "' target='_blank' class='success'>🚀 Test Course</a></td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            verifyRs.close();
            verifyStmt.close();
            conn.close();
            
            // Success message
            out.println("<div style='margin-top:20px; padding:15px; background-color:#d4edda; border:1px solid #c3e6cb; border-radius:5px;'>");
            out.println("<h4 style='color:#155724; margin:0 0 10px 0;'>✅ Complete Fix Successful!</h4>");
            out.println("<p style='margin:0;'><strong>Everything is now properly set up:</strong></p>");
            out.println("<ul style='margin:5px 0;'>");
            out.println("<li>✅ Subjects created</li>");
            out.println("<li>✅ Courses created</li>");
            out.println("<li>✅ Packages created (required by CourseDAO)</li>");
            out.println("<li>✅ Lessons properly organized</li>");
            out.println("<li>✅ No duplicate or orphaned lessons</li>");
            out.println("</ul>");
            out.println("<p><strong>Test the courses now:</strong></p>");
            out.println("<ul>");
            out.println("<li><a href='course-details?id=1' target='_blank'><strong>🎯 Test Course 1</strong></a></li>");
            out.println("<li><a href='course-details?id=2' target='_blank'><strong>🎯 Test Course 2</strong></a></li>");
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