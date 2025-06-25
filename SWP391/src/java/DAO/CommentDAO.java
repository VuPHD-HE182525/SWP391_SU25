package DAO;

import model.Comment;
import utils.DBContext;
import java.sql.*;
import java.util.*;

public class CommentDAO {
    public List<Comment> getCommentsBySubjectId(int subjectId) throws Exception {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT * FROM comments WHERE subject_id = ? AND (lesson_id IS NULL OR lesson_id = 0) ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Comment c = new Comment();
                c.setId(rs.getInt("id"));
                c.setUserId(rs.getInt("user_id"));
                c.setSubjectId(rs.getInt("subject_id"));
                c.setLessonId(rs.getObject("lesson_id") != null ? rs.getInt("lesson_id") : null);
                c.setContent(rs.getString("content"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(c);
            }
        }
        return list;
    }

    public List<Comment> getCommentsByLessonId(int lessonId) throws Exception {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT * FROM comments WHERE lesson_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Comment c = new Comment();
                c.setId(rs.getInt("id"));
                c.setUserId(rs.getInt("user_id"));
                c.setSubjectId(rs.getInt("subject_id"));
                c.setLessonId(rs.getObject("lesson_id") != null ? rs.getInt("lesson_id") : null);
                c.setContent(rs.getString("content"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(c);
            }
        }
        return list;
    }

    public void addComment(Comment comment) throws Exception {
        String sql = "INSERT INTO comments (user_id, subject_id, lesson_id, content, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, comment.getUserId());
            ps.setInt(2, comment.getSubjectId());
            if (comment.getLessonId() != null) {
                ps.setInt(3, comment.getLessonId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, comment.getContent());
            ps.setTimestamp(5, new java.sql.Timestamp(comment.getCreatedAt().getTime()));
            ps.executeUpdate();
        }
    }
} 