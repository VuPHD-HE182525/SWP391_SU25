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

/**
 * Lesson Detail Servlet - Handles lesson management and editing functionality
 *
 * This servlet manages the lesson detail view and editing interface for administrators
 * and instructors. It provides functionality to view, create, and update lesson information
 * including video links, HTML content, quiz associations, and lesson metadata.
 *
 * Key Features:
 * - Lesson detail display with full information
 * - Lesson creation and editing forms
 * - Subject and quiz association management
 * - Lesson hierarchy support (parent-child relationships)
 * - Status management (active/inactive lessons)
 * - Integration with subject and quiz systems
 *
 * URL Mapping: /lesson-detail
 * Methods: GET (display/form), POST (create/update)
 *
 * Request Parameters:
 * - id: Lesson ID for editing existing lesson
 * - subjectId: Subject ID for creating new lesson
 *
 * @author SWP391 Team
 */
@WebServlet("/lesson-detail")
public class LessonDetailServlet extends HttpServlet {

    /**
     * Handles GET requests for lesson detail display and editing forms
     *
     * This method serves two purposes:
     * 1. Display existing lesson details for editing (when id parameter is provided)
     * 2. Display new lesson creation form (when subjectId parameter is provided)
     *
     * Processing Flow:
     * 1. Initialize DAOs for database operations
     * 2. Determine operation mode (edit existing vs create new)
     * 3. Load lesson data and associated subject information
     * 4. Prepare form data (lesson lists, subject lists, quiz lists)
     * 5. Set request attributes for JSP rendering
     * 6. Forward to lesson detail JSP view
     *
     * @param request HTTP request with id or subjectId parameter
     * @param response HTTP response for lesson detail page
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Step 1: Initialize Data Access Objects for database operations
            LessonDAO lessonDAO = new LessonDAO();
            SubjectDAO subjectDAO = new SubjectDAO();
            QuizDAO quizDAO = new QuizDAO();

            // Step 2: Initialize lesson object for form data
            Lesson lesson = new Lesson();

            // Step 3: Determine operation mode based on request parameters
            String idRaw = request.getParameter("id");
            if (idRaw != null && !idRaw.isEmpty()) {
                // Edit existing lesson mode
                int id = Integer.parseInt(idRaw);
                lesson = lessonDAO.getLessonById(id);

                // Load associated subject information for context
                if (lesson != null && lesson.getSubjectId() > 0) {
                    Subject subject = subjectDAO.getSubjectById(lesson.getSubjectId());
                    request.setAttribute("subject", subject);
                }
            } else {
                // Create new lesson mode
                String subjectIdRaw = request.getParameter("subjectId");
                if (subjectIdRaw != null && !subjectIdRaw.isEmpty()) {
                    int subjectId = Integer.parseInt(subjectIdRaw);
                    // Pre-populate lesson with subject ID for new lesson creation
                    lesson.setSubjectId(subjectId);
                    Subject subject = subjectDAO.getSubjectById(subjectId);
                    request.setAttribute("subject", subject);
                }
            }

            // Step 4: Set main lesson data for form display
            request.setAttribute("lesson", lesson);

            // Step 5: Prepare form dropdown data
            // Load lessons for the same subject to show in parent lesson dropdown
            int subjectIdForLessonList = (lesson.getSubjectId() > 0) ? lesson.getSubjectId() : -1;
            request.setAttribute("lessonList", lessonDAO.getLessonsBySubject(subjectIdForLessonList));

            // Load all subjects for subject selection dropdown
            request.setAttribute("subjectList", subjectDAO.getAllSubjects());

            // Load all quizzes for quiz association dropdown
            List<Quiz> quizList = quizDAO.getAllQuizzes();
            request.setAttribute("quizList", quizList);

            // Step 6: Forward to lesson detail JSP for form rendering
            request.getRequestDispatcher("/WEB-INF/views/lesson_detail.jsp").forward(request, response);

        } catch (Exception e) {
            // Handle any database or processing errors gracefully
            e.printStackTrace();
            response.getWriter().println("Error loading lesson details: " + e.getMessage());
        }
    }

    /**
     * Handles POST requests for lesson creation and updates
     *
     * This method processes form submissions for creating new lessons or updating
     * existing ones. It extracts form data, validates input, creates/updates the
     * lesson record in the database, and redirects to the updated lesson detail page.
     *
     * Processing Flow:
     * 1. Set UTF-8 encoding for proper character handling
     * 2. Extract and validate form parameters
     * 3. Handle optional fields with null checking
     * 4. Create lesson object with form data
     * 5. Determine operation type (insert vs update) based on ID
     * 6. Execute database operation
     * 7. Redirect to lesson detail page with success
     *
     * @param request HTTP request with lesson form data
     * @param response HTTP response for redirect after processing
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Step 1: Set character encoding for proper UTF-8 handling
            request.setCharacterEncoding("UTF-8");

            // Step 2: Extract required form parameters
            int id = Integer.parseInt(request.getParameter("id"));                    // 0 for new lesson, >0 for update
            String name = request.getParameter("name");                              // Lesson name/title
            int orderNum = Integer.parseInt(request.getParameter("orderNum"));       // Display order in course
            String type = request.getParameter("type");                              // Lesson type (video, reading, etc.)
            boolean status = Boolean.parseBoolean(request.getParameter("status"));   // Active/inactive status
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));     // Associated subject/course ID

            // Step 3: Handle optional parent lesson ID with null checking
            String parentRaw = request.getParameter("parentLessonId");
            int parentLessonId = (parentRaw == null || parentRaw.isEmpty()) ? 0 : Integer.parseInt(parentRaw);

            // Step 4: Extract optional content fields
            String videoLink = request.getParameter("videoLink");                    // Video URL for video lessons
            String htmlContent = request.getParameter("htmlContent");                // HTML content for reading lessons
            String quizIdRaw = request.getParameter("quizId");                      // Associated quiz ID
            Integer quizId = (quizIdRaw != null && !quizIdRaw.isEmpty()) ? Integer.parseInt(quizIdRaw) : null;

            // Step 5: Create lesson object with extracted data
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
            lesson.setQuizId(quizId);

            // Step 6: Execute database operation based on lesson ID
            LessonDAO dao = new LessonDAO();
            if (id == 0) {
                // Create new lesson
                dao.insertLesson(lesson);
            } else {
                // Update existing lesson
                dao.updateLesson(lesson);
            }

            // Step 7: Redirect to lesson detail page with updated data
            response.sendRedirect("lesson-detail?id=" + lesson.getId());

        } catch (Exception e) {
            // Handle any database or processing errors gracefully
            e.printStackTrace();
            response.getWriter().println("Error updating lesson: " + e.getMessage());
        }
    }
}
