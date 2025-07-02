package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Course;
import model.Category;
import model.Subject;
import model.Contact;
import model.Package;
import DAO.CourseDAO;
import DAO.CategoryDAO;
import DAO.SubjectDAO;
import DAO.ContactDAO;
import DAO.PackageDAO;
import java.util.List;

@WebServlet({"/course-details", "/CourseDetailsServlet"})
public class CourseDetailsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        String subjectIdStr = request.getParameter("subjectId");
        Course course = null;

        // Debug logging
        System.out.println("CourseDetailsServlet - courseId: " + courseIdStr);
        System.out.println("CourseDetailsServlet - subjectId: " + subjectIdStr);

        try {
            if (subjectIdStr != null && !subjectIdStr.trim().isEmpty()) {
                int subjectId = Integer.parseInt(subjectIdStr);
                System.out.println("Searching course for subjectId: " + subjectId);
                course = CourseDAO.getCourseBySubjectId(subjectId);
                System.out.println("Found course: " + (course != null ? course.getTitle() : "null"));
            } else if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                int courseId = Integer.parseInt(courseIdStr);
                System.out.println("Searching course for courseId: " + courseId);
                course = CourseDAO.getCourseById(courseId);
                System.out.println("Found course: " + (course != null ? course.getTitle() : "null"));
            } else {
                System.out.println("No courseId or subjectId provided");
            }
            
            // Check for success/error parameters from registration
            String successParam = request.getParameter("success");
            String errorParam = request.getParameter("error");
            String registrationIdParam = request.getParameter("registrationId");
            
            if ("true".equals(successParam)) {
                String successMessage = "Registration successful!";
                if (registrationIdParam != null) {
                    successMessage += " Your registration ID is: " + registrationIdParam;
                }
                request.setAttribute("registrationSuccess", successMessage);
            } else if (errorParam != null) {
                switch (errorParam) {
                    case "registration_failed":
                        request.setAttribute("registrationError", "Registration failed. Please try again later.");
                        break;
                    case "already_registered":
                        request.setAttribute("registrationError", "You are already registered for this subject.");
                        break;
                    case "validation_failed":
                        request.setAttribute("registrationError", "Please fill in all required fields correctly.");
                        break;
                    case "invalid_package":
                        request.setAttribute("registrationError", "Selected package is not available. Please choose another package.");
                        break;
                    case "incomplete_profile":
                        request.setAttribute("registrationError", "Your profile information is incomplete. Please update your profile with phone number and gender.");
                        break;
                    default:
                        request.setAttribute("registrationError", "An error occurred during registration.");
                        break;
                }
            }

            // Get additional data for sidebar
            List<Category> categories = CategoryDAO.getAll();
            List<Subject> featuredSubjects = SubjectDAO.getFeatured();
            List<Contact> contacts = ContactDAO.getAll();
            
            // Get packages for the course (for registration modal)
            List<Package> packages = null;
            if (course != null) {
                packages = PackageDAO.getPackagesBySubjectId(course.getSubjectId());
            }
            
            // Check if user is already registered for this subject (only if user is logged in)
            boolean isAlreadyRegistered = false;
            boolean isUserLoggedIn = false;
            HttpSession userSession = request.getSession(false);
            if (userSession != null) {
                model.User sessionUser = (model.User) userSession.getAttribute("user");
                if (sessionUser != null) {
                    isUserLoggedIn = true;
                    if (course != null) {
                        isAlreadyRegistered = DAO.RegistrationDAO.isUserRegisteredForSubject(sessionUser.getId(), course.getSubjectId());
                        System.out.println("User " + sessionUser.getId() + " registration status for subject " + course.getSubjectId() + ": " + isAlreadyRegistered);
                    }
                }
            }
            
            System.out.println("User logged in: " + isUserLoggedIn + ", Already registered: " + isAlreadyRegistered);
            
            // Set attributes
            request.setAttribute("course", course);
            request.setAttribute("packages", packages);
            request.setAttribute("isAlreadyRegistered", isAlreadyRegistered);
            request.setAttribute("isUserLoggedIn", isUserLoggedIn);
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