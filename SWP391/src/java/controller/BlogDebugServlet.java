package controller;

import DAO.BlogDAO;
import model.Blog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/blog-debug")
public class BlogDebugServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Blog Debug</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println(".blog { border: 1px solid #ccc; margin: 10px 0; padding: 10px; }");
        out.println(".thumbnail { max-width: 200px; max-height: 100px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Blog Debug Information</h1>");
        
        try {
            BlogDAO blogDAO = new BlogDAO();
            List<Blog> blogs = blogDAO.getLatestBlogs();
            
            out.println("<h2>Latest Blogs (" + blogs.size() + " found)</h2>");
            
            if (blogs.isEmpty()) {
                out.println("<p style='color: red;'>No blogs found in database!</p>");
            } else {
                for (Blog blog : blogs) {
                    out.println("<div class='blog'>");
                    out.println("<h3>ID: " + blog.getId() + " - " + blog.getTitle() + "</h3>");
                    out.println("<p><strong>Thumbnail URL:</strong> " + blog.getThumbnailUrl() + "</p>");
                    
                    if (blog.getThumbnailUrl() != null && !blog.getThumbnailUrl().isEmpty()) {
                        out.println("<p><strong>Image Preview:</strong></p>");
                        out.println("<img src='" + blog.getThumbnailUrl() + "' class='thumbnail' alt='Blog thumbnail' onerror='this.style.display=\"none\"; this.nextSibling.style.display=\"block\";'>");
                        out.println("<p style='display:none; color:red;'>Image failed to load!</p>");
                    } else {
                        out.println("<p style='color: orange;'>No thumbnail URL set</p>");
                    }
                    
                    out.println("<p><strong>Author ID:</strong> " + blog.getAuthorId() + "</p>");
                    out.println("<p><strong>Published At:</strong> " + blog.getPublishedAt() + "</p>");
                    out.println("<p><strong>Content Preview:</strong> " + 
                               (blog.getContent() != null ? blog.getContent().substring(0, Math.min(100, blog.getContent().length())) + "..." : "No content"));
                    out.println("</div>");
                }
            }
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("</body>");
        out.println("</html>");
    }
}
