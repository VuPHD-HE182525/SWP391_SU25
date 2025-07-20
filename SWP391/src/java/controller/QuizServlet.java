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

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

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
                case "review":
                    showQuizReview(request, response, currentUser);
                    break;
                default:
                    showQuizDetails(request, response, currentUser);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing quiz request");
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
                    submitQuiz(request, response, currentUser);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing quiz submission");
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
        
        // Get user's latest submission for this quiz
        QuizSubmission latestSubmission = submissionDAO.getLatestSubmission(currentUser.getId(), quizId);
        
        // Get course/lesson info if available
        Course course = null;
        Lesson lesson = null;
        try {
            if (quiz.getLessonId() != null) {
                LessonDAO lessonDAO = new LessonDAO();
                lesson = lessonDAO.getLessonById(quiz.getLessonId());
                if (lesson != null) {
                    CourseDAO courseDAO = new CourseDAO();
                    course = courseDAO.getCourseById(lesson.getSubjectId());
                }
            }
        } catch (Exception e) {
            // Log error but continue - course info is optional
            e.printStackTrace();
        }
        
        request.setAttribute("quiz", quiz);
        request.setAttribute("latestSubmission", latestSubmission);
        request.setAttribute("course", course);
        request.setAttribute("lesson", lesson);
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
    
    private void showQuizReview(HttpServletRequest request, HttpServletResponse response, User currentUser)
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
        
        request.getRequestDispatcher("/WEB-INF/views/quiz_review.jsp").forward(request, response);
    }
    
    private void submitQuiz(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String quizIdParam = request.getParameter("quizId");
        if (quizIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz ID is required");
            return;
        }
        
        int quizId = Integer.parseInt(quizIdParam);
        
        QuizDAO quizDAO = new QuizDAO();
        QuestionDAO questionDAO = new QuestionDAO();
        AnswerDAO answerDAO = new AnswerDAO();
        QuizSubmissionDAO submissionDAO = new QuizSubmissionDAO();
        
        Quiz quiz = quizDAO.getQuizById(quizId);
        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
            return;
        }
        
        List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
        
        // Calculate score
        int correctAnswers = 0;
        int totalQuestions = questions.size();
        Map<Integer, Integer> userAnswers = new HashMap<>();
        
        for (Question question : questions) {
            String answerParam = request.getParameter("question_" + question.getId());
            if (answerParam != null) {
                int selectedAnswerId = Integer.parseInt(answerParam);
                userAnswers.put(question.getId(), selectedAnswerId);
                
                Answer selectedAnswer = answerDAO.getAnswerById(selectedAnswerId);
                if (selectedAnswer != null && selectedAnswer.isCorrect()) {
                    correctAnswers++;
                }
            }
        }
        
        int score = totalQuestions > 0 ? (int) Math.round((double) correctAnswers / totalQuestions * 100) : 0;
        
        // Create and save submission
        QuizSubmission submission = new QuizSubmission(currentUser.getId(), quizId, score, totalQuestions, correctAnswers);
        submission.setUserAnswers(userAnswers);
        submissionDAO.insertSubmission(submission);
        
        // Redirect to result page
        response.sendRedirect("quiz?action=result&submissionId=" + submission.getId());
    }
} 