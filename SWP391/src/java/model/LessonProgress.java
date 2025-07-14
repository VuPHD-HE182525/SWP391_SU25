package model;

import java.time.LocalDateTime;

public class LessonProgress {
    private int id;
    private int userId;
    private int lessonId;
    private boolean isCompleted;
    private LocalDateTime lastViewedAt;
    private int viewDurationSeconds;
    
    // Constructors
    public LessonProgress() {}
    
    public LessonProgress(int userId, int lessonId) {
        this.userId = userId;
        this.lessonId = lessonId;
        this.isCompleted = false;
        this.lastViewedAt = LocalDateTime.now();
        this.viewDurationSeconds = 0;
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
    
    public int getLessonId() {
        return lessonId;
    }
    
    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }
    
    public boolean isCompleted() {
        return isCompleted;
    }
    
    public void setCompleted(boolean completed) {
        isCompleted = completed;
    }
    
    public LocalDateTime getLastViewedAt() {
        return lastViewedAt;
    }
    
    public void setLastViewedAt(LocalDateTime lastViewedAt) {
        this.lastViewedAt = lastViewedAt;
    }
    
    public int getViewDurationSeconds() {
        return viewDurationSeconds;
    }
    
    public void setViewDurationSeconds(int viewDurationSeconds) {
        this.viewDurationSeconds = viewDurationSeconds;
    }
} 