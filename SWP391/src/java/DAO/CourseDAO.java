package DAO;


import java.sql.*;
import model.Course;
import model.Package;
import utils.DBContext;


public class CourseDAO {
    public static Course getCourseById(int courseId) {
        Course course = null;
        String sql = "SELECT c.*, s.tagline as subject_tagline, " +
                     "p.id as package_id, p.package_name, p.original_price, p.sale_price, p.duration_months as duration " +
                     "FROM courses c " +
                     "LEFT JOIN subjects s ON c.subject_id = s.id " +
                     "LEFT JOIN packages p ON c.id = p.course_id " +
                     "WHERE c.id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if (course == null) {
                        course = new Course();
                        course.setId(rs.getInt("id"));
                        course.setTitle(rs.getString("title"));
                        course.setDescription(rs.getString("description"));
                        course.setThumbnailUrl(rs.getString("thumbnail_url"));
                        course.setSubjectId(rs.getInt("subject_id"));
                        course.setExpertId(rs.getInt("expert_id"));
                        course.setBriefInfo(rs.getString("brief_info"));
                        course.setTagline(rs.getString("subject_tagline"));
                    }
                    

                    if (rs.getInt("package_id") != 0) {
                        int packageId = rs.getInt("package_id");
                        // Check if package already exists in the list
                        boolean packageExists = course.getPackages().stream()
                                .anyMatch(p -> p.getId() == packageId);
                        
                        if (!packageExists) {
                            Package pkg = new Package();
                            pkg.setId(packageId);
                            pkg.setName(rs.getString("package_name"));
                            pkg.setOriginalPrice(rs.getDouble("original_price"));
                            pkg.setSalePrice(rs.getDouble("sale_price"));
                            pkg.setDuration(rs.getInt("duration"));
                            course.getPackages().add(pkg);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return course;
    }
    
    public static Course getCourseBySubjectId(int subjectId) {
        Course course = null;
        String sql = "SELECT c.*, s.tagline as subject_tagline, " +
                     "p.id as package_id, p.package_name, p.original_price, p.sale_price, p.duration_months as duration " +
                     "FROM courses c " +
                     "LEFT JOIN subjects s ON c.subject_id = s.id " +
                     "LEFT JOIN packages p ON c.id = p.course_id " +
                     "WHERE s.id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if (course == null) {
                        course = new Course();
                        course.setId(rs.getInt("id"));
                        course.setTitle(rs.getString("title"));
                        course.setDescription(rs.getString("description"));
                        course.setThumbnailUrl(rs.getString("thumbnail_url"));
                        course.setSubjectId(rs.getInt("subject_id"));
                        course.setExpertId(rs.getInt("expert_id"));
                        course.setBriefInfo(rs.getString("brief_info"));
                        course.setTagline(rs.getString("subject_tagline"));
                    }
                    

                    if (rs.getInt("package_id") != 0) {
                        int packageId = rs.getInt("package_id");
                        // Check if package already exists in the list
                        boolean packageExists = course.getPackages().stream()
                                .anyMatch(p -> p.getId() == packageId);
                        
                        if (!packageExists) {
                            Package pkg = new Package();
                            pkg.setId(packageId);
                            pkg.setName(rs.getString("package_name"));
                            pkg.setOriginalPrice(rs.getDouble("original_price"));
                            pkg.setSalePrice(rs.getDouble("sale_price"));
                            pkg.setDuration(rs.getInt("duration"));
                            course.getPackages().add(pkg);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return course;
    }
    
    // Instance methods for consistency with other DAOs
    public Course getCourseByIdInstance(int courseId) {
        return getCourseById(courseId);
    }
    
    public Course getCourseBySubjectIdInstance(int subjectId) {
        return getCourseBySubjectId(subjectId);
    }
} 