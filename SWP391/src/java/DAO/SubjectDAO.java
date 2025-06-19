/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Subject;
import utils.DBContext;

/**
 *
 * @author Kaonashi
 */
public class SubjectDAO {
        public List<Subject> getFeaturedSubjects() throws Exception {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT id, name, description, created_at, thumbnail_url FROM subjects WHERE is_featured = 1 AND status = 'Published' ORDER BY created_at DESC LIMIT 6";
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

    public Subject getSubjectById(int id) throws Exception {
        String sql = "SELECT * FROM subjects WHERE id = ?";
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
                    s.setCategory(rs.getString("category"));
                    s.setStatus(rs.getString("status"));
                    s.setFeatured(rs.getBoolean("is_featured"));
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
        String sql = "SELECT id, name, description, created_at, thumbnail_url FROM subjects WHERE status = 'Published' ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
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
        }
        return list;
    }
}
