/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Kaonashi
 */
public class Lesson {

    private int id;
    private String name;
    private int orderNum;
    private String type;
    private boolean status;
    private int subjectId;
    private int parentLessonId;
    private String videoLink;
    private String htmlContent;
    private Integer quizId;
    
    // New fields for hybrid content support (file-based like Coursera)
    private String contentFilePath;
    private String objectivesFilePath;
    private String referencesFilePath;
    private String contentType; 
    private int estimatedTime;

    public Lesson() {
    }

    public Lesson(int id, String name, int orderNum, String type, boolean status, int subjectId, int parentLessonId, String videoLink, String htmlContent, Integer quizId) {
        this.id = id;
        this.name = name;
        this.orderNum = orderNum;
        this.type = type;
        this.status = status;
        this.subjectId = subjectId;
        this.parentLessonId = parentLessonId;
        this.videoLink = videoLink;
        this.htmlContent = htmlContent;
        this.quizId = quizId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(int orderNum) {
        this.orderNum = orderNum;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public int getParentLessonId() {
        return parentLessonId;
    }

    public void setParentLessonId(int parentLessonId) {
        this.parentLessonId = parentLessonId;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    public String getHtmlContent() {
        return htmlContent;
    }

    public void setHtmlContent(String htmlContent) {
        this.htmlContent = htmlContent;
    }

    public Integer getQuizId() {
        return quizId;
    }

    public void setQuizId(Integer quizId) {
        this.quizId = quizId;
    }

    // Getters and setters for hybrid content fields
    public String getContentFilePath() {
        return contentFilePath;
    }

    public void setContentFilePath(String contentFilePath) {
        this.contentFilePath = contentFilePath;
    }

    public String getObjectivesFilePath() {
        return objectivesFilePath;
    }

    public void setObjectivesFilePath(String objectivesFilePath) {
        this.objectivesFilePath = objectivesFilePath;
    }

    public String getReferencesFilePath() {
        return referencesFilePath;
    }

    public void setReferencesFilePath(String referencesFilePath) {
        this.referencesFilePath = referencesFilePath;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public int getEstimatedTime() {
        return estimatedTime;
    }

    public void setEstimatedTime(int estimatedTime) {
        this.estimatedTime = estimatedTime;
    }
}
