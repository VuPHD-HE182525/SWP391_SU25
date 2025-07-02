/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Slider;
import utils.DBContext;

/**
 *
 * @author Kaonashi
 */
public class SliderDAO {
    public List<Slider> getAllSliders() throws Exception {
        List<Slider> sliders = new ArrayList<>();
        // Try with fallback if display_order column doesn't exist
        String sql = "SELECT id, title, image_url, link_url FROM sliders ORDER BY id";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("Executing getAllSliders query: " + sql);
            while (rs.next()) {
                Slider s = new Slider();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setImageUrl(rs.getString("image_url"));
                s.setLinkUrl(rs.getString("link_url"));
                sliders.add(s);
                System.out.println("Found slider: " + s.getTitle());
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllSliders: " + e.getMessage());
            e.printStackTrace();
            
            // If the query fails, try alternative column names
            try (Connection conn = DBContext.getConnection()) {
                sql = "SELECT id, title, imageUrl as image_url, linkUrl as link_url FROM sliders ORDER BY id";
                System.out.println("Trying alternative query: " + sql);
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    
                    while (rs.next()) {
                        Slider s = new Slider();
                        s.setId(rs.getInt("id"));
                        s.setTitle(rs.getString("title"));
                        s.setImageUrl(rs.getString("image_url"));
                        s.setLinkUrl(rs.getString("link_url"));
                        sliders.add(s);
                        System.out.println("Found slider (alt): " + s.getTitle());
                    }
                }
            } catch (SQLException e2) {
                System.err.println("Alternative query also failed: " + e2.getMessage());
            }
        }
        return sliders;
    }
}
