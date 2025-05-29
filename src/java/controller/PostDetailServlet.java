/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.PostDAO;
import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.Post;

/**
 *
 * @author thang
 */
@WebServlet(name = "PostDetailServlet", urlPatterns = {"/post-detail"})
public class PostDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        System.out.println("--- PostDetailServlet: processRequest CALLED ---");
        String idParam = request.getParameter("id");
        System.out.println("--- PostDetailServlet: idParam = " + idParam + " ---");

        if (idParam == null || idParam.trim().isEmpty()) {
            System.out.println("--- PostDetailServlet: ID is null or empty. Redirecting to /blogs (hoặc trang chủ) ---");
            response.sendRedirect(request.getContextPath() + "/blogs"); // Hoặc trang chủ nếu bạn chưa có /blogs
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            System.out.println("--- PostDetailServlet: Parsed postId = " + postId + " ---");

            PostDAO postDAO = new PostDAO();
            Post post = postDAO.getPostById(postId);
            List<Post> latestPosts = postDAO.getTop3Posts();
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> categoryList = categoryDAO.getAllCategories();

            if (post != null) {
                System.out.println("--- PostDetailServlet: Post FOUND: " + post.getTitle() + " ---");
                request.setAttribute("post", post);
                request.setAttribute("categoryList", categoryList);
                request.setAttribute("latestPosts", latestPosts);
                System.out.println("--- PostDetailServlet: Forwarding to postDetail.jsp ---");
                request.getRequestDispatcher("postDetail.jsp").forward(request, response);
            } else {
                System.out.println("--- PostDetailServlet: Post NOT FOUND for ID " + postId + ". Redirecting to /blogs (hoặc trang chủ) ---");
                response.sendRedirect(request.getContextPath() + "/blogs"); // Hoặc trang chủ
            }
        } catch (NumberFormatException e) {
            System.out.println("--- PostDetailServlet: Invalid ID format. Redirecting to /blogs (hoặc trang chủ) ---");
            response.sendRedirect(request.getContextPath() + "/blogs"); // Hoặc trang chủ
        } catch (Exception e) {
            System.out.println("--- PostDetailServlet: Generic Exception. ---");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
