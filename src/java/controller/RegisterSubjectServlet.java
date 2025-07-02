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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author admin
 */
@WebServlet("/register")
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
            Subject subject = SubjectDAO.getSubjectById(subjectId);
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
        
        try {
            // Get form parameters
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String mobile = request.getParameter("mobile");
            String gender = request.getParameter("gender");
            
            // Validation
            StringBuilder errors = new StringBuilder();
            if (fullName == null || fullName.trim().isEmpty()) {
                errors.append("Full name is required. ");
            }
            if (email == null || email.trim().isEmpty() || !email.contains("@")) {
                errors.append("Valid email is required. ");
            }
            if (mobile == null || mobile.trim().isEmpty()) {
                errors.append("Mobile number is required. ");
            }
            if (gender == null || gender.trim().isEmpty()) {
                errors.append("Gender is required. ");
            }
            
            // If validation errors, redirect back with errors
            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString());
                doGet(request, response); // Re-show form with error
                return;
            }
            
            // Get current user (if logged in)
            HttpSession session = request.getSession(false);
            User user = null;
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
            
            // Check if already registered (for logged-in users)
            if (user != null && RegistrationDAO.isUserRegisteredForSubject(user.getId(), subjectId)) {
                request.setAttribute("error", "You are already registered for this subject.");
                doGet(request, response);
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
            
            // Set user ID if logged in
            if (user != null) {
                registration.setUserId(user.getId());
            }
            
            // Create registration
            int registrationId = RegistrationDAO.createRegistration(registration);
            
            if (registrationId > 0) {
                // Success - redirect to success page
                request.setAttribute("success", "Registration successful! Your registration ID is: " + registrationId);
                request.setAttribute("registrationId", registrationId);
                
                // Get subject and package info for confirmation
                Subject subject = SubjectDAO.getSubjectById(subjectId);
                Package selectedPackage = PackageDAO.getPackageById(packageId);
                request.setAttribute("subject", subject);
                request.setAttribute("selectedPackage", selectedPackage);
                
                request.getRequestDispatcher("/WEB-INF/views/register_course.jsp").forward(request, response);
            } else {
                // Error - show error message
                request.setAttribute("error", "Registration failed. Please try again later.");
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid subject or package selected.");
            response.sendRedirect(request.getContextPath() + "/subjects");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred during registration. Please try again.");
            doGet(request, response);
        }
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