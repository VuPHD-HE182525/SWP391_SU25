package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBContext;
import DAO.LessonCommentDAO;
import model.LessonComment;

@WebServlet("/test-comment")
public class TestCommentServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Test Comment Database</title></head>");
        out.println("<body>");
        out.println("<h1>Test Comment Database</h1>");
        
        try {
            // Test 1: Check table schema
            out.println("<h2>1. Table Schema Check</h2>");
            checkTableSchema(out);
            
            // Test 2: Try to insert a simple comment
            out.println("<h2>2. Insert Test Comment</h2>");
            testInsertComment(out);
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body>");
        out.println("</html>");
    }
    
    private void checkTableSchema(PrintWriter out) throws Exception {
        String sql = "DESCRIBE lesson_comments";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            out.println("<table border='1'>");
            out.println("<tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>");
            
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("Field") + "</td>");
                out.println("<td>" + rs.getString("Type") + "</td>");
                out.println("<td>" + rs.getString("Null") + "</td>");
                out.println("<td>" + rs.getString("Key") + "</td>");
                out.println("<td>" + rs.getString("Default") + "</td>");
                out.println("<td>" + rs.getString("Extra") + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
        }
    }
    
    private void testInsertComment(PrintWriter out) throws Exception {
        try {
            // First, find a valid lesson_id
            int validLessonId = getValidLessonId(out);
            if (validLessonId == -1) {
                out.println("<p style='color: orange;'>⚠ No lessons found in database. Cannot test comment insertion.</p>");
                return;
            }

            LessonCommentDAO dao = new LessonCommentDAO();
            LessonComment comment = new LessonComment(1, validLessonId, "Test comment from servlet");

            // Test with null media fields
            comment.setMediaType(null);
            comment.setMediaPath(null);
            comment.setMediaFilename(null);

            dao.addComment(comment);
            out.println("<p style='color: green;'>✓ Comment inserted successfully with null media fields for lesson_id: " + validLessonId + "</p>");

        } catch (Exception e) {
            out.println("<p style='color: red;'>✗ Failed to insert comment: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }

    private int getValidLessonId(PrintWriter out) throws Exception {
        String sql = "SELECT id FROM lessons LIMIT 1";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int lessonId = rs.getInt("id");
                out.println("<p>Found valid lesson_id: " + lessonId + "</p>");
                return lessonId;
            }
        }
        return -1;
    }
}
