package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/test-post")
public class TestPostServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Test POST Request</title></head>");
        out.println("<body>");
        out.println("<h1>Test POST Request</h1>");
        
        out.println("<form action='test-post' method='post'>");
        out.println("<input type='hidden' name='action' value='addComment'>");
        out.println("<input type='hidden' name='lessonId' value='21'>");
        out.println("<textarea name='commentText' placeholder='Enter comment'>Test comment</textarea><br><br>");
        out.println("<button type='submit'>Submit</button>");
        out.println("</form>");
        
        out.println("</body>");
        out.println("</html>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>POST Result</title></head>");
        out.println("<body>");
        out.println("<h1>POST Request Received</h1>");
        
        out.println("<p><strong>Action:</strong> " + request.getParameter("action") + "</p>");
        out.println("<p><strong>LessonId:</strong> " + request.getParameter("lessonId") + "</p>");
        out.println("<p><strong>CommentText:</strong> " + request.getParameter("commentText") + "</p>");
        
        out.println("<p><a href='lesson-view?lessonId=21'>Test redirect to lesson-view</a></p>");
        
        out.println("</body>");
        out.println("</html>");
    }
}
