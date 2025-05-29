/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author thang
 */
public class DBContext {
   public static Connection getConnection() throws ClassNotFoundException, SQLException {

        String dbURL = "jdbc:mysql://localhost:3306/subject__list";
        String username = "root";
        String password = "123456"; 

        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(dbURL, username, password);
    } 
}
