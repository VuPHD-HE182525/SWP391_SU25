package controller;

import DAO.SubjectDAO;
import model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/subject_crud")
public class SubjectCrudServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String categoryId = request.getParameter("categoryId");
        String ownerName = request.getParameter("ownerName");
        String status = request.getParameter("status");
        String action = request.getParameter("action");
        try {
            if (action.equals("delete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                try {
                    SubjectDAO.softDeleteSubject(id);
                    response.setStatus(200);
                    response.getWriter().write("OK");
                } catch (Exception e) {
                    response.setStatus(500);
                    response.getWriter().write("Error: " + e.getMessage());
                }
                return;
            } else if (idParam == null || idParam.trim().isEmpty()) {
                // Add new subject
                SubjectDAO.insertSubject(name, categoryId, ownerName, status);
            } else {
                // Edit subject
                int id = Integer.parseInt(idParam);
                SubjectDAO.updateSubject(id, name, categoryId, ownerName, status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("subject_list");
    }
} 