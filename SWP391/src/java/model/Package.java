package model;

import java.sql.Timestamp;

public class Package {

    private int id;
    private int subjectId;
    private String name;
    private double originalPrice;
    private double salePrice;
    private int duration;
    private String status;
    private Timestamp createdAt;

    public Package() {
    }

    public Package(int id, int subjectId, String name, double originalPrice, double salePrice, int duration, String status) {
        this.id = id;
        this.subjectId = subjectId;
        this.name = name;
        this.originalPrice = originalPrice;
        this.salePrice = salePrice;
        this.duration = duration;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(double originalPrice) {
        this.originalPrice = originalPrice;
    }

    public double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(double salePrice) {
        this.salePrice = salePrice;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
} 