package DAO;

import model.Question;
import model.Answer;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE quiz_id = ? ORDER BY id";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question question = mapResultSetToQuestion(rs);
                    // Load answers for each question
                    AnswerDAO answerDAO = new AnswerDAO();
                    question.setAnswers(answerDAO.getAnswersByQuestionId(question.getId()));
                    questions.add(question);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return questions;
    }

    public Question getQuestionById(int id) {
        String sql = "SELECT * FROM questions WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Question question = mapResultSetToQuestion(rs);
                    // Load answers
                    AnswerDAO answerDAO = new AnswerDAO();
                    question.setAnswers(answerDAO.getAnswersByQuestionId(question.getId()));
                    return question;
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public void insertQuestion(Question question) {
        String sql = "INSERT INTO questions (quiz_id, content) VALUES (?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, question.getQuizId());
            ps.setString(2, question.getContent());
            
            ps.executeUpdate();
            
            // Get generated ID
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    question.setId(generatedKeys.getInt(1));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateQuestion(Question question) {
        String sql = "UPDATE questions SET quiz_id = ?, content = ? WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, question.getQuizId());
            ps.setString(2, question.getContent());
            ps.setInt(3, question.getId());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteQuestion(int id) {
        String sql = "DELETE FROM questions WHERE id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Question mapResultSetToQuestion(ResultSet rs) throws SQLException {
        Question question = new Question();
        question.setId(rs.getInt("id"));
        question.setQuizId(rs.getInt("quiz_id"));
        question.setContent(rs.getString("content"));
        return question;
    }
} 