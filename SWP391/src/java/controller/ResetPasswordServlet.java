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

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/ResetPasswordServlet"})
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws jakarta.servlet.ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || token.isEmpty()) {
            request.setAttribute("message", "Invalid or missing reset token.");
            request.getRequestDispatcher("WEB-INF/views/reset_result.jsp").forward(request, response);
            return;
        }
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByResetToken(token);
        if (user == null || user.getResetTokenExpiry() == null || user.getResetTokenExpiry().isBefore(LocalDateTime.now())) {
            request.setAttribute("message", "Reset link is invalid or has expired.");
            request.getRequestDispatcher("WEB-INF/views/reset_result.jsp").forward(request, response);
            return;
        }
        // Token is valid, show reset form
        request.setAttribute("token", token);
        request.getRequestDispatcher("WEB-INF/views/reset_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws jakarta.servlet.ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");
        if (token == null || token.isEmpty()) {
            request.setAttribute("message", "Invalid or missing reset token.");
            request.getRequestDispatcher("WEB-INF/views/reset_result.jsp").forward(request, response);
            return;
        }
        if (password == null || confirm == null || !password.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("WEB-INF/views/reset_password.jsp").forward(request, response);
            return;
        }
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByResetToken(token);
        if (user == null || user.getResetTokenExpiry() == null || user.getResetTokenExpiry().isBefore(LocalDateTime.now())) {
            request.setAttribute("message", "Reset link is invalid or has expired.");
            request.getRequestDispatcher("WEB-INF/views/reset_result.jsp").forward(request, response);
            return;
        }
        // Update password (hashing recommended, here just plain for demo)
        boolean updated = userDAO.updatePassword(user.getId(), password); // Use the new method
        userDAO.clearResetToken(user.getId());
        if (updated) {
            request.setAttribute("message", "Your password has been reset successfully. You can now log in.");
        } else {
            request.setAttribute("message", "Failed to reset password. Please try again.");
        }
        request.getRequestDispatcher("WEB-INF/views/reset_result.jsp").forward(request, response);
    }
} 