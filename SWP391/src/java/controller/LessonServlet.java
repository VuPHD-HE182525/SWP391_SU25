package controller;

import DAO.LessonDAO;
import DAO.SubjectDAO;
import model.Lesson;
import model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/lesson")
public class LessonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String subjectIdParam = request.getParameter("subjectId");
            String groupIdParam = request.getParameter("groupId");
            String statusParam = request.getParameter("status");
            String keyword = request.getParameter("keyword");

            if (subjectIdParam == null || subjectIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/subjects");
                return;
            }

            int subjectId = Integer.parseInt(subjectIdParam);

            LessonDAO lessonDAO = new LessonDAO();
            List<Lesson> lessons = lessonDAO.getLessonsBySubject(subjectId);

            List<Lesson> unassignedLessons = lessonDAO.getUnassignedLessons(subjectId);
            request.setAttribute("unassignedLessons", unassignedLessons);

            // Apply filters
            if (groupIdParam != null && !groupIdParam.isEmpty()) {
                int parentId = Integer.parseInt(groupIdParam);
                lessons.removeIf(lesson -> lesson.getParentLessonId() != parentId);
            }

            if (statusParam != null && !statusParam.isEmpty()) {
                boolean status = Boolean.parseBoolean(statusParam);
                lessons.removeIf(lesson -> lesson.isStatus() != status);
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                String keywordLower = keyword.toLowerCase();
                lessons.removeIf(lesson -> !lesson.getName().toLowerCase().contains(keywordLower));
            }

            SubjectDAO subjectDAO = new SubjectDAO();
            Subject subject = subjectDAO.getSubjectById(subjectId);

            request.setAttribute("subject", subject);
            request.setAttribute("lessonList", lessons);
            request.setAttribute("groupId", groupIdParam);
            request.setAttribute("status", statusParam);
            request.setAttribute("keyword", keyword);

            request.getRequestDispatcher("/WEB-INF/views/subject_lessons.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid subject ID parameter: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/subjects");
        } catch (Exception e) {
            System.err.println("Error in LessonServlet: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Error loading lessons: " + e.getMessage());
        }
    }
}
