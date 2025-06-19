package dao;

import model.Contact;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {
    
    public static List<Contact> getAll() {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts_2 ORDER BY type";
        
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Contact contact = new Contact();
                contact.setId(rs.getInt("id"));
                contact.setType(rs.getString("type"));
                contact.setValue(rs.getString("value"));
                contacts.add(contact);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
} 