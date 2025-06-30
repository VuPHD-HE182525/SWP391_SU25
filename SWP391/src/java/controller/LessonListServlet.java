/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.LessonDAO;
import DAO.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Lesson;
import model.Subject;

/**
 *
 * @author Kaonashi
 */
@WebServlet(name = "LessonListServlet", urlPatterns = {"/lesson-list"})
public class LessonListServlet extends HttpServlet {

    /**
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String courseIdRaw = request.getParameter("subjectId");
            String groupIdRaw = request.getParameter("groupId");
            String statusRaw = request.getParameter("status");
            String keyword = request.getParameter("keyword");

            int subjectId = Integer.parseInt(courseIdRaw);

            LessonDAO lessonDAO = new LessonDAO();
            List<Lesson> lessons = lessonDAO.getLessonsBySubject(subjectId);

            List<Lesson> unassignedLessons = lessonDAO.getUnassignedLessons(subjectId);
            request.setAttribute("unassignedLessons", unassignedLessons);

            if (groupIdRaw != null && !groupIdRaw.isEmpty()) {
                int parentId = Integer.parseInt(groupIdRaw);
                lessons.removeIf(l -> l.getParentLessonId() != parentId);
            }

            if (statusRaw != null && !statusRaw.isEmpty()) {
                boolean status = Boolean.parseBoolean(statusRaw);
                lessons.removeIf(l -> l.isStatus() != !status);
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                String kwLower = keyword.toLowerCase();
                lessons.removeIf(l -> !l.getName().toLowerCase().contains(kwLower));
            }

            SubjectDAO subjectDAO = new SubjectDAO();
            Subject subject = subjectDAO.getSubjectById(subjectId);

            request.setAttribute("subject", subject);
            request.setAttribute("lessonList", lessons);

            request.setAttribute("groupId", groupIdRaw);
            request.setAttribute("status", statusRaw);
            request.setAttribute("keyword", keyword);

            request.getRequestDispatcher("/WEB-INF/views/subject_lessons.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi: " + e.getMessage());
        }
    }
}
