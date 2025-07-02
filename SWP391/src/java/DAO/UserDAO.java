/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
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
                user.setUsername(rs.getString("username"));
                user.setGender(rs.getString("gender"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
            }
        } catch (Exception e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }
    
    /**
     * Get user by email address
     * @param email the email address
     * @return User object or null if not found
     */
    public User getUserByEmail(String email) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
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
                user.setUsername(rs.getString("username"));
                user.setGender(rs.getString("gender"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
            }
        } catch (Exception e) {
            System.err.println("Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    public void updateUser(User user) {
        String sql = "UPDATE users SET username = ?, full_name = ?, gender = ?, phone = ?, address = ?, avatar_url = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getFullName());
            stmt.setString(3, user.getGender());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getAvatarUrl());
            stmt.setInt(7, user.getId());

            stmt.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
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
                user.setUsername(rs.getString("username"));
                user.setGender(rs.getString("gender"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
            }
        } catch (Exception e) {
            System.err.println("Error authenticating user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        return user;
    }
    
    /**
     * Get user by reset token
     * @param token the reset token
     * @return User object or null if not found
     */
    public User getUserByResetToken(String token) {
        User user = null;
        String sql = "SELECT * FROM users WHERE reset_token = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            
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
                user.setUsername(rs.getString("username"));
                user.setGender(rs.getString("gender"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                
                // Set reset token and expiry if available
                user.setResetToken(rs.getString("reset_token"));
                if (rs.getTimestamp("reset_token_expiry") != null) {
                    user.setResetTokenExpiry(rs.getTimestamp("reset_token_expiry").toLocalDateTime());
                }
            }
        } catch (Exception e) {
            System.err.println("Error getting user by reset token: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Update user password
     * @param userId the user ID
     * @param newPassword the new password (should be hashed)
     * @return true if successful, false otherwise
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword); // In production, this should be hashed
            stmt.setInt(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error updating password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Clear reset token for user
     * @param userId the user ID
     * @return true if successful, false otherwise
     */
    public boolean clearResetToken(int userId) {
        String sql = "UPDATE users SET reset_token = NULL, reset_token_expiry = NULL WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error clearing reset token: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Set reset token for user
     * @param email the user email
     * @param token the reset token
     * @param expiry the token expiry time
     * @return true if successful, false otherwise
     */
    public boolean setResetToken(String email, String token, LocalDateTime expiry) {
        String sql = "UPDATE users SET reset_token = ?, reset_token_expiry = ? WHERE email = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setTimestamp(2, java.sql.Timestamp.valueOf(expiry));
            stmt.setString(3, email);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error setting reset token: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

