package DAO;

import model.LessonProgress;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class LessonProgressDAO {
    
    public LessonProgress getUserLessonProgress(int userId, int lessonId) throws Exception {
        String sql = "SELECT * FROM lesson_progress WHERE user_id = ? AND lesson_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LessonProgress progress = new LessonProgress();
                    progress.setId(rs.getInt("id"));
                    progress.setUserId(rs.getInt("user_id"));
                    progress.setLessonId(rs.getInt("lesson_id"));
                    progress.setCompleted(rs.getBoolean("is_completed"));
                    
                    Timestamp lastViewed = rs.getTimestamp("last_viewed_at");
                    if (lastViewed != null) {
                        progress.setLastViewedAt(lastViewed.toLocalDateTime());
                    }
                    
                    progress.setViewDurationSeconds(rs.getInt("view_duration_seconds"));
                    return progress;
                }
            }
        }
        return null;
    }
    
    public List<LessonProgress> getUserProgressForCourse(int userId, int courseId) throws Exception {
        String sql = "SELECT lp.* FROM lesson_progress lp " +
                    "JOIN lessons l ON lp.lesson_id = l.id " +
                    "WHERE lp.user_id = ? AND l.course_id = ?";
        
        List<LessonProgress> progressList = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LessonProgress progress = new LessonProgress();
                    progress.setId(rs.getInt("id"));
                    progress.setUserId(rs.getInt("user_id"));
                    progress.setLessonId(rs.getInt("lesson_id"));
                    progress.setCompleted(rs.getBoolean("is_completed"));
                    
                    Timestamp lastViewed = rs.getTimestamp("last_viewed_at");
                    if (lastViewed != null) {
                        progress.setLastViewedAt(lastViewed.toLocalDateTime());
                    }
                    
                    progress.setViewDurationSeconds(rs.getInt("view_duration_seconds"));
                    progressList.add(progress);
                }
            }
        }
        return progressList;
    }
    
    public void updateProgress(LessonProgress progress) throws Exception {
        LessonProgress existing = getUserLessonProgress(progress.getUserId(), progress.getLessonId());
        
        if (existing == null) {
            insertProgress(progress);
        } else {
            String sql = "UPDATE lesson_progress SET is_completed = ?, last_viewed_at = ?, view_duration_seconds = ? " +
                        "WHERE user_id = ? AND lesson_id = ?";
            
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setBoolean(1, progress.isCompleted());
                ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                ps.setInt(3, progress.getViewDurationSeconds());
                ps.setInt(4, progress.getUserId());
                ps.setInt(5, progress.getLessonId());
                
                ps.executeUpdate();
            }
        }
    }
    
    public void insertProgress(LessonProgress progress) throws Exception {
        String sql = "INSERT INTO lesson_progress (user_id, lesson_id, is_completed, last_viewed_at, view_duration_seconds) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, progress.getUserId());
            ps.setInt(2, progress.getLessonId());
            ps.setBoolean(3, progress.isCompleted());
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(5, progress.getViewDurationSeconds());
            
            ps.executeUpdate();
        }
    }
    
    public void markLessonCompleted(int userId, int lessonId) throws Exception {
        LessonProgress progress = getUserLessonProgress(userId, lessonId);
        if (progress == null) {
            progress = new LessonProgress(userId, lessonId);
        }
        progress.setCompleted(true);
        updateProgress(progress);
    }
    
    public void markLessonViewed(int userId, int lessonId, int viewDurationSeconds) throws Exception {
        LessonProgress progress = getUserLessonProgress(userId, lessonId);
        if (progress == null) {
            progress = new LessonProgress(userId, lessonId);
        }
        progress.setViewDurationSeconds(Math.max(progress.getViewDurationSeconds(), viewDurationSeconds));
        updateProgress(progress);
    }
} 