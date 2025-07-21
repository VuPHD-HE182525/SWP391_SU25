package utils;

public class AiContextBuilder {
    
    /**
     * Build comprehensive context for AI responses (Video + Reading)
     */
    public static String buildEnhancedContext(String lessonId, String lessonName, String userMessage) {
        StringBuilder context = new StringBuilder();
        
        try {
            // Basic context building without complex dependencies
            context.append("=== LESSON CONTEXT ===\n");
            context.append("Lesson: ").append(lessonName != null ? lessonName : "Current Lesson").append("\n");
            context.append("Lesson ID: ").append(lessonId).append("\n\n");
            
            // Add content type detection and handling
            String contentContext = buildContentContext(lessonId, lessonName, userMessage);
            context.append(contentContext);
            
            // Add educational context based on lesson name
            context.append("=== EDUCATIONAL CONTEXT ===\n");
            context.append(buildEducationalContext(lessonName, userMessage));
            
            // Add AI instructions
            context.append("\n=== AI INSTRUCTIONS ===\n");
            context.append("You are an expert educational AI assistant. ");
            context.append("Provide detailed, accurate answers based on the lesson content. ");
            context.append("Use examples and explanations that help students understand. ");
            context.append("If the question is not related to this lesson, politely guide back to course topics. ");
            context.append("Always be encouraging and supportive in your responses.");
            
        } catch (Exception e) {
            System.err.println("Error building enhanced context: " + e.getMessage());
            // Fallback to basic context
            context.append("Current lesson: ").append(lessonName).append("\n");
            context.append("Please provide helpful answers related to the course content.");
        }
        
        return context.toString();
    }
    
    /**
     * Build content-specific context (Video or Reading)
     */
    private static String buildContentContext(String lessonId, String lessonName, String userMessage) {
        StringBuilder context = new StringBuilder();
        
        try {
            // Determine content type based on lesson name or ID
            boolean isReadingLesson = isReadingLesson(lessonName, lessonId);
            
            if (isReadingLesson) {
                context.append("=== READING CONTENT ANALYSIS ===\n");
                context.append("This is a reading-based lesson with text content. ");
                context.append("The content includes articles, documents, or written materials. ");
                context.append("Focus on text comprehension, key concepts, and written explanations.\n\n");
                
                // Add reading-specific context
                context.append(buildReadingContext(lessonId, lessonName, userMessage));
                
            } else {
                context.append("=== VIDEO CONTENT ANALYSIS ===\n");
                context.append("This is a video-based lesson with audio-visual content. ");
                context.append("The content includes video explanations, demonstrations, and visual examples.\n\n");
                
                // Add video-specific context (existing logic)
                context.append(buildVideoContext(lessonId, lessonName, userMessage));
            }
            
        } catch (Exception e) {
            System.err.println("Error building content context: " + e.getMessage());
            context.append("Content type could not be determined. ");
            context.append("Please provide general educational assistance.\n\n");
        }
        
        return context.toString();
    }
    
    /**
     * Determine if lesson is reading-based
     */
    private static boolean isReadingLesson(String lessonName, String lessonId) {
        if (lessonName != null) {
            String lessonNameLower = lessonName.toLowerCase();
            return lessonNameLower.contains("reading") || 
                   lessonNameLower.contains("text") || 
                   lessonNameLower.contains("article") ||
                   lessonNameLower.contains("document");
        }
        
        // Check lesson ID for reading lessons (ID 15 is reading lesson)
        if (lessonId != null && lessonId.equals("15")) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Build context for reading lessons
     */
    private static String buildReadingContext(String lessonId, String lessonName, String userMessage) {
        StringBuilder context = new StringBuilder();
        
        // Load reading content using ReadingContentLoader
        String readingContent = ReadingContentLoader.loadReadingContent(lessonId, lessonName);
        if (readingContent != null && !readingContent.isEmpty()) {
            context.append("LESSON CONTENT:\n").append(readingContent).append("\n\n");
            
            // Extract relevant sections based on user question
            String relevantContent = ReadingContentLoader.extractRelevantSections(readingContent, userMessage);
            if (relevantContent != null && !relevantContent.isEmpty()) {
                context.append("RELEVANT SECTIONS:\n").append(relevantContent).append("\n\n");
            }
        }
        
        return context.toString();
    }
    
    /**
     * Build context for video lessons (existing logic)
     */
    private static String buildVideoContext(String lessonId, String lessonName, String userMessage) {
        StringBuilder context = new StringBuilder();
        
        // Video lesson specific content
        context.append("This lesson includes video content with audio explanations. ");
        context.append("Focus on visual demonstrations, practical examples, and step-by-step explanations.\n\n");
        
        return context.toString();
    }
    
    /**
     * Extract relevant reading content based on user question
     */
    private static String extractRelevantReadingContent(String userMessage) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return null;
        }
        
