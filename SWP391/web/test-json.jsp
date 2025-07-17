<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.json.JSONObject" %>

<!DOCTYPE html>
<html>
<head>
    <title>JSON Library Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .success { color: green; background: #e8f5e8; padding: 15px; border-radius: 5px; }
        .error { color: red; background: #ffe8e8; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>JSON Library Test</h1>
    
    <%
        try {
            // Test JSON library
            JSONObject test = new JSONObject();
            test.put("message", "JSON library is working!");
            test.put("timestamp", System.currentTimeMillis());
            test.put("status", "success");
            
            out.println("<div class='success'>");
            out.println("<h3>✅ JSON Library Test PASSED</h3>");
            out.println("<p><strong>Result:</strong> " + test.toString() + "</p>");
            out.println("</div>");
            
        } catch (Exception e) {
            out.println("<div class='error'>");
            out.println("<h3>❌ JSON Library Test FAILED</h3>");
            out.println("<p><strong>Error:</strong> " + e.getMessage() + "</p>");
            out.println("<p><strong>Class not found:</strong> Make sure json-20250517.jar is in WEB-INF/lib/</p>");
            out.println("</div>");
        }
    %>
    
    <h3>Next Steps:</h3>
    <ul>
        <li>If test passes → We can proceed with Gemini API</li>
        <li>If test fails → Need to fix JSON library setup</li>
    </ul>
    
    <p><a href="lesson-view?lessonId=10">← Back to Lesson</a></p>
</body>
</html> 