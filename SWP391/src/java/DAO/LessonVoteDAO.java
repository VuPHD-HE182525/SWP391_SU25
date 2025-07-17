package DAO;

import model.LessonVote;
import utils.DBContext;
import java.sql.*;
import java.util.Date;

public class LessonVoteDAO {
    
    // Save or update a user's vote for a lesson
    public void saveVote(LessonVote vote) throws Exception {
        String sql = "INSERT INTO lesson_votes (user_id, lesson_id, vote_type) " +
                    "VALUES (?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE vote_type = VALUES(vote_type), updated_at = CURRENT_TIMESTAMP";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, vote.getUserId());
            ps.setInt(2, vote.getLessonId());
            ps.setString(3, vote.getVoteType());
            
            ps.executeUpdate();
        }
    }
    
    // Get a user's vote for a specific lesson
    public LessonVote getUserVote(int userId, int lessonId) throws Exception {
        String sql = "SELECT * FROM lesson_votes WHERE user_id = ? AND lesson_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LessonVote vote = new LessonVote();
                    vote.setId(rs.getInt("id"));
                    vote.setUserId(rs.getInt("user_id"));
                    vote.setLessonId(rs.getInt("lesson_id"));
                    vote.setVoteType(rs.getString("vote_type"));
                    vote.setCreatedAt(rs.getTimestamp("created_at"));
                    vote.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return vote;
                }
            }
        }
        return null;
    }
    
    // Get vote statistics for a lesson (likes and dislikes count)
    public VoteStats getVoteStats(int lessonId) throws Exception {
        String sql = "SELECT " +
                    "SUM(CASE WHEN vote_type = 'like' THEN 1 ELSE 0 END) as likes, " +
                    "SUM(CASE WHEN vote_type = 'dislike' THEN 1 ELSE 0 END) as dislikes " +
                    "FROM lesson_votes WHERE lesson_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int likes = rs.getInt("likes");
                    int dislikes = rs.getInt("dislikes");
                    return new VoteStats(likes, dislikes);
                }
            }
        }
        return new VoteStats(0, 0);
    }
    
    // Delete a user's vote for a lesson
    public void deleteVote(int userId, int lessonId) throws Exception {
        String sql = "DELETE FROM lesson_votes WHERE user_id = ? AND lesson_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, lessonId);
            
            ps.executeUpdate();
        }
    }
    
    // Inner class to hold vote statistics
    public static class VoteStats {
        private int likes;
        private int dislikes;
        
        public VoteStats(int likes, int dislikes) {
            this.likes = likes;
            this.dislikes = dislikes;
        }
        
        public int getLikes() {
            return likes;
        }
        
        public int getDislikes() {
            return dislikes;
        }
        
        public int getTotal() {
            return likes + dislikes;
        }
        
        public double getLikePercentage() {
            int total = getTotal();
            return total > 0 ? (double) likes / total * 100 : 0;
        }
    }
} 