package controller;

import DAO.LessonDAO;
import DAO.CourseDAO;
import DAO.LessonProgressDAO;
import DAO.LessonCommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Lesson;
import model.Course;
import model.LessonProgress;
import model.LessonComment;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/lesson-view")
public class LessonViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect("login");
                return;
            }
            
            String lessonIdParam = request.getParameter("lessonId");
            if (lessonIdParam == null || lessonIdParam.isEmpty()) {
                response.sendRedirect("course-list");
                return;
            }
            
            int lessonId = Integer.parseInt(lessonIdParam);
            
            // Initialize DAOs
            LessonDAO lessonDAO = new LessonDAO();
            CourseDAO courseDAO = new CourseDAO();
            LessonProgressDAO progressDAO = new LessonProgressDAO();
            LessonCommentDAO commentDAO = new LessonCommentDAO();
            
            // Get current lesson
            Lesson currentLesson = lessonDAO.getLessonById(lessonId);
            if (currentLesson == null) {
                response.sendRedirect("course-list");
                return;
            }
            
            // Keep original video URL for JSP processing - no need to modify here
            
            // Get course info (assuming lessons are linked to courses via course_id)
            Course course = courseDAO.getCourseById(currentLesson.getSubjectId()); // Note: might need to adjust based on actual schema
            
            // Get all lessons for this course to build the sidebar
            List<Lesson> courseLessons = lessonDAO.getLessonsBySubject(currentLesson.getSubjectId());
            
            // Keep original video URLs for JSP processing - no need to modify here
            
            // Get user progress for all lessons in this course
            List<LessonProgress> userProgress = progressDAO.getUserProgressForCourse(currentUser.getId(), currentLesson.getSubjectId());
            
            // Create a map for easy lookup of progress by lesson ID
            Map<Integer, LessonProgress> progressMap = new HashMap<>();
            for (LessonProgress progress : userProgress) {
                progressMap.put(progress.getLessonId(), progress);
            }
            
            // Get comments for current lesson
            List<LessonComment> comments = commentDAO.getCommentsByLessonId(lessonId);
            
            // Find previous and next lessons
            Lesson previousLesson = null;
            Lesson nextLesson = null;
            
            for (int i = 0; i < courseLessons.size(); i++) {
                if (courseLessons.get(i).getId() == lessonId) {
                    if (i > 0) {
                        previousLesson = courseLessons.get(i - 1);
                    }
                    if (i < courseLessons.size() - 1) {
                        nextLesson = courseLessons.get(i + 1);
                    }
                    break;
                }
            }
            
            // Mark lesson as viewed
            progressDAO.markLessonViewed(currentUser.getId(), lessonId, 0);
            
            // Set attributes for JSP
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("course", course);
            request.setAttribute("courseLessons", courseLessons);
            request.setAttribute("progressMap", progressMap);
            request.setAttribute("comments", comments);
            request.setAttribute("previousLesson", previousLesson);
            request.setAttribute("nextLesson", nextLesson);
            request.setAttribute("currentUser", currentUser);
            
            // Forward to lesson view page
            request.getRequestDispatcher("/WEB-INF/views/lesson_view.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error loading lesson: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            request.setCharacterEncoding("UTF-8");
            
            // Check if user is logged in
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect("login");
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("addComment".equals(action)) {
                handleAddComment(request, response, currentUser);
            } else if ("markCompleted".equals(action)) {
                handleMarkCompleted(request, response, currentUser);
            } else if ("updateProgress".equals(action)) {
                handleUpdateProgress(request, response, currentUser);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in LessonViewServlet POST: " + e.getMessage());
            // Redirect to avoid showing error page
            String lessonId = request.getParameter("lessonId");
            if (lessonId != null) {
                response.sendRedirect("lesson-view?lessonId=" + lessonId + "&error=true");
            } else {
                response.sendRedirect("course-list");
            }
        }
    }
    
    private void handleAddComment(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws Exception {
        
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        String commentText = request.getParameter("commentText");
        
        if (commentText != null && !commentText.trim().isEmpty()) {
            LessonCommentDAO commentDAO = new LessonCommentDAO();
            LessonComment comment = new LessonComment(currentUser.getId(), lessonId, commentText.trim());
            commentDAO.addComment(comment);
        }
        
        // Redirect back to lesson view
        response.sendRedirect("lesson-view?lessonId=" + lessonId);
    }
    
    private void handleMarkCompleted(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws Exception {
        
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        
        LessonProgressDAO progressDAO = new LessonProgressDAO();
        progressDAO.markLessonCompleted(currentUser.getId(), lessonId);
        
        // Return JSON response for AJAX
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true}");
    }
    
    private void handleUpdateProgress(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws Exception {
        
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        int viewDuration = Integer.parseInt(request.getParameter("viewDuration"));
        
        LessonProgressDAO progressDAO = new LessonProgressDAO();
        progressDAO.markLessonViewed(currentUser.getId(), lessonId, viewDuration);
        
        // Return JSON response for AJAX
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true}");
    }
} 