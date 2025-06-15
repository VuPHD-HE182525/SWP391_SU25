package dao;

import model.Course;
import model.Package;
import utils.DBContext;
import java.sql.*;

public class CourseDAO {
    public static Course getCourseById(int courseId) {
        Course course = null;
        String sql = "SELECT TOP 1 c.*, s.tagline as subject_tagline, p.id as package_id, p.package_name as package_name, p.original_price, p.sale_price, p.duration_months as duration " +
                     "FROM courses_2 c " +
                     "LEFT JOIN packages_2 p ON c.id = p.course_id " +
                     "LEFT JOIN subjects_2 s ON c.subject_id = s.id " +
                     "WHERE c.id = ? ORDER BY p.sale_price ASC";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setThumbnailUrl(rs.getString("thumbnail_url"));
                    course.setSubjectId(rs.getInt("subject_id"));
                    course.setExpertId(rs.getInt("expert_id"));
                    course.setBriefInfo(rs.getString("brief_info"));
                    course.setTagline(rs.getString("subject_tagline"));
                    // Only set package if available
                    if (rs.getInt("package_id") != 0) {
                        Package pkg = new Package();
                        pkg.setId(rs.getInt("package_id"));
                        pkg.setName(rs.getString("package_name"));
                        pkg.setOriginalPrice(rs.getDouble("original_price"));
                        pkg.setSalePrice(rs.getDouble("sale_price"));
                        pkg.setDuration(rs.getInt("duration"));
                        course.setCoursePackage(pkg);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return course;
    }

    public static Course getMainCourseBySubjectId(int subjectId) {
        Course course = null;
        String sql = "SELECT TOP 1 c.*, s.tagline as subject_tagline, p.id as package_id, p.package_name as package_name, p.original_price, p.sale_price, p.duration_months as duration " +
                     "FROM courses_2 c " +
                     "LEFT JOIN packages_2 p ON c.id = p.course_id " +
                     "LEFT JOIN subjects_2 s ON c.subject_id = s.id " +
                     "WHERE c.subject_id = ? ORDER BY p.sale_price ASC";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setThumbnailUrl(rs.getString("thumbnail_url"));
                    course.setSubjectId(rs.getInt("subject_id"));
                    course.setExpertId(rs.getInt("expert_id"));
                    course.setBriefInfo(rs.getString("brief_info"));
                    course.setTagline(rs.getString("subject_tagline"));
                    // Only set package if available
                    if (rs.getInt("package_id") != 0) {
                        Package pkg = new Package();
                        pkg.setId(rs.getInt("package_id"));
                        pkg.setName(rs.getString("package_name"));
                        pkg.setOriginalPrice(rs.getDouble("original_price"));
                        pkg.setSalePrice(rs.getDouble("sale_price"));
                        pkg.setDuration(rs.getInt("duration"));
                        course.setCoursePackage(pkg);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return course;
    }
} 