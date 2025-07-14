package controller;

import DAO.RegistrationDAO;
import DAO.CourseDAO;
import DAO.LessonDAO;
import DAO.LessonProgressDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Registration;
import model.Course;
import model.Lesson;
import model.LessonProgress;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/my-course")
public class MyCourseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect("login");
                return;
            }
            
            // Initialize DAOs
            RegistrationDAO registrationDAO = new RegistrationDAO();
            CourseDAO courseDAO = new CourseDAO();
            LessonDAO lessonDAO = new LessonDAO();
            LessonProgressDAO progressDAO = new LessonProgressDAO();
            
            // Debug: Print user info
            System.out.println("=== MY COURSE DEBUG ===");
            System.out.println("Current User ID: " + currentUser.getId());
            System.out.println("Current User Name: " + currentUser.getFullName());
            
            // Get user's registered courses
            List<Registration> registrations = RegistrationDAO.getRegistrationsByUserId(currentUser.getId());
            System.out.println("Registrations found: " + registrations.size());
            
            // Create a list to hold course information with progress
            List<MyCourseInfo> myCourses = new ArrayList<>();
            
            for (Registration registration : registrations) {
                MyCourseInfo courseInfo = new MyCourseInfo();
                
                // Get course details using course_id
                Course course = courseDAO.getCourseByIdInstance(registration.getCourseId());
                courseInfo.setCourse(course);
                courseInfo.setRegistration(registration);
                
                // Get lessons for this course using course_id
                List<Lesson> lessons = lessonDAO.getLessonsByCourse(registration.getCourseId());
                courseInfo.setLessons(lessons);
                
                // Calculate progress using course_id
                if (!lessons.isEmpty()) {
                    List<LessonProgress> userProgress = progressDAO.getUserProgressForCourse(
                        currentUser.getId(), registration.getCourseId());
                    
                    int completedLessons = 0;
                    for (LessonProgress progress : userProgress) {
                        if (progress.isCompleted()) {
                            completedLessons++;
                        }
                    }
                    
                    int progressPercentage = (lessons.size() > 0) ? 
                        (completedLessons * 100) / lessons.size() : 0;
                    
                    courseInfo.setProgressPercentage(progressPercentage);
                    courseInfo.setCompletedLessons(completedLessons);
                    courseInfo.setTotalLessons(lessons.size());
                    
                    // Find first lesson for "Start Learning" link
                    if (!lessons.isEmpty()) {
                        courseInfo.setFirstLessonId(lessons.get(0).getId());
                    }
                }
                
                myCourses.add(courseInfo);
            }
            
            // Set attributes for JSP
            request.setAttribute("myCourses", myCourses);
            request.setAttribute("currentUser", currentUser);
            
            // Forward to my courses page
            request.getRequestDispatcher("/WEB-INF/views/my_courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error loading my courses: " + e.getMessage());
        }
    }
    
    // Inner class to hold course information with progress
    public static class MyCourseInfo {
        private Course course;
        private Registration registration;
        private List<Lesson> lessons;
        private int progressPercentage;
        private int completedLessons;
        private int totalLessons;
        private int firstLessonId;
        
        // Getters and Setters
        public Course getCourse() { return course; }
        public void setCourse(Course course) { this.course = course; }
        
        public Registration getRegistration() { return registration; }
        public void setRegistration(Registration registration) { this.registration = registration; }
        
        public List<Lesson> getLessons() { return lessons; }
        public void setLessons(List<Lesson> lessons) { this.lessons = lessons; }
        
        public int getProgressPercentage() { return progressPercentage; }
        public void setProgressPercentage(int progressPercentage) { this.progressPercentage = progressPercentage; }
        
        public int getCompletedLessons() { return completedLessons; }
        public void setCompletedLessons(int completedLessons) { this.completedLessons = completedLessons; }
        
        public int getTotalLessons() { return totalLessons; }
        public void setTotalLessons(int totalLessons) { this.totalLessons = totalLessons; }
        
        public int getFirstLessonId() { return firstLessonId; }
        public void setFirstLessonId(int firstLessonId) { this.firstLessonId = firstLessonId; }
    }
} 