package model;

import java.util.List;

public class Question {
    private int id;
    private int quizId;
    private String content;
    private List<Answer> answers;
    
    // Constructors
    public Question() {}
    
    public Question(int id, int quizId, String content) {
        this.id = id;
        this.quizId = quizId;
        this.content = content;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getQuizId() {
        return quizId;
    }
    
    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public List<Answer> getAnswers() {
        return answers;
    }
    
    public void setAnswers(List<Answer> answers) {
        this.answers = answers;
    }
} 