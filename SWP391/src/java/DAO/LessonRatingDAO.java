package DAO;

import model.LessonRating;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LessonRatingDAO {
    
    /**
     * Add or update a rating for a lesson
     */
    public void addOrUpdateRating(LessonRating rating) throws Exception {
        // Check if user already rated this lesson
        LessonRating existing = getUserRating(rating.getUserId(), rating.getLessonId());
        
        if (existing != null) {
            updateRating(rating);
        } else {
            insertRating(rating);
        }
    }
    
    /**
     * Insert new rating
     */
    private void insertRating(LessonRating rating) throws Exception {
        String sql = "INSERT INTO lesson_ratings (user_id, lesson_id, rating, review_text) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, rating.getUserId());
            ps.setInt(2, rating.getLessonId());
            ps.setInt(3, rating.getRating());
            ps.setString(4, rating.getReviewText());
            
            ps.executeUpdate();
            
            // Get generated ID
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    rating.setId(generatedKeys.getInt(1));
                }
            }
        }
    }
    
    /**
     * Update existing rating
     */
    private void updateRating(LessonRating rating) throws Exception {
        String sql = "UPDATE lesson_ratings SET rating = ?, review_text = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE user_id = ? AND lesson_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, rating.getRating());
            ps.setString(2, rating.getReviewText());
            ps.setInt(3, rating.getUserId());
            ps.setInt(4, rating.getLessonId());
            
            ps.executeUpdate();
        }
    }
    
    /**
     * Get user's rating for a specific lesson
     */
    public LessonRating getUserRating(int userId, int lessonId) throws Exception {
        String sql = "SELECT lr.*, u.full_name as user_name, u.avatar_url as user_avatar " +
                    "FROM lesson_ratings lr " +
                    "LEFT JOIN users u ON lr.user_id = u.id " +
                    "WHERE lr.user_id = ? AND lr.lesson_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRating(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Get all ratings for a lesson with user info
     */
    public List<LessonRating> getLessonRatings(int lessonId) throws Exception {
        String sql = "SELECT lr.*, u.full_name as user_name, u.avatar_url as user_avatar " +
                    "FROM lesson_ratings lr " +
                    "LEFT JOIN users u ON lr.user_id = u.id " +
                    "WHERE lr.lesson_id = ? " +
                    "ORDER BY lr.created_at DESC";
        
        List<LessonRating> ratings = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ratings.add(mapResultSetToRating(rs));
                }
            }
        }
        return ratings;
    }
    
    /**
     * Get rating statistics for a lesson
     */
    public Map<String, Object> getLessonRatingStats(int lessonId) throws Exception {
        Map<String, Object> stats = new HashMap<>();
        
        // Get average rating and total count
        String avgSql = "SELECT AVG(rating) as avg_rating, COUNT(*) as total_ratings FROM lesson_ratings WHERE lesson_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(avgSql)) {
            
            ps.setInt(1, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double avgRating = rs.getDouble("avg_rating");
                    int totalRatings = rs.getInt("total_ratings");
                    
                    stats.put("averageRating", Math.round(avgRating * 10.0) / 10.0); // Round to 1 decimal
                    stats.put("totalRatings", totalRatings);
                }
            }
        }
        
        // Get rating breakdown (1-5 stars)
        String breakdownSql = "SELECT rating, COUNT(*) as count FROM lesson_ratings WHERE lesson_id = ? GROUP BY rating";
        Map<Integer, Integer> breakdown = new HashMap<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(breakdownSql)) {
            
            ps.setInt(1, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    breakdown.put(rs.getInt("rating"), rs.getInt("count"));
                }
            }
        }
        
        // Calculate percentages
        int totalRatings = (Integer) stats.getOrDefault("totalRatings", 0);
        Map<Integer, Double> percentages = new HashMap<>();
        
        for (int i = 1; i <= 5; i++) {
            int count = breakdown.getOrDefault(i, 0);
            double percentage = totalRatings > 0 ? (count * 100.0 / totalRatings) : 0.0;
            // Round to 1 decimal place instead of integer
            percentages.put(i, Math.round(percentage * 10.0) / 10.0);
        }
        
        stats.put("ratingBreakdown", breakdown);
        stats.put("ratingPercentages", percentages);
        
        return stats;
    }
    
    /**
     * Map ResultSet to LessonRating object
     */
    private LessonRating mapResultSetToRating(ResultSet rs) throws SQLException {
        LessonRating rating = new LessonRating();
        
        rating.setId(rs.getInt("id"));
        rating.setUserId(rs.getInt("user_id"));
        rating.setLessonId(rs.getInt("lesson_id"));
        rating.setRating(rs.getInt("rating"));
        rating.setReviewText(rs.getString("review_text"));
        rating.setUserName(rs.getString("user_name"));
        rating.setUserAvatar(rs.getString("user_avatar"));
        
        // Handle timestamps
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            rating.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            rating.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return rating;
    }
    
    /**
     * Delete a rating (for admin or user)
     */
    public void deleteRating(int ratingId) throws Exception {
        String sql = "DELETE FROM lesson_ratings WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ratingId);
            ps.executeUpdate();
        }
    }
    
    /**
     * Get top rated lessons
     */
    public List<Map<String, Object>> getTopRatedLessons(int limit) throws Exception {
        String sql = "SELECT l.id, l.title, AVG(lr.rating) as avg_rating, COUNT(lr.rating) as total_ratings " +
                    "FROM lessons l " +
                    "LEFT JOIN lesson_ratings lr ON l.id = lr.lesson_id " +
                    "GROUP BY l.id, l.title " +
                    "HAVING COUNT(lr.rating) > 0 " +
                    "ORDER BY avg_rating DESC, total_ratings DESC " +
                    "LIMIT ?";
        
        List<Map<String, Object>> topLessons = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> lesson = new HashMap<>();
                    lesson.put("id", rs.getInt("id"));
                    lesson.put("title", rs.getString("title"));
                    lesson.put("averageRating", Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0);
                    lesson.put("totalRatings", rs.getInt("total_ratings"));
                    topLessons.add(lesson);
                }
            }
        }
        
        return topLessons;
    }
} 