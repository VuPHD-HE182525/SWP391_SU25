package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Lesson;
import utils.DBContext;

public class LessonDAO {

    public List<Lesson> getLessonsBySubject(int subjectId) throws Exception {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM lessons WHERE course_id = ? ORDER BY parent_lesson_id, lesson_order";

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
                    lesson.setSubjectId(rs.getInt("course_id")); // Use course_id from database
                    lesson.setParentLessonId(rs.getInt("parent_lesson_id"));
                    lesson.setVideoLink(rs.getString("video_url"));
                    
                    // Load hybrid content fields (file paths)
                    lesson.setContentFilePath(rs.getString("content_file_path"));
                    lesson.setObjectivesFilePath(rs.getString("objectives_file_path"));
                    lesson.setReferencesFilePath(rs.getString("references_file_path"));
                    lesson.setContentType(rs.getString("content_type"));
                    lesson.setEstimatedTime(rs.getInt("estimated_time"));
                    
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
                    lesson.setSubjectId(rs.getInt("course_id")); // Use course_id from database
                    lesson.setParentLessonId(rs.getInt("parent_lesson_id"));
                    lesson.setVideoLink(rs.getString("video_url")); // Use video_url from database
                    
                    // Load hybrid content fields (file paths)
                    lesson.setContentFilePath(rs.getString("content_file_path"));
                    lesson.setObjectivesFilePath(rs.getString("objectives_file_path"));
                    lesson.setReferencesFilePath(rs.getString("references_file_path"));
                    lesson.setContentType(rs.getString("content_type"));
                    lesson.setEstimatedTime(rs.getInt("estimated_time"));

                    return lesson;
                }
            }
        }
        return null;
    }

    public void updateLesson(Lesson lesson) throws Exception {
        String sql = "UPDATE lessons SET title = ?, lesson_order = ?, type = ?, status = ?, parent_lesson_id = ?, video_url = ? WHERE id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, lesson.getName());
            ps.setInt(2, lesson.getOrderNum());
            ps.setString(3, lesson.getType());
            ps.setBoolean(4, lesson.isStatus());
            ps.setInt(5, lesson.getParentLessonId());
            ps.setString(6, lesson.getVideoLink());

            ps.setInt(7, lesson.getId());
            ps.executeUpdate();
        }

    }

    public List<Lesson> getLessonsBySubjectWithFilters(int subjectId, String status, String search, String group) throws Exception {
        List<Lesson> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM lessons WHERE course_id = ?");
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
                    lesson.setSubjectId(rs.getInt("course_id")); // Use course_id from database
                    lesson.setParentLessonId(rs.getInt("parent_lesson_id"));
                    list.add(lesson);
                }
            }
        }
        return list;
    }

    public List<Lesson> getUnassignedLessons(int subjectId) throws Exception {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM lessons WHERE course_id IS NULL OR course_id != ?";

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
        String sql = "INSERT INTO lessons (title, lesson_order, type, status, course_id, parent_lesson_id) VALUES (?, ?, ?, ?, ?, ?)";

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

    // New methods to support course_id structure
    public List<Lesson> getLessonsByCourse(int courseId) throws Exception {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM lessons WHERE course_id = ? ORDER BY parent_lesson_id, lesson_order";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("title"));
                    lesson.setOrderNum(rs.getInt("lesson_order"));
                    lesson.setType(rs.getString("type"));
                    lesson.setStatus(rs.getBoolean("status"));
                    lesson.setSubjectId(rs.getInt("course_id")); // Note: using subjectId field for course_id
                    lesson.setParentLessonId(rs.getInt("parent_lesson_id"));
                    lesson.setVideoLink(rs.getString("video_url"));
                    
                    list.add(lesson);
                }
            }
        }
        return list;
    }
    
    public Lesson getLessonByIdWithCourse(int lessonId) throws Exception {
        String sql = "SELECT * FROM lessons WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setId(rs.getInt("id"));
                    lesson.setName(rs.getString("title"));
                    lesson.setOrderNum(rs.getInt("lesson_order"));
                    lesson.setType(rs.getString("type"));
                    lesson.setStatus(rs.getBoolean("status"));
                    lesson.setSubjectId(rs.getInt("course_id")); // Use course_id from database
                    lesson.setParentLessonId(rs.getInt("parent_lesson_id"));
                    lesson.setVideoLink(rs.getString("video_url")); // Use video_url from database

                    return lesson;
                }
            }
        }
        return null;
    }

}
