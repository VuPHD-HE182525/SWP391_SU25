package controller;

import DAO.QuizDAO;
import DAO.QuestionDAO;
import DAO.AnswerDAO;
import DAO.QuizSubmissionDAO;
import DAO.LessonDAO;
import DAO.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;

@WebServlet("/quiz-fixed")
public class QuizServletFixed extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "view";
        
        try {
            switch (action) {
                case "view":
                    showQuizDetails(request, response, currentUser);
                    break;
                case "take":
                    showQuizTaking(request, response, currentUser);
                    break;
                case "result":
                    showQuizResult(request, response, currentUser);
                    break;
                default:
                    showQuizDetails(request, response, currentUser);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // More detailed error message
            request.setAttribute("errorMessage", "Quiz Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "submit";
        
        try {
            switch (action) {
                case "submit":
                    submitQuizSimplified(request, response, currentUser);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // More detailed error message
            request.setAttribute("errorMessage", "Quiz Submission Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    private void showQuizDetails(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String quizIdParam = request.getParameter("quizId");
        if (quizIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz ID is required");
            return;
        }
        
        int quizId = Integer.parseInt(quizIdParam);
        
        QuizDAO quizDAO = new QuizDAO();
        QuizSubmissionDAO submissionDAO = new QuizSubmissionDAO();
        
        Quiz quiz = quizDAO.getQuizById(quizId);
        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
            return;
        }
        
        // Get user's latest submission for this quiz (simplified)
        QuizSubmission latestSubmission = null;
        try {
            latestSubmission = submissionDAO.getLatestSubmission(currentUser.getId(), quizId);
        } catch (Exception e) {
            System.out.println("Error getting latest submission: " + e.getMessage());
            // Continue without latest submission
        }
        
        request.setAttribute("quiz", quiz);
        request.setAttribute("latestSubmission", latestSubmission);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/WEB-INF/views/quiz_view.jsp").forward(request, response);
    }
    
    private void showQuizTaking(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String quizIdParam = request.getParameter("quizId");
        if (quizIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz ID is required");
            return;
        }
        
        int quizId = Integer.parseInt(quizIdParam);
        
        QuizDAO quizDAO = new QuizDAO();
        QuestionDAO questionDAO = new QuestionDAO();
        
        Quiz quiz = quizDAO.getQuizById(quizId);
        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
            return;
        }
        
        List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
        
        request.setAttribute("quiz", quiz);
        request.setAttribute("questions", questions);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/WEB-INF/views/quiz_handle.jsp").forward(request, response);
    }
    
    private void showQuizResult(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String submissionIdParam = request.getParameter("submissionId");
        if (submissionIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Submission ID is required");
            return;
        }
        
        int submissionId = Integer.parseInt(submissionIdParam);
        
        QuizSubmissionDAO submissionDAO = new QuizSubmissionDAO();
        QuizDAO quizDAO = new QuizDAO();
        QuestionDAO questionDAO = new QuestionDAO();
        
        QuizSubmission submission = submissionDAO.getSubmissionById(submissionId);
        if (submission == null || submission.getUserId() != currentUser.getId()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Submission not found");
            return;
        }
        
        Quiz quiz = quizDAO.getQuizById(submission.getQuizId());
        List<Question> questions = questionDAO.getQuestionsByQuizId(submission.getQuizId());
        
        request.setAttribute("submission", submission);
        request.setAttribute("quiz", quiz);
        request.setAttribute("questions", questions);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/WEB-INF/views/quiz_result.jsp").forward(request, response);
    }
    
    private void submitQuizSimplified(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String quizIdParam = request.getParameter("quizId");
        if (quizIdParam == null) {
            throw new ServletException("Quiz ID is required");
        }
        
        int quizId = Integer.parseInt(quizIdParam);
        
        QuizDAO quizDAO = new QuizDAO();
        QuestionDAO questionDAO = new QuestionDAO();
        AnswerDAO answerDAO = new AnswerDAO();
        
        Quiz quiz = quizDAO.getQuizById(quizId);
        if (quiz == null) {
            throw new ServletException("Quiz not found");
        }
        
        List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
        
        // Calculate score
        int correctAnswers = 0;
        int totalQuestions = questions.size();
        
        for (Question question : questions) {
            String answerParam = request.getParameter("question_" + question.getId());
            if (answerParam != null && !answerParam.trim().isEmpty()) {
                try {
                    int selectedAnswerId = Integer.parseInt(answerParam);
                    Answer selectedAnswer = answerDAO.getAnswerById(selectedAnswerId);
                    if (selectedAnswer != null && selectedAnswer.isCorrect()) {
                        correctAnswers++;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Invalid answer ID: " + answerParam);
                }
            }
        }
        
        int score = totalQuestions > 0 ? (int) Math.round((double) correctAnswers / totalQuestions * 100) : 0;
        
        // Create simplified submission (only fields that exist in DB)
        QuizSubmission submission = new QuizSubmission();
        submission.setUserId(currentUser.getId());
        submission.setQuizId(quizId);
        submission.setScore(score);
        submission.setSubmittedAt(LocalDateTime.now());
        
        // Insert submission with simplified method
        insertSubmissionSimplified(submission);
        
        // Redirect to a simple success page instead of result page
        request.setAttribute("quiz", quiz);
        request.setAttribute("score", score);
        request.setAttribute("correctAnswers", correctAnswers);
        request.setAttribute("totalQuestions", totalQuestions);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/WEB-INF/views/quiz_success.jsp").forward(request, response);
    }
    
    private void insertSubmissionSimplified(QuizSubmission submission) throws ServletException {
        String sql = "INSERT INTO quiz_submissions (user_id, quiz_id, submitted_at, score) VALUES (?, ?, ?, ?)";
        
        try (java.sql.Connection conn = utils.DBContext.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, submission.getUserId());
            ps.setInt(2, submission.getQuizId());
            ps.setTimestamp(3, java.sql.Timestamp.valueOf(submission.getSubmittedAt()));
            ps.setInt(4, submission.getScore());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (java.sql.ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        submission.setId(generatedKeys.getInt(1));
                    }
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to save quiz submission: " + e.getMessage());
        }
    }
} 