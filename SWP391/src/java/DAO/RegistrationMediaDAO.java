package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.RegistrationMedia;
import utils.DBContext;

/**
 * Data Access Object for Registration Media operations
 * Handles multiple images and videos for each registration
 */
public class RegistrationMediaDAO {
    
    /**
     * Create a new registration media record
     * @param media the registration media to create
     * @return the generated media ID, or -1 if failed
     */
    public static int createRegistrationMedia(RegistrationMedia media) {
        String sql = "INSERT INTO registration_media (registration_id, media_type, file_url, file_description, file_size, file_name, display_order) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            ps.setInt(1, media.getRegistrationId());
            ps.setString(2, media.getMediaType());
            ps.setString(3, media.getFileUrl());
            ps.setString(4, media.getFileDescription());
            ps.setLong(5, media.getFileSize());
            ps.setString(6, media.getFileName());
            ps.setInt(7, media.getDisplayOrder());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
            return -1;
        } catch (Exception e) {
            System.err.println("Error in createRegistrationMedia: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            closeResources(rs, ps, conn);
        }
    }
    
    /**
     * Create multiple registration media records
     * @param mediaList list of registration media to create
     * @return list of generated media IDs
     */
    public static List<Integer> createRegistrationMediaBatch(List<RegistrationMedia> mediaList) {
        List<Integer> generatedIds = new ArrayList<>();
        
        if (mediaList == null || mediaList.isEmpty()) {
            return generatedIds;
        }
        
        String sql = "INSERT INTO registration_media (registration_id, media_type, file_url, file_description, file_size, file_name, display_order) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            for (RegistrationMedia media : mediaList) {
                ps.setInt(1, media.getRegistrationId());
                ps.setString(2, media.getMediaType());
                ps.setString(3, media.getFileUrl());
                ps.setString(4, media.getFileDescription());
                ps.setLong(5, media.getFileSize());
                ps.setString(6, media.getFileName());
                ps.setInt(7, media.getDisplayOrder());
                
                ps.addBatch();
            }
            
            int[] affectedRows = ps.executeBatch();
            
            ResultSet rs = ps.getGeneratedKeys();
            while (rs.next()) {
                generatedIds.add(rs.getInt(1));
            }
            
            conn.commit(); // Commit transaction
            
        } catch (Exception e) {
            System.err.println("Error in createRegistrationMediaBatch: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException rollbackEx) {
                System.err.println("Error rolling back transaction: " + rollbackEx.getMessage());
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                System.err.println("Error resetting auto-commit: " + e.getMessage());
            }
            closeResources(null, ps, conn);
        }
        
        return generatedIds;
    }
    
    /**
     * Get all media for a specific registration
     * @param registrationId the registration ID
     * @return list of registration media
     */
    public static List<RegistrationMedia> getMediaByRegistrationId(int registrationId) {
        List<RegistrationMedia> mediaList = new ArrayList<>();
        String sql = "SELECT * FROM registration_media WHERE registration_id = ? ORDER BY display_order, id";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, registrationId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                mediaList.add(mapResultSetToMedia(rs));
            }
            
        } catch (Exception e) {
            System.err.println("Error in getMediaByRegistrationId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return mediaList;
    }
    
    /**
     * Get media by type for a specific registration
     * @param registrationId the registration ID
     * @param mediaType the media type ('image' or 'video')
     * @return list of registration media
     */
    public static List<RegistrationMedia> getMediaByRegistrationIdAndType(int registrationId, String mediaType) {
        List<RegistrationMedia> mediaList = new ArrayList<>();
        String sql = "SELECT * FROM registration_media WHERE registration_id = ? AND media_type = ? ORDER BY display_order, id";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, registrationId);
            ps.setString(2, mediaType);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                mediaList.add(mapResultSetToMedia(rs));
            }
            
        } catch (Exception e) {
            System.err.println("Error in getMediaByRegistrationIdAndType: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        
        return mediaList;
    }
    
    /**
     * Update a registration media record
     * @param media the registration media to update
     * @return true if successful, false otherwise
     */
    public static boolean updateRegistrationMedia(RegistrationMedia media) {
        String sql = "UPDATE registration_media SET file_description = ?, display_order = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, media.getFileDescription());
            ps.setInt(2, media.getDisplayOrder());
            ps.setInt(3, media.getId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        } catch (Exception e) {
            System.err.println("Error in updateRegistrationMedia: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Delete a registration media record
     * @param mediaId the media ID to delete
     * @return true if successful, false otherwise
     */
    public static boolean deleteRegistrationMedia(int mediaId) {
        String sql = "DELETE FROM registration_media WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, mediaId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        } catch (Exception e) {
            System.err.println("Error in deleteRegistrationMedia: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Delete all media for a specific registration
     * @param registrationId the registration ID
     * @return true if successful, false otherwise
     */
    public static boolean deleteAllMediaForRegistration(int registrationId) {
        String sql = "DELETE FROM registration_media WHERE registration_id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, registrationId);
            
            int affectedRows = ps.executeUpdate();
            return true; // Return true even if no rows affected (no media to delete)
            
        } catch (Exception e) {
            System.err.println("Error in deleteAllMediaForRegistration: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(null, ps, conn);
        }
    }
    
    /**
     * Map ResultSet to RegistrationMedia object
     * @param rs the ResultSet
     * @return RegistrationMedia object
     * @throws SQLException if mapping fails
     */
    private static RegistrationMedia mapResultSetToMedia(ResultSet rs) throws SQLException {
        RegistrationMedia media = new RegistrationMedia();
        media.setId(rs.getInt("id"));
        media.setRegistrationId(rs.getInt("registration_id"));
        media.setMediaType(rs.getString("media_type"));
        media.setFileUrl(rs.getString("file_url"));
        media.setFileDescription(rs.getString("file_description"));
        media.setFileSize(rs.getLong("file_size"));
        media.setFileName(rs.getString("file_name"));
        media.setUploadedAt(rs.getTimestamp("uploaded_at"));
        media.setDisplayOrder(rs.getInt("display_order"));
        return media;
    }
    
    /**
     * Close database resources
     * @param rs ResultSet to close
     * @param ps PreparedStatement to close
     * @param conn Connection to close
     */
    private static void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error closing database resources: " + e.getMessage());
        }
    }
} 