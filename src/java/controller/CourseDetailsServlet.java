package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Course;
import model.Category;
import model.Subject;
import model.Contact;
import DAO.CourseDAO;
import DAO.CategoryDAO;
import DAO.SubjectDAO;
import DAO.ContactDAO;
import java.util.List;

@WebServlet("/course-details")
public class CourseDetailsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        String subjectIdStr = request.getParameter("subjectId");
        Course course = null;

        try {
            int courseIdToFetch = -1;
            
            if (subjectIdStr != null && !subjectIdStr.trim().isEmpty()) {
                int subjectId = Integer.parseInt(subjectIdStr);
                // Get course by subject ID (assuming subject_id maps to course_id)
                courseIdToFetch = subjectId;
            } else if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                courseIdToFetch = Integer.parseInt(courseIdStr);
            }

            if (courseIdToFetch != -1) {
                course = CourseDAO.getCourseById(courseIdToFetch);
            }

            // Get additional data for sidebar
            List<Category> categories = CategoryDAO.getAll();
            
            // Fetch all subjects to pass to getFeatured
            List<Subject> allSubjects = SubjectDAO.getSubjectsForMainContent(null, null, 1, Integer.MAX_VALUE);
            List<Subject> featuredSubjects = SubjectDAO.getFeatured(allSubjects);
            List<Contact> contacts = ContactDAO.getAll();
            
            // Set attributes
            request.setAttribute("course", course);
            request.setAttribute("categories", categories);
            request.setAttribute("featuredSubjects", featuredSubjects);
            request.setAttribute("contacts", contacts);
            
            // Handle case where course is not found
            if (course == null) {
                request.setAttribute("error", "Course not found");
            }
            
            request.getRequestDispatcher("/WEB-INF/views/CourseDetails.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid course/subject ID parameter: " + e.getMessage());
            request.setAttribute("error", "Invalid course ID");
            request.getRequestDispatcher("/WEB-INF/views/CourseDetails.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in CourseDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error loading course details", e);
        }
    }
} 