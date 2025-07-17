package model;

import java.time.LocalDateTime;

public class VideoTranscript {
    
    private int id;
    private int lessonId;
    private String videoPath;
    private String transcript;
    private String keyTopics;
    private String learningObjectives;
    private String timestamps;
    private String summary;
    private LocalDateTime processedAt;
    private LocalDateTime updatedAt;
    private long fileSize;
    private int durationSeconds;
    private String status;
    private String errorMessage;
    
    // Constructors
    public VideoTranscript() {}
    
    public VideoTranscript(int lessonId, String videoPath) {
        this.lessonId = lessonId;
        this.videoPath = videoPath;
        this.status = "pending";
    }
    
    public VideoTranscript(int lessonId, String videoPath, String transcript, 
                          String keyTopics, String learningObjectives, String summary) {
        this.lessonId = lessonId;
        this.videoPath = videoPath;
        this.transcript = transcript;
        this.keyTopics = keyTopics;
        this.learningObjectives = learningObjectives;
        this.summary = summary;
        this.status = "completed";
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getLessonId() {
        return lessonId;
    }
    
    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }
    
    public String getVideoPath() {
        return videoPath;
    }
    
    public void setVideoPath(String videoPath) {
        this.videoPath = videoPath;
    }
    
    public String getTranscript() {
        return transcript;
    }
    
    public void setTranscript(String transcript) {
        this.transcript = transcript;
    }
    
    public String getKeyTopics() {
        return keyTopics;
    }
    
    public void setKeyTopics(String keyTopics) {
        this.keyTopics = keyTopics;
    }
    
    public String getLearningObjectives() {
        return learningObjectives;
    }
    
    public void setLearningObjectives(String learningObjectives) {
        this.learningObjectives = learningObjectives;
    }
    
    public String getTimestamps() {
        return timestamps;
    }
    
    public void setTimestamps(String timestamps) {
        this.timestamps = timestamps;
    }
    
    public String getSummary() {
        return summary;
    }
    
    public void setSummary(String summary) {
        this.summary = summary;
    }
    
    public LocalDateTime getProcessedAt() {
        return processedAt;
    }
    
    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public long getFileSize() {
        return fileSize;
    }
    
    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }
    
    public int getDurationSeconds() {
        return durationSeconds;
    }
    
    public void setDurationSeconds(int durationSeconds) {
        this.durationSeconds = durationSeconds;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    // Helper methods
    public boolean isCompleted() {
        return "completed".equals(this.status);
    }
    
    public boolean isProcessing() {
        return "processing".equals(this.status);
    }
    
    public boolean hasFailed() {
        return "failed".equals(this.status);
    }
    
    public String getFormattedDuration() {
        if (durationSeconds <= 0) return "Unknown";
        
        int minutes = durationSeconds / 60;
        int seconds = durationSeconds % 60;
        return String.format("%d:%02d", minutes, seconds);
    }
    
    public String getFormattedFileSize() {
        if (fileSize <= 0) return "Unknown";
        
        if (fileSize < 1024) return fileSize + " B";
        if (fileSize < 1024 * 1024) return String.format("%.1f KB", fileSize / 1024.0);
        if (fileSize < 1024 * 1024 * 1024) return String.format("%.1f MB", fileSize / (1024.0 * 1024.0));
        return String.format("%.1f GB", fileSize / (1024.0 * 1024.0 * 1024.0));
    }
    
    @Override
    public String toString() {
        return "VideoTranscript{" +
                "id=" + id +
                ", lessonId=" + lessonId +
                ", videoPath='" + videoPath + '\'' +
                ", status='" + status + '\'' +
                ", processedAt=" + processedAt +
                '}';
    }
} 