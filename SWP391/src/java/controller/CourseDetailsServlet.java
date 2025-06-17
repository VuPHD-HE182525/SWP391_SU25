package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Course;
import model.Category;
import model.Subject;
import model.Contact;
import dao.CourseDAO;
import dao.CategoryDAO;
import dao.SubjectDAO;
import dao.ContactDAO;
import java.util.List;

public class CourseDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        String subjectIdStr = request.getParameter("subjectId");
        System.out.println("CourseDetailsServlet: courseId=" + courseIdStr + ", subjectId=" + subjectIdStr);
        Course course = null;
        if (subjectIdStr != null) {
            try {
                int subjectId = Integer.parseInt(subjectIdStr);
                System.out.println("Attempting to load course for subjectId: " + subjectId);
                course = CourseDAO.getMainCourseBySubjectId(subjectId); 
                System.out.println("Loaded by subjectId: " + course);
                if (course != null) {
                    System.out.println("Course details:");
                    System.out.println("- ID: " + course.getId());
                    System.out.println("- Title: " + course.getTitle());
                    System.out.println("- Description: " + course.getDescription());
                    System.out.println("- Subject ID: " + course.getSubjectId());
                    System.out.println("- Thumbnail: " + course.getThumbnailUrl());
                    if (course.getCoursePackage() != null) {
                        System.out.println("- Package: " + course.getCoursePackage().getName());
                        System.out.println("- Price: " + course.getCoursePackage().getSalePrice());
                    } else {
                        System.out.println("- No package found");
                    }
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid subjectId format: " + subjectIdStr);
            }
        } else if (courseIdStr != null) {
            try {
            int courseId = Integer.parseInt(courseIdStr);
            course = CourseDAO.getCourseById(courseId);
            System.out.println("Loaded by courseId: " + course);
            } catch (NumberFormatException e) {
                System.out.println("Invalid courseId format: " + courseIdStr);
            }
        } else {
            System.out.println("No courseId or subjectId provided.");
        }
        if (course != null) {
            System.out.println("Course title: " + course.getTitle());
            System.out.println("Course package: " + course.getCoursePackage());
            System.out.println("Course description: " + course.getDescription());
            System.out.println("Course thumbnail: " + course.getThumbnailUrl());
            System.out.println("Course subject ID: " + course.getSubjectId());
        } else {
            System.out.println("No course found for the given ID.");
        }
        // Get additional data for sidebar
        List<Category> categories = CategoryDAO.getAll();
        List<Subject> featuredSubjects = SubjectDAO.getFeatured();
        List<Contact> contacts = ContactDAO.getAll();
        
        // Set attributes
        request.setAttribute("course", course);
        request.setAttribute("categories", categories);
        request.setAttribute("featuredSubjects", featuredSubjects);
        request.setAttribute("contacts", contacts);
        
        request.getRequestDispatcher("/views/CourseDetails.jsp").forward(request, response);
    }
} 