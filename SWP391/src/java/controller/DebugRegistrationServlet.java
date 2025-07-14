package controller;

import DAO.RegistrationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Registration;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/debug-registrations")
public class DebugRegistrationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            out.println("<html><head><title>Debug Registrations</title></head><body>");
            out.println("<h1>Debug Registrations Data</h1>");
            
            // Check if user is logged in
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                out.println("<p style='color:red;'>User not logged in!</p>");
                out.println("<a href='login'>Login</a>");
                out.println("</body></html>");
                return;
            }
            
            out.println("<h2>Current User Info:</h2>");
            out.println("<p>User ID: " + currentUser.getId() + "</p>");
            out.println("<p>User Name: " + currentUser.getFullName() + "</p>");
            out.println("<p>User Email: " + currentUser.getEmail() + "</p>");
            
            out.println("<h2>All Registrations for this User:</h2>");
            
            // Get registrations for current user
            List<Registration> registrations = RegistrationDAO.getRegistrationsByUserId(currentUser.getId());
            
            if (registrations.isEmpty()) {
                out.println("<p style='color:orange;'>No registrations found for user ID: " + currentUser.getId() + "</p>");
                
                // Check if there are any registrations at all for any user
                out.println("<h3>Checking all registrations in database...</h3>");
                try {
                    // Simple query to check if table has any data
                    List<Registration> allRegistrations = RegistrationDAO.getRegistrationsBySubjectId(0); // This might return all
                    out.println("<p>Total registrations in database: " + allRegistrations.size() + "</p>");
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error checking all registrations: " + e.getMessage() + "</p>");
                }
                
            } else {
                out.println("<p style='color:green;'>Found " + registrations.size() + " registrations!</p>");
                out.println("<table border='1'>");
                out.println("<tr><th>ID</th><th>Course/Subject ID</th><th>Package ID</th><th>Status</th><th>Date</th></tr>");
                
                for (Registration reg : registrations) {
                    out.println("<tr>");
                    out.println("<td>" + reg.getId() + "</td>");
                    out.println("<td>" + reg.getSubjectId() + "</td>");
                    out.println("<td>" + reg.getPackageId() + "</td>");
                    out.println("<td>" + reg.getStatus() + "</td>");
                    out.println("<td>" + (reg.getRegistrationDate() != null ? reg.getRegistrationDate().toString() : "null") + "</td>");
                    out.println("</tr>");
                }
                
                out.println("</table>");
            }
            
            out.println("<hr>");
            out.println("<h3>Quick Actions:</h3>");
            out.println("<a href='my-course'>Go to My Courses</a> | ");
            out.println("<a href='course-list'>Course List</a> | ");
            out.println("<a href='home'>Home</a>");
            
            out.println("</body></html>");
            
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        } finally {
            out.close();
        }
    }
} 