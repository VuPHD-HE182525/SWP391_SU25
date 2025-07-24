/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Blog;
import utils.DBContext;

/**
 *
 * @author Kaonashi
 */
public class BlogDAO {

    // Lấy bài viết nổi bật (ví dụ 5 bài mới nhất)
    public List<Blog> getHotBlogs() throws Exception {
        List<Blog> list = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = null;
            
            try {
                // First try with published_at
                sql = "SELECT id, title, content, author_id, published_at, thumbnail_url " +
                     "FROM blogs WHERE published_at IS NOT NULL " +
                     "ORDER BY published_at DESC LIMIT 3";
                System.out.println("Trying getHotBlogs with published_at: " + sql);
                
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    
                    while (rs.next()) {
                        Blog blog = new Blog();
                        blog.setId(rs.getInt("id"));
                        blog.setTitle(rs.getString("title"));
                        blog.setContent(rs.getString("content"));
                        blog.setAuthorId(rs.getInt("author_id"));
                        blog.setPublishedAt(rs.getTimestamp("published_at"));
                        blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                        list.add(blog);
                        System.out.println("Found hot blog: " + blog.getTitle());
                    }
                }
                
            } catch (SQLException e1) {
                System.out.println("published_at column issue, trying with created_at...");
                
                try {
                    // Try with created_at
                    sql = "SELECT id, title, content, author_id, created_at as published_at, thumbnail_url " +
                         "FROM blogs WHERE created_at IS NOT NULL " +
                         "ORDER BY created_at DESC LIMIT 3";
                    System.out.println("Trying getHotBlogs with created_at: " + sql);
                    
                    try (PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {
                        
                        while (rs.next()) {
                            Blog blog = new Blog();
                            blog.setId(rs.getInt("id"));
                            blog.setTitle(rs.getString("title"));
                            blog.setContent(rs.getString("content"));
                            blog.setAuthorId(rs.getInt("author_id"));
                            blog.setPublishedAt(rs.getTimestamp("published_at"));
                            blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                            list.add(blog);
                            System.out.println("Found hot blog (with created_at): " + blog.getTitle());
                        }
                    }
                    
                } catch (SQLException e2) {
                    System.out.println("created_at also failed, trying basic query...");
                    
                    // Basic query without author_id and published_at
                    sql = "SELECT id, title, content, thumbnail_url FROM blogs ORDER BY id DESC LIMIT 3";
                    System.out.println("Using fallback query: " + sql);
                    
                    try (PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {
                        
                        while (rs.next()) {
                            Blog blog = new Blog();
                            blog.setId(rs.getInt("id"));
                            blog.setTitle(rs.getString("title"));
                            blog.setContent(rs.getString("content"));
                            blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                            list.add(blog);
                            System.out.println("Found hot blog (basic): " + blog.getTitle());
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error in getHotBlogs: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Total hot blogs found: " + list.size());
        return list;
    }

    // Lấy bài viết mới nhất (cho sidebar)
    public List<Blog> getLatestBlogs() throws Exception {
        List<Blog> list = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection()) {
            String sql = null;
            
            try {
                // First try with published_at
                sql = "SELECT id, title, content, author_id, published_at, thumbnail_url " +
                     "FROM blogs WHERE published_at IS NOT NULL " +
                     "ORDER BY published_at DESC LIMIT 5";
                System.out.println("Trying getLatestBlogs with published_at: " + sql);
                
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    
                    while (rs.next()) {
                        Blog blog = new Blog();
                        blog.setId(rs.getInt("id"));
                        blog.setTitle(rs.getString("title"));
                        blog.setContent(rs.getString("content"));
                        blog.setAuthorId(rs.getInt("author_id"));
                        blog.setPublishedAt(rs.getTimestamp("published_at"));
                        blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                        list.add(blog);
                        System.out.println("Found latest blog: " + blog.getTitle());
                    }
                }
                
            } catch (SQLException e1) {
                System.out.println("published_at column issue, trying with created_at...");
                
                try {
                    // Try with created_at
                    sql = "SELECT id, title, content, author_id, created_at as published_at, thumbnail_url " +
                         "FROM blogs WHERE created_at IS NOT NULL " +
                         "ORDER BY created_at DESC LIMIT 5";
                    System.out.println("Trying getLatestBlogs with created_at: " + sql);
                    
                    try (PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {
                        
                        while (rs.next()) {
                            Blog blog = new Blog();
                            blog.setId(rs.getInt("id"));
                            blog.setTitle(rs.getString("title"));
                            blog.setContent(rs.getString("content"));
                            blog.setAuthorId(rs.getInt("author_id"));
                            blog.setPublishedAt(rs.getTimestamp("published_at"));
                            blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                            list.add(blog);
                            System.out.println("Found latest blog (with created_at): " + blog.getTitle());
                        }
                    }
                    
                } catch (SQLException e2) {
                    System.out.println("created_at also failed, trying basic query...");
                    
                    // Basic query without author_id and published_at
                    sql = "SELECT id, title, content, thumbnail_url FROM blogs ORDER BY id DESC LIMIT 5";
                    System.out.println("Using fallback query: " + sql);
                    
                    try (PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {
                        
                        while (rs.next()) {
                            Blog blog = new Blog();
                            blog.setId(rs.getInt("id"));
                            blog.setTitle(rs.getString("title"));
                            blog.setContent(rs.getString("content"));
                            blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                            list.add(blog);
                            System.out.println("Found latest blog (basic): " + blog.getTitle());
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error in getLatestBlogs: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Total latest blogs found: " + list.size());
        return list;
    }

    // Get all blogs with filters and pagination
    public List<Blog> getAllBlogsWithFilters(String searchQuery, Integer categoryId, String sortBy, int offset, int limit) throws Exception {
        List<Blog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, title, content, author_id, published_at, thumbnail_url FROM blogs WHERE 1=1");

        // Add search filter
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR content LIKE ?)");
        }

        // Note: category_id filter removed since column doesn't exist in current table
        // if (categoryId != null) {
        //     sql.append(" AND category_id = ?");
        // }

        // Add sorting
        switch (sortBy) {
            case "oldest":
                sql.append(" ORDER BY published_at ASC");
                break;
            case "title":
                sql.append(" ORDER BY title ASC");
                break;
            case "newest":
            default:
                sql.append(" ORDER BY published_at DESC");
                break;
        }

        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Set search parameters
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            // Category parameter removed since column doesn't exist
            // if (categoryId != null) {
            //     ps.setInt(paramIndex++, categoryId);
            // }

            // Set pagination parameters
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setId(rs.getInt("id"));
                    blog.setTitle(rs.getString("title"));
                    blog.setContent(rs.getString("content"));
                    blog.setAuthorId(rs.getInt("author_id"));
                    blog.setPublishedAt(rs.getTimestamp("published_at"));
                    blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                    // blog.setCategoryId(rs.getInt("category_id")); // Column doesn't exist
                    list.add(blog);
                }
            }
        } catch (SQLException e) {
            // Fallback to basic query if advanced features fail
            System.out.println("Advanced query failed, using basic query: " + e.getMessage());
            return getBasicBlogs(limit, offset);
        }

        return list;
    }

    // Get total count of blogs with filters
    public int getTotalBlogsCount(String searchQuery, Integer categoryId) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM blogs WHERE 1=1");

        // Add search filter
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR content LIKE ?)");
        }

        // Category filter removed since column doesn't exist
        // if (categoryId != null) {
        //     sql.append(" AND category_id = ?");
        // }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Set search parameters
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            // Category parameter removed since column doesn't exist

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Count query failed: " + e.getMessage());
            // Return basic count
            return getBasicBlogsCount();
        }

        return 0;
    }

    // Fallback method for basic blogs
    private List<Blog> getBasicBlogs(int limit, int offset) throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT id, title, content, thumbnail_url FROM blogs ORDER BY id DESC LIMIT ? OFFSET ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setId(rs.getInt("id"));
                    blog.setTitle(rs.getString("title"));
                    blog.setContent(rs.getString("content"));
                    blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                    blog.setAuthorId(1); // Default author
                    list.add(blog);
                }
            }
        }

        return list;
    }

    // Get basic blogs count
    private int getBasicBlogsCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM blogs";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    // Lấy chi tiết blog theo id
    public Blog getBlogById(int id) throws Exception {
        Blog blog = null;
        try (Connection conn = DBContext.getConnection()) {
            String sql = "SELECT * FROM blogs WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        blog = new Blog();
                        blog.setId(rs.getInt("id"));
                        blog.setTitle(rs.getString("title"));
                        blog.setContent(rs.getString("content"));
                        blog.setAuthorId(rs.getInt("author_id"));
                        blog.setPublishedAt(rs.getTimestamp("published_at"));
                        blog.setThumbnailUrl(rs.getString("thumbnail_url"));
                        // Nếu có category_id thì set luôn (nếu model có)
                        try {
                            java.lang.reflect.Field f = blog.getClass().getDeclaredField("categoryId");
                            f.setAccessible(true);
                            f.set(blog, rs.getObject("category_id"));
                        } catch (Exception ignore) {}
                    }
                }
            }
        }
        return blog;
    }
}
