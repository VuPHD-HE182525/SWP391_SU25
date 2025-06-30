package dao;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBContext;

public class UserDAO {

    public User getUserById(int id) {
        User user = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = DBContext.getConnection();
            stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ? LIMIT 1");
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role")); 
                String avatarUrl = rs.getString("avatar_url");
                user.setAvatarUrl((avatarUrl == null || avatarUrl.isEmpty()) ? "/uploads/images/default-avatar.svg" : avatarUrl);
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

    public void updateUser(User user) {
        PreparedStatement stmt = null;
        try {
            Connection conn = DBContext.getConnection();
            String sql = "UPDATE users SET full_name = ?, avatar_url = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getAvatarUrl());
            stmt.setInt(3, user.getId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public User authenticateUser(String email, String password) {
        User user = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = DBContext.getConnection();
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
