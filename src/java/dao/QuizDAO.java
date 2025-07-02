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

    public void insertQuiz(Quiz quiz) {
        String sql = "INSERT INTO quizzes (lesson_id, code, description, title, subject_id, level, duration, pass_rate, quiz_type, total_questions) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (quiz.getLessonId() != null) {
                ps.setInt(1, quiz.getLessonId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, quiz.getCode());
            ps.setString(3, quiz.getDescription());
            ps.setString(4, quiz.getTitle());
            ps.setInt(5, quiz.getSubjectId());
            ps.setString(6, quiz.getLevel());
            ps.setInt(7, quiz.getDuration());
            ps.setDouble(8, quiz.getPassRate());
            ps.setString(9, quiz.getQuizType());
            ps.setInt(10, quiz.getTotalQuestions());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateQuiz(Quiz quiz) {
        String sql = "UPDATE quizzes SET lesson_id = ?, code = ?, description = ?, title = ?, subject_id = ?, " +
                     "level = ?, duration = ?, pass_rate = ?, quiz_type = ?, total_questions = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (quiz.getLessonId() != null) {
                ps.setInt(1, quiz.getLessonId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, quiz.getCode());
            ps.setString(3, quiz.getDescription());
            ps.setString(4, quiz.getTitle());
            ps.setInt(5, quiz.getSubjectId());
            ps.setString(6, quiz.getLevel());
            ps.setInt(7, quiz.getDuration());
            ps.setDouble(8, quiz.getPassRate());
            ps.setString(9, quiz.getQuizType());
            ps.setInt(10, quiz.getTotalQuestions());
            ps.setInt(11, quiz.getId());

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
        quiz.setCode(rs.getString("code"));
        quiz.setDescription(rs.getString("description"));
        quiz.setTitle(rs.getString("title"));
        quiz.setSubjectId(rs.getInt("subject_id"));
        quiz.setLevel(rs.getString("level"));
        quiz.setDuration(rs.getInt("duration"));
        quiz.setPassRate(rs.getDouble("pass_rate"));
        quiz.setQuizType(rs.getString("quiz_type"));
        quiz.setTotalQuestions(rs.getInt("total_questions"));
        return quiz;
    }
}
