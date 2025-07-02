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
@WebServlet(urlPatterns = {"/home", "/"})
public class HomeController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("=== HomeController Debug ===");
            
            HttpSession session = request.getSession(false);
            User user = null;

            if (session != null) {
                user = (User) session.getAttribute("user");
                if (user == null) {
                    user = (User) session.getAttribute("userObj");
                }
            }
            System.out.println("User: " + (user != null ? user.getFullName() : "Not logged in"));

            // Get sliders
            SliderDAO sliderDAO = new SliderDAO();
            List<Slider> sliders = sliderDAO.getAllSliders();
            System.out.println("Sliders count: " + (sliders != null ? sliders.size() : 0));

            // Get blogs
            BlogDAO blogDAO = new BlogDAO();
            List<Blog> hotBlogs = blogDAO.getHotBlogs();
            List<Blog> latestBlogs = blogDAO.getLatestBlogs();
            System.out.println("Hot blogs count: " + (hotBlogs != null ? hotBlogs.size() : 0));
            System.out.println("Latest blogs count: " + (latestBlogs != null ? latestBlogs.size() : 0));

            // Get subjects
            SubjectDAO subjectDAO = new SubjectDAO();
            List<Subject> featuredSubjects = subjectDAO.getFeaturedSubjects();
            List<Subject> recentSubjects = subjectDAO.getRecentSubjects(6);
            System.out.println("Featured subjects count: " + (featuredSubjects != null ? featuredSubjects.size() : 0));
            System.out.println("Recent subjects count: " + (recentSubjects != null ? recentSubjects.size() : 0));

            // Set attributes
            request.setAttribute("user", user);
            request.setAttribute("sliders", sliders != null ? sliders : new java.util.ArrayList<>());
            request.setAttribute("hotBlogs", hotBlogs != null ? hotBlogs : new java.util.ArrayList<>());
            request.setAttribute("latestBlogs", latestBlogs != null ? latestBlogs : new java.util.ArrayList<>());
            request.setAttribute("featuredSubjects", featuredSubjects != null ? featuredSubjects : new java.util.ArrayList<>());
            request.setAttribute("recentSubjects", recentSubjects != null ? recentSubjects : new java.util.ArrayList<>());

            System.out.println("=== Forwarding to home.jsp ===");
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in HomeController: " + e.getMessage());
            e.printStackTrace();
            
            // Set empty lists to prevent JSP errors
            request.setAttribute("sliders", new java.util.ArrayList<>());
            request.setAttribute("hotBlogs", new java.util.ArrayList<>());
            request.setAttribute("latestBlogs", new java.util.ArrayList<>());
            request.setAttribute("featuredSubjects", new java.util.ArrayList<>());
            request.setAttribute("recentSubjects", new java.util.ArrayList<>());
            request.setAttribute("error", "Database connection error: " + e.getMessage());
            
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
        }
    }
}