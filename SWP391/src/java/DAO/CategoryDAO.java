package DAO;

import model.Category;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    public static List<Category> getAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name";
        
        try {
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getInt("id"));
                    category.setName(rs.getString("name"));
                    category.setDescription(rs.getString("description"));
                    category.setCreatedAt(rs.getTimestamp("created_at"));
                    categories.add(category);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public static Category getCategoryById(int id) {
        Category category = null;
        String sql = "SELECT * FROM categories_2 WHERE id = ? LIMIT 1";
        try {
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        category = new Category();
                        category.setId(rs.getInt("id"));
                        category.setName(rs.getString("name"));
                        category.setDescription(rs.getString("description"));
                        category.setCreatedAt(rs.getTimestamp("created_at"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return category;
    }
} 