        String messageLower = userMessage.toLowerCase();
        StringBuilder relevant = new StringBuilder();
        
        // Reading content mapping based on keywords
        if (messageLower.contains("listening") || messageLower.contains("hear")) {
            relevant.append("Active listening involves fully concentrating on what is being said, ");
            relevant.append("rather than just passively hearing the message. ");
            relevant.append("It includes understanding, responding, and remembering what is said.\n");
        }
        
        if (messageLower.contains("communication") || messageLower.contains("speak")) {
            relevant.append("Effective communication requires both speaking and listening skills. ");
            relevant.append("Good communicators know how to express ideas clearly and listen actively.\n");
        }
        
        if (messageLower.contains("technique") || messageLower.contains("method")) {
            relevant.append("Key listening techniques include: maintaining eye contact, ");
            relevant.append("asking clarifying questions, providing feedback, and avoiding interruptions.\n");
        }
        
        if (messageLower.contains("professional") || messageLower.contains("work")) {
            relevant.append("In professional settings, active listening is crucial for building relationships, ");
            relevant.append("solving problems, and avoiding misunderstandings.\n");
        }
        
        return relevant.toString().trim();
    }
    
    /**
     * Build educational context based on lesson type and content
     */
    private static String buildEducationalContext(String lessonName, String userMessage) {
        StringBuilder context = new StringBuilder();
        
        if (lessonName != null) {
            String lessonNameLower = lessonName.toLowerCase();
            
            if (lessonNameLower.contains("java") || lessonNameLower.contains("programming")) {
                context.append("This is a Java programming lesson. ");
                context.append("Key concepts include: variables, data types, methods, classes, OOP principles. ");
                context.append("Focus on practical coding examples and best practices.\n");
            } else if (lessonNameLower.contains("ai") || lessonNameLower.contains("artificial intelligence")) {
                context.append("This is an AI/ML lesson. ");
                context.append("Key concepts include: machine learning, neural networks, algorithms, data science. ");
                context.append("Emphasize real-world applications and current AI trends.\n");
            } else if (lessonNameLower.contains("soft skills") || lessonNameLower.contains("communication")) {
                context.append("This is a soft skills development lesson. ");
                context.append("Key concepts include: communication, teamwork, leadership, professional development. ");
                context.append("Provide practical tips and real-world scenarios.\n");
            } else if (lessonNameLower.contains("reading")) {
                context.append("This is a reading comprehension lesson. ");
                context.append("Focus on understanding key concepts, critical thinking, and knowledge retention. ");
                context.append("Encourage active reading and note-taking strategies.\n");
            } else {
                context.append("This is an educational lesson. ");
                context.append("Focus on helping students understand the material clearly. ");
                context.append("Provide explanations, examples, and practical applications.\n");
            }
        }
        
        return context.toString();
    }
    
    /**
     * Extract relevant keywords from user message for better context
     */
    public static String extractKeywords(String userMessage) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "";
        }
        
        // Simple keyword extraction
        String[] words = userMessage.toLowerCase().split("\\s+");
        StringBuilder keywords = new StringBuilder();
        
        for (String word : words) {
            if (word.length() > 3 && !isCommonWord(word)) {
                keywords.append(word).append(" ");
            }
        }
        
        return keywords.toString().trim();
    }
    
    /**
     * Check if word is a common word to filter out
     */
    private static boolean isCommonWord(String word) {
        String[] commonWords = {"the", "and", "for", "are", "but", "not", "you", "all", "can", "had", "her", "was", "one", "our", "out", "day", "get", "has", "him", "his", "how", "man", "new", "now", "old", "see", "two", "way", "who", "boy", "did", "its", "let", "put", "say", "she", "too", "use"};
        
        for (String common : commonWords) {
            if (common.equals(word)) {
                return true;
            }
        }
        return false;
    }
} 