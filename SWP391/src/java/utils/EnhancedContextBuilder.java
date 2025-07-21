package utils;

import DAO.VideoTranscriptDAO;
import DAO.LessonDAO;
import DAO.CourseDAO;
import model.VideoTranscript;
import model.Lesson;
import model.Course;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class EnhancedContextBuilder {
    
    /**
     * Build comprehensive context for AI responses
     */
    public static String buildEnhancedContext(String lessonId, String lessonName, String userMessage) {
        StringBuilder context = new StringBuilder();
        
        try {
            int lessonIdInt = Integer.parseInt(lessonId);
            
            // 1. Get lesson details
            LessonDAO lessonDAO = new LessonDAO();
            Lesson lesson = lessonDAO.getLessonById(lessonIdInt);
            
            if (lesson != null) {
                context.append("=== LESSON INFORMATION ===\n");
                context.append("Title: ").append(lesson.getName()).append("\n");
                context.append("Type: ").append(lesson.getType()).append("\n");
                context.append("Duration: ").append(lesson.getEstimatedTime()).append(" minutes\n\n");
                
                // 2. Get course context
                CourseDAO courseDAO = new CourseDAO();
                Course course = courseDAO.getCourseById(lesson.getSubjectId());
                if (course != null) {
                    context.append("=== COURSE CONTEXT ===\n");
                    context.append("Course: ").append(course.getTitle()).append("\n");
                    context.append("Description: ").append(course.getDescription()).append("\n\n");
                }
            }
            
            // 3. Get video transcript with enhanced processing
            VideoTranscriptDAO transcriptDAO = new VideoTranscriptDAO();
            VideoTranscript transcript = transcriptDAO.getTranscriptByLessonId(lessonIdInt);
            
            if (transcript != null && transcript.isCompleted()) {
                context.append("=== VIDEO CONTENT ANALYSIS ===\n");
                
                if (transcript.getSummary() != null) {
                    context.append("SUMMARY:\n").append(transcript.getSummary()).append("\n\n");
                }
                
                if (transcript.getKeyTopics() != null) {
                    context.append("KEY TOPICS:\n").append(transcript.getKeyTopics()).append("\n\n");
                }
                
                if (transcript.getLearningObjectives() != null) {
                    context.append("LEARNING OBJECTIVES:\n").append(transcript.getLearningObjectives()).append("\n\n");
                }
                
                // Include relevant transcript sections based on user question
                String relevantTranscript = extractRelevantTranscript(transcript.getTranscript(), userMessage);
                if (relevantTranscript != null && !relevantTranscript.isEmpty()) {
                    context.append("RELEVANT TRANSCRIPT SECTIONS:\n").append(relevantTranscript).append("\n\n");
                }
            }
            
            // 4. Add educational context based on lesson type
            context.append("=== EDUCATIONAL CONTEXT ===\n");
            context.append(buildEducationalContext(lesson, userMessage));
            
            // 5. Add AI instructions
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
     * Extract relevant transcript sections based on user question
     */
    private static String extractRelevantTranscript(String fullTranscript, String userMessage) {
        if (fullTranscript == null || fullTranscript.isEmpty() || userMessage == null) {
            return null;
        }
        
        // Simple keyword matching for now
        String[] keywords = userMessage.toLowerCase().split("\\s+");
        String[] sentences = fullTranscript.split("[.!?]");
        
        StringBuilder relevant = new StringBuilder();
        int matchCount = 0;
        
        for (String sentence : sentences) {
            if (sentence.trim().length() < 10) continue; // Skip very short sentences
            
            int keywordMatches = 0;
            for (String keyword : keywords) {
                if (keyword.length() > 3 && sentence.toLowerCase().contains(keyword)) {
                    keywordMatches++;
                }
            }
            
            if (keywordMatches > 0) {
                relevant.append(sentence.trim()).append(". ");
                matchCount++;
                
                if (matchCount >= 3) break; // Limit to 3 most relevant sentences
            }
        }
        
        return relevant.toString().trim();
    }
    
    /**
     * Build educational context based on lesson type and content
     */
    private static String buildEducationalContext(Lesson lesson, String userMessage) {
        StringBuilder context = new StringBuilder();
        
        if (lesson != null) {
            String lessonName = lesson.getName().toLowerCase();
            String lessonType = lesson.getType();
            
            if (lessonName.contains("java") || lessonName.contains("programming")) {
                context.append("This is a Java programming lesson. ");
                context.append("Key concepts include: variables, data types, methods, classes, OOP principles. ");
                context.append("Focus on practical coding examples and best practices.\n");
            } else if (lessonName.contains("ai") || lessonName.contains("artificial intelligence")) {
                context.append("This is an AI/ML lesson. ");
                context.append("Key concepts include: machine learning, neural networks, algorithms, data science. ");
                context.append("Emphasize real-world applications and current AI trends.\n");
            } else if (lessonName.contains("soft skills") || lessonName.contains("communication")) {
                context.append("This is a soft skills development lesson. ");
                context.append("Key concepts include: communication, teamwork, leadership, professional development. ");
                context.append("Provide practical tips and real-world scenarios.\n");
            } else if (lessonType != null && lessonType.equals("reading")) {
                context.append("This is a reading comprehension lesson. ");
                context.append("Focus on understanding key concepts, critical thinking, and knowledge retention. ");
                context.append("Encourage active reading and note-taking strategies.\n");
            }
        }
        
        return context.toString();
    }
} 