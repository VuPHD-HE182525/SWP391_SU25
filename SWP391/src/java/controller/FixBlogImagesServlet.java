package controller;

import DAO.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/fix-blog-images")
public class FixBlogImagesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Fix Blog Images</title>");
        out.println("<style>body { font-family: Arial, sans-serif; margin: 20px; }</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Fix Blog Images</h1>");
        
        try {
            DBContext dbContext = new DBContext();
            Connection conn = dbContext.getConnection();
            
            // Check current blog data
            out.println("<h2>Current Blog Data:</h2>");
            String selectSQL = "SELECT id, title, thumbnail_url FROM blogs LIMIT 10";
            try (PreparedStatement ps = conn.prepareStatement(selectSQL);
                 ResultSet rs = ps.executeQuery()) {
                
                out.println("<table border='1' style='border-collapse: collapse;'>");
                out.println("<tr><th>ID</th><th>Title</th><th>Thumbnail URL</th></tr>");
                
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("title") + "</td>");
                    out.println("<td>" + rs.getString("thumbnail_url") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            
            // Update blog thumbnails with working image URLs
            out.println("<h2>Updating Blog Images...</h2>");
            
            String[] imageUrls = {
                "https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400&h=200&fit=crop",
                "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop", 
                "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400&h=200&fit=crop",
                "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=200&fit=crop",
                "https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=400&h=200&fit=crop",
                "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=200&fit=crop",
                "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&h=200&fit=crop",
                "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400&h=200&fit=crop",
                "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=200&fit=crop",
                "https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400&h=200&fit=crop"
            };
            
            String updateSQL = "UPDATE blogs SET thumbnail_url = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSQL)) {
                for (int i = 0; i < imageUrls.length; i++) {
                    ps.setString(1, imageUrls[i]);
                    ps.setInt(2, i + 1);
                    int updated = ps.executeUpdate();
                    out.println("<p>Updated blog ID " + (i + 1) + ": " + updated + " rows affected</p>");
                }
            }
            
            // Insert sample blogs if none exist
            String countSQL = "SELECT COUNT(*) as total FROM blogs";
            try (PreparedStatement ps = conn.prepareStatement(countSQL);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next() && rs.getInt("total") == 0) {
                    out.println("<h2>No blogs found, inserting sample data...</h2>");
                    
                    String insertSQL = "INSERT INTO blogs (title, content, author_id, published_at, thumbnail_url) VALUES (?, ?, ?, NOW(), ?)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSQL)) {
                        String[] titles = {
                            "Latest Trends in Software Development",
                            "Getting Started with Java Programming", 
                            "Mastering Problem-Solving Skills",
                            "Effective Communication Skills for Developers",
                            "Introduction to Cloud Computing"
                        };
                        
                        String[] contents = {
                            "The software development landscape is constantly changing...",
                            "Java is one of the most popular programming languages...",
                            "Problem-solving is at the heart of programming...",
                            "Technical skills alone are not enough...",
                            "Cloud computing has revolutionized how we build..."
                        };
                        
                        for (int i = 0; i < titles.length; i++) {
                            insertPs.setString(1, titles[i]);
                            insertPs.setString(2, contents[i]);
                            insertPs.setInt(3, 1); // author_id = 1
                            insertPs.setString(4, imageUrls[i]);
                            int inserted = insertPs.executeUpdate();
                            out.println("<p>Inserted blog: " + titles[i] + " (" + inserted + " rows)</p>");
                        }
                    }
                }
            }
            
            // Show updated data
            out.println("<h2>Updated Blog Data:</h2>");
            try (PreparedStatement ps = conn.prepareStatement(selectSQL);
                 ResultSet rs = ps.executeQuery()) {
                
                out.println("<table border='1' style='border-collapse: collapse;'>");
                out.println("<tr><th>ID</th><th>Title</th><th>Thumbnail URL</th><th>Preview</th></tr>");
                
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("title") + "</td>");
                    out.println("<td>" + rs.getString("thumbnail_url") + "</td>");
                    out.println("<td><img src='" + rs.getString("thumbnail_url") + "' style='width:100px;height:50px;object-fit:cover;' alt='preview'></td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            
            conn.close();
            out.println("<h2 style='color: green;'>✓ Blog images fixed successfully!</h2>");
            out.println("<p><a href='blog-list'>View Blog List</a> | <a href='home'>Go to Home</a></p>");
            
        } catch (Exception e) {
            out.println("<h2 style='color: red;'>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        }
        
        out.println("</body>");
        out.println("</html>");
    }
}
