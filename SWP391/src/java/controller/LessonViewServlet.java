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

/**
 * Lesson View Servlet - Handles comprehensive lesson display and interaction functionality
 *
 * This servlet manages the complete lesson viewing experience including video/reading content,
 * progress tracking, comments, ratings, and navigation between lessons. It provides a rich
 * learning interface with sidebar navigation and interactive features.
 *
 * Key Features:
 * - Lesson content display (video and reading types)
 * - Progress tracking and completion marking
 * - Comment system with CRUD operations
 * - Rating and review system
 * - Smart lesson navigation (previous/next with section awareness)
 * - Quiz integration and display
 * - User authentication and session management
 * - Sidebar with course structure and progress indicators
 *
 * URL Mapping: Not explicitly mapped (uses default servlet name)
 * Methods: GET (display), POST (interactions)
 *
 * Request Parameters:
 * - lessonId: Required lesson ID to display
 * - action: POST action type (addComment, editComment, deleteComment, addRating, markCompleted, updateProgress)
 *
 * @author SWP391 Team
 */
public class LessonViewServlet extends HttpServlet {

    /**
     * Handles GET requests for lesson display
     *
     * Processing Flow:
     * 1. Validate user authentication and lesson ID
     * 2. Load lesson content and associated course information
     * 3. Retrieve quiz information if available
     * 4. Build course lesson structure for sidebar navigation
     * 5. Load user progress data for all lessons in course
     * 6. Retrieve comments and ratings for current lesson
     * 7. Calculate smart navigation (previous/next lessons with section awareness)
     * 8. Mark lesson as viewed in progress tracking
     * 9. Set request attributes and forward to JSP view
     *
     * @param request HTTP request with lessonId parameter
     * @param response HTTP response for lesson view page
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Step 1: Validate user authentication
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            // Redirect to login if user is not authenticated
            if (currentUser == null) {
                response.sendRedirect("login");
                return;
            }

            // Step 2: Extract and validate lesson ID parameter
            String lessonIdParam = request.getParameter("lessonId");
            if (lessonIdParam == null || lessonIdParam.isEmpty()) {
                response.sendRedirect("course-list");
                return;
            }

            int lessonId = Integer.parseInt(lessonIdParam);

            // Step 3: Initialize Data Access Objects for database operations
            LessonDAO lessonDAO = new LessonDAO();
            CourseDAO courseDAO = new CourseDAO();
            LessonProgressDAO progressDAO = new LessonProgressDAO();
            LessonCommentDAO commentDAO = new LessonCommentDAO();
            QuizDAO quizDAO = new QuizDAO();

            // Step 4: Retrieve current lesson data
            Lesson currentLesson = lessonDAO.getLessonById(lessonId);
            if (currentLesson == null) {
                // Redirect to course list if lesson not found
                response.sendRedirect("course-list");
                return;
            }

            // Step 5: Load associated quiz information if available
            Quiz lessonQuiz = quizDAO.getQuizByLessonId(lessonId);
            if (lessonQuiz != null) {
                // Set quiz ID in lesson object for JSP access
                currentLesson.setQuizId(lessonQuiz.getId());
            }

            // Note: Video URL is kept original for JSP processing - no modification needed here

            // Step 6: Retrieve course information for context
            // Note: Using subjectId as courseId based on current database schema
            Course course = courseDAO.getCourseById(currentLesson.getSubjectId());

            // Step 7: Load all lessons in this course for sidebar navigation
            List<Lesson> courseLessons = lessonDAO.getLessonsBySubject(currentLesson.getSubjectId());

            // Step 8: Load quiz information for all lessons in sidebar
            for (Lesson lesson : courseLessons) {
                Quiz quiz = quizDAO.getQuizByLessonId(lesson.getId());
                if (quiz != null) {
                    // Set quiz ID for display in sidebar
                    lesson.setQuizId(quiz.getId());
                }
            }

            // Note: Video URLs are kept original for JSP processing - no modification needed

            // Step 9: Retrieve user progress data for all lessons in this course
            List<LessonProgress> userProgress = progressDAO.getUserProgressForCourse(currentUser.getId(), currentLesson.getSubjectId());

            // Step 10: Create progress lookup map for efficient JSP access
            Map<Integer, LessonProgress> progressMap = new HashMap<>();
            for (LessonProgress progress : userProgress) {
                progressMap.put(progress.getLessonId(), progress);
            }

            // Step 11: Load comments for current lesson
            List<LessonComment> comments = commentDAO.getCommentsByLessonId(lessonId);

            // Step 12: Load rating and review data for current lesson
            DAO.LessonRatingDAO ratingDAO = new DAO.LessonRatingDAO();
            List<LessonRating> ratings = ratingDAO.getLessonRatings(lessonId);
            Map<String, Object> ratingStats = ratingDAO.getLessonRatingStats(lessonId);
            LessonRating userRating = ratingDAO.getUserRating(currentUser.getId(), lessonId);

            // Step 13: Handle rating statistics with fallback mechanism
            // WORKAROUND: Calculate rating percentages manually if DAO method fails
            try {
                // Validate that rating statistics were properly loaded
                if (ratingStats == null || ratingStats.get("ratingPercentages") == null) {
                    throw new Exception("DAO method failed to load rating statistics");
                }
            } catch (Exception e) {
                // Fallback to manual calculation to prevent null pointer exceptions
                ratingStats = calculateRatingStatsManually(lessonId);
            }

            // Step 14: Implement smart lesson navigation with section-aware logic
            // This complex navigation system handles the course structure:
            // Section 1: First 3 video lessons
            // Section 2: Reading lessons followed by remaining video lessons
            Lesson previousLesson = null;
            Lesson nextLesson = null;

            // Step 15: Categorize lessons by type and section for proper navigation
            List<Lesson> section1Videos = new ArrayList<>();      // First 3 video lessons
            List<Lesson> section2Readings = new ArrayList<>();    // Reading lessons in section 2
            List<Lesson> section2Videos = new ArrayList<>();      // Remaining video lessons in section 2

            // Categorize each lesson based on type and order
            for (Lesson lesson : courseLessons) {
                if ("video".equals(lesson.getType())) {
                    if (lesson.getOrderNum() <= 3) {
                        // Section 1: First 3 video lessons
                        section1Videos.add(lesson);
                    } else {
                        // Section 2: Remaining video lessons (after readings)
                        section2Videos.add(lesson);
                    }
                } else if ("reading".equals(lesson.getType()) ||
                          "reading".equals(lesson.getContentType()) ||
                          lesson.getContentFilePath() != null) {
                    // Section 2: Reading lessons (between section 1 and 2 videos)
                    section2Readings.add(lesson);
                }
            }

            // Step 16: Sort each section by order number for proper sequence
            section1Videos.sort((a, b) -> Integer.compare(a.getOrderNum(), b.getOrderNum()));
            section2Readings.sort((a, b) -> Integer.compare(a.getOrderNum(), b.getOrderNum()));
            section2Videos.sort((a, b) -> Integer.compare(a.getOrderNum(), b.getOrderNum()));

            // Step 17: Find current lesson position and determine navigation links
            boolean found = false;

            // Step 18: Search for current lesson in Section 1 videos
            for (int i = 0; i < section1Videos.size(); i++) {
                if (section1Videos.get(i).getId() == lessonId) {
                    found = true;
                    // Set previous lesson if not the first in section
                    if (i > 0) {
                        previousLesson = section1Videos.get(i - 1);
                    }
                    // Set next lesson within section or transition to Section 2
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

            // Step 19: Search for current lesson in Section 2 readings (if not found in Section 1)
            if (!found) {
                for (int i = 0; i < section2Readings.size(); i++) {
                    if (section2Readings.get(i).getId() == lessonId) {
                        found = true;
                        // Set previous lesson within readings or transition from Section 1
                        if (i > 0) {
                            previousLesson = section2Readings.get(i - 1);
                        } else {
                            // First reading in Section 2 → Previous should be last video in Section 1
                            if (!section1Videos.isEmpty()) {
                                previousLesson = section1Videos.get(section1Videos.size() - 1);
                            }
                        }
                        // Set next lesson within readings or transition to Section 2 videos
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

            // Step 20: Search for current lesson in Section 2 videos (if not found in previous sections)
            if (!found) {
                for (int i = 0; i < section2Videos.size(); i++) {
                    if (section2Videos.get(i).getId() == lessonId) {
                        found = true;
                        // Set previous lesson within videos or transition from readings
                        if (i > 0) {
                            previousLesson = section2Videos.get(i - 1);
                        } else {
                            // First video in Section 2 → Previous should be last reading in Section 2
                            if (!section2Readings.isEmpty()) {
                                previousLesson = section2Readings.get(section2Readings.size() - 1);
                            }
                        }
                        // Set next lesson within Section 2 videos
                        if (i < section2Videos.size() - 1) {
                            nextLesson = section2Videos.get(i + 1);
                        }
                        // Note: No next lesson if this is the last video in the course
                        break;
                    }
                }
            }

            // Step 21: Mark lesson as viewed for progress tracking
            // This updates the user's progress record with view timestamp
            progressDAO.markLessonViewed(currentUser.getId(), lessonId, 0);

            // Step 22: Determine lesson type for conditional JSP rendering
            boolean isReadingLesson = "reading".equals(currentLesson.getType());

            // Step 23: Set request attributes for JSP rendering
            request.setAttribute("currentLesson", currentLesson);        // Main lesson content
            request.setAttribute("course", course);                      // Course information
            request.setAttribute("courseLessons", courseLessons);        // All lessons for sidebar
            request.setAttribute("progressMap", progressMap);            // User progress lookup map
            request.setAttribute("comments", comments);                  // Lesson comments
            request.setAttribute("ratings", ratings);                    // Lesson ratings
            request.setAttribute("ratingStats", ratingStats);            // Rating statistics and percentages
            request.setAttribute("userRating", userRating);              // Current user's rating
            request.setAttribute("previousLesson", previousLesson);      // Previous lesson for navigation
            request.setAttribute("nextLesson", nextLesson);              // Next lesson for navigation
            request.setAttribute("currentUser", currentUser);            // Current user information
            request.setAttribute("isReadingLesson", isReadingLesson);    // Lesson type flag for JSP

            // Step 24: Forward to lesson view JSP for rendering
            request.getRequestDispatcher("/WEB-INF/views/lesson_view.jsp").forward(request, response);

        } catch (Exception e) {
            // Handle any unexpected errors gracefully
            e.printStackTrace();
            response.getWriter().println("Error loading lesson: " + e.getMessage());
        }
    }

    /**
     * Handles POST requests for lesson interactions
     *
     * This method processes various user interactions with lessons including:
     * - Adding, editing, and deleting comments
     * - Adding and updating ratings
     * - Marking lessons as completed
     * - Updating lesson progress
     *
     * Processing Flow:
     * 1. Set UTF-8 encoding for proper character handling
     * 2. Validate user authentication
     * 3. Extract action parameter to determine operation type
     * 4. Delegate to appropriate handler method based on action
     * 5. Handle errors gracefully with appropriate redirects
     *
     * @param request HTTP request with action parameter and relevant data
     * @param response HTTP response for redirects or JSON responses
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Step 1: Set character encoding for proper UTF-8 handling
            request.setCharacterEncoding("UTF-8");

            // Step 2: Validate user authentication
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            // Debug logging for troubleshooting
            System.out.println("=== DEBUG: POST Request ===");
            System.out.println("Action: " + request.getParameter("action"));
            System.out.println("LessonId: " + request.getParameter("lessonId"));
            System.out.println("User: " + (currentUser != null ? currentUser.getFullName() : "null"));

            // Redirect to login if user is not authenticated
            if (currentUser == null) {
                System.err.println("ERROR: User not logged in, redirecting to login");
                response.sendRedirect("login");
                return;
            }

            // Step 3: Extract action parameter to determine operation type
            String action = request.getParameter("action");

            // Step 4: Delegate to appropriate handler method based on action
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
            // Step 5: Handle errors gracefully with detailed logging
            e.printStackTrace();
            System.err.println("=== ERROR in LessonViewServlet POST ===");
            System.err.println("Action: " + request.getParameter("action"));
            System.err.println("LessonId: " + request.getParameter("lessonId"));
            System.err.println("Error: " + e.getMessage());
            System.err.println("=== END ERROR ===");

            // Redirect to avoid showing error page to user
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

    /**
     * Handles adding new comments to lessons
     *
     * This method processes comment submission from users, validates the input,
     * creates a new comment record in the database, and redirects back to the lesson view.
     *
     * @param request HTTP request containing lessonId and commentText parameters
     * @param response HTTP response for redirect after comment processing
     * @param currentUser Authenticated user adding the comment
     * @throws Exception if database error occurs during comment creation
     */
    private void handleAddComment(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {

        // Extract parameters from request
        String lessonIdParam = request.getParameter("lessonId");
        String commentText = request.getParameter("commentText");

        // Debug logging for troubleshooting
        System.out.println("=== handleAddComment ===");
        System.out.println("lessonId: " + lessonIdParam);
        System.out.println("commentText: " + commentText);

        // Validate input parameters
        if (lessonIdParam != null && commentText != null && !commentText.trim().isEmpty()) {
            try {
                int lessonId = Integer.parseInt(lessonIdParam);

                // Create new comment object with user and lesson information
                LessonCommentDAO commentDAO = new LessonCommentDAO();
                LessonComment comment = new LessonComment(currentUser.getId(), lessonId, commentText.trim());

                // Save comment to database
                commentDAO.addComment(comment);
                System.out.println("Comment added successfully");

                // Redirect back to lesson view with success
                response.sendRedirect("lesson-view?lessonId=" + lessonId);
                return;

            } catch (Exception e) {
                // Log error details for debugging
                System.err.println("Error adding comment: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // Fallback redirect with error flag if validation fails
        String lessonId = lessonIdParam != null ? lessonIdParam : "1";
        response.sendRedirect("lesson-view?lessonId=" + lessonId + "&error=true");
    }



    /**
     * Handles editing existing comments
     *
     * This method processes comment edit requests, validates ownership,
     * updates the comment text in the database, and redirects back to the lesson view.
     *
     * @param request HTTP request containing lessonId, commentId, and commentText parameters
     * @param response HTTP response for redirect after comment processing
     * @param currentUser Authenticated user editing the comment
     * @throws Exception if database error occurs during comment update
     */
    private void handleEditComment(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {

        // Extract parameters from request
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        String commentText = request.getParameter("commentText");

        // Validate comment text is not empty
        if (commentText != null && !commentText.trim().isEmpty()) {
            LessonCommentDAO commentDAO = new LessonCommentDAO();

            // Verify comment ownership before allowing edit
            LessonComment comment = commentDAO.getCommentById(commentId);
            if (comment != null && comment.getUserId() == currentUser.getId()) {
                // Update comment text in database
                comment.setCommentText(commentText.trim());
                commentDAO.updateComment(commentId, commentText.trim());
            }
        }

        // Redirect back to lesson view
        response.sendRedirect("lesson-view?lessonId=" + lessonId);
    }

    /**
     * Handles deleting existing comments
     *
     * This method processes comment deletion requests, validates ownership,
     * removes the comment from the database, and redirects back to the lesson view.
     *
     * @param request HTTP request containing lessonId and commentId parameters
     * @param response HTTP response for redirect after comment processing
     * @param currentUser Authenticated user deleting the comment
     * @throws Exception if database error occurs during comment deletion
     */
    private void handleDeleteComment(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {

        // Extract parameters from request
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        int commentId = Integer.parseInt(request.getParameter("commentId"));

        LessonCommentDAO commentDAO = new LessonCommentDAO();

        // Verify comment ownership before allowing deletion
        LessonComment comment = commentDAO.getCommentById(commentId);
        if (comment != null && comment.getUserId() == currentUser.getId()) {
            // Delete comment from database
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

    /**
     * Fallback method to calculate rating statistics manually
     *
     * This method serves as a workaround when the main DAO method fails to load
     * rating statistics properly. It provides a safe fallback to prevent null
     * pointer exceptions in the JSP view.
     *
     * In a production environment, this method would:
     * 1. Query the database directly for rating counts
     * 2. Calculate percentages for each rating level (1-5 stars)
     * 3. Compute average rating and total count
     *
     * Currently returns dummy data to maintain application stability.
     *
     * @param lessonId The lesson ID to calculate statistics for
     * @return Map containing rating statistics with safe default values
     */
    private Map<String, Object> calculateRatingStatsManually(int lessonId) {
        Map<String, Object> ratingStats = new HashMap<>();
        try {
            // TODO: Implement actual database queries for rating statistics
            // This is a placeholder for manual calculation that would:
            // 1. Query database for raw rating counts by rating value (1-5)
            // 2. Calculate total ratings count
            // 3. Compute percentage distribution for each rating level
            // 4. Calculate average rating score
            //
            // Example implementation:
            // int totalRatings = LessonRatingDAO.getTotalRatingsForLesson(lessonId);
            // int rating1Count = LessonRatingDAO.getRatingCount(lessonId, 1);
            // int rating2Count = LessonRatingDAO.getRatingCount(lessonId, 2);
            // int rating3Count = LessonRatingDAO.getRatingCount(lessonId, 3);
            // int rating4Count = LessonRatingDAO.getRatingCount(lessonId, 4);
            // int rating5Count = LessonRatingDAO.getRatingCount(lessonId, 5);
            //
            // ratingStats.put("totalRatings", totalRatings);
            // ratingStats.put("ratingPercentages", new HashMap<Integer, Double>() {{
            //     put(1, totalRatings > 0 ? (double) rating1Count / totalRatings * 100 : 0.0);
            //     put(2, totalRatings > 0 ? (double) rating2Count / totalRatings * 100 : 0.0);
            //     put(3, totalRatings > 0 ? (double) rating3Count / totalRatings * 100 : 0.0);
            //     put(4, totalRatings > 0 ? (double) rating4Count / totalRatings * 100 : 0.0);
            //     put(5, totalRatings > 0 ? (double) rating5Count / totalRatings * 100 : 0.0);
            // }});
            // double avgRating = (rating1Count * 1 + rating2Count * 2 + rating3Count * 3 +
            //                    rating4Count * 4 + rating5Count * 5) / (double) totalRatings;
            // ratingStats.put("averageRating", totalRatings > 0 ? avgRating : 0.0);

            // For now, return safe default values to prevent null pointer exceptions
            ratingStats.put("totalRatings", 0);
            ratingStats.put("ratingPercentages", new HashMap<Integer, Double>() {{
                put(1, 0.0);  // 0% for 1-star ratings
                put(2, 0.0);  // 0% for 2-star ratings
                put(3, 0.0);  // 0% for 3-star ratings
                put(4, 0.0);  // 0% for 4-star ratings
                put(5, 0.0);  // 0% for 5-star ratings
            }});
            ratingStats.put("averageRating", 0.0);  // 0.0 average rating

        } catch (Exception e) {
            // Log error for debugging purposes
            e.printStackTrace();
            System.err.println("Error in calculateRatingStatsManually for lessonId: " + lessonId);
        }
        return ratingStats;
    }
} 