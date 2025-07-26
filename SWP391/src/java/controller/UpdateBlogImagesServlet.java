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

@WebServlet("/update-blog-images")
public class UpdateBlogImagesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Update Blog Images</title>");
        out.println("<style>body { font-family: Arial, sans-serif; margin: 20px; }</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Update Blog Images with Local Files</h1>");
        
        try {
            DBContext dbContext = new DBContext();
            Connection conn = dbContext.getConnection();
            
            // Local image paths based on your uploads/images folder (with correct extensions)
            String[] localImagePaths = {
                "uploads/images/blog1.jpg",
                "uploads/images/blog2.jpg",
                "uploads/images/blog3.png",
                "uploads/images/blog4.png",
                "uploads/images/blog5.png",
                "uploads/images/blog6.jpg",
                "uploads/images/blog7.jpg",
                "uploads/images/blog8.jpg",
                "uploads/images/blog9.png",
                "uploads/images/blog10.jpg",
                "uploads/images/blog11.jpg",
                "uploads/images/blog12.png",
                "uploads/images/blog13.webp"
            };
            
            // Check current blog count
            String countSQL = "SELECT COUNT(*) as total FROM blogs";
            int totalBlogs = 0;
            try (PreparedStatement ps = conn.prepareStatement(countSQL);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalBlogs = rs.getInt("total");
                }
            }
            
            out.println("<p>Found " + totalBlogs + " blogs in database</p>");
            
            if (totalBlogs == 0) {
                // Insert sample blogs with local images
                out.println("<h2>No blogs found, creating sample blogs...</h2>");
                
                String[] titles = {
                    "Latest Trends in Software Development",
                    "Getting Started with Java Programming", 
                    "Mastering Problem-Solving Skills",
                    "Effective Communication Skills for Developers",
                    "Introduction to Cloud Computing",
                    "Understanding Database Design Principles",
                    "Building Your First Web Application",
                    "The Future of Online Learning",
                    "Teamwork Skills for Developers",
                    "Startup and Entrepreneurship",
                    "Presentation & Public Speaking",
                    "10 Soft Skills for IT World",
                    "The Importance of Continuous Learning"
                };
                
                String[] contents = {
                    "The software development landscape is constantly changing, with new frameworks, tools, and methodologies emerging regularly. This article explores the most significant trends shaping the industry today.",
                    "Java is one of the most popular programming languages in the world. In this comprehensive guide, we will explore the fundamentals of Java programming, from basic syntax to advanced concepts.",
                    "Problem-solving is at the heart of programming and software development. This article provides practical strategies and techniques to improve your analytical thinking.",
                    "Technical skills alone are not enough in today's collaborative development environment. Learn how to communicate effectively with team members, stakeholders, and clients.",
                    "Cloud computing has revolutionized how we build and deploy applications. This introduction covers the fundamental concepts, major providers, and practical guidance.",
                    "Database design is a fundamental skill for any developer working with data-driven applications. This comprehensive guide covers the essential principles of database design.",
                    "Creating your first web application can be both exciting and challenging. This step-by-step guide will walk you through the process of building a simple web application from scratch.",
                    "Online learning has revolutionized education, making knowledge accessible to millions of people worldwide. This article examines the current trends in e-learning.",
                    "Make the art of working effectively with others by understanding team dynamics, collaboration, and conflict resolution.",
                    "Entrepreneurship knowledge and skills for starting and running a successful business in the technology sector.",
                    "Learn to communicate clearly and confidently in personal and professional settings. Improve your listening, speaking, and writing abilities.",
                    "Nội dung blog về 10 kỹ năng mềm quan trọng trong lĩnh vực công nghệ thông tin.",
                    "In the rapidly evolving world of technology, continuous learning is not just beneficial—it is essential for career survival and growth."
                };
                
                String insertSQL = "INSERT INTO blogs (title, content, author_id, published_at, thumbnail_url) VALUES (?, ?, ?, DATE_SUB(NOW(), INTERVAL ? DAY), ?)";
                try (PreparedStatement insertPs = conn.prepareStatement(insertSQL)) {
                    for (int i = 0; i < titles.length && i < localImagePaths.length; i++) {
                        insertPs.setString(1, titles[i]);
                        insertPs.setString(2, contents[i]);
                        insertPs.setInt(3, 1); // author_id = 1
                        insertPs.setInt(4, i + 1); // published days ago
                        insertPs.setString(5, localImagePaths[i]);
                        int inserted = insertPs.executeUpdate();
                        out.println("<p>✓ Inserted: " + titles[i] + " with image " + localImagePaths[i] + "</p>");
                    }
                }
            } else {
                // Update existing blogs with local images
                out.println("<h2>Updating existing blogs with local images...</h2>");
                
                String updateSQL = "UPDATE blogs SET thumbnail_url = ? WHERE id = ?";
                try (PreparedStatement updatePs = conn.prepareStatement(updateSQL)) {
                    for (int i = 0; i < localImagePaths.length; i++) {
                        updatePs.setString(1, localImagePaths[i]);
                        updatePs.setInt(2, i + 1);
                        int updated = updatePs.executeUpdate();
                        if (updated > 0) {
                            out.println("<p>✓ Updated blog ID " + (i + 1) + " with image " + localImagePaths[i] + "</p>");
                        }
                    }
                }
            }
            
            // Show updated data with image previews
            out.println("<h2>Updated Blog Data:</h2>");
            String selectSQL = "SELECT id, title, thumbnail_url FROM blogs ORDER BY id LIMIT 15";
            try (PreparedStatement ps = conn.prepareStatement(selectSQL);
                 ResultSet rs = ps.executeQuery()) {
                
                out.println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                out.println("<tr><th>ID</th><th>Title</th><th>Thumbnail Path</th><th>Preview</th></tr>");
                
                while (rs.next()) {
                    String thumbnailUrl = rs.getString("thumbnail_url");
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("title") + "</td>");
                    out.println("<td>" + thumbnailUrl + "</td>");
                    out.println("<td>");
                    if (thumbnailUrl != null && !thumbnailUrl.isEmpty()) {
                        out.println("<img src='" + request.getContextPath() + "/" + thumbnailUrl + "' style='width:100px;height:60px;object-fit:cover;' alt='preview' onerror='this.style.display=\"none\"; this.nextSibling.style.display=\"inline\";'>");
                        out.println("<span style='display:none; color:red;'>Image not found</span>");
                    } else {
                        out.println("<span style='color:gray;'>No image</span>");
                    }
                    out.println("</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            
            conn.close();
            out.println("<h2 style='color: green;'>✓ Blog images updated successfully with local files!</h2>");
            out.println("<p><a href='blog-list'>View Blog List</a> | <a href='home'>Go to Home</a></p>");
            
        } catch (Exception e) {
            out.println("<h2 style='color: red;'>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        }
        
        out.println("</body>");
        out.println("</html>");
    }
}
