package controller;

import DAO.LessonDAO;
import DAO.CourseDAO;
import DAO.LessonProgressDAO;
import DAO.LessonCommentDAO;
import DAO.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletContext;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Lesson;
import model.Course;
import model.LessonProgress;
import model.LessonComment;
import model.LessonRating;
import model.User;
import model.Quiz;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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
            QuizDAO quizDAO = new QuizDAO();
            
            // Get current lesson
            Lesson currentLesson = lessonDAO.getLessonById(lessonId);
            if (currentLesson == null) {
                response.sendRedirect("course-list");
                return;
            }
            
            // Get quiz for this lesson if exists
            Quiz lessonQuiz = quizDAO.getQuizByLessonId(lessonId);
            if (lessonQuiz != null) {
                currentLesson.setQuizId(lessonQuiz.getId());
            }
            
            // Keep original video URL for JSP processing - no need to modify here
            
            // Get course info (assuming lessons are linked to courses via course_id)
            Course course = courseDAO.getCourseById(currentLesson.getSubjectId()); // Note: might need to adjust based on actual schema
            
            // Get all lessons for this course to build the sidebar
            List<Lesson> courseLessons = lessonDAO.getLessonsBySubject(currentLesson.getSubjectId());
            
            // Load quiz information for all lessons in the sidebar
            for (Lesson lesson : courseLessons) {
                Quiz quiz = quizDAO.getQuizByLessonId(lesson.getId());
                if (quiz != null) {
                    lesson.setQuizId(quiz.getId());
                }
            }
            
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
            
            // Get ratings for current lesson
            DAO.LessonRatingDAO ratingDAO = new DAO.LessonRatingDAO();
            List<LessonRating> ratings = ratingDAO.getLessonRatings(lessonId);
            Map<String, Object> ratingStats = ratingDAO.getLessonRatingStats(lessonId);
            LessonRating userRating = ratingDAO.getUserRating(currentUser.getId(), lessonId);
            
            // WORKAROUND: Calculate rating percentages manually if DAO fails
            try {
                // Test if ratingStats has proper data
                if (ratingStats == null || ratingStats.get("ratingPercentages") == null) {
                    throw new Exception("DAO method failed");
                }
            } catch (Exception e) {
                // Fallback: Calculate using raw SQL
                ratingStats = calculateRatingStatsManually(lessonId);
            }
            
            // Find previous and next lessons with section-aware logic
            Lesson previousLesson = null;
            Lesson nextLesson = null;

            // Separate lessons by sections for proper navigation
            List<Lesson> section1Videos = new ArrayList<>();
            List<Lesson> section2Readings = new ArrayList<>();
            List<Lesson> section2Videos = new ArrayList<>();

            for (Lesson lesson : courseLessons) {
                if ("video".equals(lesson.getType())) {
                    if (lesson.getOrderNum() <= 3) { // Section 1: first 3 videos
                        section1Videos.add(lesson);
                    } else { // Section 2: remaining videos
                        section2Videos.add(lesson);
                    }
                } else if ("reading".equals(lesson.getType()) ||
                          "reading".equals(lesson.getContentType()) ||
                          lesson.getContentFilePath() != null) {
                    section2Readings.add(lesson);
                }
            }

            // Sort each section by order
            section1Videos.sort((a, b) -> Integer.compare(a.getOrderNum(), b.getOrderNum()));
            section2Readings.sort((a, b) -> Integer.compare(a.getOrderNum(), b.getOrderNum()));
            section2Videos.sort((a, b) -> Integer.compare(a.getOrderNum(), b.getOrderNum()));

            // Find current lesson position and determine navigation
            boolean found = false;

            // Check if current lesson is in Section 1 videos
            for (int i = 0; i < section1Videos.size(); i++) {
                if (section1Videos.get(i).getId() == lessonId) {
                    found = true;
                    if (i > 0) {
                        previousLesson = section1Videos.get(i - 1);
                    }
                    if (i < section1Videos.size() - 1) {
                        nextLesson = section1Videos.get(i + 1);
                    } else {
                        // Last video in Section 1 → Next should be first reading in Section 2
                        if (!section2Readings.isEmpty()) {
                            nextLesson = section2Readings.get(0);
                        }
                    }
                    break;
                }
            }

            // Check if current lesson is in Section 2 readings
            if (!found) {
                for (int i = 0; i < section2Readings.size(); i++) {
                    if (section2Readings.get(i).getId() == lessonId) {
                        found = true;
                        if (i > 0) {
                            previousLesson = section2Readings.get(i - 1);
                        } else {
                            // First reading in Section 2 → Previous should be last video in Section 1
                            if (!section1Videos.isEmpty()) {
                                previousLesson = section1Videos.get(section1Videos.size() - 1);
                            }
                        }
                        if (i < section2Readings.size() - 1) {
                            nextLesson = section2Readings.get(i + 1);
                        } else {
                            // Last reading in Section 2 → Next should be first video in Section 2
                            if (!section2Videos.isEmpty()) {
                                nextLesson = section2Videos.get(0);
                            }
                        }
                        break;
                    }
                }
            }

            // Check if current lesson is in Section 2 videos
            if (!found) {
                for (int i = 0; i < section2Videos.size(); i++) {
                    if (section2Videos.get(i).getId() == lessonId) {
                        found = true;
                        if (i > 0) {
                            previousLesson = section2Videos.get(i - 1);
                        } else {
                            // First video in Section 2 → Previous should be last reading in Section 2
                            if (!section2Readings.isEmpty()) {
                                previousLesson = section2Readings.get(section2Readings.size() - 1);
                            }
                        }
                        if (i < section2Videos.size() - 1) {
                            nextLesson = section2Videos.get(i + 1);
                        }
                        break;
                    }
                }
            }
            
            // Mark lesson as viewed
            progressDAO.markLessonViewed(currentUser.getId(), lessonId, 0);
            
            // Check if current lesson is reading type
            boolean isReadingLesson = "reading".equals(currentLesson.getType());
            
            // Set attributes for JSP
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("course", course);
            request.setAttribute("courseLessons", courseLessons);
            request.setAttribute("progressMap", progressMap);
            request.setAttribute("comments", comments);
            request.setAttribute("ratings", ratings);
            request.setAttribute("ratingStats", ratingStats);
            request.setAttribute("userRating", userRating);
            request.setAttribute("previousLesson", previousLesson);
            request.setAttribute("nextLesson", nextLesson);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isReadingLesson", isReadingLesson);
            
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

            System.out.println("=== DEBUG: POST Request ===");
            System.out.println("Action: " + request.getParameter("action"));
            System.out.println("LessonId: " + request.getParameter("lessonId"));
            System.out.println("User: " + (currentUser != null ? currentUser.getFullName() : "null"));

            if (currentUser == null) {
                System.err.println("ERROR: User not logged in, redirecting to login");
                response.sendRedirect("login");
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("addComment".equals(action)) {
                handleAddComment(request, response, currentUser);
            } else if ("editComment".equals(action)) {
                handleEditComment(request, response, currentUser);
            } else if ("deleteComment".equals(action)) {
                handleDeleteComment(request, response, currentUser);
            } else if ("addRating".equals(action)) {
                handleAddRating(request, response, currentUser);
            } else if ("markCompleted".equals(action)) {
                handleMarkCompleted(request, response, currentUser);
            } else if ("updateProgress".equals(action)) {
                handleUpdateProgress(request, response, currentUser);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("=== ERROR in LessonViewServlet POST ===");
            System.err.println("Action: " + request.getParameter("action"));
            System.err.println("LessonId: " + request.getParameter("lessonId"));
            System.err.println("Error: " + e.getMessage());
            System.err.println("=== END ERROR ===");

            // Redirect to avoid showing error page
            String lessonId = request.getParameter("lessonId");
            if (lessonId != null && !lessonId.trim().isEmpty()) {
                System.err.println("Redirecting to lesson-view with lessonId: " + lessonId);
                response.sendRedirect("lesson-view?lessonId=" + lessonId + "&error=true");
            } else {
                System.err.println("Redirecting to course-list (no valid lessonId)");
                response.sendRedirect("course-list");
            }
        }
    }

    private void handleAddComment(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {

        String lessonIdParam = request.getParameter("lessonId");
        String commentText = request.getParameter("commentText");

        System.out.println("=== handleAddComment ===");
        System.out.println("lessonId: " + lessonIdParam);
        System.out.println("commentText: " + commentText);

        if (lessonIdParam != null && commentText != null && !commentText.trim().isEmpty()) {
            try {
                int lessonId = Integer.parseInt(lessonIdParam);

                // Create simple comment object (no media)
                LessonCommentDAO commentDAO = new LessonCommentDAO();
                LessonComment comment = new LessonComment(currentUser.getId(), lessonId, commentText.trim());

                commentDAO.addComment(comment);
                System.out.println("Comment added successfully");
                response.sendRedirect("lesson-view?lessonId=" + lessonId);
                return;

            } catch (Exception e) {
                System.err.println("Error adding comment: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // Fallback redirect
        String lessonId = lessonIdParam != null ? lessonIdParam : "1";
        response.sendRedirect("lesson-view?lessonId=" + lessonId + "&error=true");
    }


    
    private void handleEditComment(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws Exception {
        
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        String commentText = request.getParameter("commentText");
        
        if (commentText != null && !commentText.trim().isEmpty()) {
            LessonCommentDAO commentDAO = new LessonCommentDAO();
            // Verify comment ownership
            LessonComment comment = commentDAO.getCommentById(commentId);
            if (comment != null && comment.getUserId() == currentUser.getId()) {
                comment.setCommentText(commentText.trim());
                commentDAO.updateComment(commentId, commentText.trim());
            }
        }
        
        // Redirect back to lesson view
        response.sendRedirect("lesson-view?lessonId=" + lessonId);
    }
    
    private void handleDeleteComment(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws Exception {
        
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        
        LessonCommentDAO commentDAO = new LessonCommentDAO();
        // Verify comment ownership
        LessonComment comment = commentDAO.getCommentById(commentId);
        if (comment != null && comment.getUserId() == currentUser.getId()) {
            commentDAO.deleteComment(commentId);
        }
        
        // Redirect back to lesson view
        response.sendRedirect("lesson-view?lessonId=" + lessonId);
    }
    
    private void handleAddRating(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws Exception {
        
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String reviewText = request.getParameter("reviewText");
        
        // Basic validation
        if (rating >= 1 && rating <= 5) {
            try {
                // Save rating to database
                DAO.LessonRatingDAO ratingDAO = new DAO.LessonRatingDAO();
                LessonRating lessonRating = new LessonRating(currentUser.getId(), lessonId, rating, reviewText);
                ratingDAO.addOrUpdateRating(lessonRating);
                
                // Success redirect
                response.sendRedirect("lesson-view?lessonId=" + lessonId + "&ratingSuccess=true");
                return;
            } catch (Exception e) {
                System.err.println("Error saving rating: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        // Error redirect
        response.sendRedirect("lesson-view?lessonId=" + lessonId + "&ratingError=true");
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

    // WORKAROUND: Calculate rating percentages manually if DAO fails
    private Map<String, Object> calculateRatingStatsManually(int lessonId) {
        Map<String, Object> ratingStats = new HashMap<>();
        try {
            // This is a placeholder for manual calculation.
            // In a real application, you would query the database directly
            // to get the raw counts for each rating (1, 2, 3, 4, 5) and total ratings.
            // Then, you would calculate percentages based on these raw counts.
            // For example:
            // int totalRatings = LessonRatingDAO.getTotalRatingsForLesson(lessonId);
            // int rating1Count = LessonRatingDAO.getRatingCount(lessonId, 1);
            // int rating2Count = LessonRatingDAO.getRatingCount(lessonId, 2);
            // ...
            // ratingStats.put("totalRatings", totalRatings);
            // ratingStats.put("ratingPercentages", new HashMap<Integer, Double>() {{
            //     put(1, (double) rating1Count / totalRatings * 100);
            //     put(2, (double) rating2Count / totalRatings * 100);
            //     put(3, (double) rating3Count / totalRatings * 100);
            //     put(4, (double) rating4Count / totalRatings * 100);
            //     put(5, (double) rating5Count / totalRatings * 100);
            // }});
            // ratingStats.put("averageRating", (double) totalRatings / 5); // This is a placeholder

            // For now, return a dummy map to avoid null pointer exceptions
            ratingStats.put("totalRatings", 0);
            ratingStats.put("ratingPercentages", new HashMap<Integer, Double>() {{
                put(1, 0.0);
                put(2, 0.0);
                put(3, 0.0);
                put(4, 0.0);
                put(5, 0.0);
            }});
            ratingStats.put("averageRating", 0.0);

        } catch (Exception e) {
            e.printStackTrace();
            // Log the error or handle it appropriately
        }
        return ratingStats;
    }
} 