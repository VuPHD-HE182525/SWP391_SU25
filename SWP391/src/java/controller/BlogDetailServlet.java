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

@WebServlet(name = "BlogDetailServlet", urlPatterns = {"/blog_detail"})
public class BlogDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing blog id");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid blog id");
            return;
        }
        Blog blog = null;
        User author = null;
        Category category = null;
        try {
            BlogDAO blogDAO = new BlogDAO();
            blog = blogDAO.getBlogById(id);
            if (blog == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Blog not found");
                return;
            }
            author = UserDAO.getUserById(blog.getAuthorId());
            // Nếu có category_id thì lấy category, còn không thì null
            Integer categoryId = null;
            try {
                java.lang.reflect.Field f = blog.getClass().getDeclaredField("categoryId");
                f.setAccessible(true);
                categoryId = (Integer) f.get(blog);
            } catch (Exception ignore) {}
            if (categoryId != null) {
                category = CategoryDAO.getCategoryById(categoryId);
            }
            List<Blog> latestBlogs = blogDAO.getLatestBlogs();
            List<Category> categories = CategoryDAO.getAll();
            request.setAttribute("blog", blog);
            request.setAttribute("author", author);
            request.setAttribute("category", category);
            request.setAttribute("latestBlogs", latestBlogs);
            request.setAttribute("categories", categories);
        } catch (Exception e) {
            throw new ServletException(e);
        }
        request.getRequestDispatcher("WEB-INF/views/blog_detail.jsp").forward(request, response);
    }
} 