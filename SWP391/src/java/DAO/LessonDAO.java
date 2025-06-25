package DAO;

import model.Lesson;
import utils.DBContext;
import java.sql.*;
import java.util.*;

public class LessonDAO {
    public List<Lesson> getLessonsBySubjectId(int subjectId) throws Exception {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM lessons WHERE subject_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Lesson l = new Lesson();
                l.setId(rs.getInt("id"));
                l.setSubjectId(rs.getInt("subject_id"));
                l.setTitle(rs.getString("title"));
                l.setVideoUrl(rs.getString("video_url"));
                l.setDuration(rs.getDouble("duration"));
                list.add(l);
            }
        }
        return list;
    }

    public Lesson getLessonById(int id) throws Exception {
        String sql = "SELECT * FROM lessons WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Lesson(
                    rs.getInt("id"),
                    rs.getInt("subject_id"),
                    rs.getString("title"),
                    rs.getString("video_url"),
                    rs.getDouble("duration")
                );
            }
        }
        return null;
    }

    public void addLesson(Lesson lesson) throws Exception {
        String sql = "INSERT INTO lessons (subject_id, title, video_url, duration) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lesson.getSubjectId());
            ps.setString(2, lesson.getTitle());
            ps.setString(3, lesson.getVideoUrl());
            ps.setDouble(4, lesson.getDuration());
            ps.executeUpdate();
        }
    }
} 