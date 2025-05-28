/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBContext;

/**
 *
 * @author Kaonashi
 */
public class UserDAO {
        public static User getUserById(int id) {
            User user = null;
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?")) {
                stmt.setInt(1, id);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));

                    String avatarUrl = rs.getString("avatar_url");
                    if (avatarUrl == null || avatarUrl.isEmpty()) {
                        avatarUrl = "/uploads/images/default-avatar.svg";
                    }
                    user.setAvatarUrl(avatarUrl);

                    user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
            } catch (Exception e) {
            }
            return user;
        }
        
        public void updateUser(User user) {
            String sql = "UPDATE users SET full_name = ?, avatar_url = ? WHERE id = ?";
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, user.getFullName());
                stmt.setString(2, user.getAvatarUrl());
                stmt.setInt(3, user.getId());
                stmt.executeUpdate();
            } catch (Exception e) {
        }
}
public User authenticateUser(String email, String password) {
        User user = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);
            rs = stmt.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setRole(rs.getString("role"));
                String avatar = rs.getString("avatar_url");
                user.setAvatarUrl((avatar == null || avatar.isEmpty()) ? "/uploads/images/default-avatar.svg" : avatar);
                user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return user;
    }
}
