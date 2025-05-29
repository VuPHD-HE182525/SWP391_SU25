/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author thang
 */
public class Subject {
    private int id;
    private String name;
    private String category;
    private int numberOfLessons;
    private String owner;
    private boolean status;

    // Constructors, Getters, and Setters
    public Subject() {}

    // Getters and Setters for all fields
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public int getNumberOfLessons() { return numberOfLessons; }
    public void setNumberOfLessons(int numberOfLessons) { this.numberOfLessons = numberOfLessons; }
    public String getOwner() { return owner; }
    public void setOwner(String owner) { this.owner = owner; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
}
