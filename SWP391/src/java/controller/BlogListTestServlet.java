package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/blog-test")
public class BlogListTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Blog Test</title>");
        out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css' rel='stylesheet'>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container py-5'>");
        out.println("<h1>Blog System Test</h1>");
        
        try {
            // Test database connection
            out.println("<div class='alert alert-info'>Testing database connection...</div>");
            
            // Test BlogDAO
            DAO.BlogDAO blogDAO = new DAO.BlogDAO();
            java.util.List<model.Blog> blogs = blogDAO.getLatestBlogs();
            
            out.println("<div class='alert alert-success'>✓ BlogDAO connection successful</div>");
            out.println("<p>Found " + blogs.size() + " blogs</p>");
            
            if (!blogs.isEmpty()) {
                out.println("<h3>Sample Blogs:</h3>");
                out.println("<ul>");
                for (model.Blog blog : blogs) {
                    out.println("<li>" + blog.getTitle() + " (ID: " + blog.getId() + ")</li>");
                }
                out.println("</ul>");
            }
            
            // Test CategoryDAO
            java.util.List<model.Category> categories = DAO.CategoryDAO.getAll();
            out.println("<div class='alert alert-success'>✓ CategoryDAO connection successful</div>");
            out.println("<p>Found " + categories.size() + " categories</p>");
            
            if (!categories.isEmpty()) {
                out.println("<h3>Categories:</h3>");
                out.println("<ul>");
                for (model.Category category : categories) {
                    out.println("<li>" + category.getName() + " (ID: " + category.getId() + ")</li>");
                }
                out.println("</ul>");
            }
            
            out.println("<hr>");
            out.println("<h3>Next Steps:</h3>");
            out.println("<ol>");
            out.println("<li>If you see blogs and categories above, the blog list should work</li>");
            out.println("<li>If no data, run the SQL script: <code>add_sample_blogs.sql</code></li>");
            out.println("<li>Then test: <a href='blog-list' class='btn btn-primary'>Blog List Page</a></li>");
            out.println("</ol>");
            
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>❌ Error: " + e.getMessage() + "</div>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
