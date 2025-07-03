/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Package;
import model.Subject;
import utils.DBContext;

/**
 *
 * @author Kaonashi
 */
public class SubjectDAO {
    
    public List<Subject> getAllSubjects() throws Exception {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT id, name, description, created_at, thumbnail_url FROM subjects ORDER BY name ASC";

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
    
    public List<Subject> getFeaturedSubjects() throws Exception {
        List<Subject> list = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            // First, try to check if is_featured or featured column exists
            String sql = null;
            
            try {
                // Try with is_featured column
                sql = "SELECT id, name, description, created_at, thumbnail_url " +
                     "FROM subjects WHERE is_featured = 1 ORDER BY created_at DESC LIMIT 6";
                System.out.println("Trying getFeaturedSubjects with is_featured: " + sql);
                
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    
                    while (rs.next()) {
                        Subject s = new Subject();
                        s.setId(rs.getInt("id"));
                        s.setName(rs.getString("name"));
                        s.setDescription(rs.getString("description"));
                        s.setCreatedAt(rs.getTimestamp("created_at"));
                        s.setThumbnailUrl(rs.getString("thumbnail_url"));
                        list.add(s);
                        System.out.println("Found featured subject: " + s.getName());
                    }
                }
                
            } catch (SQLException e1) {
                System.out.println("is_featured column not found, trying featured column...");
                
                try {
                    // Try with featured column
                    sql = "SELECT id, name, description, created_at, thumbnail_url " +
                         "FROM subjects WHERE featured = 1 ORDER BY created_at DESC LIMIT 6";
                    System.out.println("Trying getFeaturedSubjects with featured: " + sql);
                    
                    try (PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {
                        
                        while (rs.next()) {
                            Subject s = new Subject();
                            s.setId(rs.getInt("id"));
                            s.setName(rs.getString("name"));
                            s.setDescription(rs.getString("description"));
                            s.setCreatedAt(rs.getTimestamp("created_at"));
                            s.setThumbnailUrl(rs.getString("thumbnail_url"));
                            list.add(s);
                            System.out.println("Found featured subject: " + s.getName());
                        }
                    }
                    
                } catch (SQLException e2) {
                    System.out.println("featured column also not found, getting first 6 subjects as featured...");
                    
                    // If no featured column exists, just get first 6 subjects
                    sql = "SELECT id, name, description, created_at, thumbnail_url " +
                         "FROM subjects ORDER BY created_at DESC LIMIT 6";
                    System.out.println("Using fallback query: " + sql);
                    
                    try (PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {
                        
                        while (rs.next()) {
                            Subject s = new Subject();
                            s.setId(rs.getInt("id"));
                            s.setName(rs.getString("name"));
                            s.setDescription(rs.getString("description"));
                            s.setCreatedAt(rs.getTimestamp("created_at"));
                            s.setThumbnailUrl(rs.getString("thumbnail_url"));
                            list.add(s);
                            System.out.println("Found featured subject (fallback): " + s.getName());
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error in getFeaturedSubjects: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Total featured subjects found: " + list.size());
        return list;
    }

    public Subject getSubjectById(int id) throws Exception {
        String sql = "SELECT s.id, s.name, s.description, s.created_at, s.thumbnail_url, s.category_id, s.status, s.is_featured, c.name AS category_name " +
                     "FROM subjects s LEFT JOIN categories c ON s.category_id = c.id WHERE s.id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Subject s = new Subject();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setDescription(rs.getString("description"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    s.setThumbnailUrl(rs.getString("thumbnail_url"));
                    s.setCategoryId(rs.getInt("category_id"));
                    s.setStatus(rs.getString("status"));
                    s.setFeatured(rs.getBoolean("is_featured"));
                    s.setCategoryName(rs.getString("category_name"));
                    return s;
                }
            }
        }
        return null;
    }

    public void updateSubject(Subject subject) throws Exception {
        String sql = "UPDATE subjects SET name=?, description=?, thumbnail_url=?, category=?, status=?, is_featured=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subject.getName());
            ps.setString(2, subject.getDescription());
            ps.setString(3, subject.getThumbnailUrl());
            ps.setString(4, subject.getCategory());
            ps.setString(5, subject.getStatus());
            ps.setBoolean(6, subject.isFeatured());
            ps.setInt(7, subject.getId());
            ps.executeUpdate();
        }
    }

    // Returns the latest N published subjects (not just featured)
    public List<Subject> getRecentSubjects(int limit) throws Exception {
        List<Subject> list = new ArrayList<>();
        // More flexible query without strict status filter
        String sql = "SELECT id, name, description, created_at, thumbnail_url " +
                    "FROM subjects " +
                    "WHERE (status = 'Published' OR status = 'published' OR status = 'active' OR status = '1' OR status IS NULL) " +
                    "ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            System.out.println("Executing getRecentSubjects query: " + sql + " with limit: " + limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject s = new Subject();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setDescription(rs.getString("description"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    s.setThumbnailUrl(rs.getString("thumbnail_url"));
                    list.add(s);
                    System.out.println("Found recent subject: " + s.getName());
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getRecentSubjects: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
        
    public static List<Subject> getSubjects(String search, String categoryId) throws Exception {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "p.id AS package_id, p.package_name AS package_name, p.original_price, p.sale_price, p.duration_months AS duration, p.status " +
                "FROM subjects s " +
                "LEFT JOIN courses c ON s.id = c.subject_id " +
                "LEFT JOIN packages p ON c.id = p.course_id " +
                "WHERE p.sale_price = ( " +
                "    SELECT MIN(p2.sale_price) " +
                "    FROM packages p2 " +
                "    LEFT JOIN courses c2 ON p2.course_id = c2.id " +
                "    WHERE c2.subject_id = s.id " +
                ") " +
                (search != null && !search.trim().isEmpty() ? "AND (s.name LIKE ? OR s.tagline LIKE ?) " : "") +
                (categoryId != null && !categoryId.trim().isEmpty() ? "AND s.category_id = ? " : "") +
                "ORDER BY s.created_at DESC";
        
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }
    
    public static List<Subject> getFeatured() throws Exception {
        List<Subject> featured = new ArrayList<>();
        List<Subject> all = getSubjects(null, null);
        if (!all.isEmpty()) featured.add(all.get(0));
        return featured;
    }

    public static List<Subject> getSubjectsForMainContent(String search, String categoryId, int page, int pageSize) {
        List<Subject> subjects = new ArrayList<>();
        
        // Simplified query for MySQL
        String sql = "SELECT id, name, description, created_at, thumbnail_url " +
                    "FROM subjects " +
                    "WHERE 1=1 " +
                    (search != null && !search.trim().isEmpty() ? 
                        "AND (name LIKE ? OR description LIKE ?) " : "") +
                    (categoryId != null && !categoryId.trim().isEmpty() ? 
                        "AND category = ? " : "") +
                    "ORDER BY created_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            System.out.println("Executing getSubjectsForMainContent...");
            
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
                System.out.println("Search parameter: " + search);
            }
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                ps.setString(paramIndex++, categoryId);
                System.out.println("Category parameter: " + categoryId);
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, (page - 1) * pageSize);
            
            System.out.println("Pagination: pageSize=" + pageSize + ", offset=" + ((page - 1) * pageSize));
            System.out.println("SQL: " + sql);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setId(rs.getInt("id"));
                    subject.setName(rs.getString("name"));
                    subject.setDescription(rs.getString("description"));
                    subject.setCreatedAt(rs.getTimestamp("created_at"));
                    subject.setThumbnailUrl(rs.getString("thumbnail_url"));
                    
                    subjects.add(subject);
                    System.out.println("Found subject: " + subject.getName());
                }
            }
            
