package utils;

import java.util.*;

public class SmartSuggestions {
    
    // Predefined suggestions based on lesson types
    private static final Map<String, List<String>> lessonSuggestions = new HashMap<>();
    
    static {
        // Java Programming suggestions
        lessonSuggestions.put("java", Arrays.asList(
            "What are variables in Java?",
            "Explain data types in Java",
            "How do methods work in Java?",
            "What is object-oriented programming?",
            "Show me a simple Java example"
        ));
        
        // AI/ML suggestions
        lessonSuggestions.put("ai", Arrays.asList(
            "What is machine learning?",
            "Explain neural networks",
            "How does AI work?",
            "What are the types of AI?",
            "Show me AI applications"
        ));
        
        // Soft Skills suggestions
        lessonSuggestions.put("soft skills", Arrays.asList(
            "How to improve communication?",
            "What are leadership skills?",
            "How to work in a team?",
            "Tips for public speaking",
            "How to handle conflicts?"
        ));
        
        // Reading suggestions
        lessonSuggestions.put("reading", Arrays.asList(
            "Can you summarize this reading?",
            "What are the main concepts?",
            "Explain the key points",
            "How can I apply this knowledge?",
            "What should I remember from this?"
        ));
        
        // General suggestions
        lessonSuggestions.put("general", Arrays.asList(
            "Can you summarize this lesson?",
            "What are the key points?",
            "Give me an example",
            "How can I practice this?",
            "What should I focus on?"
        ));
    }
    
    /**
     * Get smart suggestions based on lesson content
     */
    public static List<String> getSuggestions(String lessonName, String userMessage) {
        List<String> suggestions = new ArrayList<>();
        
        if (lessonName == null) {
            return lessonSuggestions.get("general");
        }
        
        String lessonNameLower = lessonName.toLowerCase();
        
        // Determine lesson type
        String lessonType = "general";
        if (lessonNameLower.contains("java") || lessonNameLower.contains("programming")) {
            lessonType = "java";
        } else if (lessonNameLower.contains("ai") || lessonNameLower.contains("artificial intelligence")) {
            lessonType = "ai";
        } else if (lessonNameLower.contains("soft skills") || lessonNameLower.contains("communication")) {
            lessonType = "soft skills";
        } else if (lessonNameLower.contains("reading") || lessonNameLower.contains("text") || lessonNameLower.contains("article")) {
            lessonType = "reading";
        }
        
        // Get base suggestions
        List<String> baseSuggestions = lessonSuggestions.get(lessonType);
        if (baseSuggestions != null) {
            suggestions.addAll(baseSuggestions);
        }
        
        // Add contextual suggestions based on user message
        suggestions.addAll(getContextualSuggestions(userMessage));
        
        return suggestions;
    }
    
    /**
     * Generate contextual suggestions based on user message
     */
    private static List<String> getContextualSuggestions(String userMessage) {
        List<String> suggestions = new ArrayList<>();
        
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return suggestions;
        }
        
        String messageLower = userMessage.toLowerCase();
        
        // Context-based suggestions
        if (messageLower.contains("variable") || messageLower.contains("var")) {
            suggestions.add("How to declare variables?");
            suggestions.add("What are different variable types?");
        }
        
        if (messageLower.contains("method") || messageLower.contains("function")) {
            suggestions.add("How to create methods?");
            suggestions.add("What are method parameters?");
        }
        
        if (messageLower.contains("class") || messageLower.contains("object")) {
            suggestions.add("How to create classes?");
            suggestions.add("What is inheritance?");
        }
        
        if (messageLower.contains("error") || messageLower.contains("problem")) {
            suggestions.add("How to debug code?");
            suggestions.add("Common programming mistakes");
        }
        
        if (messageLower.contains("example") || messageLower.contains("practice")) {
            suggestions.add("Show me a practical example");
            suggestions.add("How can I practice this?");
        }
        
        return suggestions;
    }
    
    /**
     * Get follow-up questions based on AI response
     */
    public static List<String> getFollowUpQuestions(String aiResponse) {
        List<String> followUps = new ArrayList<>();
        
        if (aiResponse == null || aiResponse.trim().isEmpty()) {
            return followUps;
        }
        
        String responseLower = aiResponse.toLowerCase();
        
        // Generate follow-up questions based on response content
        if (responseLower.contains("variable")) {
            followUps.add("Can you show me more variable examples?");
            followUps.add("What about different data types?");
        }
        
        if (responseLower.contains("method")) {
            followUps.add("How do I call methods?");
            followUps.add("What are method parameters?");
        }
        
        if (responseLower.contains("class")) {
            followUps.add("How do I create objects?");
            followUps.add("What is inheritance?");
        }
        
        if (responseLower.contains("example")) {
            followUps.add("Can you explain this example step by step?");
            followUps.add("What if I want to modify this example?");
        }
        
        return followUps;
    }
    
    /**
     * Get quick action suggestions
     */
    public static List<String> getQuickActions(String lessonName) {
        List<String> actions = new ArrayList<>();
        
        actions.add("Take notes");
        actions.add("Practice exercise");
        actions.add("Read more");
        actions.add("Ask question");
        actions.add("Review lesson");
        
        return actions;
    }
} 