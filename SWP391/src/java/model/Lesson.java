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

    public Lesson() {
    }

    public Lesson(int id, String name, int orderNum, String type, boolean status, int subjectId, int parentLessonId) {
        this.id = id;
        this.name = name;
        this.orderNum = orderNum;
        this.type = type;
        this.status = status;
        this.subjectId = subjectId;
        this.parentLessonId = parentLessonId;
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
    
    
}
