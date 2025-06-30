package model;

public class Dimension {
    private int id;
    private int subjectId;
    private String type;
    private String name;

    public Dimension() {}

    public Dimension(int id, int subjectId, String type, String name) {
        this.id = id;
        this.subjectId = subjectId;
        this.type = type;
        this.name = name;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
} 