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
        String sql = "SELECT id, title, image_url, link_url FROM sliders ORDER BY display_order";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Slider s = new Slider();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setImageUrl(rs.getString("image_url"));
                s.setLinkUrl(rs.getString("link_url"));
                sliders.add(s);
            }
        }
        return sliders;
    }
}
