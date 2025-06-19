package DAO;

import java.sql.*;
import java.util.*;
import model.PricePackage;
import utils.DBContext;

public class PricePackageDAO {
    public List<PricePackage> getPricePackagesBySubjectId(int subjectId, int limit) throws Exception {
        List<PricePackage> list = new ArrayList<>();
        String sql = "SELECT * FROM price_packages WHERE subject_id = ? AND is_deleted = 0 ORDER BY id DESC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PricePackage p = new PricePackage(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getString("name"),
                        rs.getInt("duration"),
                        rs.getDouble("list_price"),
                        rs.getDouble("sale_price"),
                        rs.getString("status")
                    );
                    list.add(p);
                }
            }
        }
        return list;
    }

    // Backward compatible: returns all
    public List<PricePackage> getPricePackagesBySubjectId(int subjectId) throws Exception {
        return getPricePackagesBySubjectId(subjectId, Integer.MAX_VALUE);
    }

    public void addPricePackage(PricePackage p) throws Exception {
        String sql = "INSERT INTO price_packages (subject_id, name, duration, list_price, sale_price, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getSubjectId());
            ps.setString(2, p.getName());
            ps.setInt(3, p.getDuration());
            ps.setDouble(4, p.getListPrice());
            ps.setDouble(5, p.getSalePrice());
            ps.setString(6, p.getStatus());
            ps.executeUpdate();
        }
    }

    public void updatePricePackage(PricePackage p) throws Exception {
        String sql = "UPDATE price_packages SET name=?, duration=?, list_price=?, sale_price=?, status=? WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getDuration());
            ps.setDouble(3, p.getListPrice());
            ps.setDouble(4, p.getSalePrice());
            ps.setString(5, p.getStatus());
            ps.setInt(6, p.getId());
            ps.executeUpdate();
        }
    }

    public void deletePricePackage(int id) throws Exception {
        String sql = "UPDATE price_packages SET is_deleted = 1 WHERE id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public List<PricePackage> getPricePackagesBySubjectIdRange(int startId, int endId, int limit) throws Exception {
        List<PricePackage> list = new ArrayList<>();
        String sql = "SELECT * FROM (SELECT * FROM price_packages WHERE subject_id BETWEEN ? AND ? AND is_deleted = 0 ORDER BY id DESC LIMIT ?) AS sub ORDER BY id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, startId);
            ps.setInt(2, endId);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PricePackage p = new PricePackage(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getString("name"),
                        rs.getInt("duration"),
                        rs.getDouble("list_price"),
                        rs.getDouble("sale_price"),
                        rs.getString("status")
                    );
                    list.add(p);
                }
            }
        }
        return list;
    }

    public List<PricePackage> getPricePackagesByIdRange(int startId, int endId) throws Exception {
        List<PricePackage> list = new ArrayList<>();
        String sql = "SELECT * FROM price_packages WHERE id BETWEEN ? AND ? AND is_deleted = 0 ORDER BY id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, startId);
            ps.setInt(2, endId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PricePackage p = new PricePackage(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getString("name"),
                        rs.getInt("duration"),
                        rs.getDouble("list_price"),
                        rs.getDouble("sale_price"),
                        rs.getString("status")
                    );
                    list.add(p);
                }
            }
        }
        return list;
    }

    public List<PricePackage> getPricePackages(int limit) throws Exception {
        List<PricePackage> list = new ArrayList<>();
        String sql = "SELECT * FROM price_packages WHERE is_deleted = 0 ORDER BY id ASC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PricePackage p = new PricePackage(
                        rs.getInt("id"),
                        rs.getInt("subject_id"),
                        rs.getString("name"),
                        rs.getInt("duration"),
                        rs.getDouble("list_price"),
                        rs.getDouble("sale_price"),
                        rs.getString("status")
                    );
                    list.add(p);
                }
            }
        }
        return list;
    }

    // Add more CRUD methods as needed
} 