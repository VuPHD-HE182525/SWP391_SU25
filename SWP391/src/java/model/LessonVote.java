package model;

import java.util.Date;

public class LessonVote {
    private int id;
    private int userId;
    private int lessonId;
    private String voteType; // 'like' or 'dislike'
    private Date createdAt;
    private Date updatedAt;
    
    // Constructors
    public LessonVote() {}
    
    public LessonVote(int userId, int lessonId, String voteType) {
        this.userId = userId;
        this.lessonId = lessonId;
        this.voteType = voteType;
    }
    
    public LessonVote(int id, int userId, int lessonId, String voteType, Date createdAt, Date updatedAt) {
        this.id = id;
        this.userId = userId;
        this.lessonId = lessonId;
        this.voteType = voteType;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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
    
    public String getVoteType() {
        return voteType;
    }
    
    public void setVoteType(String voteType) {
        this.voteType = voteType;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Date getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Utility methods
    public boolean isLike() {
        return "like".equalsIgnoreCase(voteType);
    }
    
    public boolean isDislike() {
        return "dislike".equalsIgnoreCase(voteType);
    }
    
    @Override
    public String toString() {
        return "LessonVote{" +
                "id=" + id +
                ", userId=" + userId +
                ", lessonId=" + lessonId +
                ", voteType='" + voteType + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 