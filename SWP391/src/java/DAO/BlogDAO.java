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

/**
 *
 * @author Kaonashi
 */
public class BlogDAO {

    // Lấy bài viết nổi bật (ví dụ 5 bài mới nhất)
    public List<Blog> getHotBlogs() throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT id, title, content, author_id, published_at, thumbnail_url " +
                     "FROM blogs WHERE published_at IS NOT NULL ORDER BY published_at DESC LIMIT 3";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
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
            }
        }
        return list;
    }

    // Lấy bài viết mới nhất (cho sidebar)
    public List<Blog> getLatestBlogs() throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT id, title, content, author_id, published_at, thumbnail_url " +
                     "FROM blogs WHERE published_at IS NOT NULL ORDER BY published_at DESC LIMIT 5";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
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
            }
        }
        return list;
    }
}
