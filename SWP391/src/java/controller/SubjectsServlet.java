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
import model.Subject;
import model.Package;
import model.Category;
import model.Contact;
import DAO.SubjectDAO;
import DAO.PackageDAO;
import DAO.CategoryDAO;
import DAO.ContactDAO;
import java.util.List;
import java.util.ArrayList;

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
        
        System.out.println("=== SubjectsServlet Debug ===");
        
        String search = request.getParameter("search");
        String categoryId = request.getParameter("category");
        int page = 1;
        int pageSize = 4;
        
        System.out.println("Search: " + search);
        System.out.println("Category: " + categoryId);
        
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
            System.out.println("Loading subjects...");
            
            // Use simpler method first
            SubjectDAO subjectDAO = new SubjectDAO();
            List<Subject> allSubjects = subjectDAO.getAllSubjects();
            System.out.println("All subjects count: " + allSubjects.size());
            
            // Load packages for each subject
            System.out.println("Loading packages for subjects...");
            for (Subject subject : allSubjects) {
                try {
                    List<Package> packages = PackageDAO.getPackagesBySubjectId(subject.getId());
                    if (packages != null) {
                        subject.setPackages(packages);
                        
                        // Find the lowest price package
                        Package lowestPackage = null;
                        for (Package pkg : packages) {
                            if (pkg != null && (lowestPackage == null || pkg.getSalePrice() < lowestPackage.getSalePrice())) {
                                lowestPackage = pkg;
                            }
                        }
                        if (lowestPackage != null) {
                            subject.setLowestPackage(lowestPackage);
                        }
                        
                        System.out.println("Subject: " + subject.getName() + 
                                         " - Packages: " + packages.size() + 
                                         " - Lowest price: " + (lowestPackage != null ? lowestPackage.getSalePrice() : "N/A"));
                    } else {
                        System.out.println("No packages found for subject: " + subject.getName());
                        subject.setPackages(new ArrayList<>());
                    }
                } catch (Exception e) {
                    System.out.println("Failed to load packages for subject " + subject.getId() + ": " + e.getMessage());
                    e.printStackTrace();
                    subject.setPackages(new ArrayList<>());
                }
            }
            
            // Apply pagination manually
            List<Subject> subjects = new ArrayList<>();
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, allSubjects.size());
            
            for (int i = startIndex; i < endIndex; i++) {
                subjects.add(allSubjects.get(i));
            }
            
            System.out.println("Paginated subjects count: " + subjects.size());
            
            int totalSubjects = allSubjects.size();
            
            // Get featured subjects using instance method
            List<Subject> featuredSubjects = subjectDAO.getFeaturedSubjects();
            System.out.println("Featured subjects count: " + featuredSubjects.size());

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

            // Try to fetch other data, with fallbacks
            List<Category> categories = new ArrayList<>();
            List<Contact> contacts = new ArrayList<>();
            
            try {
                categories = CategoryDAO.getAll();
                System.out.println("Categories count: " + categories.size());
            } catch (Exception e) {
                System.out.println("Failed to load categories: " + e.getMessage());
            }
            
            try {
                contacts = ContactDAO.getAll();
                System.out.println("Contacts count: " + contacts.size());
            } catch (Exception e) {
                System.out.println("Failed to load contacts: " + e.getMessage());
            }

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

            System.out.println("=== Forwarding to subjects.jsp ===");
            request.getRequestDispatcher("/WEB-INF/views/subjects.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in SubjectsServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Set empty data to prevent JSP errors
            request.setAttribute("subjects", new ArrayList<>());
            request.setAttribute("categories", new ArrayList<>());
            request.setAttribute("featuredSubjects", new ArrayList<>());
            request.setAttribute("contacts", new ArrayList<>());
            request.setAttribute("totalSubjects", 0);
            request.setAttribute("page", 1);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("subjectsJson", "[]");
            request.setAttribute("error", "Error loading subjects: " + e.getMessage());
            
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
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Subjects listing servlet";
    }
} 

