/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Kaonashi
 */
public class Quiz {

    private int id;
    private Integer lessonId;
    private String code;
    private String description;
    private String title;
    private int subjectId;
    private String level;
    private int duration;
    private double passRate;
    private String quizType;
    private int totalQuestions;

    public Quiz() {
    }

    public Quiz(int id, Integer lessonId, String code, String description, String title, int subjectId, String level, int duration, double passRate, String quizType, int totalQuestions) {
        this.id = id;
        this.lessonId = lessonId;
        this.code = code;
        this.description = description;
        this.title = title;
        this.subjectId = subjectId;
        this.level = level;
        this.duration = duration;
        this.passRate = passRate;
        this.quizType = quizType;
        this.totalQuestions = totalQuestions;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getLessonId() {
        return lessonId;
    }

    public void setLessonId(Integer lessonId) {
        this.lessonId = lessonId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public double getPassRate() {
        return passRate;
    }

    public void setPassRate(double passRate) {
        this.passRate = passRate;
    }

    public String getQuizType() {
        return quizType;
    }

    public void setQuizType(String quizType) {
        this.quizType = quizType;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

}
