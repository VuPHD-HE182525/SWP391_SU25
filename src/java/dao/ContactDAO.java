package dao;

import model.Contact;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {
    
    public static List<Contact> getAll() {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts ORDER BY type";
        
        try {
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Contact contact = new Contact();
                    contact.setId(rs.getInt("id"));
                    contact.setType(rs.getString("type"));
                    contact.setValue(rs.getString("value"));
                    contacts.add(contact);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return contacts;
    }

    public static Contact getContactById(int id) {
        Contact contact = null;
        String sql = "SELECT * FROM contacts WHERE id = ? LIMIT 1";
        
        try {
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        contact = new Contact();
                        contact.setId(rs.getInt("id"));
                        contact.setType(rs.getString("type"));
                        contact.setValue(rs.getString("value"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return contact;
    }
} 