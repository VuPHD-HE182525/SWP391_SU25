package DAO;

import java.sql.*;
import java.util.*;
import model.Dimension;
import utils.DBContext;

public class DimensionDAO {
    public List<Dimension> getDimensionsBySubjectId(int subjectId, int limit) throws Exception {
        List<Dimension> list = new ArrayList<>();
        String sql = "SELECT * FROM dimensions WHERE subject_id = ? AND is_deleted = 0 ORDER BY id ASC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dimension d = new Dimension(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getString("type"),
                        rs.getString("name")
                    );
                    list.add(d);
                }
            }
        }
        return list;
    }

    // Backward compatible: returns all
    public List<Dimension> getDimensionsBySubjectId(int subjectId) throws Exception {
        return getDimensionsBySubjectId(subjectId, Integer.MAX_VALUE);
    }

    public void addDimension(Dimension d) throws Exception {
        String sql = "INSERT INTO dimensions (subject_id, type, name) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, d.getSubjectId());
            ps.setString(2, d.getType());
            ps.setString(3, d.getName());
            ps.executeUpdate();
        }
    }

    public void updateDimension(Dimension d) throws Exception {
        String sql = "UPDATE dimensions SET type=?, name=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, d.getType());
            ps.setString(2, d.getName());
            ps.setInt(3, d.getId());
            ps.executeUpdate();
        }
    }

    public void deleteDimension(int id) throws Exception {
        String sql = "UPDATE dimensions SET is_deleted = 1 WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
    //get the number rows
    public List<Dimension> getDimensionsBySubjectIdRange(int startId, int endId, int limit) throws Exception {
        List<Dimension> list = new ArrayList<>();
        String sql = "SELECT * FROM (SELECT * FROM dimensions WHERE subject_id BETWEEN ? AND ? AND is_deleted = 0 ORDER BY id DESC LIMIT ?) AS sub ORDER BY id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, startId);
            ps.setInt(2, endId);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dimension d = new Dimension(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getString("type"),
                        rs.getString("name")
                    );
                    list.add(d);
                }
            }
        }
        return list;
    }

    public List<Dimension> getDimensionsByIdRange(int startId, int endId) throws Exception {
        List<Dimension> list = new ArrayList<>();
        String sql = "SELECT * FROM dimensions WHERE id BETWEEN ? AND ? AND is_deleted = 0 ORDER BY id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, startId);
            ps.setInt(2, endId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dimension d = new Dimension(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getString("type"),
                        rs.getString("name")
                    );
                    list.add(d);
                }
            }
        }
        return list;
    }

    public List<Dimension> getDimensions(int limit) throws Exception {
        List<Dimension> list = new ArrayList<>();
        String sql = "SELECT * FROM dimensions WHERE is_deleted = 0 ORDER BY id ASC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dimension d = new Dimension(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getString("type"),
                        rs.getString("name")
                    );
                    list.add(d);
                }
            }
        }
        return list;
    }

    // Add more CRUD methods as needed
} 