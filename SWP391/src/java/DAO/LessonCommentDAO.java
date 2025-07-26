package DAO;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.LessonComment;
import utils.DBContext;

public class LessonCommentDAO {
    
    public List<LessonComment> getCommentsByLessonId(int lessonId) throws Exception {
        String sql = "SELECT lc.*, u.full_name, u.avatar_url " +
                    "FROM lesson_comments lc " +
                    "JOIN users u ON lc.user_id = u.id " +
                    "WHERE lc.lesson_id = ? " +
                    "ORDER BY lc.created_at DESC";

        List<LessonComment> comments = new ArrayList<>();

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LessonComment comment = new LessonComment();
                    comment.setId(rs.getInt("id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setLessonId(rs.getInt("lesson_id"));
                    comment.setCommentText(rs.getString("comment_text"));

                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        comment.setCreatedAt(createdAt.toLocalDateTime());
                    }

                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    if (updatedAt != null) {
                        comment.setUpdatedAt(updatedAt.toLocalDateTime());
                    }

                    // Load media fields safely (check if columns exist)
                    try {
                        comment.setMediaType(rs.getString("media_type"));
                        comment.setMediaPath(rs.getString("media_path"));
                        comment.setMediaFilename(rs.getString("media_filename"));
                    } catch (SQLException e) {
                        // Media columns don't exist, set to null
                        comment.setMediaType(null);
                        comment.setMediaPath(null);
                        comment.setMediaFilename(null);
                    }

                    comment.setUserFullName(rs.getString("full_name"));
                    comment.setUserAvatarUrl(rs.getString("avatar_url"));

                    // Debug
                    System.out.println("Loaded comment: " + comment.getCommentText() + " by " + comment.getUserFullName());

                    comments.add(comment);
                }
            }
        }
        return comments;
    }
    
    public void addComment(LessonComment comment) throws Exception {
        // First try to check if media columns exist
        boolean hasMediaColumns = checkMediaColumnsExist();

        if (hasMediaColumns) {
            // Use full SQL with media columns
            String sql = "INSERT INTO lesson_comments (user_id, lesson_id, comment_text, created_at, updated_at, media_type, media_path, media_filename) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, comment.getUserId());
                ps.setInt(2, comment.getLessonId());
                ps.setString(3, comment.getCommentText());
                ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
                ps.setString(6, comment.getMediaType());
                ps.setString(7, comment.getMediaPath());
                ps.setString(8, comment.getMediaFilename());

                ps.executeUpdate();
            }
        } else {
            // Use basic SQL without media columns
            String sql = "INSERT INTO lesson_comments (user_id, lesson_id, comment_text, created_at, updated_at) " +
                        "VALUES (?, ?, ?, ?, ?)";

            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, comment.getUserId());
                ps.setInt(2, comment.getLessonId());
                ps.setString(3, comment.getCommentText());
                ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));

                ps.executeUpdate();
            }
        }
    }

    private boolean checkMediaColumnsExist() {
        try (Connection conn = DBContext.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet columns = metaData.getColumns(null, null, "lesson_comments", "media_type");
            return columns.next();
        } catch (Exception e) {
            return false;
        }
    }
    
    public void updateComment(int commentId, String newText) throws Exception {
        String sql = "UPDATE lesson_comments SET comment_text = ?, updated_at = ? WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newText);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, commentId);
            
            ps.executeUpdate();
        }
    }
    
    public void deleteComment(int commentId) throws Exception {
        String sql = "DELETE FROM lesson_comments WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, commentId);
            ps.executeUpdate();
        }
    }
    
    public LessonComment getCommentById(int commentId) throws Exception {
        String sql = "SELECT lc.*, u.full_name, u.avatar_url " +
                    "FROM lesson_comments lc " +
                    "JOIN users u ON lc.user_id = u.id " +
                    "WHERE lc.id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, commentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LessonComment comment = new LessonComment();
                    comment.setId(rs.getInt("id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setLessonId(rs.getInt("lesson_id"));
                    comment.setCommentText(rs.getString("comment_text"));

                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        comment.setCreatedAt(createdAt.toLocalDateTime());
                    }

                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    if (updatedAt != null) {
                        comment.setUpdatedAt(updatedAt.toLocalDateTime());
                    }

                    // Load media fields safely (check if columns exist)
                    try {
                        comment.setMediaType(rs.getString("media_type"));
                        comment.setMediaPath(rs.getString("media_path"));
                        comment.setMediaFilename(rs.getString("media_filename"));
                    } catch (SQLException e) {
                        // Media columns don't exist, set to null
                        comment.setMediaType(null);
                        comment.setMediaPath(null);
                        comment.setMediaFilename(null);
                    }

                    comment.setUserFullName(rs.getString("full_name"));
                    comment.setUserAvatarUrl(rs.getString("avatar_url"));

                    return comment;
                }
            }
        }
        return null;
    }
} 