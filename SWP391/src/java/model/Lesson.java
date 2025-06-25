package model;

public class Lesson {
    private int id;
    private int subjectId;
    private String title;
    private String videoUrl;
    private double duration;

    public Lesson() {}

    public Lesson(int id, int subjectId, String title, String videoUrl, double duration) {
        this.id = id;
        this.subjectId = subjectId;
        this.title = title;
        this.videoUrl = videoUrl;
        this.duration = duration;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getVideoUrl() { return videoUrl; }
    public void setVideoUrl(String videoUrl) { this.videoUrl = videoUrl; }
    public double getDuration() { return duration; }
    public void setDuration(double duration) { this.duration = duration; }
} 