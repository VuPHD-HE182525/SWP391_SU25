package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/json-test")
public class JsonTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h1>JSON Library Test</h1>");
        
        try {
            // Test JSON library
            org.json.JSONObject test = new org.json.JSONObject();
            test.put("message", "JSON library is working!");
            test.put("timestamp", System.currentTimeMillis());
            
            response.getWriter().println("<h3>✅ JSON Library Test Passed:</h3>");
            response.getWriter().println("<p>" + test.toString() + "</p>");
            
        } catch (Exception e) {
            response.getWriter().println("<h3>❌ JSON Library Test Failed:</h3>");
            response.getWriter().println("<p style='color:red;'>" + e.getMessage() + "</p>");
            response.getWriter().println("<p>Make sure json-20250517.jar is properly added to project</p>");
        }
        
        response.getWriter().println("</body></html>");
    }
} 