            System.out.println("Total subjects found: " + subjects.size());
            
        } catch (Exception e) {
            System.err.println("Error in getSubjectsForMainContent: " + e.getMessage());
            e.printStackTrace();
        }
        
        return subjects;
    }

    public static int getTotalSubjects(String search, String categoryId) {
        String sql = "SELECT COUNT(*) as total FROM subjects WHERE 1=1 " +
                    (search != null && !search.trim().isEmpty() ? 
                        "AND (name LIKE ? OR description LIKE ?)" : "") +
                    (categoryId != null && !categoryId.trim().isEmpty() ? 
                        "AND category = ?" : "");
        
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
                    int total = rs.getInt("total");
                    System.out.println("Total subjects count: " + total);
                    return total;
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getTotalSubjects: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    // Lấy danh sách subject với đủ thông tin cho Subject List
    public static List<Subject> getSubjectsWithDetails(String search, String categoryId, String status) throws Exception {
        List<Subject> subjects = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.id, s.name, c.name AS categoryName, s.status, u.full_name AS ownerName, ");
        sql.append("(SELECT COUNT(*) FROM lessons l JOIN courses c2 ON l.course_id = c2.id WHERE c2.subject_id = s.id) AS lessonCount ");
        sql.append("FROM subjects s ");
        sql.append("LEFT JOIN categories c ON s.category_id = c.id ");
        sql.append("LEFT JOIN users u ON s.owner_id = u.id ");
        sql.append("WHERE 1=1 ");
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND s.name LIKE ? ");
        }
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            sql.append("AND s.category_id = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND s.status = ? ");
        }
        sql.append("ORDER BY s.id DESC");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                ps.setString(paramIndex++, categoryId);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setId(rs.getInt("id"));
                    subject.setName(rs.getString("name"));
                    subject.setCategoryName(rs.getString("categoryName"));
                    subject.setStatus(rs.getString("status"));
                    subject.setOwnerName(rs.getString("ownerName"));
                    subject.setLessonCount(rs.getInt("lessonCount"));
                    subjects.add(subject);
                }
            }
        }
        return subjects;
    }

    // Thêm subject mới
    public static void insertSubject(String name, String categoryId, String ownerName, String status) throws Exception {
        String sql = "INSERT INTO subjects (name, category_id, owner_id, status) VALUES (?, ?, (SELECT id FROM users WHERE full_name = ? LIMIT 1), ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, categoryId);
            ps.setString(3, ownerName);
            ps.setString(4, status);
            ps.executeUpdate();
        }
    }
    // Cập nhật subject
    public static void updateSubject(int id, String name, String categoryId, String ownerName, String status) throws Exception {
        String sql = "UPDATE subjects SET name=?, category_id=?, owner_id=(SELECT id FROM users WHERE full_name = ? LIMIT 1), status=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, categoryId);
            ps.setString(3, ownerName);
            ps.setString(4, status);
            ps.setInt(5, id);
            ps.executeUpdate();
        }
    }

    // Soft delete subject (update status='inactive')
    public static void softDeleteSubject(int id) throws Exception {
        String sql = "UPDATE subjects SET status='inactive' WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
