package controller;

import DAO.SubjectDAO;
import DAO.CategoryDAO;
import DAO.DimensionDAO;
import DAO.PricePackageDAO;
import model.Subject;
import model.Category;
import model.Dimension;
import model.PricePackage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.http.Part;

@WebServlet("/subject-details")
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 5 * 1024 * 1024,      // 5 MB
    maxRequestSize = 10 * 1024 * 1024   // 10 MB
)
public class SubjectDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/subjects");
            return;
        }
        
        try {
            int subjectId = Integer.parseInt(idParam);
            
            SubjectDAO subjectDAO = new SubjectDAO();
            DimensionDAO dimensionDAO = new DimensionDAO();
            PricePackageDAO pricePackageDAO = new PricePackageDAO();

            Subject subject = subjectDAO.getSubjectById(subjectId);
            if (subject == null) {
                request.setAttribute("error", "Subject not found");
                response.sendRedirect(request.getContextPath() + "/subjects");
                return;
            }
            
            // Get dimensions and price packages (showing up to 6)
            List<Dimension> dimensions = dimensionDAO.getDimensions(6);
            List<PricePackage> pricePackages = pricePackageDAO.getPricePackages(6);

            // Get categories from database instead of hardcoded list
            List<Category> categoryList = CategoryDAO.getAll();
            List<String> categories = new java.util.ArrayList<>();
            for (Category cat : categoryList) {
                categories.add(cat.getName());
            }
            
            // Add default categories if database is empty
            if (categories.isEmpty()) {
                categories.add("Communication Skills");
                categories.add("Collaboration");
                categories.add("Leadership");
                categories.add("Time Management");
                categories.add("Problem-Solving");
                categories.add("Critical Thinking");
            }

            request.setAttribute("subject", subject);
            request.setAttribute("dimensions", dimensions);
            request.setAttribute("pricePackages", pricePackages);
            request.setAttribute("categories", categories);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid subject ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/subjects");
            return;
        } catch (Exception e) {
            System.err.println("Error in SubjectDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error loading subject details", e);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/SubjectDetails.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idParam = request.getParameter("id");
        String action = request.getParameter("action");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/subjects");
            return;
        }
        
        try {
            int subjectId = Integer.parseInt(idParam);
            
            if (action != null) {
                if (action.equals("addDimension")) {
                    DimensionDAO dimensionDAO = new DimensionDAO();
                    Dimension d = new Dimension();
                    d.setSubjectId(subjectId);
                    d.setType(request.getParameter("type"));
                    d.setName(request.getParameter("name"));
                    dimensionDAO.addDimension(d);
                } else if (action.equals("editDimension")) {
                    DimensionDAO dimensionDAO = new DimensionDAO();
                    Dimension d = new Dimension();
                    d.setId(Integer.parseInt(request.getParameter("dimensionId")));
                    d.setType(request.getParameter("type"));
                    d.setName(request.getParameter("name"));
                    dimensionDAO.updateDimension(d);
                } else if (action.equals("deleteDimension")) {
                    DimensionDAO dimensionDAO = new DimensionDAO();
                    int dimensionId = Integer.parseInt(request.getParameter("dimensionId"));
                    dimensionDAO.deleteDimension(dimensionId);
                } else if (action.equals("addPrice") || action.equals("editPrice") || action.equals("deletePrice")) {
                    handlePricePackageActions(request, subjectId, action);
                } else {
                    // Fallback to subject update (overview form)
                    updateSubject(request, subjectId);
                }
            } else {
                // Fallback to subject update (overview form)
                updateSubject(request, subjectId);
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid subject ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/subjects");
            return;
        } catch (Exception e) {
            System.err.println("Error in SubjectDetailsServlet POST: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error updating subject", e);
        }
        
        response.sendRedirect(request.getContextPath() + "/subject-details?id=" + idParam);
    }

    private void handlePricePackageActions(HttpServletRequest request, int subjectId, String action) throws Exception {
        PricePackageDAO pricePackageDAO = new PricePackageDAO();
        if (action.equals("addPrice")) {
            PricePackage p = new PricePackage();
            p.setSubjectId(subjectId);
            p.setName(request.getParameter("name"));
            p.setDuration(Integer.parseInt(request.getParameter("duration")));
            p.setListPrice(Double.parseDouble(request.getParameter("listPrice")));
            p.setSalePrice(Double.parseDouble(request.getParameter("salePrice")));
            p.setStatus(request.getParameter("status"));
            pricePackageDAO.addPricePackage(p);
        } else if (action.equals("editPrice")) {
            PricePackage p = new PricePackage();
            p.setId(Integer.parseInt(request.getParameter("priceId")));
            p.setName(request.getParameter("name"));
            p.setDuration(Integer.parseInt(request.getParameter("duration")));
            p.setListPrice(Double.parseDouble(request.getParameter("listPrice")));
            p.setSalePrice(Double.parseDouble(request.getParameter("salePrice")));
            p.setStatus(request.getParameter("status"));
            pricePackageDAO.updatePricePackage(p);
        } else if (action.equals("deletePrice")) {
            int priceId = Integer.parseInt(request.getParameter("priceId"));
            pricePackageDAO.deletePricePackage(priceId);
        }
    }

    private void updateSubject(HttpServletRequest request, int subjectId) throws ServletException, IOException {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        boolean featured = request.getParameter("featured") != null;

        String thumbnailUrl = null;
        try {
            Part filePart = request.getPart("thumbnail");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = "avatar_" + subjectId + "_" + System.currentTimeMillis() + ".png";
                String uploadPath = request.getServletContext().getRealPath("/uploads/images/");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + java.io.File.separator + fileName);
                thumbnailUrl = "uploads/images/" + fileName;
            } else {
                SubjectDAO subjectDAO = new SubjectDAO();
                Subject oldSubject = subjectDAO.getSubjectById(subjectId);
                thumbnailUrl = oldSubject.getThumbnailUrl();
            }
            Subject subject = new Subject();
            subject.setId(subjectId);
            subject.setName(name);
            subject.setCategory(category);
            subject.setStatus(status);
            subject.setDescription(description);
            subject.setFeatured(featured);
            subject.setThumbnailUrl(thumbnailUrl);
            SubjectDAO subjectDAO = new SubjectDAO();
            subjectDAO.updateSubject(subject);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
} 