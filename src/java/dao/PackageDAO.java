package DAO;

import model.Package;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Package operations
 */
public class PackageDAO {
    
    /**
     * Get all packages for a specific subject/course ID
     * @param subjectId the subject ID (maps to course_id in packages table)
     * @return List of packages for the subject
     */
    public static List<Package> getPackagesBySubjectId(int subjectId) {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM packages WHERE course_id = ? ORDER BY sale_price ASC";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, subjectId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("id"));
                pkg.setSubjectId(rs.getInt("course_id")); // Map course_id to subjectId
                pkg.setName(rs.getString("package_name")); // Use package_name column
                pkg.setOriginalPrice(rs.getDouble("original_price"));
                pkg.setSalePrice(rs.getDouble("sale_price"));
                pkg.setDuration(rs.getInt("duration_months")); // Use duration_months column
                
                // Handle optional fields
                try {
                    pkg.setStatus(rs.getString("status"));
                } catch (SQLException e) {
                    pkg.setStatus("active"); // Default value
                }
                
                try {
                    pkg.setCreatedAt(rs.getTimestamp("created_at"));
                } catch (SQLException e) {
                    // Ignore if column doesn't exist
                }
                
                packages.add(pkg);
            }
            
            System.out.println("Found " + packages.size() + " packages for subject/course ID: " + subjectId);
        } catch (Exception e) {
            System.err.println("Error getting packages for subject " + subjectId + ": " + e.getMessage());
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
        
        return packages;
    }
    
    /**
     * Get a package by its ID
     * @param packageId the package ID
     * @return Package object or null if not found
     */
    public static Package getPackageById(int packageId) {
        Package pkg = null;
        String sql = "SELECT * FROM packages WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, packageId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                pkg = new Package();
                pkg.setId(rs.getInt("id"));
                pkg.setSubjectId(rs.getInt("course_id"));
                pkg.setName(rs.getString("package_name"));
                pkg.setOriginalPrice(rs.getDouble("original_price"));
                pkg.setSalePrice(rs.getDouble("sale_price"));
                pkg.setDuration(rs.getInt("duration_months"));
                
                try {
                    pkg.setStatus(rs.getString("status"));
                } catch (SQLException e) {
                    pkg.setStatus("active");
                }
                
                try {
                    pkg.setCreatedAt(rs.getTimestamp("created_at"));
                } catch (SQLException e) {
                    // Ignore if column doesn't exist
                }
            }
        } catch (Exception e) {
            System.err.println("Error getting package by ID " + packageId + ": " + e.getMessage());
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
        
        return pkg;
    }
    
    /**
     * Get all packages
     * @return List of all packages
     */
    public static List<Package> getAllPackages() {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM packages ORDER BY course_id, sale_price ASC";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("id"));
                pkg.setSubjectId(rs.getInt("course_id"));
                pkg.setName(rs.getString("package_name"));
                pkg.setOriginalPrice(rs.getDouble("original_price"));
                pkg.setSalePrice(rs.getDouble("sale_price"));
                pkg.setDuration(rs.getInt("duration_months"));
                
                try {
                    pkg.setStatus(rs.getString("status"));
                } catch (SQLException e) {
                    pkg.setStatus("active");
                }
                
                try {
                    pkg.setCreatedAt(rs.getTimestamp("created_at"));
                } catch (SQLException e) {
                    // Ignore if column doesn't exist
                }
                
                packages.add(pkg);
            }
        } catch (Exception e) {
            System.err.println("Error getting all packages: " + e.getMessage());
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
        
        return packages;
    }
} 