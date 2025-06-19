package model;

public class PricePackage {
    private int id;
    private int subjectId;
    private String name;
    private int duration;
    private double listPrice;
    private double salePrice;
    private String status;

    public PricePackage() {}

    public PricePackage(int id, int subjectId, String name, int duration, double listPrice, double salePrice, String status) {
        this.id = id;
        this.subjectId = subjectId;
        this.name = name;
        this.duration = duration;
        this.listPrice = listPrice;
        this.salePrice = salePrice;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public double getListPrice() { return listPrice; }
    public void setListPrice(double listPrice) { this.listPrice = listPrice; }

    public double getSalePrice() { return salePrice; }
    public void setSalePrice(double salePrice) { this.salePrice = salePrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
} 