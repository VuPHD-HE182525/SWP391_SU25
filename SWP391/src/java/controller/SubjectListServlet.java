package controller;

import DAO.SubjectDAO;
import DAO.CategoryDAO;
import DAO.LessonDAO;
import model.Subject;
import model.Category;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/subject_list")
public class SubjectListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String categoryId = request.getParameter("category");
        String status = request.getParameter("status");
        int page = 1;
        int pageSize = 5;
        if (request.getParameter("page") != null) {
            try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) { page = 1; }
        }
        // Lấy danh sách category
        List<Category> categories = CategoryDAO.getAll();
        // Lấy danh sách subject (có thể cần chỉnh lại DAO cho filter/search)
        List<Subject> allSubjects = new ArrayList<>();
        try {
            allSubjects = SubjectDAO.getSubjectsWithDetails(search, categoryId, status);
            System.out.println("DEBUG: search = " + search);
            System.out.println("DEBUG: categoryId = " + categoryId);
            System.out.println("DEBUG: status = " + status);
            System.out.println("DEBUG: allSubjects.size() = " + allSubjects.size());
            System.out.println("DEBUG: page = " + page + ", pageSize = " + pageSize);
        } catch (Exception e) {
            e.printStackTrace();
        }
        int totalSubjects = allSubjects.size();
        int totalPages = (int) Math.ceil((double) totalSubjects / pageSize);
        int start = (page-1)*pageSize;
        int end = Math.min(start+pageSize, totalSubjects);
        List<Subject> subjects = new ArrayList<>();
        if (start < end) subjects = allSubjects.subList(start, end);
        System.out.println("DEBUG: subjects.size() = " + subjects.size());
        request.setAttribute("categories", categories);
        request.setAttribute("subjects", subjects);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("param", request.getParameterMap());
        request.getRequestDispatcher("/WEB-INF/views/subject_list.jsp").forward(request, response);
    }
} 