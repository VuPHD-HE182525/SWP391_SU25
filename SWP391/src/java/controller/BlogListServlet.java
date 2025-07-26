package controller;

import DAO.BlogDAO;
import DAO.CategoryDAO;
import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Blog;
import model.Category;
import model.User;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Blog List Servlet - Handles blog listing functionality with search, filtering, and pagination
 *
 * This servlet manages the display of blog posts in a paginated list format with various
 * filtering and sorting options. It provides a comprehensive blog browsing experience
 * including search functionality, author information, and sidebar content.
 *
 * Key Features:
 * - Paginated blog listing (6 blogs per page)
 * - Search functionality by blog title and content
 * - Sorting options (newest, oldest, popular)
 * - Author information mapping and display
 * - Sidebar with latest blogs
 * - Error handling for missing data
 * - Category support (currently disabled due to database schema)
 *
 * URL Mappings: /blog-list, /blogs
 * Method: GET
 *
 * Request Parameters:
 * - search: Search query string for filtering blogs
 * - sort: Sorting option (newest, oldest, popular)
 * - page: Current page number for pagination
 *
 * @author SWP391 Team
 */
@WebServlet({"/blog-list", "/blogs"})
public class BlogListServlet extends HttpServlet {

    // Data Access Objects for database operations
    private BlogDAO blogDAO = new BlogDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private UserDAO userDAO = new UserDAO();

    /**
     * Handles GET requests for blog list display
     *
     * Processing Flow:
     * 1. Extract and validate request parameters (search, sort, page)
     * 2. Set up pagination configuration (6 blogs per page)
     * 3. Retrieve filtered and sorted blogs from database
     * 4. Calculate pagination metadata (total pages, current page)
     * 5. Load author information for each blog
     * 6. Prepare sidebar content (latest blogs, categories)
     * 7. Set request attributes for JSP rendering
     * 8. Forward to blog list JSP view
     *
     * @param request HTTP request with optional search, sort, and page parameters
     * @param response HTTP response for blog list page
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Step 1: Extract and validate request parameters
            String searchQuery = request.getParameter("search");    // Search term for filtering blogs
            String sortBy = request.getParameter("sort");           // Sorting option (newest, oldest, popular)
            String pageStr = request.getParameter("page");          // Current page number for pagination

            // Note: Category functionality is currently disabled since the blogs table
            // doesn't have a category_id column in the current database schema
            Integer categoryId = null;

            // Step 2: Parse and validate page number
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    // Ensure page number is at least 1
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    // Default to page 1 if invalid page number provided
                    currentPage = 1;
                }
            }

            // Step 3: Set default sorting option
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "newest";  // Default to newest blogs first
            }

            // Step 4: Configure pagination settings
            int blogsPerPage = 6;                                   // Number of blogs to display per page
            int offset = (currentPage - 1) * blogsPerPage;          // Calculate database offset for pagination

            // Step 5: Retrieve blogs with applied filters and pagination
            List<Blog> blogs = getAllBlogsWithFilters(searchQuery, categoryId, sortBy, offset, blogsPerPage);
            int totalBlogs = getTotalBlogsCount(searchQuery, categoryId);
            int totalPages = (int) Math.ceil((double) totalBlogs / blogsPerPage);

            // Step 6: Prepare sidebar content
            // Get all categories for sidebar (currently disabled due to database schema limitations)
            List<Category> categories = new java.util.ArrayList<>();

            // Get latest blogs for sidebar display (separate from main paginated list)
            List<Blog> latestBlogs = blogDAO.getLatestBlogs();

            // Step 7: Build author information mapping
            // Create a map to store author details for efficient lookup in JSP
            Map<Integer, User> authorMap = new HashMap<>();

            // Populate author map for all blogs in current page
            for (Blog blog : blogs) {
                // Only fetch author data if not already cached
                if (!authorMap.containsKey(blog.getAuthorId())) {
                    try {
                        User author = userDAO.getUserById(blog.getAuthorId());
                        if (author != null) {
                            authorMap.put(blog.getAuthorId(), author);
                        }
                    } catch (Exception e) {
                        // Create default author profile if database lookup fails
                        User defaultAuthor = new User();
                        defaultAuthor.setId(blog.getAuthorId());
                        defaultAuthor.setFullName("Unknown Author");
                        defaultAuthor.setAvatarUrl("/uploads/images/default-avatar.svg");
                        authorMap.put(blog.getAuthorId(), defaultAuthor);
                    }
                }
            }

            // Category functionality is disabled since the blogs table doesn't have category_id column
            Category selectedCategory = null;

            // Step 8: Set request attributes for JSP rendering
            request.setAttribute("blogs", blogs);                      // Main blog list for current page
            request.setAttribute("categories", categories);             // Category list for sidebar (empty)
            request.setAttribute("latestBlogs", latestBlogs);          // Latest blogs for sidebar
            request.setAttribute("authorMap", authorMap);              // Author information mapping
            request.setAttribute("selectedCategory", selectedCategory); // Currently selected category (null)
            request.setAttribute("totalBlogs", totalBlogs);            // Total number of blogs for pagination
            request.setAttribute("currentPage", currentPage);          // Current page number
            request.setAttribute("totalPages", totalPages);            // Total number of pages
            request.setAttribute("searchQuery", searchQuery);          // Current search query
            request.setAttribute("sortBy", sortBy);                    // Current sorting option

            // Step 9: Forward to JSP view for rendering
            request.getRequestDispatcher("WEB-INF/views/blog_list.jsp").forward(request, response);

        } catch (Exception e) {
            // Handle any unexpected errors gracefully
            e.printStackTrace();
            response.sendError(500, "Error loading blog list");
        }
    }

    /**
     * Retrieve blogs with applied filters, sorting, and pagination
     *
     * This method delegates to the BlogDAO to fetch blogs based on the specified
     * criteria. It supports search functionality, category filtering (when available),
     * various sorting options, and pagination.
     *
     * @param searchQuery Search term to filter blogs by title and content
     * @param categoryId Category ID for filtering (currently not used due to schema limitations)
     * @param sortBy Sorting option (newest, oldest, popular)
     * @param offset Number of records to skip for pagination
     * @param limit Maximum number of records to return
     * @return List of blogs matching the specified criteria
     * @throws Exception if database error occurs during blog retrieval
     */
    private List<Blog> getAllBlogsWithFilters(String searchQuery, Integer categoryId, String sortBy, int offset, int limit) throws Exception {
        // Delegate to BlogDAO for database operations with filtering and pagination
        return blogDAO.getAllBlogsWithFilters(searchQuery, categoryId, sortBy, offset, limit);
    }

    /**
     * Get total count of blogs matching the specified filters
     *
     * This method is used for pagination calculations to determine the total
     * number of pages needed to display all matching blogs.
     *
     * @param searchQuery Search term to filter blogs by title and content
     * @param categoryId Category ID for filtering (currently not used due to schema limitations)
     * @return Total number of blogs matching the specified criteria
     * @throws Exception if database error occurs during count retrieval
     */
    private int getTotalBlogsCount(String searchQuery, Integer categoryId) throws Exception {
        // Delegate to BlogDAO for database operations to get total count
        return blogDAO.getTotalBlogsCount(searchQuery, categoryId);
    }
}
