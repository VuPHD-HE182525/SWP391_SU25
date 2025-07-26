package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.GeminiService;
import utils.AppConfig;
import utils.AiContextBuilder;
import utils.ConversationMemory;
import model.User;
import model.VideoTranscript;
import DAO.VideoTranscriptDAO;
import java.io.IOException;

/**
 * AI Chat Servlet - Handles AI-powered chat functionality for educational assistance
 *
 * This servlet provides an intelligent chat interface that helps students with lesson-related questions.
 * It integrates with Google's Gemini AI service to provide contextual responses based on lesson content,
 * video transcripts, and conversation history.
 *
 * Key Features:
 * - Session-based authentication (users must be logged in)
 * - Context-aware responses using lesson data and video transcripts
 * - Conversation memory to maintain chat history
 * - JSON-based API for frontend integration
 * - Error handling and input validation
 *
 * URL Mapping: /ai-chat
 * Methods: POST (main functionality), GET (status page)
 *
 * @author SWP391 Team
 */
public class AiChatServlet extends HttpServlet {

    /**
     * Handles POST requests for AI chat functionality
     *
     * Processing Flow:
     * 1. Validate user session (must be logged in)
     * 2. Extract and validate request parameters (message, lessonId, lessonName)
     * 3. Check AI service configuration (API key availability)
     * 4. Build enhanced context from lesson data and video transcripts
     * 5. Retrieve conversation history from memory
     * 6. Call Gemini AI service with context and user message
     * 7. Store AI response in conversation memory
     * 8. Clean and format response for JSON output
     * 9. Return structured JSON response to client
     *
     * @param request HTTP request containing user message and lesson context
     * @param response HTTP response with JSON-formatted AI reply or error
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during request processing
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response content type to JSON with UTF-8 encoding
        response.setContentType("application/json;charset=UTF-8");

        try {
            // Step 1: Validate user authentication
            // Check if user is logged in by retrieving user object from session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            if (currentUser == null) {
                response.getWriter().write("{\"error\": \"Please login to use AI Assistant\"}");
                return;
            }

            // Step 2: Extract and validate request parameters
            String userMessage = request.getParameter("message");      // User's chat message
            String lessonId = request.getParameter("lessonId");        // Current lesson ID for context
            String lessonName = request.getParameter("lessonName");    // Current lesson name for context

            // Validate that user message is not empty
            if (userMessage == null || userMessage.trim().isEmpty()) {
                response.getWriter().write("{\"error\": \"Message cannot be empty\"}");
                return;
            }

            // Step 3: Check AI service configuration
            // Verify that Gemini API key and configuration are properly set
            if (!AppConfig.isConfigured()) {
                response.getWriter().write("{\"error\": \"AI Assistant is not configured. Please check configuration.\"}");
                return;
            }

            // Step 4: Build conversation context and memory
            String sessionId = session.getId();
            // Store user message in conversation memory for context continuity
            ConversationMemory.addMessage(sessionId, userMessage, "user", lessonId);

            // Step 5: Build enhanced context from lesson data
            // Create rich context using lesson content, video transcripts, and learning objectives
            String context = AiContextBuilder.buildEnhancedContext(lessonId, lessonName, userMessage);
            // Retrieve previous conversation history for better context understanding
            String conversationContext = ConversationMemory.getConversationContext(sessionId);

            // Combine lesson context with conversation history
            String fullContext = context + "\n" + conversationContext;

            // Step 6: Generate AI response using Gemini service
            String aiResponse;
            if (fullContext != null && !fullContext.isEmpty()) {
                // Use context-aware chat for better educational responses
                aiResponse = GeminiService.chatWithContext(userMessage, fullContext);
            } else {
                // Fallback to simple chat if no context available
                aiResponse = GeminiService.simpleChat(userMessage);
            }

            // Step 7: Store AI response in conversation memory
            ConversationMemory.addMessage(sessionId, aiResponse, "ai", lessonId);

            // Step 8: Clean and format response for output
            aiResponse = cleanAiResponse(aiResponse);

            // Step 9: Return structured JSON response to client
            response.getWriter().write("{\"response\": \"" + escapeJson(aiResponse) + "\"}");

        } catch (Exception e) {
            // Handle any unexpected errors gracefully
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"Sorry, I encountered an error. Please try again.\"}");
        }
    }
    
    /**
     * Build comprehensive context information for AI responses based on lesson content
     *
     * This method creates rich contextual information to help the AI provide more accurate
     * and relevant educational responses. It attempts to use video transcript data when
     * available, and falls back to basic context based on lesson name patterns.
     *
     * Context Building Process:
     * 1. Query VideoTranscriptDAO to retrieve transcript data for the lesson
     * 2. Verify transcript completion status
     * 3. Build rich context string including:
     *    - Lesson name and summary
     *    - Key topics covered in the lesson
     *    - Learning objectives
     *    - Video transcript content (limited to 1500 characters to avoid token limits)
     * 4. Add specific AI instructions for educational response formatting
     * 5. Fallback to basic context if no transcript is available
     * 6. Use pattern matching to identify lesson types (Java, AI, Soft Skills)
     *
     * @param lessonId The ID of the current lesson for transcript lookup
     * @param lessonName The name of the current lesson for context building
     * @return A formatted context string for AI processing
     */
    private String buildLessonContext(String lessonId, String lessonName) {
        StringBuilder context = new StringBuilder();

        try {
            // Attempt to retrieve video transcript for enhanced context
            if (lessonId != null && !lessonId.trim().isEmpty()) {
                VideoTranscriptDAO transcriptDAO = new VideoTranscriptDAO();
                VideoTranscript transcript = transcriptDAO.getTranscriptByLessonId(Integer.parseInt(lessonId));

                // Check if transcript exists and processing is completed
                if (transcript != null && transcript.isCompleted()) {
                    // Build rich context using actual video transcript data
                    context.append("LESSON: ").append(lessonName != null ? lessonName : "Current Lesson").append("\\n\\n");

                    // Add lesson summary if available
                    if (transcript.getSummary() != null) {
                        context.append("LESSON SUMMARY:\\n").append(transcript.getSummary()).append("\\n\\n");
                    }

                    // Add key topics covered in the lesson
                    if (transcript.getKeyTopics() != null) {
                        context.append("KEY TOPICS:\\n").append(transcript.getKeyTopics()).append("\\n\\n");
                    }

                    // Add learning objectives for the lesson
                    if (transcript.getLearningObjectives() != null) {
                        context.append("LEARNING OBJECTIVES:\\n").append(transcript.getLearningObjectives()).append("\\n\\n");
                    }

                    // Add video transcript content with length limitation
                    if (transcript.getTranscript() != null) {
                        // Limit transcript length to avoid exceeding AI token limits
                        String fullTranscript = transcript.getTranscript();
                        if (fullTranscript.length() > 1500) {
                            fullTranscript = fullTranscript.substring(0, 1500) + "...";
                        }
                        context.append("VIDEO TRANSCRIPT:\\n").append(fullTranscript).append("\\n\\n");
                    }

                    // Add specific instructions for AI response formatting
                    context.append("Please answer questions based on this lesson content. ");
                    context.append("Provide detailed, specific explanations using information from the video transcript. ");
                    context.append("When listing topics, include brief explanations for each topic. ");
                    context.append("Use examples and context from the lesson to make answers comprehensive and educational. ");
                    context.append("If asked about topics not covered in this lesson, politely redirect to the actual lesson content.");

                    return context.toString();
                }
            }
        } catch (Exception e) {
            // Log error and continue with fallback context
            System.err.println("Error loading video transcript: " + e.getMessage());
            // Fall back to basic context generation
        }

        // Fallback context generation when video transcript is not available
        if (lessonName != null && !lessonName.trim().isEmpty()) {
            context.append("Current lesson: ").append(lessonName).append("\\n");
        }

        // Generate basic context based on lesson name pattern matching
        if (lessonName != null) {
            // Java programming lessons
            if (lessonName.toLowerCase().contains("java")) {
                context.append("This is a Java programming lesson. ");
                context.append("Topics may include variables, data types, methods, classes, and object-oriented programming concepts.\\n");
            }
            // Artificial Intelligence lessons
            else if (lessonName.toLowerCase().contains("ai") || lessonName.toLowerCase().contains("artificial intelligence")) {
                context.append("This is an Artificial Intelligence lesson. ");
                context.append("Topics may include machine learning, neural networks, algorithms, and AI applications.\\n");
            }
            // Soft skills development lessons
            else if (lessonName.toLowerCase().contains("soft skills")) {
                context.append("This is a soft skills development lesson. ");
                context.append("Topics may include communication, teamwork, leadership, and professional development.\\n");
            }
        }

        // Add general instructions for educational responses
        context.append("Please provide helpful, accurate answers related to the lesson content. ");
        context.append("If the question is not related to the current lesson, politely guide the student back to course-related topics.");

        return context.toString();
    }

