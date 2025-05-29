/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author thang
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Subject;
import util.DBContext;

public class SubjectDAO {

    // Đếm tổng số subject theo bộ lọc để phân trang
    public int getTotalSubjects(String categoryId, String status, String search) {
        String sql = "SELECT COUNT(*) FROM subjects s " +
                     "JOIN categories c ON s.category_id = c.category_id " +
                     "JOIN users u ON s.owner_id = u.user_id WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (categoryId != null && !categoryId.isEmpty()) {
            sql += " AND s.category_id = ?";
            params.add(Integer.parseInt(categoryId));
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND s.status = ?";
            params.add(Boolean.parseBoolean(status));
        }
        if (search != null && !search.isEmpty()) {
            sql += " AND s.subject_name LIKE ?";
            params.add("%" + search + "%");
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
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

    // Lấy danh sách subject đã được phân trang và lọc
    public List<Subject> getSubjects(String categoryId, String status, String search, int pageIndex, int pageSize) {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT s.subject_id, s.subject_name, c.category_name, s.number_of_lessons, u.full_name, s.status " +
                     "FROM subjects s " +
                     "JOIN categories c ON s.category_id = c.category_id " +
                     "JOIN users u ON s.owner_id = u.user_id WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (categoryId != null && !categoryId.isEmpty()) {
            sql += " AND s.category_id = ?";
            params.add(Integer.parseInt(categoryId));
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND s.status = ?";
            params.add(Boolean.parseBoolean(status));
        }
        if (search != null && !search.isEmpty()) {
            sql += " AND s.subject_name LIKE ?";
            params.add("%" + search + "%");
        }
        sql += " ORDER BY s.subject_id ASC LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add((pageIndex - 1) * pageSize);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setId(rs.getInt("subject_id"));
                    subject.setName(rs.getString("subject_name"));
                    subject.setCategory(rs.getString("category_name"));
                    subject.setNumberOfLessons(rs.getInt("number_of_lessons"));
                    subject.setOwner(rs.getString("full_name"));
                    subject.setStatus(rs.getBoolean("status"));
                    list.add(subject);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
