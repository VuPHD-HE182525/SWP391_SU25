package DAO;

import model.Answer;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnswerDAO {

    public List<Answer> getAnswersByQuestionId(int questionId) {
        List<Answer> answers = new ArrayList<>();
        String sql = "SELECT * FROM answers WHERE question_id = ? ORDER BY id";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    answers.add(mapResultSetToAnswer(rs));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return answers;
    }

    public Answer getAnswerById(int id) {
        String sql = "SELECT * FROM answers WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAnswer(rs);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public Answer getCorrectAnswerByQuestionId(int questionId) {
        String sql = "SELECT * FROM answers WHERE question_id = ? AND is_correct = 1";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAnswer(rs);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public void insertAnswer(Answer answer) {
        String sql = "INSERT INTO answers (question_id, content, is_correct) VALUES (?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, answer.getQuestionId());
            ps.setString(2, answer.getContent());
            ps.setBoolean(3, answer.isCorrect());
            
            ps.executeUpdate();
            
            // Get generated ID
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    answer.setId(generatedKeys.getInt(1));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateAnswer(Answer answer) {
        String sql = "UPDATE answers SET question_id = ?, content = ?, is_correct = ? WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, answer.getQuestionId());
            ps.setString(2, answer.getContent());
            ps.setBoolean(3, answer.isCorrect());
            ps.setInt(4, answer.getId());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteAnswer(int id) {
        String sql = "DELETE FROM answers WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Answer mapResultSetToAnswer(ResultSet rs) throws SQLException {
        Answer answer = new Answer();
        answer.setId(rs.getInt("id"));
        answer.setQuestionId(rs.getInt("question_id"));
        answer.setContent(rs.getString("content"));
        answer.setCorrect(rs.getBoolean("is_correct"));
        return answer;
    }
} 