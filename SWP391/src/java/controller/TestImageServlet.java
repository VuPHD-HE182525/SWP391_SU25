package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test-images")
public class TestImageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Test Blog Images</title>");
        out.println("<style>body { font-family: Arial, sans-serif; margin: 20px; }</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Test Blog Images</h1>");
        
        String contextPath = request.getContextPath();
        out.println("<p>Context Path: " + contextPath + "</p>");
        
        // Test different image paths
        String[] imagePaths = {
            "uploads/images/blog1.jpg",
            "uploads/images/blog2.jpg", 
            "uploads/images/blog3.png",
            "uploads/images/blog4.png",
            "uploads/images/blog5.png"
        };
        
        out.println("<h2>Testing Image Paths:</h2>");
        out.println("<table border='1' style='border-collapse: collapse;'>");
        out.println("<tr><th>Path</th><th>Full URL</th><th>Preview</th></tr>");
        
        for (String imagePath : imagePaths) {
            String fullUrl = contextPath + "/" + imagePath;
            out.println("<tr>");
            out.println("<td>" + imagePath + "</td>");
            out.println("<td>" + fullUrl + "</td>");
            out.println("<td>");
            out.println("<img src='" + fullUrl + "' style='width:100px;height:60px;object-fit:cover;' alt='test' ");
            out.println("onload='this.nextSibling.innerHTML=\"✓ Loaded\"' ");
            out.println("onerror='this.nextSibling.innerHTML=\"✗ Failed to load\"'>");
            out.println("<span style='margin-left:10px;'>Loading...</span>");
            out.println("</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
        // Test direct access
        out.println("<h2>Direct Access Test:</h2>");
        out.println("<p>Try accessing images directly:</p>");
        out.println("<ul>");
        for (String imagePath : imagePaths) {
            String fullUrl = contextPath + "/" + imagePath;
            out.println("<li><a href='" + fullUrl + "' target='_blank'>" + fullUrl + "</a></li>");
        }
        out.println("</ul>");
        
        out.println("<h2>Alternative Paths Test:</h2>");
        out.println("<table border='1' style='border-collapse: collapse;'>");
        out.println("<tr><th>Alternative Path</th><th>Preview</th></tr>");
        
        // Test without context path
        for (String imagePath : imagePaths) {
            out.println("<tr>");
            out.println("<td>/" + imagePath + "</td>");
            out.println("<td>");
            out.println("<img src='/" + imagePath + "' style='width:100px;height:60px;object-fit:cover;' alt='test' ");
            out.println("onload='this.nextSibling.innerHTML=\"✓ Loaded\"' ");
            out.println("onerror='this.nextSibling.innerHTML=\"✗ Failed\"'>");
            out.println("<span style='margin-left:10px;'>Loading...</span>");
            out.println("</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
        out.println("<p><a href='blog-list'>Back to Blog List</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}
