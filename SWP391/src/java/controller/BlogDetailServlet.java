package controller;

import DAO.BlogDAO;
import DAO.UserDAO;
import DAO.CategoryDAO;
import model.Blog;
import model.User;
import model.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Blog Detail Servlet - Handles individual blog post display functionality
 *
 * This servlet manages the display of a single blog post with complete details
 * including author information, category data, and related content. It provides
 * a comprehensive blog reading experience with sidebar content and navigation.
 *
 * Key Features:
 * - Individual blog post retrieval and display
 * - Author information loading and display
 * - Category information (when available in database schema)
 * - Sidebar content with latest blogs and categories
 * - Error handling for missing or invalid blog IDs
 * - Reflection-based category handling for schema flexibility
 *
 * URL Mapping: /blog_detail
 * Method: GET
 *
 * Required Parameters:
 * - id: Blog ID to display (integer)
 *
 * @author SWP391 Team
 */
@WebServlet(name = "BlogDetailServlet", urlPatterns = {"/blog_detail"})
public class BlogDetailServlet extends HttpServlet {

    /**
     * Handles GET requests for individual blog post display
     *
     * Processing Flow:
     * 1. Extract and validate blog ID parameter
     * 2. Retrieve blog post from database
     * 3. Load author information for the blog
     * 4. Attempt to load category information (if available)
     * 5. Prepare sidebar content (latest blogs, categories)
     * 6. Set request attributes for JSP rendering
     * 7. Forward to blog detail JSP view
     *
     * @param request HTTP request with required 'id' parameter
     * @param response HTTP response for blog detail page
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Step 1: Extract and validate blog ID parameter
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing blog id");
            return;
        }

        // Step 2: Parse blog ID with error handling
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid blog id");
            return;
        }

        // Step 3: Initialize data objects for blog content
        Blog blog = null;
        User author = null;
        Category category = null;

        try {
            // Step 4: Retrieve blog post from database
            BlogDAO blogDAO = new BlogDAO();
            blog = blogDAO.getBlogById(id);

            // Verify blog exists
            if (blog == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Blog not found");
                return;
            }

            // Step 5: Load author information for the blog
            author = UserDAO.getUserById(blog.getAuthorId());

            // Step 6: Attempt to load category information using reflection
            // This approach handles the case where category_id field may or may not exist
            // in the Blog model depending on database schema evolution
            Integer categoryId = null;
            try {
                // Use reflection to check if categoryId field exists in Blog model
                java.lang.reflect.Field f = blog.getClass().getDeclaredField("categoryId");
                f.setAccessible(true);
                categoryId = (Integer) f.get(blog);
            } catch (Exception ignore) {
                // Field doesn't exist or is not accessible - this is expected
                // when the database schema doesn't include category support
            }

            // Load category information if category ID is available
            if (categoryId != null) {
                category = CategoryDAO.getCategoryById(categoryId);
            }

            // Step 7: Prepare sidebar content
            List<Blog> latestBlogs = blogDAO.getLatestBlogs();        // Latest blogs for sidebar
            List<Category> categories = CategoryDAO.getAll();         // All categories for navigation

            // Step 8: Set request attributes for JSP rendering
            request.setAttribute("blog", blog);                       // Main blog content
            request.setAttribute("author", author);                   // Author information
            request.setAttribute("category", category);               // Category information (may be null)
            request.setAttribute("latestBlogs", latestBlogs);         // Sidebar latest blogs
            request.setAttribute("categories", categories);           // Sidebar categories

        } catch (Exception e) {
            // Handle any database or processing errors
            throw new ServletException(e);
        }

        // Step 9: Forward to JSP view for rendering
        request.getRequestDispatcher("WEB-INF/views/blog_detail.jsp").forward(request, response);
    }
} 