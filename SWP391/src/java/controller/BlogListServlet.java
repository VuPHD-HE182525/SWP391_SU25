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

@WebServlet({"/blog-list", "/blogs"})
public class BlogListServlet extends HttpServlet {
    
    private BlogDAO blogDAO = new BlogDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get parameters
            String searchQuery = request.getParameter("search");
            String sortBy = request.getParameter("sort");
            String pageStr = request.getParameter("page");

            // Note: Category functionality disabled since table doesn't have category_id column
            Integer categoryId = null;
            
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Set default sort
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "newest";
            }
            
            // Pagination settings
            int blogsPerPage = 6;
            int offset = (currentPage - 1) * blogsPerPage;
            
            // Get blogs with filters and pagination
            List<Blog> blogs = getAllBlogsWithFilters(searchQuery, categoryId, sortBy, offset, blogsPerPage);
            int totalBlogs = getTotalBlogsCount(searchQuery, categoryId);
            int totalPages = (int) Math.ceil((double) totalBlogs / blogsPerPage);
            
            // Get all categories for sidebar (disabled for now)
            List<Category> categories = new java.util.ArrayList<>();

            // Get latest blogs for sidebar (different from main list)
            List<Blog> latestBlogs = blogDAO.getLatestBlogs();

            // Create maps for authors
            Map<Integer, User> authorMap = new HashMap<>();
            
            // Populate author map
            for (Blog blog : blogs) {
                if (!authorMap.containsKey(blog.getAuthorId())) {
                    try {
                        User author = userDAO.getUserById(blog.getAuthorId());
                        if (author != null) {
                            authorMap.put(blog.getAuthorId(), author);
                        }
                    } catch (Exception e) {
                        // Create default author if not found
                        User defaultAuthor = new User();
                        defaultAuthor.setId(blog.getAuthorId());
                        defaultAuthor.setFullName("Unknown Author");
                        defaultAuthor.setAvatarUrl("/uploads/images/default-avatar.svg");
                        authorMap.put(blog.getAuthorId(), defaultAuthor);
                    }
                }
            }
            
            // Category functionality disabled since table doesn't have category_id column
            Category selectedCategory = null;
            
            // Set attributes
            request.setAttribute("blogs", blogs);
            request.setAttribute("categories", categories);
            request.setAttribute("latestBlogs", latestBlogs);
            request.setAttribute("authorMap", authorMap);
            request.setAttribute("selectedCategory", selectedCategory);
            request.setAttribute("totalBlogs", totalBlogs);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("sortBy", sortBy);
            
            // Forward to JSP
            request.getRequestDispatcher("WEB-INF/views/blog_list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error loading blog list");
        }
    }
    
    private List<Blog> getAllBlogsWithFilters(String searchQuery, Integer categoryId, String sortBy, int offset, int limit) throws Exception {
        // This method should be implemented in BlogDAO
        // For now, we'll use a simple approach
        return blogDAO.getAllBlogsWithFilters(searchQuery, categoryId, sortBy, offset, limit);
    }
    
    private int getTotalBlogsCount(String searchQuery, Integer categoryId) throws Exception {
        // This method should be implemented in BlogDAO
        // For now, we'll use a simple approach
        return blogDAO.getTotalBlogsCount(searchQuery, categoryId);
    }
}
