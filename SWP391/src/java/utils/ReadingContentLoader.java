package utils;

public class ReadingContentLoader {
    
    /**
     * Load reading content from file or database
     */
    public static String loadReadingContent(String lessonId, String lessonName) {
        StringBuilder content = new StringBuilder();
        
        try {
            // For reading lesson ID 15 (Active Listening)
            if ("15".equals(lessonId)) {
                // Try to load from file first
                String fileContent = loadFromFile("/content/active_listening.txt");
                if (fileContent != null && !fileContent.trim().isEmpty()) {
                    content.append(fileContent);
                } else {
                    // Fallback to hardcoded content
                    content.append("ACTIVE LISTENING FUNDAMENTALS\n\n");
                    content.append("Active listening is a communication technique that requires the listener to fully concentrate, understand, respond, and then remember what is being said.\n\n");
                    
                    content.append("KEY CONCEPTS:\n");
                    content.append("1. Full Attention: Give complete focus to the speaker\n");
                    content.append("2. Understanding: Comprehend the message being conveyed\n");
                    content.append("3. Responding: Provide appropriate feedback\n");
                    content.append("4. Remembering: Retain important information\n\n");
                    
                    content.append("TECHNIQUES:\n");
                    content.append("- Maintain eye contact\n");
                    content.append("- Ask clarifying questions\n");
                    content.append("- Provide verbal and non-verbal feedback\n");
                    content.append("- Avoid interrupting\n");
                    content.append("- Show empathy and understanding\n\n");
                    
                    content.append("BENEFITS:\n");
                    content.append("- Improved relationships\n");
                    content.append("- Better problem-solving\n");
                    content.append("- Enhanced communication skills\n");
                    content.append("- Reduced misunderstandings\n");
                    content.append("- Professional development\n\n");
                    
                    content.append("PRACTICAL APPLICATIONS:\n");
                    content.append("- Workplace communication\n");
                    content.append("- Customer service\n");
                    content.append("- Conflict resolution\n");
                    content.append("- Team collaboration\n");
                    content.append("- Leadership development\n");
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error loading reading content: " + e.getMessage());
            content.append("Reading content could not be loaded. ");
            content.append("Please provide general assistance based on the lesson topic.");
        }
        
        return content.toString();
    }
    
    /**
     * Extract relevant sections from reading content based on user question
     */
    public static String extractRelevantSections(String fullContent, String userQuestion) {
        if (fullContent == null || userQuestion == null) {
            return fullContent;
        }
        
        String questionLower = userQuestion.toLowerCase();
        StringBuilder relevant = new StringBuilder();
        
        // Simple keyword-based extraction
        if (questionLower.contains("technique") || questionLower.contains("method")) {
            relevant.append("TECHNIQUES:\n");
            relevant.append("- Maintain eye contact\n");
            relevant.append("- Ask clarifying questions\n");
            relevant.append("- Provide verbal and non-verbal feedback\n");
            relevant.append("- Avoid interrupting\n");
            relevant.append("- Show empathy and understanding\n\n");
        }
        
        if (questionLower.contains("benefit") || questionLower.contains("advantage")) {
            relevant.append("BENEFITS:\n");
            relevant.append("- Improved relationships\n");
            relevant.append("- Better problem-solving\n");
            relevant.append("- Enhanced communication skills\n");
            relevant.append("- Reduced misunderstandings\n");
            relevant.append("- Professional development\n\n");
        }
        
        if (questionLower.contains("apply") || questionLower.contains("use")) {
            relevant.append("PRACTICAL APPLICATIONS:\n");
            relevant.append("- Workplace communication\n");
            relevant.append("- Customer service\n");
            relevant.append("- Conflict resolution\n");
            relevant.append("- Team collaboration\n");
            relevant.append("- Leadership development\n\n");
        }
        
        if (questionLower.contains("concept") || questionLower.contains("understand")) {
            relevant.append("KEY CONCEPTS:\n");
            relevant.append("1. Full Attention: Give complete focus to the speaker\n");
            relevant.append("2. Understanding: Comprehend the message being conveyed\n");
            relevant.append("3. Responding: Provide appropriate feedback\n");
            relevant.append("4. Remembering: Retain important information\n\n");
        }
        
        return relevant.length() > 0 ? relevant.toString() : fullContent;
    }
    
    /**
     * Get reading lesson summary
     */
    public static String getReadingSummary(String lessonId) {
        if ("15".equals(lessonId)) {
            return "Active Listening Fundamentals - A comprehensive guide to developing effective listening skills for professional and personal communication.";
        }
        return "Reading lesson content summary.";
    }
    
    /**
     * Load content from file
     */
    private static String loadFromFile(String filePath) {
        try {
            // Get the real path from servlet context
            String realPath = getServletContextPath(filePath);
            if (realPath != null) {
                java.io.File file = new java.io.File(realPath);
                if (file.exists()) {
                    return new String(java.nio.file.Files.readAllBytes(file.toPath()), "UTF-8");
                }
            }
        } catch (Exception e) {
            System.err.println("Error loading file: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Get servlet context path (helper method)
     */
    private static String getServletContextPath(String relativePath) {
        try {
            // This is a simplified approach - in real implementation, 
            // you'd pass ServletContext from the servlet
            String webappRoot = System.getProperty("catalina.home") + "/webapps/ROOT";
            return webappRoot + relativePath;
        } catch (Exception e) {
            return null;
        }
    }
} 