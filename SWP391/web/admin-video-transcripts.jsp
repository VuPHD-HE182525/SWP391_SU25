<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="DAO.VideoTranscriptDAO, model.VideoTranscript, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <title>Video Transcripts Management</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { background: #2563eb; color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .card { background: white; border: 1px solid #e5e7eb; border-radius: 8px; padding: 20px; margin-bottom: 20px; }
        .table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .table th, .table td { padding: 12px; text-align: left; border-bottom: 1px solid #e5e7eb; }
        .table th { background: #f9fafb; font-weight: 600; }
        .status { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 500; }
        .status-completed { background: #d1fae5; color: #065f46; }
        .status-pending { background: #fef3c7; color: #92400e; }
        .status-processing { background: #dbeafe; color: #1e40af; }
        .status-failed { background: #fee2e2; color: #991b1b; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-primary { background: #2563eb; color: white; }
        .btn-success { background: #059669; color: white; }
        .btn-danger { background: #dc2626; color: white; }
        .btn-secondary { background: #6b7280; color: white; }
        .stats { display: flex; gap: 20px; margin-bottom: 20px; }
        .stat-card { flex: 1; background: #f8fafc; padding: 20px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #2563eb; }
        .transcript-preview { max-width: 300px; max-height: 100px; overflow: hidden; text-overflow: ellipsis; }
        .search-box { margin-bottom: 20px; }
        .search-input { padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 4px; width: 300px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎥 Video Transcripts Management</h1>
            <p>AI-powered video transcript analysis and management system</p>
        </div>

        <%
            VideoTranscriptDAO transcriptDAO = new VideoTranscriptDAO();
            List<VideoTranscript> allTranscripts = null;
            
            // Get statistics
            int totalTranscripts = 0;
            int completedTranscripts = 0;
            int pendingTranscripts = 0;
            int failedTranscripts = 0;
            
            try {
                allTranscripts = transcriptDAO.getAllTranscripts();
                totalTranscripts = allTranscripts.size();
                
                for (VideoTranscript transcript : allTranscripts) {
                    switch (transcript.getStatus()) {
                        case "completed": completedTranscripts++; break;
                        case "pending": pendingTranscripts++; break;
                        case "failed": failedTranscripts++; break;
                    }
                }
            } catch (Exception e) {
                out.println("<div style='color: red;'>Error loading transcripts: " + e.getMessage() + "</div>");
            }
        %>

        <!-- Statistics -->
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number"><%= totalTranscripts %></div>
                <div>Total Videos</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= completedTranscripts %></div>
                <div>Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= pendingTranscripts %></div>
                <div>Pending</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= failedTranscripts %></div>
                <div>Failed</div>
            </div>
        </div>

        <!-- Actions -->
        <div class="card">
            <h3>Actions</h3>
            <a href="process-videos?action=processAll" class="btn btn-primary">Process All Pending Videos</a>
            <a href="process-videos?action=reprocessFailed" class="btn btn-secondary">Reprocess Failed Videos</a>
            <a href="lesson-view?lessonId=10" class="btn btn-success">Test AI Assistant</a>
        </div>

        <!-- Search -->
        <div class="search-box">
            <form method="get" action="">
                <input type="text" name="search" class="search-input" placeholder="Search transcripts..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn btn-primary">Search</button>
                <% if (request.getParameter("search") != null) { %>
                    <a href="?" class="btn btn-secondary">Clear</a>
                <% } %>
            </form>
        </div>

        <!-- Transcripts Table -->
        <div class="card">
            <h3>Video Transcripts</h3>
            
            <% if (allTranscripts != null && !allTranscripts.isEmpty()) { %>
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Lesson</th>
                            <th>Video Path</th>
                            <th>Status</th>
                            <th>Duration</th>
                            <th>Size</th>
                            <th>Key Topics</th>
                            <th>Transcript Preview</th>
                            <th>Processed</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String searchQuery = request.getParameter("search");
                            List<VideoTranscript> transcriptsToShow = allTranscripts;
                            
                            // Filter by search if provided
                            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                                try {
                                    transcriptsToShow = transcriptDAO.searchTranscripts(searchQuery);
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='10' style='color: red;'>Search error: " + e.getMessage() + "</td></tr>");
                                }
                            }
                            
                            for (VideoTranscript transcript : transcriptsToShow) {
                        %>
                        <tr>
                            <td><%= transcript.getId() %></td>
                            <td>Lesson <%= transcript.getLessonId() %></td>
                            <td><%= transcript.getVideoPath() %></td>
                            <td>
                                <span class="status status-<%= transcript.getStatus() %>">
                                    <%= transcript.getStatus().toUpperCase() %>
                                </span>
                            </td>
                            <td><%= transcript.getFormattedDuration() %></td>
                            <td><%= transcript.getFormattedFileSize() %></td>
                            <td><%= transcript.getKeyTopics() != null ? transcript.getKeyTopics().substring(0, Math.min(50, transcript.getKeyTopics().length())) + "..." : "N/A" %></td>
                            <td class="transcript-preview">
                                <%= transcript.getTranscript() != null ? transcript.getTranscript().substring(0, Math.min(100, transcript.getTranscript().length())) + "..." : "N/A" %>
                            </td>
                            <td><%= transcript.getProcessedAt() != null ? transcript.getProcessedAt().toString().substring(0, 16) : "N/A" %></td>
                            <td>
                                <a href="view-transcript?id=<%= transcript.getId() %>" class="btn btn-primary" style="font-size: 12px;">View</a>
                                <% if (transcript.hasFailed() || transcript.getStatus().equals("pending")) { %>
                                    <a href="process-videos?action=reprocess&id=<%= transcript.getId() %>" class="btn btn-secondary" style="font-size: 12px;">Reprocess</a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p>No video transcripts found. 
                   <a href="create_video_transcripts_table.sql">Run the SQL script first</a> to create the table and sample data.
                </p>
            <% } %>
        </div>

        <!-- Instructions -->
        <div class="card">
            <h3>📝 Instructions</h3>
            <ol>
                <li><strong>Setup Database:</strong> Run the SQL script <code>create_video_transcripts_table.sql</code> first</li>
                <li><strong>Test AI Assistant:</strong> Go to any lesson and click the AI button to test enhanced responses</li>
                <li><strong>Process Videos:</strong> Use "Process All Pending Videos" to analyze video content with Gemini AI</li>
                <li><strong>Enhanced Context:</strong> AI will now use actual video transcripts for more accurate responses</li>
            </ol>
            
            <h4>🚀 Next Steps:</h4>
            <ul>
                <li>Real-time video processing with Gemini Vision API</li>
                <li>Vector embeddings for semantic search</li>
                <li>Automatic timestamp generation</li>
                <li>Quiz generation from video content</li>
            </ul>
        </div>

        <div style="margin-top: 30px; text-align: center;">
            <a href="lesson-view?lessonId=10">← Back to Lesson</a> | 
            <a href="debug-ai.jsp">Debug AI</a> |
            <a href="gemini-test.jsp">Test Gemini</a>
        </div>
    </div>

</body>
</html> 