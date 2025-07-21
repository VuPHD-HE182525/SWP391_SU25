package utils;

import java.time.LocalDateTime;
import java.util.*;

public class ConversationMemory {
    
    private static final Map<String, List<ChatMessage>> conversationHistory = new HashMap<>();
    private static final int MAX_HISTORY_SIZE = 10; // Keep last 10 messages per session
    
    public static class ChatMessage {
        private String message;
        private String sender; // "user" or "ai"
        private LocalDateTime timestamp;
        private String lessonId;
        
        public ChatMessage(String message, String sender, String lessonId) {
            this.message = message;
            this.sender = sender;
            this.timestamp = LocalDateTime.now();
            this.lessonId = lessonId;
        }
        
        // Getters
        public String getMessage() { return message; }
        public String getSender() { return sender; }
        public LocalDateTime getTimestamp() { return timestamp; }
        public String getLessonId() { return lessonId; }
    }
    
    /**
     * Add message to conversation history
     */
    public static void addMessage(String sessionId, String message, String sender, String lessonId) {
        List<ChatMessage> history = conversationHistory.get(sessionId);
        if (history == null) {
            history = new ArrayList<>();
            conversationHistory.put(sessionId, history);
        }
        
        history.add(new ChatMessage(message, sender, lessonId));
        
        // Keep only last MAX_HISTORY_SIZE messages
        if (history.size() > MAX_HISTORY_SIZE) {
            history.remove(0);
        }
    }
    
    /**
     * Get conversation history for context building
     */
    public static String getConversationContext(String sessionId) {
        List<ChatMessage> history = conversationHistory.get(sessionId);
        if (history == null || history.isEmpty()) {
            return "";
        }
        
        StringBuilder context = new StringBuilder();
        context.append("=== CONVERSATION HISTORY ===\n");
        
        for (ChatMessage msg : history) {
            String prefix = msg.getSender().equals("user") ? "User: " : "AI: ";
            context.append(prefix).append(msg.getMessage()).append("\n");
        }
        
        context.append("\n");
        return context.toString();
    }
    
    /**
     * Get recent user questions for better context
     */
    public static List<String> getRecentUserQuestions(String sessionId) {
        List<ChatMessage> history = conversationHistory.get(sessionId);
        List<String> questions = new ArrayList<>();
        
        if (history != null) {
            for (ChatMessage msg : history) {
                if (msg.getSender().equals("user")) {
                    questions.add(msg.getMessage());
                }
            }
        }
        
        return questions;
    }
    
    /**
     * Clear conversation history for a session
     */
    public static void clearHistory(String sessionId) {
        conversationHistory.remove(sessionId);
    }
    
    /**
     * Get conversation summary for AI context
     */
    public static String getConversationSummary(String sessionId) {
        List<ChatMessage> history = conversationHistory.get(sessionId);
        if (history == null || history.isEmpty()) {
            return "This is a new conversation.";
        }
        
        int userMessages = 0;
        int aiMessages = 0;
        String lastUserMessage = "";
        
        for (ChatMessage msg : history) {
            if (msg.getSender().equals("user")) {
                userMessages++;
                lastUserMessage = msg.getMessage();
            } else {
                aiMessages++;
            }
        }
        
        StringBuilder summary = new StringBuilder();
        summary.append("Conversation summary: ");
        summary.append(userMessages).append(" user messages, ");
        summary.append(aiMessages).append(" AI responses. ");
        
        if (!lastUserMessage.isEmpty()) {
            summary.append("Last user question: ").append(lastUserMessage);
        }
        
        return summary.toString();
    }
} 