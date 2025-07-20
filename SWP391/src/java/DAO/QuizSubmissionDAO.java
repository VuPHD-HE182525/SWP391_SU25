package DAO;

import model.QuizSubmission;
import utils.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class QuizSubmissionDAO {

    public List<QuizSubmission> getSubmissionsByUserId(int userId) {
        List<QuizSubmission> submissions = new ArrayList<>();
        String sql = "SELECT qs.*, q.title as quiz_title, u.full_name as user_name " +
                    "FROM quiz_submissions qs " +
                    "LEFT JOIN quizzes q ON qs.quiz_id = q.id " +
                    "LEFT JOIN users u ON qs.user_id = u.id " +
                    "WHERE qs.user_id = ? ORDER BY qs.submitted_at DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    submissions.add(mapResultSetToQuizSubmission(rs));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return submissions;
    }

    public List<QuizSubmission> getSubmissionsByQuizId(int quizId) {
        List<QuizSubmission> submissions = new ArrayList<>();
        String sql = "SELECT qs.*, q.title as quiz_title, u.full_name as user_name " +
                    "FROM quiz_submissions qs " +
                    "LEFT JOIN quizzes q ON qs.quiz_id = q.id " +
                    "LEFT JOIN users u ON qs.user_id = u.id " +
                    "WHERE qs.quiz_id = ? ORDER BY qs.submitted_at DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    submissions.add(mapResultSetToQuizSubmission(rs));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return submissions;
    }

    public QuizSubmission getSubmissionById(int id) {
        String sql = "SELECT qs.*, q.title as quiz_title, u.full_name as user_name " +
                    "FROM quiz_submissions qs " +
                    "LEFT JOIN quizzes q ON qs.quiz_id = q.id " +
                    "LEFT JOIN users u ON qs.user_id = u.id " +
                    "WHERE qs.id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToQuizSubmission(rs);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public QuizSubmission getLatestSubmission(int userId, int quizId) {
        String sql = "SELECT qs.*, q.title as quiz_title, u.full_name as user_name " +
                    "FROM quiz_submissions qs " +
                    "LEFT JOIN quizzes q ON qs.quiz_id = q.id " +
                    "LEFT JOIN users u ON qs.user_id = u.id " +
                    "WHERE qs.user_id = ? AND qs.quiz_id = ? " +
                    "ORDER BY qs.submitted_at DESC LIMIT 1";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToQuizSubmission(rs);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public void insertSubmission(QuizSubmission submission) {
        String sql = "INSERT INTO quiz_submissions (user_id, quiz_id, submitted_at, score) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, submission.getUserId());
            ps.setInt(2, submission.getQuizId());
            ps.setTimestamp(3, Timestamp.valueOf(submission.getSubmittedAt()));
            ps.setInt(4, submission.getScore());
            
            ps.executeUpdate();
            
            // Get generated ID
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    submission.setId(generatedKeys.getInt(1));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateSubmission(QuizSubmission submission) {
        String sql = "UPDATE quiz_submissions SET user_id = ?, quiz_id = ?, submitted_at = ?, score = ? WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, submission.getUserId());
            ps.setInt(2, submission.getQuizId());
            ps.setTimestamp(3, Timestamp.valueOf(submission.getSubmittedAt()));
            ps.setInt(4, submission.getScore());
            ps.setInt(5, submission.getId());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteSubmission(int id) {
        String sql = "DELETE FROM quiz_submissions WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private QuizSubmission mapResultSetToQuizSubmission(ResultSet rs) throws SQLException {
        QuizSubmission submission = new QuizSubmission();
        submission.setId(rs.getInt("id"));
        submission.setUserId(rs.getInt("user_id"));
        submission.setQuizId(rs.getInt("quiz_id"));
        
        Timestamp submittedAt = rs.getTimestamp("submitted_at");
        if (submittedAt != null) {
            submission.setSubmittedAt(submittedAt.toLocalDateTime());
        }
        
        submission.setScore(rs.getInt("score"));
        submission.setQuizTitle(rs.getString("quiz_title"));
        submission.setUserName(rs.getString("user_name"));
        
        return submission;
    }
} 