package DAO;

import model.Registration;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Registration operations
 * Updated to work with existing 'registrations' table
 */
public class RegistrationDAO {
    
    /**
     * Create a new registration
     * @param registration the registration to create
     * @return the generated registration ID, or -1 if failed
     */
    public static int createRegistration(Registration registration) {
        String sql = "INSERT INTO registrations (user_id, course_id, package_id, full_name, email, mobile, gender, image_url, image_description, video_url, video_description, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            // Set parameters
            if (registration.getUserId() != null) {
                ps.setInt(1, registration.getUserId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            
            ps.setInt(2, registration.getSubjectId()); // maps to course_id
            ps.setInt(3, registration.getPackageId());
            ps.setString(4, registration.getFullName());
            ps.setString(5, registration.getEmail());
            ps.setString(6, registration.getMobile());
            ps.setString(7, registration.getGender());
            ps.setString(8, registration.getImageUrl());
            ps.setString(9, registration.getImageDescription());
            ps.setString(10, registration.getVideoUrl());
            ps.setString(11, registration.getVideoDescription());
            ps.setString(12, registration.getStatus());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    return generatedId;
                }
            }
            
            return -1;
        } catch (SQLException e) {
            System.err.println("SQL Error in createRegistration: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } catch (Exception e) {
            System.err.println("Error creating registration: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Get all registrations for a specific subject/course
     * @param subjectId the subject ID (course_id in registrations table)
     * @return List of registrations for the subject
     */
    public static List<Registration> getRegistrationsBySubjectId(int subjectId) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT * FROM registrations WHERE course_id = ? ORDER BY registered_at DESC";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, subjectId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Registration registration = mapResultSetToRegistration(rs);
                registrations.add(registration);
            }
        } catch (Exception e) {
            System.err.println("Error getting registrations for subject " + subjectId + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return registrations;
    }
    
    /**
     * Check if a user is already registered for a subject
     * @param userId the user ID
     * @param subjectId the subject ID (course_id in registrations table)
     * @return true if already registered, false otherwise
     */
    public static boolean isUserRegisteredForSubject(int userId, int subjectId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE user_id = ? AND course_id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, subjectId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("Error checking user registration: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return false;
    }
    
    /**
     * Get registration by ID
     * @param registrationId the registration ID
     * @return Registration object or null if not found
     */
    public static Registration getRegistrationById(int registrationId) {
        Registration registration = null;
        String sql = "SELECT * FROM registrations WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, registrationId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                registration = mapResultSetToRegistration(rs);
            }
        } catch (Exception e) {
            System.err.println("Error getting registration by ID " + registrationId + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return registration;
    }
    
    /**
     * Helper method to map ResultSet to Registration object
     * Updated to work with existing table structure
     */
    private static Registration mapResultSetToRegistration(ResultSet rs) throws SQLException {
        Registration registration = new Registration();
        registration.setId(rs.getInt("id"));
        registration.setSubjectId(rs.getInt("course_id")); // map course_id to subjectId
        
        // Handle package_id safely (might not exist in existing records)
        try {
            registration.setPackageId(rs.getInt("package_id"));
        } catch (SQLException e) {
            registration.setPackageId(1); // default package
        }
        
        Integer userId = rs.getObject("user_id", Integer.class);
        registration.setUserId(userId);
        
        // Handle new columns safely (might not exist in existing records)
        try {
            registration.setFullName(rs.getString("full_name"));
        } catch (SQLException e) {
            registration.setFullName("");
        }
        
        try {
            registration.setEmail(rs.getString("email"));
        } catch (SQLException e) {
            registration.setEmail("");
        }
        
        try {
            registration.setMobile(rs.getString("mobile"));
        } catch (SQLException e) {
            registration.setMobile("");
        }
        
        try {
            registration.setGender(rs.getString("gender"));
        } catch (SQLException e) {
            registration.setGender("Male");
        }
        
        try {
            registration.setImageUrl(rs.getString("image_url"));
        } catch (SQLException e) {
            registration.setImageUrl(null);
        }
        
        try {
            registration.setImageDescription(rs.getString("image_description"));
        } catch (SQLException e) {
            registration.setImageDescription(null);
        }
        
        try {
            registration.setVideoUrl(rs.getString("video_url"));
        } catch (SQLException e) {
            registration.setVideoUrl(null);
        }
        
        try {
            registration.setVideoDescription(rs.getString("video_description"));
        } catch (SQLException e) {
            registration.setVideoDescription(null);
        }
        
        registration.setRegistrationDate(rs.getTimestamp("registered_at")); // map registered_at to registrationDate
        registration.setStatus(rs.getString("status"));
        
        return registration;
    }
    
    /**
     * Update registration status
     * @param registrationId the registration ID
     * @param status the new status
     * @return true if updated successfully
     */
    public static boolean updateRegistrationStatus(int registrationId, String status) {
        String sql = "UPDATE registrations SET status = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, registrationId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.err.println("Error updating registration status: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
} 