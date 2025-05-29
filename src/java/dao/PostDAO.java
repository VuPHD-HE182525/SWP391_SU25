/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Post; 
import util.DBContext; 
/**
 *
 * @author thang
 */
public class PostDAO {
    public Post getPostById(int postId) {
        Post post = null;
        String sql = "SELECT p.post_id, p.title, p.content, p.thumbnail_url, p.created_at, p.updated_at, " +
                     "pc.p_category_name, u.full_name AS author_name " +
                     "FROM posts p " +
                     "LEFT JOIN post_categories pc ON p.p_category_id = pc.p_category_id " +
                     "LEFT JOIN users u ON p.author_id = u.user_id " +
                     "WHERE p.post_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    post = new Post();
                    post.setId(rs.getInt("post_id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setThumbnailUrl(rs.getString("thumbnail_url"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUpdatedAt(rs.getTimestamp("updated_at"));
                    post.setCategoryName(rs.getString("p_category_name"));
                    String authorName = rs.getString("author_name");
                    post.setAuthor(authorName == null ? "N/A" : authorName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return post;
    }
    public List<Post> getTop3Posts() {
    List<Post> topPosts = new ArrayList<>();
    String sql = "SELECT p.post_id, p.title, p.content, p.thumbnail_url, p.created_at, p.updated_at, " +
                 "pc.p_category_name, u.full_name AS author_name " +
                 "FROM posts p " +
                 "LEFT JOIN post_categories pc ON p.p_category_id = pc.p_category_id " +
                 "LEFT JOIN users u ON p.author_id = u.user_id " +
                 "ORDER BY p.created_at DESC " +
                 "LIMIT 3";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Post post = new Post();
            post.setId(rs.getInt("post_id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setThumbnailUrl(rs.getString("thumbnail_url"));
            post.setCreatedAt(rs.getTimestamp("created_at"));
            post.setUpdatedAt(rs.getTimestamp("updated_at"));
            post.setCategoryName(rs.getString("p_category_name"));
            String authorName = rs.getString("author_name");
            post.setAuthor(authorName == null ? "N/A" : authorName);
            topPosts.add(post);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return topPosts;
}
    
    
    
    
    
    
    
    
    
    
    

}
