package model;

import java.time.LocalDateTime;
import java.util.Map;

public class QuizSubmission {
    private int id;
    private int userId;
    private int quizId;
    private LocalDateTime submittedAt;
    private int score;
    private int totalQuestions;
    private int correctAnswers;
    private Map<Integer, Integer> userAnswers; // questionId -> answerId
    
    // Additional fields for display
    private String userName;
    private String quizTitle;
    
    // Constructors
    public QuizSubmission() {}
    
    public QuizSubmission(int userId, int quizId, int score, int totalQuestions, int correctAnswers) {
        this.userId = userId;
        this.quizId = quizId;
        this.score = score;
        this.totalQuestions = totalQuestions;
        this.correctAnswers = correctAnswers;
        this.submittedAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getQuizId() {
        return quizId;
    }
    
    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }
    
    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }
    
    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }
    
    public int getScore() {
        return score;
    }
    
    public void setScore(int score) {
        this.score = score;
    }
    
    public int getTotalQuestions() {
        return totalQuestions;
    }
    
    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }
    
    public int getCorrectAnswers() {
        return correctAnswers;
    }
    
    public void setCorrectAnswers(int correctAnswers) {
        this.correctAnswers = correctAnswers;
    }
    
    public Map<Integer, Integer> getUserAnswers() {
        return userAnswers;
    }
    
    public void setUserAnswers(Map<Integer, Integer> userAnswers) {
        this.userAnswers = userAnswers;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getQuizTitle() {
        return quizTitle;
    }
    
    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }
    
    public double getPercentage() {
        if (totalQuestions == 0) return 0;
        return (double) correctAnswers / totalQuestions * 100;
    }
} 