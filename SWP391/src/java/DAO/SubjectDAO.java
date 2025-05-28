/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Subject;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Kaonashi
 */
public class SubjectDAO {
        public List<Subject> getFeaturedSubjects() throws Exception {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT id, name, description, created_at, thumbnail_url " +
                     "FROM subjects ORDER BY created_at DESC LIMIT 5";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Subject s = new Subject();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                s.setThumbnailUrl(rs.getString("thumbnail_url"));
                list.add(s);
            }
        }
        return list;
    }
}
