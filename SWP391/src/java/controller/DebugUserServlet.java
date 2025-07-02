package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/debug-user")
public class DebugUserServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>User Session Debug</title></head>");
        out.println("<body>");
        out.println("<h1>User Session Debug</h1>");
        
        // Get session
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            out.println("<p style='color: red'>❌ No session found</p>");
        } else {
            out.println("<p style='color: green'>✅ Session exists</p>");
            out.println("<p><strong>Session ID:</strong> " + session.getId() + "</p>");
            
            // Check user in session
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                out.println("<p style='color: red'>❌ No user in session</p>");
            } else {
                out.println("<p style='color: green'>✅ User found in session</p>");
                out.println("<h3>User Information:</h3>");
                out.println("<table border='1'>");
                out.println("<tr><th>Property</th><th>Value</th><th>Is Null?</th></tr>");
                
                out.println("<tr><td>ID</td><td>" + user.getId() + "</td><td>" + (user.getId() == 0) + "</td></tr>");
                out.println("<tr><td>Full Name</td><td>" + user.getFullName() + "</td><td>" + (user.getFullName() == null) + "</td></tr>");
                out.println("<tr><td>Email</td><td>" + user.getEmail() + "</td><td>" + (user.getEmail() == null) + "</td></tr>");
                out.println("<tr><td>Phone</td><td>" + user.getPhone() + "</td><td>" + (user.getPhone() == null) + "</td></tr>");
                out.println("<tr><td>Gender</td><td>" + user.getGender() + "</td><td>" + (user.getGender() == null) + "</td></tr>");
                out.println("<tr><td>Role</td><td>" + user.getRole() + "</td><td>" + (user.getRole() == null) + "</td></tr>");
                out.println("<tr><td>Username</td><td>" + user.getUsername() + "</td><td>" + (user.getUsername() == null) + "</td></tr>");
                
                out.println("</table>");
                
                // Check for potential problems
                out.println("<h3>Potential Issues:</h3>");
                out.println("<ul>");
                
                if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
                    out.println("<li style='color: red'>❌ Full Name is null or empty</li>");
                } else {
                    out.println("<li style='color: green'>✅ Full Name is OK</li>");
                }
                
                if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                    out.println("<li style='color: red'>❌ Email is null or empty</li>");
                } else {
                    out.println("<li style='color: green'>✅ Email is OK</li>");
                }
                
                if (user.getPhone() == null || user.getPhone().trim().isEmpty()) {
                    out.println("<li style='color: red'>❌ Phone is null or empty - THIS WILL CAUSE REGISTRATION TO FAIL</li>");
                } else {
                    out.println("<li style='color: green'>✅ Phone is OK</li>");
                }
                
                if (user.getGender() == null || user.getGender().trim().isEmpty()) {
                    out.println("<li style='color: red'>❌ Gender is null or empty - THIS WILL CAUSE REGISTRATION TO FAIL</li>");
                } else {
                    out.println("<li style='color: green'>✅ Gender is OK</li>");
                }
                
                out.println("</ul>");
            }
        }
        
        out.println("<br><hr>");
        out.println("<h3>Test Registration Modal Values:</h3>");
        out.println("<p>If any value shows 'null' below, registration will fail:</p>");
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                out.println("<p><strong>Hidden fullName value:</strong> '" + (user.getFullName() != null ? user.getFullName() : "null") + "'</p>");
                out.println("<p><strong>Hidden email value:</strong> '" + (user.getEmail() != null ? user.getEmail() : "null") + "'</p>");
                out.println("<p><strong>Hidden mobile value:</strong> '" + (user.getPhone() != null ? user.getPhone() : "null") + "'</p>");
                out.println("<p><strong>Hidden gender value:</strong> '" + (user.getGender() != null ? user.getGender() : "null") + "'</p>");
            }
        }
        
        out.println("<br><a href='" + request.getContextPath() + "/course-details?subjectId=1'>← Back to Course Details</a>");
        out.println("</body></html>");
    }
} 