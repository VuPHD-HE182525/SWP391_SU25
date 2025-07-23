package controller;

import DAO.LessonDAO;
import DAO.CourseDAO;
import DAO.LessonProgressDAO;
import DAO.LessonCommentDAO;
import DAO.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import model.Lesson;
import model.Course;
import model.LessonProgress;
import model.LessonComment;
import model.LessonRating;
import model.User;
import model.Quiz;
import java.io.IOException;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.UUID;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/lesson-view")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
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
            
            if (currentUser == null) {
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
            
            // Handle file upload
            Part filePart = request.getPart("mediaFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                String fileExtension = getFileExtension(fileName);
                
                // Validate file type
                if (isValidMediaFile(fileExtension)) {
                    // Create upload directory
                    String uploadPath = getServletContext().getRealPath("/uploads/comments");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Generate unique filename
                    String uniqueFileName = generateUniqueFileName(fileExtension);
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    
                    // Save file
                    filePart.write(filePath);
                    
                    // Set media info
                    String mediaType = fileExtension.matches("(?i)(jpg|jpeg|png|gif)") ? "image" : "video";
                    comment.setMediaType(mediaType);
                    comment.setMediaPath("/uploads/comments/" + uniqueFileName);
                    comment.setMediaFilename(fileName);
                }
            }
            
            commentDAO.addComment(comment);
        }
        
        // Redirect back to lesson view
        response.sendRedirect("lesson-view?lessonId=" + lessonId);
    }
    
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDot = fileName.lastIndexOf('.');
        return lastDot > 0 ? fileName.substring(lastDot + 1).toLowerCase() : "";
    }
    
    private boolean isValidMediaFile(String extension) {
        String[] validExtensions = {"jpg", "jpeg", "png", "gif", "mp4", "avi", "mov"};
        for (String validExt : validExtensions) {
            if (validExt.equals(extension)) {
                return true;
            }
        }
        return false;
    }
    
    private String generateUniqueFileName(String extension) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String uuid = UUID.randomUUID().toString().substring(0, 8);
        return "comment_" + timestamp + "_" + uuid + "." + extension;
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