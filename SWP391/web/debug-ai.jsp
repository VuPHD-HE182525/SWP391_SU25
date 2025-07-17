<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="utils.AppConfig, utils.GeminiService" %>

<!DOCTYPE html>
<html>
<head>
    <title>AI Debug</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .pass { background: #d4edda; border-color: #c3e6cb; }
        .fail { background: #f8d7da; border-color: #f5c6cb; }
        .loading { background: #fff3cd; border-color: #ffeaa7; }
    </style>
</head>
<body>
    <h1>🔍 AI Assistant Debug</h1>
    
    <!-- Test 1: Check AppConfig -->
    <div class="test">
        <h3>Test 1: AppConfig Loading</h3>
        <%
            try {
                String apiKey = AppConfig.getGeminiApiKey();
                boolean isConfigured = AppConfig.isConfigured();
                
                out.println("<p><strong>API Key:</strong> " + 
                           (apiKey != null ? apiKey.substring(0, 10) + "..." : "NULL") + "</p>");
                out.println("<p><strong>Is Configured:</strong> " + isConfigured + "</p>");
                
                if (isConfigured) {
                    out.println("<p style='color: green;'>✅ AppConfig is working</p>");
                } else {
                    out.println("<p style='color: red;'>❌ AppConfig failed</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ AppConfig Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </div>
    
    <!-- Test 2: Simple AI Call -->
    <div class="test">
        <h3>Test 2: Direct GeminiService Call</h3>
        <%
            try {
                String testMessage = "Hello, can you respond with just 'AI is working'?";
                String aiResponse = GeminiService.simpleChat(testMessage);
                
                out.println("<p><strong>Request:</strong> " + testMessage + "</p>");
                out.println("<p><strong>Response:</strong> " + aiResponse + "</p>");
                
                if (aiResponse != null && !aiResponse.contains("Error") && !aiResponse.contains("sorry")) {
                    out.println("<p style='color: green;'>✅ GeminiService is working</p>");
                } else {
                    out.println("<p style='color: red;'>❌ GeminiService failed</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ GeminiService Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </div>
    
    <!-- Test 3: Check if classes exist -->
    <div class="test">
        <h3>Test 3: Class Loading</h3>
        <%
            try {
                Class<?> appConfigClass = Class.forName("utils.AppConfig");
                Class<?> geminiServiceClass = Class.forName("utils.GeminiService");
                
                out.println("<p>✅ AppConfig class found: " + appConfigClass.getName() + "</p>");
                out.println("<p>✅ GeminiService class found: " + geminiServiceClass.getName() + "</p>");
                
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ Class loading error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
    
    <!-- Test 4: JSON Library -->
    <div class="test">
        <h3>Test 4: JSON Library</h3>
        <%
            try {
                org.json.JSONObject test = new org.json.JSONObject();
                test.put("test", "working");
                out.println("<p>✅ JSON Library: " + test.toString() + "</p>");
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ JSON Library Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
    
    <!-- Test 5: Check config file path -->
    <div class="test">
        <h3>Test 5: Config File Path</h3>
        <%
            try {
                java.net.URL configUrl = application.getClass().getClassLoader().getResource("config.properties");
                if (configUrl != null) {
                    out.println("<p>✅ Config file found at: " + configUrl.getPath() + "</p>");
                } else {
                    out.println("<p style='color: red;'>❌ Config file NOT found in classpath</p>");
                    out.println("<p>Expected location: src/config.properties</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>❌ Config path error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
    
    <div style="margin-top: 30px;">
        <a href="lesson-view?lessonId=10">← Back to Lesson</a> | 
        <a href="ai-chat">Test AI Chat Servlet</a>
    </div>

</body>
</html> 