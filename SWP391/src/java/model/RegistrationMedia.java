package model;

import java.sql.Timestamp;

/**
 * Model class for registration media files
 * Handles multiple images and videos for each registration
 */
public class RegistrationMedia {
    private int id;
    private int registrationId;
    private String mediaType; // 'image' or 'video'
    private String fileUrl;
    private String fileDescription;
    private long fileSize;
    private String fileName;
    private Timestamp uploadedAt;
    private int displayOrder;

    // Constructors
    public RegistrationMedia() {
    }

    public RegistrationMedia(int registrationId, String mediaType, String fileUrl, String fileDescription) {
        this.registrationId = registrationId;
        this.mediaType = mediaType;
        this.fileUrl = fileUrl;
        this.fileDescription = fileDescription;
        this.displayOrder = 0;
    }

    public RegistrationMedia(int registrationId, String mediaType, String fileUrl, String fileDescription, 
                           long fileSize, String fileName, int displayOrder) {
        this.registrationId = registrationId;
        this.mediaType = mediaType;
        this.fileUrl = fileUrl;
        this.fileDescription = fileDescription;
        this.fileSize = fileSize;
        this.fileName = fileName;
        this.displayOrder = displayOrder;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRegistrationId() {
        return registrationId;
    }

    public void setRegistrationId(int registrationId) {
        this.registrationId = registrationId;
    }

    public String getMediaType() {
        return mediaType;
    }

    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getFileDescription() {
        return fileDescription;
    }

    public void setFileDescription(String fileDescription) {
        this.fileDescription = fileDescription;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    // Helper methods
    public boolean isImage() {
        return "image".equals(mediaType);
    }

    public boolean isVideo() {
        return "video".equals(mediaType);
    }

    @Override
    public String toString() {
        return "RegistrationMedia{" +
                "id=" + id +
                ", registrationId=" + registrationId +
                ", mediaType='" + mediaType + '\'' +
                ", fileUrl='" + fileUrl + '\'' +
                ", fileDescription='" + fileDescription + '\'' +
                ", fileName='" + fileName + '\'' +
                ", displayOrder=" + displayOrder +
                '}';
    }
} 