package model;

import java.time.LocalDateTime;

public class LessonComment {
    private int id;
    private int userId;
    private int lessonId;
    private String commentText;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Additional fields for display
    private String userFullName;
    private String userAvatarUrl;
    
    // Constructors
    public LessonComment() {}
    
    public LessonComment(int userId, int lessonId, String commentText) {
        this.userId = userId;
        this.lessonId = lessonId;
        this.commentText = commentText;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
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
    
    public String getCommentText() {
        return commentText;
    }
    
    public void setCommentText(String commentText) {
        this.commentText = commentText;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getUserFullName() {
        return userFullName;
    }
    
    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }
    
    public String getUserAvatarUrl() {
        return userAvatarUrl;
    }
    
    public void setUserAvatarUrl(String userAvatarUrl) {
        this.userAvatarUrl = userAvatarUrl;
    }
} 