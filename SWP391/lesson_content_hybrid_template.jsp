<!-- HYBRID CONTENT APPROACH TEMPLATE -->
<!-- ADD THIS TO YOUR lesson_view.jsp AFTER NAVIGATION BUTTONS -->

<!-- Lesson Content Section (Reading Materials) -->
<c:if test="${not empty currentLesson.contentFilePath}">
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <!-- Content Header -->
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center">
                <i class="fas fa-book-open text-blue-600 text-xl mr-3"></i>
                <h3 class="text-xl font-bold text-gray-800">Reading: ${currentLesson.name}</h3>
            </div>
            <div class="flex items-center text-sm text-gray-600">
                <i class="fas fa-clock mr-1"></i>
                <span>${currentLesson.estimatedTime > 0 ? currentLesson.estimatedTime : '15'} min read</span>
            </div>
        </div>
        
        <!-- Learning Objectives -->
        <c:if test="${not empty currentLesson.objectivesFilePath}">
            <div class="mb-6 bg-blue-50 rounded-lg p-4">
                <h4 class="font-semibold text-blue-800 mb-3 flex items-center">
                    <i class="fas fa-target mr-2"></i>
                    What You'll Learn
                </h4>
                <div class="text-blue-700">
                    <!-- Load objectives from file -->
                    <jsp:include page="${currentLesson.objectivesFilePath}" />
                </div>
            </div>
        </c:if>
        
        <!-- Main Content from File -->
        <div class="prose max-w-none mb-6">
            <!-- Load main content from HTML file -->
            <jsp:include page="${currentLesson.contentFilePath}" />
        </div>
        
        <!-- References Section -->
        <c:if test="${not empty currentLesson.referencesFilePath}">
            <div class="border-t pt-6">
                <h4 class="font-semibold text-gray-800 mb-3 flex items-center">
                    <i class="fas fa-bookmark mr-2"></i>
                    Additional References
                </h4>
                <div class="bg-gray-50 rounded-lg p-4">
                    <!-- Load references from file -->
                    <jsp:include page="${currentLesson.referencesFilePath}" />
                </div>
            </div>
        </c:if>
        
        <!-- Content Type Badge -->
        <div class="flex justify-between items-center mt-6 pt-4 border-t">
            <div class="text-sm text-gray-600">
                Content Type: 
                <c:choose>
                    <c:when test="${currentLesson.contentType == 'video'}">
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                            <i class="fas fa-play mr-1"></i> Video
                        </span>
                    </c:when>
                    <c:when test="${currentLesson.contentType == 'reading'}">
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                            <i class="fas fa-book mr-1"></i> Reading
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                            <i class="fas fa-layer-group mr-1"></i> Mixed Content
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <button class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                <i class="fas fa-print mr-1"></i>
                Print Reading
            </button>
        </div>
    </div>
</c:if>

<!-- Alternative: Load content with Java utility in servlet -->
<!--
In your LessonViewServlet.java:

// Load content from files
String webAppPath = request.getServletContext().getRealPath("/");
if (currentLesson.getContentFilePath() != null) {
    String content = ContentLoaderUtil.loadHtmlContent(webAppPath, currentLesson.getContentFilePath());
    request.setAttribute("lessonContent", content);
}
if (currentLesson.getObjectivesFilePath() != null) {
    String objectives = ContentLoaderUtil.loadMarkdownContent(webAppPath, currentLesson.getObjectivesFilePath());
    request.setAttribute("lessonObjectives", objectives);
}

Then in JSP use:
${lessonContent}
${lessonObjectives}
--> 