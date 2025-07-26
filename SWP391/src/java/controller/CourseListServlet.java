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
 * Course List Servlet - Handles course/subject listing with search, filtering, and pagination
 *
 * This servlet manages the comprehensive course listing page with advanced features
 * including search functionality, category filtering, pagination, and package information.
 * It provides a complete course browsing experience with sidebar content and featured courses.
 *
 * Key Features:
 * - Paginated course/subject listing (4 items per page by default)
 * - Search functionality by course name
 * - Category-based filtering
 * - Package information loading with lowest price calculation
 * - Featured subjects display in sidebar
 * - JSON data generation for client-side search
 * - Responsive pagination with customizable page size
 * - Error handling with graceful fallbacks
 * - Sidebar content (categories, contacts, featured subjects)
 *
 * URL Mapping: /course_list
 * Methods: GET (main functionality), POST (delegates to GET)
 *
 * Request Parameters:
 * - search: Search term for filtering courses by name
 * - category: Category ID for filtering courses by category
 * - page: Current page number for pagination (default: 1)
 * - pageSize: Number of items per page (default: 4, max: 100)
 *
 * @author SWP391 Team
 */
@WebServlet("/course_list")
public class CourseListServlet extends HttpServlet {

    /**
     * Handles GET requests for course list display
     *
     * Processing Flow:
     * 1. Extract and validate request parameters (search, category, page, pageSize)
     * 2. Apply search and category filters to subject list
     * 3. Load package information for each subject with price calculation
     * 4. Apply pagination to filtered results
     * 5. Load sidebar content (featured subjects, categories, contacts)
     * 6. Generate JSON data for client-side functionality
     * 7. Set request attributes for JSP rendering
     * 8. Forward to course list JSP view
     *
     * @param request HTTP request with optional search, category, page, and pageSize parameters
     * @param response HTTP response for course list page
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Debug logging for troubleshooting
        System.out.println("=== CourseListServlet Debug ===");

        // Step 1: Extract request parameters for filtering and pagination
        String search = request.getParameter("search");           // Search term for course name filtering
        String categoryId = request.getParameter("category");     // Category ID for category filtering
        int page = 1;                                            // Current page number (default: 1)
        int pageSize = 4;                                        // Items per page (default: 4)

        // Debug logging for parameter values
        System.out.println("Search: " + search);
        System.out.println("Category: " + categoryId);

        // Step 2: Parse and validate page size parameter
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null) {
            try {
                int parsedPageSize = Integer.parseInt(pageSizeParam);
                // Validate page size is within reasonable bounds
                if (parsedPageSize > 0 && parsedPageSize <= 100) {
                    pageSize = parsedPageSize;
                }
            } catch (NumberFormatException e) {
                // Use default pageSize if parsing fails
            }
        }

        // Step 3: Parse and validate page number parameter
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                // Ensure page number is at least 1
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                // Use default page 1 if parsing fails
                page = 1;
            }
        }

        try {
            // Step 4: Load subjects from database with filtering
            System.out.println("Loading subjects...");

            SubjectDAO subjectDAO = new SubjectDAO();
            List<Subject> allSubjects;

            // Step 5: Apply search and category filters
            if ((search != null && !search.trim().isEmpty()) || (categoryId != null && !categoryId.trim().isEmpty())) {
                // Load subjects with applied filters
                System.out.println("Applying filters - Search: " + search + ", Category: " + categoryId);
                allSubjects = subjectDAO.getSubjectsWithFilters(search, categoryId);
            } else {
                // Load all subjects without filters
                allSubjects = subjectDAO.getAllSubjects();
            }
            System.out.println("Filtered subjects count: " + allSubjects.size());

            // Step 6: Load package information for each subject
            System.out.println("Loading packages for subjects...");
            for (Subject subject : allSubjects) {
                try {
                    // Retrieve packages associated with this subject
                    List<Package> packages = PackageDAO.getPackagesBySubjectId(subject.getId());
                    if (packages != null) {
                        subject.setPackages(packages);

                        // Step 7: Find the lowest price package for display
                        Package lowestPackage = null;
                        for (Package pkg : packages) {
                            if (pkg != null && (lowestPackage == null || pkg.getSalePrice() < lowestPackage.getSalePrice())) {
                                lowestPackage = pkg;
                            }
                        }
                        if (lowestPackage != null) {
                            subject.setLowestPackage(lowestPackage);
                        }

                        // Debug logging for package information
                        System.out.println("Subject: " + subject.getName() +
                                         " - Packages: " + packages.size() +
                                         " - Lowest price: " + (lowestPackage != null ? lowestPackage.getSalePrice() : "N/A"));
                    } else {
                        // Handle case where no packages are found
                        System.out.println("No packages found for subject: " + subject.getName());
                        subject.setPackages(new ArrayList<>());
                    }
                } catch (Exception e) {
                    // Handle package loading errors gracefully
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
            request.getRequestDispatcher("/WEB-INF/views/course_list.jsp").forward(request, response);

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
            
            request.getRequestDispatcher("/WEB-INF/views/course_list.jsp").forward(request, response);
        }
    }

    /**
     * Handles POST requests by delegating to GET method
     *
     * This method simply delegates POST requests to the doGet method since
     * the course list functionality doesn't require different handling for POST requests.
     * This allows forms to submit to the same servlet using either GET or POST methods.
     *
     * @param request HTTP request (delegated to doGet)
     * @param response HTTP response (delegated to doGet)
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Delegate POST requests to GET method for consistent handling
        doGet(request, response);
    }

    /**
     * Returns servlet description for administrative purposes
     *
     * @return String description of the servlet's functionality
     */
    @Override
    public String getServletInfo() {
        return "Course List Servlet - Handles course/subject listing with search, filtering, and pagination";
    }
} 

