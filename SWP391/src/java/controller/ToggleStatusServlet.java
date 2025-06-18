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
@WebServlet(name = "ToggleStatusServlet", urlPatterns = {"/toggleStatus"})
public class ToggleStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        try {
            int lessonId = Integer.parseInt(request.getParameter("id"));
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));

            LessonDAO dao = new LessonDAO();
            Lesson lesson = dao.getLessonById(lessonId);

            boolean currentStatus = lesson.isStatus();
            boolean newStatus = !currentStatus;

            dao.toggleStatus(lessonId, newStatus);

            response.sendRedirect("lesson-list?subjectId=" + subjectId);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi đổi trạng thái lesson: " + e.getMessage());
        }
    }
}