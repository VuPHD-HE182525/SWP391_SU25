package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Subject {
    private int id;
    private String name;
    private String tagline;
    private String description;
    private String thumbnailUrl;
    private String category;
    private String status;
    private boolean featured;
    private Date createdAt;
    private Date updatedDate;
    private int categoryId;
    private Package lowestPackage;
    private List<Package> packages;
    private String categoryName;
    private String ownerName;
    private int lessonCount;

    public Subject() {
        this.packages = new ArrayList<>();
    }

    public Subject(int id, String name, String tagline, String description, String thumbnailUrl, Date createdAt, int categoryId) {
        this.id = id;
        this.name = name;
        this.tagline = tagline;
        this.description = description;
        this.thumbnailUrl = thumbnailUrl;
        this.createdAt = createdAt;
        this.categoryId = categoryId;
        this.packages = new ArrayList<>();
    }

    // Getters and Setters
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

    public String getTagline() {
        return tagline;
    }

    public void setTagline(String tagline) {
        this.tagline = tagline;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
    }
  
    public Package getLowestPackage() {
        return lowestPackage;
    }

    public void setLowestPackage(Package lowestPackage) {
        this.lowestPackage = lowestPackage;
    }

    public List<Package> getPackages() {
        return packages;
    }

    public void setPackages(List<Package> packages) {
        this.packages = packages;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public int getLessonCount() {
        return lessonCount;
    }

    public void setLessonCount(int lessonCount) {
        this.lessonCount = lessonCount;
    }
}
