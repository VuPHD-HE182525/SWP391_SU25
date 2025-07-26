/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LogoutServlet - Handles user logout functionality
 * Invalidates session and redirects to home page
 * 
 * @author admin
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }
    
    /**
     * Handles the logout process
     * - Invalidates the current session
     * - Redirects to home page
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get current session
            HttpSession session = request.getSession(false);
            
            // If session exists, invalidate it
            if (session != null) {
                System.out.println("Logging out user: " + session.getAttribute("user"));
                session.invalidate();
            }
            
            // Redirect to home page
            response.sendRedirect(request.getContextPath() + "/home");
            
        } catch (Exception e) {
            e.printStackTrace();
            // Even if there's an error, redirect to home
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
