/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;


import DAO.BlogDAO;
import DAO.SliderDAO;
import DAO.SubjectDAO;
import DAO.UserDAO;
import model.Blog;
import model.Slider;
import model.Subject;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;
/**
 *
 * @author Kaonashi
 */
@WebServlet("")
public class HomeController extends HttpServlet{
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User user = null;

            if (session != null) {
                user = (User) session.getAttribute("userObj");
            }

            SliderDAO sliderDAO = new SliderDAO();
            List<Slider> sliders = sliderDAO.getAllSliders();

            BlogDAO blogDAO = new BlogDAO();
            List<Blog> hotPosts = blogDAO.getHotPosts();
            List<Blog> latestPosts = blogDAO.getLatestPosts();

            SubjectDAO subjectDAO = new SubjectDAO();
            List<Subject> featuredSubjects = subjectDAO.getFeaturedSubjects();

            request.setAttribute("user", user);  // **Thêm dòng này**
            request.setAttribute("sliders", sliders);
            request.setAttribute("hotPosts", hotPosts);
            request.setAttribute("latestPosts", latestPosts);
            request.setAttribute("featuredSubjects", featuredSubjects);

            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}