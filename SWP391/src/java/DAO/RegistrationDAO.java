package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Registration;
import utils.DBContext;

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
        // Updated SQL to include all media fields
        String sql = "INSERT INTO registrations (user_id, course_id, package_id, full_name, email, mobile, gender, status, image_url, image_description, video_url, video_description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            System.out.println("Creating registration for user: " + registration.getUserId() + ", subject: " + registration.getSubjectId());
            
            conn = DBContext.getConnection();
            System.out.println("Database connection successful");
            
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
            ps.setString(8, registration.getStatus() != null ? registration.getStatus() : "pending");
            
            // Add media fields
            ps.setString(9, registration.getImageUrl());
            ps.setString(10, registration.getImageDescription());
            ps.setString(11, registration.getVideoUrl());
            ps.setString(12, registration.getVideoDescription());
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: userId=" + registration.getUserId() + 
                             ", subjectId=" + registration.getSubjectId() + 
                             ", packageId=" + registration.getPackageId() + 
                             ", fullName=" + registration.getFullName() + 
                             ", email=" + registration.getEmail() + 
                             ", imageUrl=" + registration.getImageUrl() + 
                             ", videoUrl=" + registration.getVideoUrl());
            
            int affectedRows = ps.executeUpdate();
            System.out.println("Affected rows: " + affectedRows);
            
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    System.out.println("Successfully created registration with ID: " + generatedId);
                    return generatedId;
                }
            }
            
            System.out.println("No registration created - no affected rows");
            return -1;
        } catch (SQLException e) {
            System.err.println("SQL Error in createRegistration: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            
            // Try to create table if it doesn't exist
            if (e.getErrorCode() == 1146) { // Table doesn't exist
                System.out.println("Attempting to create registrations table...");
                createRegistrationsTable();
            }
            
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
     * Create registrations table if it doesn't exist
     */
    private static void createRegistrationsTable() {
        String createTableSQL = """
            CREATE TABLE IF NOT EXISTS registrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT,
                course_id INT NOT NULL,
                package_id INT,
                full_name VARCHAR(255) NOT NULL,
                email VARCHAR(255) NOT NULL,
                mobile VARCHAR(20) NOT NULL,
                gender VARCHAR(10) NOT NULL,
                status VARCHAR(20) DEFAULT 'pending',
                image_url VARCHAR(500),
                image_description TEXT,
                video_url VARCHAR(500),
                video_description TEXT,
                registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                INDEX idx_user_course (user_id, course_id),
                INDEX idx_course (course_id),
                INDEX idx_email (email)
            )
            """;
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(createTableSQL);
            ps.executeUpdate();
            System.out.println("Registrations table created successfully");
        } catch (Exception e) {
            System.err.println("Error creating registrations table: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
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
            System.out.println("Checking if user " + userId + " is already registered for subject " + subjectId);
            
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, subjectId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Found " + count + " existing registrations for user " + userId + " and subject " + subjectId);
                return count > 0;
            }
        } catch (SQLException e) {
            System.err.println("SQL Error checking user registration: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            
            // If table doesn't exist, user is not registered
            if (e.getErrorCode() == 1146) {
                System.out.println("Registrations table doesn't exist - user not registered");
                return false;
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
        
        System.out.println("Default return false - user not registered");
        return false;
    }
    
    /**
     * Check if an email is already registered for a subject (for non-logged-in users)
     * @param email the email address
     * @param subjectId the subject ID (course_id in registrations table)
     * @return true if email already registered, false otherwise
     */
    public static boolean isEmailRegisteredForSubject(String email, int subjectId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE email = ? AND course_id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            System.out.println("Checking if email " + email + " is already registered for subject " + subjectId);
            
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email.trim().toLowerCase());
            ps.setInt(2, subjectId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Found " + count + " existing registrations for email " + email + " and subject " + subjectId);
                return count > 0;
            }
        } catch (SQLException e) {
            System.err.println("SQL Error checking email registration: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            
            // If table doesn't exist, email is not registered
            if (e.getErrorCode() == 1146) {
                System.out.println("Registrations table doesn't exist - email not registered");
                return false;
            }
        } catch (Exception e) {
            System.err.println("Error checking email registration: " + e.getMessage());
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
        
        System.out.println("Default return false - email not registered");
        return false;
    }
    
    /**
     * Check for any duplicate registration (by user ID or email)
     * @param userId the user ID (can be null for non-logged-in users)
     * @param email the email address
     * @param subjectId the subject ID
     * @return true if any duplicate found, false otherwise
     */
    public static boolean isDuplicateRegistration(Integer userId, String email, int subjectId) {
        // Check by user ID if user is logged in
        if (userId != null && userId > 0) {
            if (isUserRegisteredForSubject(userId, subjectId)) {
                System.out.println("Duplicate found: User ID " + userId + " already registered for subject " + subjectId);
                return true;
            }
        }
        
        // Also check by email (for both logged-in and non-logged-in users)
        if (email != null && !email.trim().isEmpty()) {
            if (isEmailRegisteredForSubject(email, subjectId)) {
                System.out.println("Duplicate found: Email " + email + " already registered for subject " + subjectId);
                return true;
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
        registration.setCourseId(rs.getInt("course_id")); // map course_id to courseId
        
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
        
        // Handle different possible column names for registration date
        try {
            registration.setRegistrationDate(rs.getTimestamp("registered_at"));
        } catch (SQLException e) {
            try {
                registration.setRegistrationDate(rs.getTimestamp("created_at"));
            } catch (SQLException e2) {
                // If both fail, set current timestamp
                registration.setRegistrationDate(new java.sql.Timestamp(System.currentTimeMillis()));
            }
        }
        
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
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("Error updating registration status: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Get all registrations for a specific user
     * @param userId the user ID
     * @return list of registrations for the user
     */
    public static List<Registration> getRegistrationsByUserId(int userId) {
        List<Registration> registrations = new ArrayList<>();
        // Remove status filter to get all registrations first
        String sql = "SELECT * FROM registrations WHERE user_id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            System.out.println("DEBUG: Getting registrations for user ID: " + userId);
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Registration registration = mapResultSetToRegistration(rs);
                registrations.add(registration);
                System.out.println("DEBUG: Found registration - ID: " + registration.getId() + 
                                 ", Course ID: " + registration.getCourseId() + 
                                 ", Status: " + registration.getStatus());
            }
            
            System.out.println("DEBUG: Total registrations found: " + registrations.size());
            
        } catch (Exception e) {
            System.err.println("Error getting registrations by user ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
        
        return registrations;
    }
} 