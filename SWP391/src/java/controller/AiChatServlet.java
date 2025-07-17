package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.GeminiService;
import utils.AppConfig;
import model.User;
import model.VideoTranscript;
import DAO.VideoTranscriptDAO;
import java.io.IOException;

@WebServlet("/ai-chat")
public class AiChatServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.getWriter().write("{\"error\": \"Please login to use AI Assistant\"}");
                return;
            }
            
            // Get request parameters
            String userMessage = request.getParameter("message");
            String lessonId = request.getParameter("lessonId");
            String lessonName = request.getParameter("lessonName");
            
            if (userMessage == null || userMessage.trim().isEmpty()) {
                response.getWriter().write("{\"error\": \"Message cannot be empty\"}");
                return;
            }
            
            // Check if AI is configured
            if (!AppConfig.isConfigured()) {
                response.getWriter().write("{\"error\": \"AI Assistant is not configured. Please check configuration.\"}");
                return;
            }
            
            // Build context from lesson information
            String context = buildLessonContext(lessonId, lessonName);
            
            // Get AI response
            String aiResponse;
            if (context != null && !context.isEmpty()) {
                aiResponse = GeminiService.chatWithContext(userMessage, context);
            } else {
                aiResponse = GeminiService.simpleChat(userMessage);
            }
            
            // Clean and format response
            aiResponse = cleanAiResponse(aiResponse);
            
            // Return JSON response
            response.getWriter().write("{\"response\": \"" + escapeJson(aiResponse) + "\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"Sorry, I encountered an error. Please try again.\"}");
        }
    }
    
    /**
     * Build context information for the lesson using video transcript if available
     */
    private String buildLessonContext(String lessonId, String lessonName) {
        StringBuilder context = new StringBuilder();
        
        try {
            // Try to get video transcript for more accurate context
            if (lessonId != null && !lessonId.trim().isEmpty()) {
                VideoTranscriptDAO transcriptDAO = new VideoTranscriptDAO();
                VideoTranscript transcript = transcriptDAO.getTranscriptByLessonId(Integer.parseInt(lessonId));
                
                if (transcript != null && transcript.isCompleted()) {
                    // Use actual video transcript for context
                    context.append("LESSON: ").append(lessonName != null ? lessonName : "Current Lesson").append("\\n\\n");
                    
                    if (transcript.getSummary() != null) {
                        context.append("LESSON SUMMARY:\\n").append(transcript.getSummary()).append("\\n\\n");
                    }
                    
                    if (transcript.getKeyTopics() != null) {
                        context.append("KEY TOPICS:\\n").append(transcript.getKeyTopics()).append("\\n\\n");
                    }
                    
                    if (transcript.getLearningObjectives() != null) {
                        context.append("LEARNING OBJECTIVES:\\n").append(transcript.getLearningObjectives()).append("\\n\\n");
                    }
                    
                    if (transcript.getTranscript() != null) {
                        // Include transcript but limit length to avoid token limits
                        String fullTranscript = transcript.getTranscript();
                        if (fullTranscript.length() > 1500) {
                            fullTranscript = fullTranscript.substring(0, 1500) + "...";
                        }
                        context.append("VIDEO TRANSCRIPT:\\n").append(fullTranscript).append("\\n\\n");
                    }
                    
                    context.append("Please answer questions based on this lesson content. ");
                    context.append("Provide specific, accurate information from the video transcript. ");
                    context.append("If asked about topics not covered in this lesson, politely redirect to the actual lesson content.");
                    
                    return context.toString();
                }
            }
        } catch (Exception e) {
            System.err.println("Error loading video transcript: " + e.getMessage());
            // Fall back to basic context
        }
        
        // Fallback to basic context if no transcript available
        if (lessonName != null && !lessonName.trim().isEmpty()) {
            context.append("Current lesson: ").append(lessonName).append("\\n");
        }
        
        // Add basic context based on lesson content
        if (lessonName != null) {
            if (lessonName.toLowerCase().contains("java")) {
                context.append("This is a Java programming lesson. ");
                context.append("Topics may include variables, data types, methods, classes, and object-oriented programming concepts.\\n");
            } else if (lessonName.toLowerCase().contains("ai") || lessonName.toLowerCase().contains("artificial intelligence")) {
                context.append("This is an Artificial Intelligence lesson. ");
                context.append("Topics may include machine learning, neural networks, algorithms, and AI applications.\\n");
            } else if (lessonName.toLowerCase().contains("soft skills")) {
                context.append("This is a soft skills development lesson. ");
                context.append("Topics may include communication, teamwork, leadership, and professional development.\\n");
            }
        }
        
        context.append("Please provide helpful, accurate answers related to the lesson content. ");
        context.append("If the question is not related to the current lesson, politely guide the student back to course-related topics.");
        
        return context.toString();
    }
    
    /**
     * Clean and format AI response
     */
    private String cleanAiResponse(String response) {
        if (response == null) return "Sorry, I couldn't generate a response.";
        
        // Remove any unwanted characters or formatting
        response = response.trim();
        
        // Limit response length to reasonable size
        if (response.length() > 2000) {
            response = response.substring(0, 1997) + "...";
        }
        
        return response;
    }
    
    /**
     * Escape JSON special characters
     */
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h1>AI Chat Service</h1>");
        response.getWriter().println("<p>This service handles AI chat requests via POST method.</p>");
        
        // Show configuration status
        if (AppConfig.isConfigured()) {
            response.getWriter().println("<p style='color: green;'>✅ AI Assistant is configured and ready.</p>");
        } else {
            response.getWriter().println("<p style='color: red;'>❌ AI Assistant is not configured.</p>");
        }
        
        response.getWriter().println("<p><a href='lesson-view?lessonId=10'>← Back to Lesson</a></p>");
        response.getWriter().println("</body></html>");
    }
} 