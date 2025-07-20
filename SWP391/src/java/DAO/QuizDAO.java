package DAO;

import model.Quiz;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {

    public List<Quiz> getAllQuizzes() {
        List<Quiz> list = new ArrayList<>();
        String sql = "SELECT * FROM quizzes";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToQuiz(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Quiz getQuizById(int id) {
        String sql = "SELECT * FROM quizzes WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToQuiz(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Quiz getQuizByLessonId(int lessonId) {
        String sql = "SELECT * FROM quizzes WHERE lesson_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToQuiz(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private int countQuestionsForQuiz(int quizId) {
        String sql = "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void insertQuiz(Quiz quiz) {
        String sql = "INSERT INTO quizzes (lesson_id, title, description) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (quiz.getLessonId() != null) {
                ps.setInt(1, quiz.getLessonId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, quiz.getTitle());
            ps.setString(3, quiz.getDescription());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateQuiz(Quiz quiz) {
        String sql = "UPDATE quizzes SET lesson_id = ?, title = ?, description = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (quiz.getLessonId() != null) {
                ps.setInt(1, quiz.getLessonId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, quiz.getTitle());
            ps.setString(3, quiz.getDescription());
            ps.setInt(4, quiz.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteQuiz(int id) {
        String sql = "DELETE FROM quizzes WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Quiz mapResultSetToQuiz(ResultSet rs) throws SQLException {
        Quiz quiz = new Quiz();
        quiz.setId(rs.getInt("id"));
        int lessonId = rs.getInt("lesson_id");
        quiz.setLessonId(rs.wasNull() ? null : lessonId);
        quiz.setTitle(rs.getString("title"));
        quiz.setDescription(rs.getString("description"));
        
        // Set default values for fields not in database
        quiz.setCode("QUIZ_" + quiz.getId());
        quiz.setSubjectId(0);
        quiz.setLevel("Intermediate");
        quiz.setDuration(30);
        quiz.setPassRate(70.0);
        quiz.setQuizType("Multiple Choice");
        
        // Count actual questions for this quiz
        quiz.setTotalQuestions(countQuestionsForQuiz(quiz.getId()));
        
        return quiz;
    }
}