    /**
     * Clean and format AI response for output
     *
     * This method ensures that AI responses are properly formatted and within
     * reasonable length limits for display in the chat interface.
     *
     * @param response Raw AI response string
     * @return Cleaned and formatted response string
     */
    private String cleanAiResponse(String response) {
        // Handle null responses gracefully
        if (response == null) return "Sorry, I couldn't generate a response.";

        // Remove leading/trailing whitespace
        response = response.trim();

        // Limit response length to prevent UI overflow and improve readability
        if (response.length() > 2000) {
            response = response.substring(0, 1997) + "...";
        }

        return response;
    }

    /**
     * Escape special characters for JSON output
     *
     * This method properly escapes characters that have special meaning in JSON
     * to prevent parsing errors and security issues.
     *
     * @param input Raw string input
     * @return JSON-safe escaped string
     */
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")      // Escape backslashes
                    .replace("\"", "\\\"")      // Escape double quotes
                    .replace("\n", "\\n")       // Escape newlines
                    .replace("\r", "\\r")       // Escape carriage returns
                    .replace("\t", "\\t");      // Escape tabs
    }

    /**
     * Handles GET requests for AI Chat service status page
     *
     * This method provides a simple status page that displays:
     * - Service information and usage instructions
     * - Current AI configuration status (configured/not configured)
     * - Navigation link back to lesson view
     *
     * This is primarily used for debugging and service verification purposes.
     * The main chat functionality is handled via POST requests.
     *
     * @param request HTTP request (no parameters required)
     * @param response HTTP response with HTML status page
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if I/O error occurs during response writing
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response content type to HTML
        response.setContentType("text/html;charset=UTF-8");

        // Generate simple HTML status page
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h1>AI Chat Service</h1>");
        response.getWriter().println("<p>This service handles AI chat requests via POST method.</p>");

        // Display current AI configuration status
        if (AppConfig.isConfigured()) {
            response.getWriter().println("<p style='color: green;'>[OK] AI Assistant is configured and ready.</p>");
        } else {
            response.getWriter().println("<p style='color: red;'>[ERROR] AI Assistant is not configured.</p>");
        }

        // Provide navigation link back to lesson view
        response.getWriter().println("<p><a href='lesson-view?lessonId=10'>&lt; Back to Lesson</a></p>");
        response.getWriter().println("</body></html>");
    }
}