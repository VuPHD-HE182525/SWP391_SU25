package DAO;

import model.VideoTranscript;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class VideoTranscriptDAO {
    
    /**
     * Get video transcript by lesson ID
     */
    public VideoTranscript getTranscriptByLessonId(int lessonId) throws Exception {
        String sql = "SELECT * FROM video_transcripts WHERE lesson_id = ? AND status = 'completed'";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVideoTranscript(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Get all video transcripts
     */
    public List<VideoTranscript> getAllTranscripts() throws Exception {
        String sql = "SELECT * FROM video_transcripts ORDER BY processed_at DESC";
        List<VideoTranscript> transcripts = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                transcripts.add(mapResultSetToVideoTranscript(rs));
            }
        }
        return transcripts;
    }
    
    /**
     * Get transcripts by status
     */
    public List<VideoTranscript> getTranscriptsByStatus(String status) throws Exception {
        String sql = "SELECT * FROM video_transcripts WHERE status = ? ORDER BY processed_at DESC";
        List<VideoTranscript> transcripts = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    transcripts.add(mapResultSetToVideoTranscript(rs));
                }
            }
        }
        return transcripts;
    }
    
    /**
     * Save new video transcript
     */
    public void saveTranscript(VideoTranscript transcript) throws Exception {
        String sql = "INSERT INTO video_transcripts (lesson_id, video_path, transcript, key_topics, " +
                    "learning_objectives, timestamps, summary, file_size, duration_seconds, status, error_message) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, transcript.getLessonId());
            ps.setString(2, transcript.getVideoPath());
            ps.setString(3, transcript.getTranscript());
            ps.setString(4, transcript.getKeyTopics());
            ps.setString(5, transcript.getLearningObjectives());
            ps.setString(6, transcript.getTimestamps());
            ps.setString(7, transcript.getSummary());
            ps.setLong(8, transcript.getFileSize());
            ps.setInt(9, transcript.getDurationSeconds());
            ps.setString(10, transcript.getStatus());
            ps.setString(11, transcript.getErrorMessage());
            
            ps.executeUpdate();
            
            // Get generated ID
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    transcript.setId(generatedKeys.getInt(1));
                }
            }
        }
    }
    
    /**
     * Update existing video transcript
     */
    public void updateTranscript(VideoTranscript transcript) throws Exception {
        String sql = "UPDATE video_transcripts SET video_path = ?, transcript = ?, key_topics = ?, " +
                    "learning_objectives = ?, timestamps = ?, summary = ?, file_size = ?, " +
                    "duration_seconds = ?, status = ?, error_message = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, transcript.getVideoPath());
            ps.setString(2, transcript.getTranscript());
            ps.setString(3, transcript.getKeyTopics());
            ps.setString(4, transcript.getLearningObjectives());
            ps.setString(5, transcript.getTimestamps());
            ps.setString(6, transcript.getSummary());
            ps.setLong(7, transcript.getFileSize());
            ps.setInt(8, transcript.getDurationSeconds());
            ps.setString(9, transcript.getStatus());
            ps.setString(10, transcript.getErrorMessage());
            ps.setInt(11, transcript.getId());
            
            ps.executeUpdate();
        }
    }
    
    /**
     * Update transcript status
     */
    public void updateStatus(int transcriptId, String status, String errorMessage) throws Exception {
        String sql = "UPDATE video_transcripts SET status = ?, error_message = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, errorMessage);
            ps.setInt(3, transcriptId);
            
            ps.executeUpdate();
        }
    }
    
    /**
     * Delete video transcript
     */
    public void deleteTranscript(int transcriptId) throws Exception {
        String sql = "DELETE FROM video_transcripts WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, transcriptId);
            ps.executeUpdate();
        }
    }
    
    /**
     * Check if transcript exists for lesson
     */
    public boolean transcriptExists(int lessonId) throws Exception {
        String sql = "SELECT COUNT(*) FROM video_transcripts WHERE lesson_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, lessonId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    /**
     * Search transcripts by keyword
     */
    public List<VideoTranscript> searchTranscripts(String keyword) throws Exception {
        String sql = "SELECT * FROM video_transcripts WHERE " +
                    "(transcript LIKE ? OR key_topics LIKE ? OR summary LIKE ?) " +
                    "AND status = 'completed' ORDER BY processed_at DESC";
        List<VideoTranscript> transcripts = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    transcripts.add(mapResultSetToVideoTranscript(rs));
                }
            }
        }
        return transcripts;
    }
    
    /**
     * Map ResultSet to VideoTranscript object
     */
    private VideoTranscript mapResultSetToVideoTranscript(ResultSet rs) throws SQLException {
        VideoTranscript transcript = new VideoTranscript();
        
        transcript.setId(rs.getInt("id"));
        transcript.setLessonId(rs.getInt("lesson_id"));
        transcript.setVideoPath(rs.getString("video_path"));
        transcript.setTranscript(rs.getString("transcript"));
        transcript.setKeyTopics(rs.getString("key_topics"));
        transcript.setLearningObjectives(rs.getString("learning_objectives"));
        transcript.setTimestamps(rs.getString("timestamps"));
        transcript.setSummary(rs.getString("summary"));
        transcript.setFileSize(rs.getLong("file_size"));
        transcript.setDurationSeconds(rs.getInt("duration_seconds"));
        transcript.setStatus(rs.getString("status"));
        transcript.setErrorMessage(rs.getString("error_message"));
        
        // Handle timestamp conversion
        Timestamp processedAt = rs.getTimestamp("processed_at");
        if (processedAt != null) {
            transcript.setProcessedAt(processedAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            transcript.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return transcript;
    }
} 