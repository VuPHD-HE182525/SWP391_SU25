<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="utils.GeminiService" %>

<!DOCTYPE html>
<html>
<head>
    <title>Gemini API Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .test-section { margin: 20px 0; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }
        .success { background: #e8f5e8; border-color: #4caf50; }
        .loading { background: #fff3cd; border-color: #ffc107; }
        .error { background: #f8d7da; border-color: #dc3545; }
        .chat-response { background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 10px 0; }
        button { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background: #0056b3; }
        input[type="text"] { width: 300px; padding: 8px; margin: 5px; border: 1px solid #ddd; border-radius: 4px; }
    </style>
</head>
<body>
    <h1>🤖 Gemini AI Assistant Test</h1>
    
    <!-- Test 1: Simple Chat -->
    <div class="test-section">
        <h3>Test 1: Simple Chat</h3>
        <p>Testing basic Gemini API functionality...</p>
        
        <%
            String testResult = "";
            String testMessage = "Hello! Can you help me understand Java variables?";
            
            try {
                testResult = GeminiService.simpleChat(testMessage);
            } catch (Exception e) {
                testResult = "Error: " + e.getMessage();
            }
        %>
        
        <div class="chat-response">
            <strong>Question:</strong> <%= testMessage %><br><br>
            <strong>AI Response:</strong><br>
            <%= testResult.replace("\n", "<br>") %>
        </div>
    </div>
    
    <!-- Test 2: Interactive Chat -->
    <div class="test-section">
        <h3>Test 2: Interactive Chat</h3>
        <form action="gemini-test.jsp" method="post">
            <input type="text" name="userQuestion" placeholder="Ask a question about programming..." 
                   value="<%= request.getParameter("userQuestion") != null ? request.getParameter("userQuestion") : "" %>">
            <button type="submit">Ask AI</button>
        </form>
        
        <%
            String userQuestion = request.getParameter("userQuestion");
            if (userQuestion != null && !userQuestion.trim().isEmpty()) {
                try {
                    String aiResponse = GeminiService.simpleChat(userQuestion);
        %>
        
        <div class="chat-response">
            <strong>Your Question:</strong> <%= userQuestion %><br><br>
            <strong>AI Response:</strong><br>
            <%= aiResponse.replace("\n", "<br>") %>
        </div>
        
        <%
                } catch (Exception e) {
        %>
        <div class="chat-response error">
            <strong>Error:</strong> <%= e.getMessage() %>
        </div>
        <%
                }
            }
        %>
    </div>
    
    <!-- Test 3: Context-Aware Chat (Simulated) -->
    <div class="test-section">
        <h3>Test 3: Context-Aware Chat</h3>
        <p>Testing with mock video context about Java programming...</p>
        
        <%
            String mockVideoContext = "This video covers Java variables and data types. " +
                                    "Topics include: int, String, boolean, double, variable declaration, " +
                                    "initialization, and best practices for naming variables.";
            
            String contextQuestion = "What are the main data types covered in this lesson?";
            String contextResponse = "";
            
            try {
                contextResponse = GeminiService.chatWithContext(contextQuestion, mockVideoContext);
            } catch (Exception e) {
                contextResponse = "Error: " + e.getMessage();
            }
        %>
        
        <div style="background: #e3f2fd; padding: 10px; border-radius: 5px; margin: 10px 0;">
            <strong>Mock Video Context:</strong><br>
            <%= mockVideoContext %>
        </div>
        
        <div class="chat-response">
            <strong>Question:</strong> <%= contextQuestion %><br><br>
            <strong>Context-Aware Response:</strong><br>
            <%= contextResponse.replace("\n", "<br>") %>
        </div>
    </div>
    
    <!-- Navigation -->
    <div style="margin-top: 30px;">
        <a href="lesson-view?lessonId=10">← Back to Lesson</a> | 
        <a href="test-json.jsp">JSON Test</a>
    </div>
    
    <%
        // Auto-scroll to bottom if there's a response
        if (userQuestion != null && !userQuestion.trim().isEmpty()) {
            out.println("<script>window.scrollTo(0, document.body.scrollHeight);</script>");
        }
    %>

</body>
</html> 