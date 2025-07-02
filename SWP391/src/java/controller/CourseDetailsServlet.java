package controller;

import jakarta.servlet.*;
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

public class CourseDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        String subjectIdStr = request.getParameter("subjectId");
        System.out.println("CourseDetailsServlet: courseId=" + courseIdStr + ", subjectId=" + subjectIdStr);
        Course course = null;

        try {
            int courseIdToFetch = -1;
            if (subjectIdStr != null) {
                int subjectId = Integer.parseInt(subjectIdStr);
                // This is a simplified approach. You might need a more robust way
                // to get the primary course for a subject if there can be multiple.
                // Assuming the first course found is the main one.
                courseIdToFetch = subjectId; // A temporary stand-in, assuming a 1-to-1 mapping for now.
                                             // In a real scenario, you'd query courses_2 for a course with this subject_id.
            } else if (courseIdStr != null) {
                courseIdToFetch = Integer.parseInt(courseIdStr);
            }

            if (courseIdToFetch != -1) {
                course = CourseDAO.getCourseById(courseIdToFetch);
            }
        } catch (NumberFormatException e) {
            // Log the error and handle it gracefully
            e.printStackTrace();
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
        
        request.getRequestDispatcher("/WEB-INF/views/CourseDetails.jsp").forward(request, response);

    }
} 