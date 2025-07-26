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

/**
 * Course Details Servlet - Handles course detail page display and registration feedback
 *
 * This servlet manages the comprehensive course detail view including course information,
 * registration status, package options, and related content. It provides a complete
 * course overview with registration functionality and user-specific features.
 *
 * Key Features:
 * - Course detail display with full information
 * - Registration status checking and feedback handling
 * - Package options display for course registration
 * - User authentication and registration state management
 * - Sidebar content with categories, featured subjects, and contacts
 * - Error handling for invalid course IDs and missing data
 * - Registration success/error message display
 *
 * URL Mappings: /course-details, /CourseDetailsServlet
 * Method: GET
 *
 * Request Parameters:
 * - courseId: Course ID for direct course lookup
 * - subjectId: Subject ID for course lookup (alternative to courseId)
 * - success: Registration success flag
 * - error: Registration error type
 * - registrationId: Registration ID for success confirmation
 *
 * @author SWP391 Team
 */
@WebServlet({"/course-details", "/CourseDetailsServlet"})
public class CourseDetailsServlet extends HttpServlet {

    /**
     * Handles GET requests for course detail page display
     *
     * Processing Flow:
     * 1. Extract and validate course/subject ID parameters
     * 2. Retrieve course information from database
     * 3. Process registration feedback parameters (success/error)
     * 4. Load sidebar content (categories, featured subjects, contacts)
     * 5. Retrieve available packages for course registration
     * 6. Check user authentication and registration status
     * 7. Set request attributes for JSP rendering
     * 8. Forward to course details JSP view
     *
     * @param request HTTP request with courseId or subjectId parameter
     * @param response HTTP response for course details page
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Step 1: Extract course identification parameters
        String courseIdStr = request.getParameter("courseId");      // Direct course ID lookup
        String subjectIdStr = request.getParameter("subjectId");    // Subject-based course lookup
        Course course = null;

        // Debug logging for troubleshooting
        System.out.println("CourseDetailsServlet - courseId: " + courseIdStr);
        System.out.println("CourseDetailsServlet - subjectId: " + subjectIdStr);

        try {
            // Step 2: Retrieve course information based on available parameters
            if (subjectIdStr != null && !subjectIdStr.trim().isEmpty()) {
                // Primary lookup method: Find course by subject ID
                int subjectId = Integer.parseInt(subjectIdStr);
                System.out.println("Searching course for subjectId: " + subjectId);
                course = CourseDAO.getCourseBySubjectId(subjectId);
                System.out.println("Found course: " + (course != null ? course.getTitle() : "null"));
            } else if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                // Alternative lookup method: Find course by direct course ID
                int courseId = Integer.parseInt(courseIdStr);
                System.out.println("Searching course for courseId: " + courseId);
                course = CourseDAO.getCourseById(courseId);
                System.out.println("Found course: " + (course != null ? course.getTitle() : "null"));
            } else {
                // No valid parameters provided
                System.out.println("No courseId or subjectId provided");
            }

            // Step 3: Process registration feedback parameters
            // These parameters are set by the registration servlet after processing
            String successParam = request.getParameter("success");
            String errorParam = request.getParameter("error");
            String registrationIdParam = request.getParameter("registrationId");

            // Handle registration success feedback
            if ("true".equals(successParam)) {
                String successMessage = "Registration successful!";
                if (registrationIdParam != null) {
                    successMessage += " Your registration ID is: " + registrationIdParam;
                }
                request.setAttribute("registrationSuccess", successMessage);
            }
            // Handle registration error feedback with specific error messages
            else if (errorParam != null) {
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

            // Step 4: Load sidebar content for page display
            List<Category> categories = CategoryDAO.getAll();              // Course categories for navigation
            List<Subject> featuredSubjects = SubjectDAO.getFeatured();     // Featured subjects for recommendations
            List<Contact> contacts = ContactDAO.getAll();                  // Contact information for support

            // Step 5: Retrieve available packages for course registration
            List<Package> packages = null;
            if (course != null) {
                // Load packages associated with the course's subject for registration options
                packages = PackageDAO.getPackagesBySubjectId(course.getSubjectId());
            }

            // Step 6: Check user authentication and registration status
            boolean isAlreadyRegistered = false;
            boolean isUserLoggedIn = false;
            HttpSession userSession = request.getSession(false);
            if (userSession != null) {
                model.User sessionUser = (model.User) userSession.getAttribute("user");
                if (sessionUser != null) {
                    isUserLoggedIn = true;
                    // Check if user is already registered for this course/subject
                    if (course != null) {
                        isAlreadyRegistered = DAO.RegistrationDAO.isUserRegisteredForSubject(sessionUser.getId(), course.getSubjectId());
                        System.out.println("User " + sessionUser.getId() + " registration status for subject " + course.getSubjectId() + ": " + isAlreadyRegistered);
                    }
                }
            }

            // Debug logging for user status
            System.out.println("User logged in: " + isUserLoggedIn + ", Already registered: " + isAlreadyRegistered);

            // Step 7: Set request attributes for JSP rendering
            request.setAttribute("course", course);                        // Main course information
            request.setAttribute("packages", packages);                    // Available packages for registration
            request.setAttribute("isAlreadyRegistered", isAlreadyRegistered); // User registration status
            request.setAttribute("isUserLoggedIn", isUserLoggedIn);        // User authentication status
            request.setAttribute("categories", categories);                // Sidebar categories
            request.setAttribute("featuredSubjects", featuredSubjects);    // Sidebar featured subjects
            request.setAttribute("contacts", contacts);                    // Sidebar contact information

            // Step 8: Handle case where course is not found
            if (course == null) {
                request.setAttribute("error", "Course not found");
            }

            // Step 9: Forward to course details JSP for rendering
            request.getRequestDispatcher("/WEB-INF/views/CourseDetails.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Handle invalid ID parameter format
            System.err.println("Invalid course/subject ID parameter: " + e.getMessage());
            request.setAttribute("error", "Invalid course ID");
            request.getRequestDispatcher("/WEB-INF/views/CourseDetails.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle any unexpected errors
            System.err.println("Error in CourseDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error loading course details", e);
        }
    }
} 