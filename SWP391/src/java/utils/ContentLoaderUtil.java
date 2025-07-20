package utils;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Utility class for loading lesson content from files
 * Inspired by Coursera's static content delivery approach
 */
public class ContentLoaderUtil {
    
    private static final String CONTENT_BASE_PATH = "/uploads/texts/";
    private static final String DEFAULT_CHARSET = "UTF-8";
    
    /**
     * Load HTML content from file path (relative to web app)
     */
    public static String loadHtmlContent(String webAppPath, String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return "";
        }
        
        try {
            // Construct full path: webAppPath + filePath
            String fullPath = webAppPath + filePath;
            Path path = Paths.get(fullPath);
            
            if (!Files.exists(path)) {
                System.err.println("File does not exist: " + fullPath);
                return "<p>Content not available</p>";
            }
            
            String content = new String(Files.readAllBytes(path), DEFAULT_CHARSET);
            return sanitizeHtmlContent(content);
            
        } catch (IOException e) {
            System.err.println("Error loading content from: " + filePath + " - " + e.getMessage());
            return "<p>Error loading content</p>";
        }
    }
    
    /**
     * Load markdown content and convert basic formatting
     */
    public static String loadMarkdownContent(String webAppPath, String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return "";
        }
        
        try {
            String fullPath = webAppPath + filePath;
            Path path = Paths.get(fullPath);
            
            if (!Files.exists(path)) {
                return "";
            }
            
            String content = new String(Files.readAllBytes(path), DEFAULT_CHARSET);
            return convertMarkdownToHtml(content);
            
        } catch (IOException e) {
            System.err.println("Error loading markdown from: " + filePath + " - " + e.getMessage());
            return "";
        }
    }
    
    /**
     * Basic markdown to HTML conversion
     */
    private static String convertMarkdownToHtml(String markdown) {
        if (markdown == null || markdown.trim().isEmpty()) {
            return "";
        }
        
        String html = markdown;
        
        // Convert headers
        html = html.replaceAll("(?m)^## (.+)$", "<h4>$1</h4>");
        html = html.replaceAll("(?m)^# (.+)$", "<h3>$1</h3>");
        
        // Convert bold text
        html = html.replaceAll("\\*\\*(.+?)\\*\\*", "<strong>$1</strong>");
        
        // Convert bullet points
        html = html.replaceAll("(?m)^• (.+)$", "<li>$1</li>");
        
        // Wrap lists in <ul> tags
        html = html.replaceAll("(<li>.*?</li>(?:\\s*<li>.*?</li>)*)", "<ul>$1</ul>");
        
        // Convert line breaks
        html = html.replaceAll("\\n\\n", "</p><p>");
        html = html.replaceAll("\\n", "<br>");
        
        // Wrap in paragraphs if not already wrapped
        if (!html.trim().startsWith("<") && !html.trim().isEmpty()) {
            html = "<p>" + html + "</p>";
        }
        
        return html.trim();
    }
    
    /**
     * Basic HTML sanitization (simple version)
     */
    private static String sanitizeHtmlContent(String html) {
        if (html == null) {
            return "";
        }
        
        // This is a basic sanitization - in production, use a proper HTML sanitizer
        // Allow common safe HTML tags
        String[] allowedTags = {"p", "h1", "h2", "h3", "h4", "h5", "h6", "br", "strong", "b", 
                               "em", "i", "ul", "ol", "li", "div", "span", "blockquote"};
        
        // For now, just return the content as-is (assuming it's safe)
        // In production, implement proper sanitization
        return html;
    }
    
    /**
     * Check if file exists
     */
    public static boolean fileExists(String webAppPath, String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return false;
        }
        
        try {
            String fullPath = webAppPath + filePath;
            Path path = Paths.get(fullPath);
            return Files.exists(path);
            
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Get file size in a human readable format
     */
    public static String getFileSize(String webAppPath, String filePath) {
        try {
            String fullPath = webAppPath + filePath;
            Path path = Paths.get(fullPath);
            
            if (!Files.exists(path)) return "Unknown";
            
            long bytes = Files.size(path);
            if (bytes < 1024) return bytes + " B";
            if (bytes < 1024 * 1024) return (bytes / 1024) + " KB";
            return (bytes / (1024 * 1024)) + " MB";
            
        } catch (IOException e) {
            return "Unknown";
        }
    }
} 