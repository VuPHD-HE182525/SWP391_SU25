/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.LessonDAO;
import model.Lesson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author Kaonashi
 */
@WebServlet("/toggle-status")
public class ToggleStatusServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String lessonIdParam = request.getParameter("id");
            String subjectIdParam = request.getParameter("subjectId");

            if (lessonIdParam == null || subjectIdParam == null) {
                response.sendRedirect(request.getContextPath() + "/subjects");
                return;
            }

            int lessonId = Integer.parseInt(lessonIdParam);
            int subjectId = Integer.parseInt(subjectIdParam);

            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.getLessonById(lessonId);

            if (lesson == null) {
                response.sendRedirect(request.getContextPath() + "/lesson-list?subjectId=" + subjectId);
                return;
            }

            boolean currentStatus = lesson.isStatus();
            boolean newStatus = !currentStatus;

            lessonDAO.toggleStatus(lessonId, newStatus);

            response.sendRedirect(request.getContextPath() + "/lesson-list?subjectId=" + subjectId);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid lesson or subject ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/subjects");
        } catch (Exception e) {
            System.err.println("Error toggling lesson status: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Error toggling lesson status: " + e.getMessage());
        }
    }
}