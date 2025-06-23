package dao;

import model.Subject;
import model.Package;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class SubjectDAO {
    
    public static List<Subject> getSubjects(String search, String categoryId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "p.id AS package_id, p.name AS package_name, p.original_price, p.sale_price, p.duration, p.status " +
                "FROM subjects s " +
                "LEFT JOIN packages p ON s.id = p.subject_id " +
                "WHERE p.sale_price = ( " +
                "    SELECT MIN(p2.sale_price) " +
                "    FROM packages p2 " +
                "    WHERE p2.subject_id = s.id " +
                ") " +
                (search != null && !search.trim().isEmpty() ? "AND (s.name LIKE ? OR s.tagline LIKE ?) " : "") +
                (categoryId != null && !categoryId.trim().isEmpty() ? "AND s.category_id = ? " : "") +
                "ORDER BY s.created_at DESC";
        
        try {
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                int paramIndex = 1;
                if (search != null && !search.trim().isEmpty()) {
                    ps.setString(paramIndex++, "%" + search + "%");
                    ps.setString(paramIndex++, "%" + search + "%");
                }
                if (categoryId != null && !categoryId.trim().isEmpty()) {
                    ps.setString(paramIndex, categoryId);
                }
                
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Subject subject = new Subject();
                        subject.setId(rs.getInt("id"));
                        subject.setName(rs.getString("name"));
                        subject.setTagline(rs.getString("tagline"));
                        subject.setDescription(rs.getString("description"));
                        subject.setThumbnailUrl(rs.getString("thumbnail_url"));
                        subject.setCreatedAt(rs.getTimestamp("created_at"));
                        subject.setCategoryId(rs.getInt("category_id"));

                        Package pkg = new Package();
                        pkg.setId(rs.getInt("package_id"));
                        pkg.setSubjectId(rs.getInt("id"));
                        pkg.setName(rs.getString("package_name"));
                        pkg.setOriginalPrice(rs.getDouble("original_price"));
                        pkg.setSalePrice(rs.getDouble("sale_price"));
                        pkg.setDuration(rs.getInt("duration"));
                        pkg.setStatus(rs.getString("status"));

                        subject.setLowestPackage(pkg);
                        subjects.add(subject);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return subjects;
    }
    
    public static List<Subject> getFeatured(List<Subject> allSubjects) {
        List<Subject> featured = new ArrayList<>();
        if (allSubjects != null && !allSubjects.isEmpty()) {
            // Placeholder logic: Add the first subject as featured
            featured.add(allSubjects.get(0));
        }
        return featured;
    }

    public static List<Subject> getSubjectsForMainContent(String search, String categoryId, int page, int pageSize) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "p.id as package_id, p.package_name, p.original_price, p.sale_price, p.duration_months as duration " +
                "FROM subjects s " +
                "LEFT JOIN (" +
                "    SELECT c.subject_id, p.*, ROW_NUMBER() OVER(PARTITION BY c.subject_id ORDER BY p.sale_price ASC) as rn " +
                "    FROM packages p JOIN courses c ON p.course_id = c.id" +
                ") p ON s.id = p.subject_id AND p.rn = 1 " +
                "WHERE 1=1 " +
                (search != null && !search.trim().isEmpty() ? "AND (s.name LIKE ? OR s.tagline LIKE ?) " : "") +
                (categoryId != null && !categoryId.trim().isEmpty() ? "AND s.category_id = ? " : "") +
                "ORDER BY s.created_at DESC " +
                "LIMIT ?, ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                ps.setString(paramIndex++, categoryId);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setId(rs.getInt("id"));
                    subject.setName(rs.getString("name"));
                    subject.setTagline(rs.getString("tagline"));
                    subject.setDescription(rs.getString("description"));
                    subject.setThumbnailUrl(rs.getString("thumbnail_url"));
                    subject.setCreatedAt(rs.getTimestamp("created_at"));
                    subject.setCategoryId(rs.getInt("category_id"));
                    // Set other fields as needed

                    if (rs.getObject("package_id") != null) {
                        Package pkg = new Package();
                        pkg.setId(rs.getInt("package_id"));
                        // pkg.setCourseId(rs.getInt("course_id")); This column isn't selected
                        pkg.setName(rs.getString("package_name"));
                        pkg.setOriginalPrice(rs.getDouble("original_price"));
                        pkg.setSalePrice(rs.getDouble("sale_price"));
                        pkg.setDuration(rs.getInt("duration"));
                        subject.setLowestPackage(pkg);
                    }
                    subjects.add(subject);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return subjects;
    }

    public static int getTotalSubjects(String search, String categoryId) {
        String sql = "SELECT COUNT(DISTINCT s.id) FROM subjects s " +
                "LEFT JOIN courses c ON s.id = c.subject_id " +
                "WHERE 1=1 " +
                (search != null && !search.trim().isEmpty() ? "AND (s.name LIKE ? OR s.tagline LIKE ?) " : "") +
                (categoryId != null && !categoryId.trim().isEmpty() ? "AND s.category_id = ? " : "");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                ps.setString(paramIndex, categoryId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
} 