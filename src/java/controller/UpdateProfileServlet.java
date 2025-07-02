/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import model.User;

/**
 *
 * @author Kaonashi
 */

@WebServlet("/update-profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 5 * 1024 * 1024,      // 5 MB
    maxRequestSize = 10 * 1024 * 1024   // 10 MB
)
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = null;
        
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            // User not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get form data
            String fullName = request.getParameter("fullName");
            String username = request.getParameter("username");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Validation
            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Full name is required");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            // Handle avatar upload (if provided)
            Part avatarPart = request.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String submittedFileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
                String ext = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                String avatarFileName = "avatar_" + user.getId() + "_" + System.currentTimeMillis() + ext;

                // Use relative path from web application
                String uploadPath = request.getServletContext().getRealPath("/uploads/images/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                avatarPart.write(uploadPath + File.separator + avatarFileName);
                user.setAvatarUrl("/uploads/images/" + avatarFileName);
            }

            // Update user information
            user.setFullName(fullName != null ? fullName.trim() : "");
            user.setUsername(username != null ? username.trim() : "");
            user.setGender(gender);
            user.setPhone(phone != null ? phone.trim() : "");
            user.setAddress(address != null ? address.trim() : "");

            // Update in database
            UserDAO userDAO = new UserDAO();
            userDAO.updateUser(user);

            // Update user in session
            session.setAttribute("user", user);
            session.setAttribute("userObj", user); // For compatibility

            // Success message
            request.setAttribute("success", "Profile updated successfully");

        } catch (Exception e) {
            System.err.println("Error updating profile: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to update profile. Please try again.");
        }

        // Redirect back to referring page
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
