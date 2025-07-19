package utils;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import java.nio.file.Files;
import java.nio.file.Paths;
import org.json.JSONObject;
import org.json.JSONArray;

public class GeminiService {
    
    // Secure API key loading from config
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";
    
    private static String getApiKey() {
        return AppConfig.getGeminiApiKey();
    }
    
    /**
     * Simple chat without video context - for testing
     */
    public static String simpleChat(String userMessage) {
        try {
            String prompt = "You are an AI assistant for an e-learning platform. " +
                          "Help the student with their question: " + userMessage;
            
            // Create JSON request manually (simple approach)
            String jsonRequest = "{"
                + "\"contents\": [{"
                    + "\"parts\": [{"
                        + "\"text\": \"" + escapeJson(prompt) + "\""
                    + "}]"
                + "}]"
            + "}";
            
            return sendRequest(jsonRequest);
            
        } catch (Exception e) {
            e.printStackTrace();
            return "Sorry, I encountered an error. Please try again. Error: " + e.getMessage();
        }
    }
    
    /**
     * Chat with video context
     */
    public static String chatWithContext(String userMessage, String videoContext) {
        try {
            String systemPrompt = "You are an AI assistant for an e-learning platform. " +
                                "You help students understand course content. " +
                                "Use the following video context to answer questions:\n\n" +
                                "VIDEO CONTEXT:\n" + videoContext + "\n\n" +
                                "USER QUESTION: " + userMessage + "\n\n" +
                                "Provide a helpful, accurate answer based on the video content. " +
                                "If the question is not related to the video content, politely redirect to course-related topics.";
            
            String jsonRequest = "{"
                + "\"contents\": [{"
                    + "\"parts\": [{"
                        + "\"text\": \"" + escapeJson(systemPrompt) + "\""
                    + "}]"
                + "}]"
            + "}";
            
            return sendRequest(jsonRequest);
            
        } catch (Exception e) {
            e.printStackTrace();
            return "Sorry, I encountered an error. Please try again.";
        }
    }
    
    /**
     * Send HTTP request to Gemini API
     */
    private static String sendRequest(String jsonPayload) throws Exception {
        
        String apiKey = getApiKey();
        if (apiKey == null || apiKey.isEmpty()) {
            return "WARNING: Please configure your Gemini API key:\n\n" +
                   "1. Go to: https://aistudio.google.com/app/apikey\n" +
                   "2. Create an API key\n" +
                   "3. Add it to src/config.properties: gemini.api.key=YOUR_KEY\n" +
                   "4. Or set environment variable: GEMINI_API_KEY=YOUR_KEY";
        }
        
        URL url = new URL(GEMINI_API_URL + "?key=" + apiKey);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);
        
        // Send request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonPayload.getBytes("utf-8");
            os.write(input, 0, input.length);
        }
        
        // Read response
        int responseCode = conn.getResponseCode();
        InputStream inputStream = responseCode >= 200 && responseCode < 300 
                                ? conn.getInputStream() 
                                : conn.getErrorStream();
                                
        try (BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, "utf-8"))) {
            StringBuilder response = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            
            if (responseCode >= 200 && responseCode < 300) {
                return parseGeminiResponse(response.toString());
            } else {
                System.err.println("Gemini API Error: " + response.toString());
                return "Sorry, I'm having trouble connecting to the AI service. Response code: " + responseCode;
            }
        }
    }
    
    /**
     * Parse Gemini API response to extract text content
     */
    private static String parseGeminiResponse(String jsonResponse) {
        try {
            JSONObject response = new JSONObject(jsonResponse);
            JSONArray candidates = response.getJSONArray("candidates");
            
            if (candidates.length() > 0) {
                JSONObject candidate = candidates.getJSONObject(0);
                JSONObject content = candidate.getJSONObject("content");
                JSONArray parts = content.getJSONArray("parts");
                
                if (parts.length() > 0) {
                    JSONObject part = parts.getJSONObject(0);
                    return part.getString("text");
                }
            }
            
            return "Sorry, I couldn't generate a response.";
            
        } catch (Exception e) {
            e.printStackTrace();
            return "Error parsing AI response: " + e.getMessage();
        }
    }
    
    /**
     * Escape JSON special characters
     */
    private static String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
    
    /**
     * Test method to verify JSON library is working
     */
    public static String testJsonLibrary() {
        try {
            JSONObject test = new JSONObject();
            test.put("message", "JSON library is working!");
            test.put("timestamp", System.currentTimeMillis());
            return "SUCCESS: JSON Library Test Passed: " + test.toString();
        } catch (Exception e) {
            return "ERROR: JSON Library Test Failed: " + e.getMessage();
        }
    }
} 