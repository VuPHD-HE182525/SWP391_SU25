/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Subject;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.sql.*;

/**
 *
 * @author Kaonashi
 */
public class SubjectDAO {
        public List<Subject> getFeaturedSubjects() throws Exception {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT id, name, description, created_at, thumbnail_url " +
                     "FROM subjects ORDER BY created_at DESC LIMIT 6";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Subject s = new Subject();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                s.setThumbnailUrl(rs.getString("thumbnail_url"));
                list.add(s);
            }
        }
        return list;
    }
         public static List<Subject> getSubjects(String search, String categoryId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "p.id AS package_id, p.name AS package_name, p.original_price, p.sale_price, p.duration, p.status " +
                "FROM subjects_2 s " +
                "LEFT JOIN packages_2 p ON s.id = p.subject_id " +
                "WHERE p.sale_price = ( " +
                "    SELECT MIN(p2.sale_price) " +
                "    FROM packages_2 p2 " +
                "    WHERE p2.subject_id = s.id " +
                ") " +
                (search != null && !search.trim().isEmpty() ? "AND (s.name LIKE ? OR s.tagline LIKE ?) " : "") +
                (categoryId != null && !categoryId.trim().isEmpty() ? "AND s.category_id = ? " : "") +
                "ORDER BY s.created_at DESC";
        
        try (Connection conn = DBContext.getInstance().getConnection();
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }
    
    public static List<Subject> getFeatured() {
        List<Subject> featured = new ArrayList<>();
        List<Subject> all = getSubjects(null, null);
        if (!all.isEmpty()) featured.add(all.get(0));
        return featured;
    }

    public static List<Subject> getSubjectsForMainContent(String search, String categoryId, int page, int pageSize) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT s.*, p.id as package_id, p.package_name as package_name, p.original_price, p.sale_price, p.duration_months as duration, p.description as package_description " +
                    "FROM subjects_2 s " +
                    "LEFT JOIN packages_2 p ON s.id = p.course_id " +
                    "WHERE 1=1 " +
                    (search != null && !search.trim().isEmpty() ? 
                        "AND (s.name LIKE ? OR s.tagline LIKE ?) " : "") +
                    (categoryId != null && !categoryId.trim().isEmpty() ? 
                        "AND s.category_id = ? " : "") +
                    "ORDER BY s.created_at DESC " +
                    "OFFSET ? ROWS " +
                    "FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getInstance().getConnection();
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
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: page=" + page + ", pageSize=" + pageSize);
            System.out.println("Search pattern: " + (search != null ? search : "null"));
            
            try (ResultSet rs = ps.executeQuery()) {
                Map<Integer, Subject> subjectMap = new HashMap<>();
                
                while (rs.next()) {
                    int subjectId = rs.getInt("id");
                    Subject subject = subjectMap.get(subjectId);
                    
                    if (subject == null) {
                        subject = new Subject();
                        subject.setId(subjectId);
                        subject.setName(rs.getString("name"));
                        subject.setTagline(rs.getString("tagline"));
                        subject.setDescription(rs.getString("description"));
                        subject.setThumbnailUrl(rs.getString("thumbnail_url"));
                        // Handle missing columns gracefully
                        try { subject.setFeatured(rs.getBoolean("featured")); } catch (Exception e) { subject.setFeatured(false); }
                        try { subject.setStatus(rs.getString("status")); } catch (Exception e) { subject.setStatus("active"); }
                        subject.setCreatedAt(rs.getTimestamp("created_at"));
                        subject.setCategoryId(rs.getInt("category_id"));
                        subjectMap.put(subjectId, subject);
                        
                        System.out.println("Created new subject: " + subject.getName() + 
                            " (ID: " + subjectId + 
                            ", Status: " + subject.getStatus() + 
                            ", Featured: " + subject.isFeatured() + ")");
                    }
                    
                    // Add package if it exists
                    if (rs.getInt("package_id") != 0) {
                        Package pkg = new Package();
                        pkg.setId(rs.getInt("package_id"));
                        pkg.setName(rs.getString("package_name"));
                        pkg.setOriginalPrice(rs.getDouble("original_price"));
                        pkg.setSalePrice(rs.getDouble("sale_price"));
                        pkg.setDuration(rs.getInt("duration"));
                        pkg.setStatus(""); // No status column in packages_2
                        pkg.setSubjectId(subjectId); // For compatibility
                        
                        subject.getPackages().add(pkg);
                        
                        // Update lowest package if this one is lower
                        if (subject.getLowestPackage() == null || 
                            pkg.getSalePrice() < subject.getLowestPackage().getSalePrice()) {
                            subject.setLowestPackage(pkg);
                            System.out.println("Updated lowest package for " + subject.getName() + 
                                " to price: " + pkg.getSalePrice());
                        }
                    }
                }
                
                subjects.addAll(subjectMap.values());
                System.out.println("Total subjects retrieved: " + subjects.size());
            }
        } catch (Exception e) {
            System.out.println("Error in getSubjectsForMainContent: " + e.getMessage());
            e.printStackTrace();
        }
        
        return subjects;
    }

    public static int getTotalSubjects(String search, String categoryId) {
        String sql = "SELECT COUNT(*) FROM subjects_2 WHERE status = 'active' " +
                    (search != null && !search.trim().isEmpty() ? 
                        "AND (name LIKE ? OR tagline LIKE ?)" : "") +
                    (categoryId != null && !categoryId.trim().isEmpty() ? 
                        "AND category_id = ?" : "");
        
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
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
