package model;

import java.util.Date;

public class Comment {
    private int id;
    private int userId;
    private int subjectId;
    private Integer lessonId; // Có thể null nếu bình luận cho subject
    private String content;
    private Date createdAt;

    public Comment() {}

    public Comment(int id, int userId, int subjectId, Integer lessonId, String content, Date createdAt) {
        this.id = id;
        this.userId = userId;
        this.subjectId = subjectId;
        this.lessonId = lessonId;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    public Integer getLessonId() { return lessonId; }
    public void setLessonId(Integer lessonId) { this.lessonId = lessonId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
} 