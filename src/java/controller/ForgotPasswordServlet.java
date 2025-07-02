package controller;

import DAO.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;
import utils.MailUtil;

@WebServlet("/forgot-password-process")
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws jakarta.servlet.ServletException, IOException {
        String email = request.getParameter("email");
        String expiryTimeStr = request.getParameter("expiryTime");
        
        // Validate and parse expiry time
        int expiryHours = 3; // default to 3 hours
        try {
            if (expiryTimeStr != null && !expiryTimeStr.isEmpty()) {
                expiryHours = Integer.parseInt(expiryTimeStr);
                // Validate range (1-24 hours)
                if (expiryHours < 1 || expiryHours > 24) {
                    expiryHours = 3; // fallback to default
                }
            }
        } catch (NumberFormatException e) {
            // If parsing fails, use default
            expiryHours = 3;
        }
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);
        if (user == null) {
            request.setAttribute("message", "No user found with that email address.");
            request.getRequestDispatcher("/WEB-INF/views/reset_result.jsp").forward(request, response);
            return;
        }
        // Generate token and expiry based on user selection
        String token = UUID.randomUUID().toString();
        LocalDateTime expiry = LocalDateTime.now().plusHours(expiryHours);
        boolean updated = userDAO.setResetToken(email, token, expiry);
        if (!updated) {
            request.setAttribute("message", "Failed to generate reset link. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/reset_result.jsp").forward(request, response);
            return;
        }
        // Send email using MailUtil
        String resetLink = request.getRequestURL().toString().replace("forgot-password-process", "reset-password") + "?token=" + token;
        String htmlContent =
            "<div style='background:#222;padding:40px 0;'>" +
            "<div style='background:#fff;margin:0 auto;padding:40px 40px 60px 40px;max-width:600px;border-radius:6px;'>" +
            "<h2 style='text-align:center;'>Reset your Elearning password</h2>" +
            "<p style='margin-top:40px;'>We heard that you lost your Elearning password. Sorry about that!<br>" +
            "But don't worry! You can use the following button to reset your password:</p>" +
            "<div style='text-align:center;margin:40px 0;'>" +
            "<a href='" + resetLink + "' style='background:#333;color:#fff;padding:12px 32px;border-radius:7px;text-decoration:none;font-size:18px;'>Reset Password</a>" +
            "</div>" +
            "<p>If you don't use this link within " + expiryHours + " hour" + (expiryHours > 1 ? "s" : "") + ", it will expire.<br>Thanks,<br>The Elearning Team</p>" +
            "<div style='margin-top:40px;color:#888;'>The expired time: <b>" + expiryHours + " hour" + (expiryHours > 1 ? "s" : "") + "</b></div>" +
            "</div></div>";
        try {
            MailUtil.sendMail(user.getEmail(), "Reset your Elearning password", htmlContent);
        } catch (Exception e) {
            request.setAttribute("message", "Failed to send reset email. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/reset_result.jsp").forward(request, response);
            return;
        }
        // Show confirmation
        request.setAttribute("message", "A password reset link has been sent to your email. Please check your inbox.");
        request.getRequestDispatcher("/WEB-INF/views/reset_result.jsp").forward(request, response);
    }
} 