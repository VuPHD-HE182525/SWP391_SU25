package utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class AppConfig {
    
    private static Properties properties = new Properties();
    private static boolean loaded = false;
    
    static {
        loadConfig();
    }
    
    private static void loadConfig() {
        try {
            // Try to load from external config first
            InputStream inputStream = AppConfig.class.getClassLoader()
                    .getResourceAsStream("config.properties");
            
            if (inputStream != null) {
                properties.load(inputStream);
                inputStream.close();
                loaded = true;
                System.out.println("Config loaded successfully from config.properties");
            } else {
                System.err.println("Warning: config.properties not found, using fallback");
                loadFallbackConfig();
            }
            
        } catch (IOException e) {
            System.err.println("Error loading config: " + e.getMessage());
            loadFallbackConfig();
        }
    }
    
    private static void loadFallbackConfig() {
        // Fallback to environment variables or system properties
        String geminiKey = System.getenv("GEMINI_API_KEY");
        if (geminiKey == null) {
            geminiKey = System.getProperty("gemini.api.key");
        }
        
        if (geminiKey != null) {
            properties.setProperty("gemini.api.key", geminiKey);
            loaded = true;
            System.out.println("Config loaded from environment variables");
        } else {
            System.err.println("⚠️ WARNING: No API key found! Please configure properly.");
        }
    }
    
    public static String getGeminiApiKey() {
        String key = properties.getProperty("gemini.api.key");
        if (key == null || key.trim().isEmpty()) {
            return null;
        }
        return key.trim();
    }
    
    public static boolean isConfigured() {
        return loaded && getGeminiApiKey() != null;
    }
    
    public static String getDatabaseUrl() {
        return properties.getProperty("database.url", "jdbc:mysql://localhost:3306/swp391");
    }
    
    public static String getDatabaseUser() {
        return properties.getProperty("database.user", "root");
    }
    
    public static String getDatabasePassword() {
        return properties.getProperty("database.password", "");
    }
} 