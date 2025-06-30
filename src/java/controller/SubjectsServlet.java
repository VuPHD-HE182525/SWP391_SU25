/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;


import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import dao.*;
import java.util.List;

/**
 *
 * @author admin
 */
public class SubjectsServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SubjectsServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubjectsServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String categoryId = request.getParameter("category");
        int page = 1;
        int pageSize = 4;
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null) {
            try {
                int parsedPageSize = Integer.parseInt(pageSizeParam);
                if (parsedPageSize > 0 && parsedPageSize <= 100) {
                    pageSize = parsedPageSize;
                }
            } catch (NumberFormatException e) {
                // Ignore and use default
            }
        }
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        // Debug request parameters
        System.out.println("Request Parameters:");
        System.out.println("Search: " + search);
        System.out.println("Category ID: " + categoryId);
        System.out.println("Page: " + page);
        System.out.println("PageSize: " + pageSize);

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

        System.out.println("\nSubjects Data:");
        System.out.println("Total subjects found: " + totalSubjects);
        System.out.println("Subjects fetched: " + subjects.size());
        for (Subject subject : subjects) {
            if (subject != null) {
                System.out.println("\nSubject Details:");
                System.out.println("ID: " + subject.getId());
                System.out.println("Name: " + subject.getName());
                System.out.println("Tagline: " + subject.getTagline());
                System.out.println("Status: " + subject.getStatus());
                System.out.println("Featured: " + subject.isFeatured());
                System.out.println("Category ID: " + subject.getCategoryId());
                if (subject.getLowestPackage() != null) {
                    System.out.println("Lowest Package Price: " + subject.getLowestPackage().getSalePrice());
                } else {
                    System.out.println("No lowest package found");
                }
            } else {
                System.out.println("Null subject placeholder");
            }
        }

        // Fetch other data
        List<Category> categories = CategoryDAO.getAll();
        List<Contact> contacts = ContactDAO.getAll();

        // Debug other data
        System.out.println("\nOther Data:");
        System.out.println("Categories: " + categories.size());
        for (Category cat : categories) {
            System.out.println("- " + cat.getName());
        }
        System.out.println("Featured subjects: " + featuredSubjects.size());
        System.out.println("Contacts: " + contacts.size());

        // Pad the list to always have 4 subjects
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

        // Debug attributes
        System.out.println("\nRequest Attributes:");
        System.out.println("subjects size: " + ((List<?>)request.getAttribute("subjects")).size());
        System.out.println("categories size: " + ((List<?>)request.getAttribute("categories")).size());
        System.out.println("featuredSubjects size: " + ((List<?>)request.getAttribute("featuredSubjects")).size());
        System.out.println("contacts size: " + ((List<?>)request.getAttribute("contacts")).size());
        System.out.println("totalSubjects: " + request.getAttribute("totalSubjects"));
        System.out.println("page: " + request.getAttribute("page"));
        System.out.println("pageSize: " + request.getAttribute("pageSize"));

        request.getRequestDispatcher("/views/subjects.jsp").forward(request, response);
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
        // Forward to register.jsp
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
