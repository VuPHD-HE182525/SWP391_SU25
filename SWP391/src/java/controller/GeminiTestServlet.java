package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.GeminiService;
import java.io.IOException;

@WebServlet("/gemini-test")
public class GeminiTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h1>Gemini API Test</h1>");
        
        // Test simple chat
        try {
            String testMessage = "Hello, can you help me learn Java programming?";
            String aiResponse = GeminiService.simpleChat(testMessage);
            
            response.getWriter().println("<h3>Test Question:</h3>");
            response.getWriter().println("<p>" + testMessage + "</p>");
            
            response.getWriter().println("<h3>AI Response:</h3>");
            response.getWriter().println("<p>" + aiResponse + "</p>");
            
        } catch (Exception e) {
            response.getWriter().println("<h3>Error:</h3>");
            response.getWriter().println("<p style='color:red;'>" + e.getMessage() + "</p>");
            response.getWriter().println("<p>Make sure to set your Gemini API key in GeminiService.java</p>");
        }
        
        response.getWriter().println("</body></html>");
    }
} 