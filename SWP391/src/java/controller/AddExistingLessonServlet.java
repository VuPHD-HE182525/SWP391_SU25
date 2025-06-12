/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.LessonDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBContext;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author Kaonashi
 */
@WebServlet("/addExistingLesson")
public class AddExistingLessonServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));

            String sql = "UPDATE lessons SET subject_id = ? WHERE id = ?";
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, subjectId);
                ps.setInt(2, lessonId);
                ps.executeUpdate();
            } catch (Exception ex) {
                System.getLogger(AddExistingLessonServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            }

            response.sendRedirect("lesson?subjectId=" + subjectId);
        } catch (IOException | NumberFormatException  e) {
            response.getWriter().println("Lỗi khi thêm lesson: " + e.getMessage());
        }
    }
}