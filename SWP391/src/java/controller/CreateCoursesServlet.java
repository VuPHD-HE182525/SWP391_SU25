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

@WebServlet("/create-courses")
public class CreateCoursesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Create Courses</title>");
        out.println("<style>body{font-family:Arial;margin:20px;} .success{color:green;} .error{color:red;} .info{color:blue;} table{border-collapse:collapse;width:100%;} th,td{border:1px solid #ddd;padding:8px;text-align:left;}</style>");
        out.println("</head><body>");
        out.println("<h2>🏗️ Create Courses & Subjects</h2>");
        
        try {
            Connection conn = DBContext.getConnection();
            
            // Step 1: Check and create subjects first
            out.println("<h3>📚 Creating Subjects:</h3>");
            
            // Check if subjects exist
            String checkSubjectSql = "SELECT COUNT(*) as count FROM subjects WHERE id IN (1, 2)";
            PreparedStatement checkStmt = conn.prepareStatement(checkSubjectSql);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int subjectCount = rs.getInt("count");
            
            if (subjectCount < 2) {
                // Create subjects
                String insertSubject1 = "INSERT INTO subjects (id, name, description, thumbnail_url, category_id, status, is_featured) VALUES (1, 'Communication & Soft Skills', 'Master essential communication skills including active listening, emotional intelligence, and effective interpersonal communication.', '/uploads/images/subject1.png', 1, 'active', 1) ON DUPLICATE KEY UPDATE name=VALUES(name)";
                PreparedStatement subj1Stmt = conn.prepareStatement(insertSubject1);
                int result1 = subj1Stmt.executeUpdate();
                if (result1 > 0) {
                    out.println("<p class='success'>✅ Created Subject 1: Communication & Soft Skills</p>");
                }
                subj1Stmt.close();
                
                String insertSubject2 = "INSERT INTO subjects (id, name, description, thumbnail_url, category_id, status, is_featured) VALUES (2, 'Presentation & Public Speaking', 'Develop confident presentation skills, public speaking techniques, and professional communication abilities.', '/uploads/images/subject2.jpg', 1, 'active', 1) ON DUPLICATE KEY UPDATE name=VALUES(name)";
                PreparedStatement subj2Stmt = conn.prepareStatement(insertSubject2);
                int result2 = subj2Stmt.executeUpdate();
                if (result2 > 0) {
                    out.println("<p class='success'>✅ Created Subject 2: Presentation & Public Speaking</p>");
                }
                subj2Stmt.close();
            } else {
                out.println("<p class='info'>📝 Subjects already exist</p>");
            }
            
            // Step 2: Check and create courses
            out.println("<h3>🎓 Creating Courses:</h3>");
            
            String checkCourseSql = "SELECT COUNT(*) as count FROM courses WHERE id IN (1, 2)";
            PreparedStatement checkCourseStmt = conn.prepareStatement(checkCourseSql);
            ResultSet courseRs = checkCourseStmt.executeQuery();
            courseRs.next();
            int courseCount = courseRs.getInt("count");
            
            if (courseCount < 2) {
                // Create Course 1
                String insertCourse1 = "INSERT INTO courses (id, subject_id, expert_id, title, description, thumbnail_url, brief_info) VALUES (1, 1, 1, 'Communication & Soft Skills Essentials', 'Comprehensive course covering active listening, emotional intelligence, and effective communication strategies for personal and professional success.', '/uploads/images/subject1.png', 'Learn essential communication skills through AI-powered lessons and interactive reading materials.') ON DUPLICATE KEY UPDATE title=VALUES(title)";
                PreparedStatement course1Stmt = conn.prepareStatement(insertCourse1);
                int courseResult1 = course1Stmt.executeUpdate();
                if (courseResult1 > 0) {
                    out.println("<p class='success'>✅ Created Course 1: Communication & Soft Skills Essentials</p>");
                }
                course1Stmt.close();
                
                // Create Course 2
                String insertCourse2 = "INSERT INTO courses (id, subject_id, expert_id, title, description, thumbnail_url, brief_info) VALUES (2, 2, 1, 'Presentation and Public Speaking Mastery', 'Master the art of presentations and public speaking with practical lessons covering planning, delivery, and confidence building techniques.', '/uploads/images/subject2.jpg', 'Develop confident presentation skills through comprehensive video lessons and practical exercises.') ON DUPLICATE KEY UPDATE title=VALUES(title)";
                PreparedStatement course2Stmt = conn.prepareStatement(insertCourse2);
                int courseResult2 = course2Stmt.executeUpdate();
                if (courseResult2 > 0) {
                    out.println("<p class='success'>✅ Created Course 2: Presentation and Public Speaking Mastery</p>");
                }
                course2Stmt.close();
            } else {
                out.println("<p class='info'>📝 Courses already exist</p>");
            }
            
            // Step 3: Show current subjects and courses
            out.println("<h3>📊 Current Subjects & Courses:</h3>");
            String showSql = "SELECT s.id as subject_id, s.name as subject_name, c.id as course_id, c.title as course_title FROM subjects s LEFT JOIN courses c ON s.id = c.subject_id WHERE s.id IN (1, 2) ORDER BY s.id";
            PreparedStatement showStmt = conn.prepareStatement(showSql);
            ResultSet showRs = showStmt.executeQuery();
            
            out.println("<table>");
            out.println("<tr><th>Subject ID</th><th>Subject Name</th><th>Course ID</th><th>Course Title</th><th>Actions</th></tr>");
            
            while (showRs.next()) {
                out.println("<tr>");
                out.println("<td>" + showRs.getInt("subject_id") + "</td>");
                out.println("<td>" + showRs.getString("subject_name") + "</td>");
                out.println("<td>" + (showRs.getInt("course_id") != 0 ? showRs.getInt("course_id") : "N/A") + "</td>");
                out.println("<td>" + (showRs.getString("course_title") != null ? showRs.getString("course_title") : "N/A") + "</td>");
                if (showRs.getInt("course_id") != 0) {
                    out.println("<td><a href='course-details?id=" + showRs.getInt("course_id") + "' target='_blank' class='success'>View Course</a></td>");
                } else {
                    out.println("<td>No Course</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
            
            showRs.close();
            showStmt.close();
            courseRs.close();
            checkCourseStmt.close();
            rs.close();
            checkStmt.close();
            conn.close();
            
            // Success message with next steps
            out.println("<div style='margin-top:20px; padding:15px; background-color:#d4edda; border:1px solid #c3e6cb; border-radius:5px;'>");
            out.println("<h4 style='color:#155724; margin:0 0 10px 0;'>✅ Courses Created Successfully!</h4>");
            out.println("<p style='margin:0;'>Now you can proceed to reorganize lessons:</p>");
            out.println("<ul style='margin:5px 0;'>");
            out.println("<li><a href='reorganize-courses' target='_blank'><strong>🔄 Reorganize Lessons</strong></a></li>");
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