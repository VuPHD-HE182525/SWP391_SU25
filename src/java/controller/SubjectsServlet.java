/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import DAO.*;
import java.util.List;

/**
 *
 * @author admin
 */
@WebServlet("/subjects")
public class SubjectsServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String categoryId = request.getParameter("category");
        int page = 1;
        int pageSize = 4;
        
        // Parse page size parameter
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null) {
            try {
                int parsedPageSize = Integer.parseInt(pageSizeParam);
                if (parsedPageSize > 0 && parsedPageSize <= 100) {
                    pageSize = parsedPageSize;
                }
            } catch (NumberFormatException e) {
                // Use default pageSize
            }
        }
        
        // Parse page parameter
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        try {
            // Fetch subjects with pagination and search
            List<Subject> subjects = SubjectDAO.getSubjectsForMainContent(search, categoryId, page, pageSize);
            int totalSubjects = SubjectDAO.getTotalSubjects(search, categoryId);
            
            // Fetch all subjects to determine featured subjects
            List<Subject> allSubjects = SubjectDAO.getSubjectsForMainContent(null, null, 1, Integer.MAX_VALUE);
            List<Subject> featuredSubjects = SubjectDAO.getFeatured(allSubjects);

            // Create JSON string of all subjects for JavaScript search
            StringBuilder subjectsJson = new StringBuilder("[");
            for (int i = 0; i < subjects.size(); i++) {
                Subject subject = subjects.get(i);
                if (subject != null) {
                    if (i > 0) subjectsJson.append(",");
                    subjectsJson.append("{")
                        .append("\"id\":").append(subject.getId())
                        .append(",\"name\":\"")
                        .append(subject.getName()
                            .replace("\\", "\\\\")
                            .replace("\"", "\\\"")
                            .replace("\n", "\\n")
                            .replace("\r", "\\r")
                            .replace("\t", "\\t"))
                        .append("\"}");
                }
            }
            subjectsJson.append("]");

            // Fetch other data
            List<Category> categories = CategoryDAO.getAll();
            List<Contact> contacts = ContactDAO.getAll();

            // Pad the list to always have pageSize subjects (for consistent UI)
            while (subjects.size() < pageSize) {
                subjects.add(null);
            }

            // Set attributes
            request.setAttribute("subjects", subjects);
            request.setAttribute("categories", categories);
            request.setAttribute("featuredSubjects", featuredSubjects);
            request.setAttribute("contacts", contacts);
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("subjectsJson", subjectsJson.toString());
            request.setAttribute("searchTerm", search);
            request.setAttribute("selectedCategory", categoryId);

            request.getRequestDispatcher("/WEB-INF/views/subjects.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in SubjectsServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Set error message and forward to error page
            request.setAttribute("error", "An error occurred while loading subjects. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/subjects.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to register.jsp for subject registration
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Subjects Servlet - Handles subject listing with search, filtering and pagination";
    }
} 

