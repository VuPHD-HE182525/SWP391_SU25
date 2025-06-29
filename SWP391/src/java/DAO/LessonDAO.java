package DAO;

import model.Lesson;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LessonDAO {

    public List<Lesson> getLessonsBySubject(int subjectId) throws Exception {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM lessons WHERE subject_id = ? ORDER BY parent_lesson_id, lesson_order";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("title")); // đổi từ name → title
                    lesson.setOrderNum(rs.getInt("lesson_order")); // đổi từ order_num → lesson_order
                    lesson.setType(rs.getString("type"));
                    lesson.setStatus(rs.getBoolean("status"));
                    lesson.setSubjectId(rs.getInt("subject_id"));
                    lesson.setParentLessonId(rs.getInt("parent_lesson_id"));
                    list.add(lesson);
                }
            }
        }
        return list;
    }

    public void toggleStatus(int lessonId, boolean status) throws Exception {
        String sql = "UPDATE lessons SET status = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, status);
            ps.setInt(2, lessonId);
            ps.executeUpdate();
        }
    }

    public Lesson getLessonById(int id) throws Exception {
        String sql = "SELECT * FROM lessons WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("title"));
                    lesson.setOrderNum(rs.getInt("lesson_order"));
                    lesson.setType(rs.getString("type"));
                    lesson.setStatus(rs.getBoolean("status"));
                    lesson.setSubjectId(rs.getInt("subject_id"));
                    lesson.setParentLessonId(rs.getInt("parent_lesson_id"));
                    lesson.setVideoLink(rs.getString("video_link"));
                    lesson.setHtmlContent(rs.getString("html_content"));

                    int quizId = rs.getInt("quiz_id");
                    if (!rs.wasNull()) {
                        lesson.setQuizId(quizId);
                    }

                    return lesson;
                }
            }
        }
        return null;
    }

    public void updateLesson(Lesson lesson) throws Exception {
        String sql = "UPDATE lessons SET title = ?, lesson_order = ?, type = ?, status = ?, parent_lesson_id = ?, video_link = ?, html_content = ?, quiz_id = ? WHERE id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lesson.getName());
            ps.setInt(2, lesson.getOrderNum());
            ps.setString(3, lesson.getType());
            ps.setBoolean(4, lesson.isStatus());
            ps.setInt(5, lesson.getParentLessonId());
            ps.setString(6, lesson.getVideoLink());
            ps.setString(7, lesson.getHtmlContent());

            if (lesson.getQuizId() != null) {
                ps.setInt(8, lesson.getQuizId());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            ps.setInt(9, lesson.getId());
            ps.executeUpdate();
        }

    }

    public List<Lesson> getLessonsBySubjectWithFilters(int subjectId, String status, String search, String group) throws Exception {
        List<Lesson> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM lessons WHERE subject_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(subjectId);

        if (status != null && !status.equalsIgnoreCase("all")) {
            sql.append(" AND status = ?");
            params.add(status.equalsIgnoreCase("active"));
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND title LIKE ?");
            params.add("%" + search.trim() + "%");
        }

        if (group != null && !group.equalsIgnoreCase("all")) {
            sql.append(" AND parent_lesson_id = ?");
            params.add(Integer.parseInt(group));
        }

        sql.append(" ORDER BY parent_lesson_id, lesson_order");

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("title"));
                    lesson.setOrderNum(rs.getInt("lesson_order"));
                    lesson.setType(rs.getString("type"));
                    lesson.setStatus(rs.getBoolean("status"));
                    lesson.setSubjectId(rs.getInt("subject_id"));
                    lesson.setParentLessonId(rs.getInt("parent_lesson_id"));
                    list.add(lesson);
                }
            }
        }
        return list;
    }

    public List<Lesson> getUnassignedLessons(int subjectId) throws Exception {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM lessons WHERE subject_id IS NULL OR subject_id != ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Lesson lesson = new Lesson();
                lesson.setId(rs.getInt("id"));
                lesson.setName(rs.getString("title"));
                list.add(lesson);
            }
        }
        return list;
    }

    public void insertLesson(Lesson lesson) throws Exception {
        String sql = "INSERT INTO lessons (title, lesson_order, type, status, subject_id, parent_lesson_id) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lesson.getName());
            ps.setInt(2, lesson.getOrderNum());
            ps.setString(3, lesson.getType());
            ps.setBoolean(4, lesson.isStatus());
            ps.setInt(5, lesson.getSubjectId());
            ps.setInt(6, lesson.getParentLessonId());

            ps.executeUpdate();
        }
    }

}
