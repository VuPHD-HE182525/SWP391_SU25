/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author thang
 */
import dao.CategoryDAO;
import dao.SubjectDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Subject;

@WebServlet(name = "SubjectListServlet", urlPatterns = {"/subject-list"})
public class SubjectListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 4; // Số lượng subject mỗi trang

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Lấy các tham số filter và search từ request
        String categoryId = request.getParameter("category");
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String pageStr = request.getParameter("page");
        
        int page = 1;
        if(pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                // Xử lý nếu page không phải là số
                page = 1;
            }
        }

        SubjectDAO subjectDAO = new SubjectDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Lấy tổng số subject thỏa mãn điều kiện
        int totalSubjects = subjectDAO.getTotalSubjects(categoryId, status, search);
        int totalPages = (int) Math.ceil((double) totalSubjects / PAGE_SIZE);

        // Lấy danh sách subject cho trang hiện tại
        List<Subject> subjectList = subjectDAO.getSubjects(categoryId, status, search, page, PAGE_SIZE);
        
        // Lấy danh sách tất cả category để hiển thị trên filter
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        // Đặt các thuộc tính vào request để JSP có thể truy cập
        request.setAttribute("subjects", subjectList);
        request.setAttribute("categories", categoryList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        
        // Lưu lại các giá trị filter/search để hiển thị lại trên form
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("searchValue", search);

        request.getRequestDispatcher("subjectList.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
