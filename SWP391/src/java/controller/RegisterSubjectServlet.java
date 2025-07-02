/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import DAO.PackageDAO;
import DAO.RegistrationDAO;
import DAO.SubjectDAO;
import model.Package;
import model.Registration;
import model.Subject;
import model.User;
import java.io.IOException;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.List;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author admin
 */
@WebServlet("/register")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 50,      // 50 MB
    maxRequestSize = 1024 * 1024 * 100    // 100 MB
)
public class RegisterSubjectServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method - Show registration form
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String subjectIdParam = request.getParameter("subjectId");
        if (subjectIdParam == null || subjectIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/subjects");
            return;
        }
        
        try {
            int subjectId = Integer.parseInt(subjectIdParam);
            
            // Get subject details
            SubjectDAO subjectDAO = new SubjectDAO();
            Subject subject = subjectDAO.getSubjectById(subjectId);
            if (subject == null) {
                request.setAttribute("error", "Subject not found");
                request.getRequestDispatcher("/WEB-INF/views/subjects.jsp").forward(request, response);
                return;
            }
            
            // Get packages for this subject
            List<Package> packages = PackageDAO.getPackagesBySubjectId(subjectId);
            
            // Check if user is logged in
            HttpSession session = request.getSession(false);
            User user = null;
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
            
            // Check if user is already registered for this subject
            boolean alreadyRegistered = false;
            if (user != null) {
                alreadyRegistered = RegistrationDAO.isUserRegisteredForSubject(user.getId(), subjectId);
            }
            
            // Set attributes for JSP
            request.setAttribute("subject", subject);
            request.setAttribute("packages", packages);
            request.setAttribute("user", user);
            request.setAttribute("alreadyRegistered", alreadyRegistered);
            
            request.getRequestDispatcher("/WEB-INF/views/register_course.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/subjects");
        } catch (Exception e) {
            System.err.println("Error in RegisterSubjectServlet GET: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/subjects");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method - Process registration
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("RegisterSubjectServlet doPost started");
        
        try {
            // Get form parameters
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String mobile = request.getParameter("mobile");
            String gender = request.getParameter("gender");
            String imageCaption = request.getParameter("imageCaption");
            String videoCaption = request.getParameter("videoCaption");
            
            System.out.println("Form parameters - subjectId: " + subjectId + ", packageId: " + packageId + 
                             ", fullName: " + fullName + ", email: " + email + ", mobile: " + mobile + ", gender: " + gender);
            
            // Validation - check parameters first
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() || 
                mobile == null || mobile.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty()) {
                
                System.out.println("Validation failed - missing required fields");
                System.out.println("fullName: '" + fullName + "', email: '" + email + "', mobile: '" + mobile + "', gender: '" + gender + "'");
                response.sendRedirect(request.getContextPath() + "/course-details?subjectId=" + subjectId + "&error=validation_failed");
                return;
            }
            
            // Additional validation for null values (from user session)
            if ("null".equals(fullName) || "null".equals(email) || "null".equals(mobile) || "null".equals(gender)) {
                System.out.println("Validation failed - null string values detected");
                System.out.println("fullName: '" + fullName + "', email: '" + email + "', mobile: '" + mobile + "', gender: '" + gender + "'");
                response.sendRedirect(request.getContextPath() + "/course-details?subjectId=" + subjectId + "&error=incomplete_profile");
                return;
            }
            
            // Basic email validation
            if (!email.contains("@") || !email.contains(".")) {
                System.out.println("Email validation failed: " + email);
                response.sendRedirect(request.getContextPath() + "/course-details?subjectId=" + subjectId + "&error=validation_failed");
                return;
            }
            
            // Normalize gender values
            if ("Nữ".equals(gender) || "nữ".equals(gender) || "female".equalsIgnoreCase(gender)) {
                gender = "Female";
                System.out.println("Normalized gender to: Female");
            } else if ("Nam".equals(gender) || "nam".equals(gender) || "male".equalsIgnoreCase(gender)) {
                gender = "Male";
                System.out.println("Normalized gender to: Male");
            } else if (!"Male".equals(gender) && !"Female".equals(gender) && !"Other".equals(gender)) {
                System.out.println("Invalid gender value: " + gender + " - setting to Other");
                gender = "Other";
            }
            
            System.out.println("Final gender value: " + gender);
            
            // Get current user (if logged in)
            HttpSession session = request.getSession(false);
            User user = null;
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
            
            System.out.println("Current user: " + (user != null ? "ID " + user.getId() + " (" + user.getEmail() + ")" : "not logged in"));
            
            // Debug: Print all form data as received
            System.out.println("=== FORM DATA DEBUG ===");
            System.out.println("subjectId: " + subjectId);
            System.out.println("packageId: " + packageId);
            System.out.println("fullName received: '" + fullName + "' (length: " + (fullName != null ? fullName.length() : "null") + ")");
            System.out.println("email received: '" + email + "' (length: " + (email != null ? email.length() : "null") + ")");
            System.out.println("mobile received: '" + mobile + "' (length: " + (mobile != null ? mobile.length() : "null") + ")");
            System.out.println("gender received: '" + gender + "' (length: " + (gender != null ? gender.length() : "null") + ")");
            System.out.println("======================");
            
            // Check for duplicate registration (by user ID or email)
            Integer userId = (user != null) ? user.getId() : null;
            if (RegistrationDAO.isDuplicateRegistration(userId, email, subjectId)) {
                if (user != null) {
                    System.out.println("User " + user.getId() + " already registered for subject " + subjectId);
                } else {
                    System.out.println("Email " + email + " already registered for subject " + subjectId);
                }
                response.sendRedirect(request.getContextPath() + "/course-details?subjectId=" + subjectId + "&error=already_registered");
                return;
            }
            
            // Handle file uploads
            String imagePath = null;
            String videoPath = null;
            
            try {
                // Handle image upload
                Part imagePart = request.getPart("profileImage");
                if (imagePart != null && imagePart.getSize() > 0) {
                    imagePath = saveUploadedFile(imagePart, "images", request);
                }
                
                // Handle video upload
                Part videoPart = request.getPart("profileVideo");
                if (videoPart != null && videoPart.getSize() > 0) {
                    videoPath = saveUploadedFile(videoPart, "videos", request);
                }
            } catch (Exception e) {
                System.err.println("Error handling file uploads: " + e.getMessage());
                // Continue with registration even if file upload fails
            }
            
            // Verify package exists
            try {
                Package selectedPackage = PackageDAO.getPackageById(packageId);
                if (selectedPackage == null) {
                    response.sendRedirect(request.getContextPath() + "/course-details?subjectId=" + subjectId + "&error=invalid_package");
                    return;
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/course-details?subjectId=" + subjectId + "&error=invalid_package");
                return;
            }
            
            // Create registration object
            Registration registration = new Registration();
            registration.setSubjectId(subjectId);
            registration.setPackageId(packageId);
            registration.setFullName(fullName.trim());
            registration.setEmail(email.trim());
            registration.setMobile(mobile.trim());
            registration.setGender(gender);
            registration.setStatus("pending");
            
            // Set media files if uploaded
            if (imagePath != null && !imagePath.trim().isEmpty()) {
                registration.setImageUrl(imagePath);
                if (imageCaption != null && !imageCaption.trim().isEmpty()) {
                    registration.setImageDescription(imageCaption.trim());
                }
            }
            if (videoPath != null && !videoPath.trim().isEmpty()) {
                registration.setVideoUrl(videoPath);
                if (videoCaption != null && !videoCaption.trim().isEmpty()) {
                    registration.setVideoDescription(videoCaption.trim());
                }
            }
            
            // Set user ID if logged in
            if (user != null) {
                registration.setUserId(user.getId());
            }
            
            // Create registration
            try {
                System.out.println("Attempting to create registration for subject " + subjectId + ", package " + packageId);
                System.out.println("Registration object details:");
                System.out.println("  - subjectId: " + registration.getSubjectId());
                System.out.println("  - packageId: " + registration.getPackageId());
                System.out.println("  - fullName: '" + registration.getFullName() + "'");
                System.out.println("  - email: '" + registration.getEmail() + "'");
                System.out.println("  - mobile: '" + registration.getMobile() + "'");
                System.out.println("  - gender: '" + registration.getGender() + "'");
                System.out.println("  - userId: " + registration.getUserId());
                System.out.println("  - status: " + registration.getStatus());
                
                int registrationId = RegistrationDAO.createRegistration(registration);
                
                System.out.println("RegistrationDAO.createRegistration returned: " + registrationId);
                
                if (registrationId > 0) {
                    System.out.println("Registration successful with ID: " + registrationId);
                    // Success - redirect back to course details with success parameter
                    String redirectUrl = request.getContextPath() + "/course-details?subjectId=" + subjectId + "&success=true&registrationId=" + registrationId;
                    System.out.println("Redirecting to: " + redirectUrl);
                    response.sendRedirect(redirectUrl);
                } else {
                    System.err.println("Registration failed - createRegistration returned " + registrationId);
                    // Error - redirect back to course details with error parameter
                    String redirectUrl = request.getContextPath() + "/course-details?subjectId=" + subjectId + "&error=registration_failed";
                    System.out.println("Redirecting to error page: " + redirectUrl);
                    response.sendRedirect(redirectUrl);
                }
            } catch (Exception e) {
                System.err.println("Exception during registration creation: " + e.getMessage());
                e.printStackTrace();
                // Registration creation failed
                String redirectUrl = request.getContextPath() + "/course-details?subjectId=" + subjectId + "&error=registration_failed";
                System.out.println("Redirecting to error page due to exception: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid number format in RegisterSubjectServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/subjects");
        } catch (Exception e) {
            System.err.println("Error in RegisterSubjectServlet POST: " + e.getMessage());
            e.printStackTrace();
            String subjectIdParam = request.getParameter("subjectId");
            if (subjectIdParam != null && !subjectIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/course-details?subjectId=" + subjectIdParam + "&error=registration_failed");
            } else {
                response.sendRedirect(request.getContextPath() + "/subjects");
            }
        }
    }
    
    /**
     * Saves uploaded file to the server
     * @param filePart the uploaded file part
     * @param subfolder the subfolder to save to (images/videos)
     * @param request the servlet request
     * @return the relative path to the saved file
     * @throws IOException if file save fails
     */
    private String saveUploadedFile(Part filePart, String subfolder, HttpServletRequest request) throws IOException {
        String fileName = extractFileName(filePart);
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }
        
        // Generate unique filename
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String fileExtension = getFileExtension(fileName);
        String uniqueFileName = subfolder + "_" + timestamp + "_" + System.currentTimeMillis() + fileExtension;
        
        // Get upload directory path
        String uploadPath = request.getServletContext().getRealPath("/uploads/" + subfolder);
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save file
        Path filePath = Paths.get(uploadPath, uniqueFileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        // Return relative path for database storage
        return "/uploads/" + subfolder + "/" + uniqueFileName;
    }
    
    /**
     * Extracts filename from content-disposition header
     */
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return null;
    }
    
    /**
     * Gets file extension from filename
     */
    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf(".");
        return (lastDotIndex == -1) ? "" : fileName.substring(lastDotIndex);
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Subject Registration Servlet - Handles course registration functionality";
    }
} 