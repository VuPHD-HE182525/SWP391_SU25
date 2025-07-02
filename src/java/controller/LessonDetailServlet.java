package controller;

import DAO.LessonDAO;
import DAO.QuizDAO;
import DAO.SubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Lesson;
import model.Quiz;
import model.Subject;

@WebServlet(name = "LessonDetailServlet", urlPatterns = {"/lesson-detail"})
public class LessonDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            LessonDAO lessonDAO = new LessonDAO();
            SubjectDAO subjectDAO = new SubjectDAO();
            QuizDAO quizDAO = new QuizDAO();

            Lesson lesson = new Lesson();

            String idRaw = request.getParameter("id");
            if (idRaw != null && !idRaw.isEmpty()) {
                int id = Integer.parseInt(idRaw);
                lesson = lessonDAO.getLessonById(id);

                if (lesson != null && lesson.getSubjectId() > 0) {
                    Subject subject = subjectDAO.getSubjectById(lesson.getSubjectId());
                    request.setAttribute("subject", subject);
                }
            } else {
                String subjectIdRaw = request.getParameter("subjectId");
                if (subjectIdRaw != null && !subjectIdRaw.isEmpty()) {
                    int subjectId = Integer.parseInt(subjectIdRaw);
                    lesson.setSubjectId(subjectId);
                    Subject subject = subjectDAO.getSubjectById(subjectId);
                    request.setAttribute("subject", subject);
                }
            }

            // Đặt các attribute cho JSP
            request.setAttribute("lesson", lesson);

            int subjectIdForLessonList = (lesson.getSubjectId() > 0) ? lesson.getSubjectId() : -1;
            request.setAttribute("lessonList", lessonDAO.getLessonsBySubject(subjectIdForLessonList));
            request.setAttribute("subjectList", subjectDAO.getAllSubjects());

            List<Quiz> quizList = quizDAO.getAllQuizzes();
            request.setAttribute("quizList", quizList);

            request.getRequestDispatcher("/WEB-INF/views/lesson_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            int orderNum = Integer.parseInt(request.getParameter("orderNum"));
            String type = request.getParameter("type");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            String parentRaw = request.getParameter("parentLessonId");
            int parentLessonId = (parentRaw == null || parentRaw.isEmpty()) ? 0 : Integer.parseInt(parentRaw);

            // Lấy thêm các trường có thể null
            String videoLink = request.getParameter("videoLink");
            String htmlContent = request.getParameter("htmlContent");
            String quizIdRaw = request.getParameter("quizId");
            Integer quizId = (quizIdRaw != null && !quizIdRaw.isEmpty()) ? Integer.parseInt(quizIdRaw) : null;

            // Tạo hoặc cập nhật lesson
            Lesson lesson = new Lesson();
            lesson.setId(id);
            lesson.setName(name);
            lesson.setOrderNum(orderNum);
            lesson.setType(type);
            lesson.setStatus(status);
            lesson.setSubjectId(subjectId);
            lesson.setParentLessonId(parentLessonId);
            lesson.setVideoLink(videoLink);
            lesson.setHtmlContent(htmlContent);
            lesson.setQuizId(quizId); // đảm bảo có trường này trong model

            LessonDAO dao = new LessonDAO();
            if (id == 0) {
                dao.insertLesson(lesson);
            } else {
                dao.updateLesson(lesson);
            }

            response.sendRedirect("lesson-detail?id=" + lesson.getId());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi cập nhật bài học: " + e.getMessage());
        }
    }
}
