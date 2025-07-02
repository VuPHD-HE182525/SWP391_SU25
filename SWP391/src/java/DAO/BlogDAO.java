/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Blog;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;

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
}
