package controller;

import DAO.SubjectDAO;
import DAO.LessonDAO;
import DAO.CommentDAO;
import model.Subject;
import model.Lesson;
import model.Comment;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/subjectView")
public class SubjectViewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String lessonIdParam = request.getParameter("lessonId");
        try {
            SubjectDAO subjectDAO = new SubjectDAO();
            LessonDAO lessonDAO = new LessonDAO();
            CommentDAO commentDAO = new CommentDAO();

            Subject subject = subjectDAO.getSubjectById(subjectId);
            List<Lesson> lessons = lessonDAO.getLessonsBySubjectId(subjectId);
            Lesson currentLesson = null;
            if (lessonIdParam != null) {
                int lessonId = Integer.parseInt(lessonIdParam);
                currentLesson = lessonDAO.getLessonById(lessonId);
            }
            List<Comment> comments;
            if (currentLesson != null) {
                comments = commentDAO.getCommentsByLessonId(currentLesson.getId());
            } else {
                comments = commentDAO.getCommentsBySubjectId(subjectId);
            }

            request.setAttribute("subject", subject);
            request.setAttribute("lessons", lessons);
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("comments", comments);
        } catch (Exception e) {
            throw new ServletException(e);
        }
        request.getRequestDispatcher("/WEB-INF/views/SubjectView.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Xử lý thêm bình luận
        request.setCharacterEncoding("UTF-8");
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String lessonIdParam = request.getParameter("lessonId");
        String content = request.getParameter("content");
        int userId = 1; // Demo: lấy userId cố định, thực tế lấy từ session
        Integer lessonId = null;
        if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
            lessonId = Integer.parseInt(lessonIdParam);
        }
        try {
            CommentDAO commentDAO = new CommentDAO();
            Comment comment = new Comment();
            comment.setUserId(userId);
            comment.setSubjectId(subjectId);
            comment.setLessonId(lessonId);
            comment.setContent(content);
            comment.setCreatedAt(new java.util.Date());
            commentDAO.addComment(comment);
        } catch (Exception e) {
            throw new ServletException(e);
        }
        // Quay lại trang view
        if (lessonId != null) {
            response.sendRedirect("subjectView?subjectId=" + subjectId + "&lessonId=" + lessonId);
        } else {
            response.sendRedirect("subjectView?subjectId=" + subjectId);
        }
    }
} 