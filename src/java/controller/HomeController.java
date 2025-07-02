/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.BlogDAO;
import DAO.SliderDAO;
import DAO.SubjectDAO;
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
@WebServlet({"/", "/home"})
public class HomeController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User user = null;

            if (session != null) {
                user = (User) session.getAttribute("user");
                // Also check userObj for compatibility
                if (user == null) {
                    user = (User) session.getAttribute("userObj");
                }
            }

            SliderDAO sliderDAO = new SliderDAO();
            List<Slider> sliders = sliderDAO.getAllSliders();

            BlogDAO blogDAO = new BlogDAO();
            List<Blog> hotBlogs = blogDAO.getHotBlogs();
            List<Blog> latestBlogs = blogDAO.getLatestBlogs();

            SubjectDAO subjectDAO = new SubjectDAO();
            List<Subject> featuredSubjects = subjectDAO.getFeaturedSubjects();
            List<Subject> recentSubjects = subjectDAO.getRecentSubjects(6);

            request.setAttribute("user", user);
            request.setAttribute("sliders", sliders);
            request.setAttribute("hotBlogs", hotBlogs);
            request.setAttribute("latestBlogs", latestBlogs);
            request.setAttribute("featuredSubjects", featuredSubjects);
            request.setAttribute("recentSubjects", recentSubjects);

            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in HomeController: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error loading home page", e);
        }
    }
}