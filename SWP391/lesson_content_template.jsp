<!-- ADD THIS AFTER NAVIGATION BUTTONS AND BEFORE COMMENTS SECTION -->

<!-- Lesson Content Section (Reading Materials) -->
<c:if test="${not empty currentLesson.contentText}">
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <!-- Content Header -->
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center">
                <i class="fas fa-book-open text-blue-600 text-xl mr-3"></i>
                <h3 class="text-xl font-bold text-gray-800">Reading: Chunking</h3>
            </div>
            <div class="flex items-center text-sm text-gray-600">
                <i class="fas fa-clock mr-1"></i>
                <span>15 min read</span>
            </div>
        </div>
        
        <!-- Learning Objectives -->
        <c:if test="${not empty currentLesson.learningObjectives}">
            <div class="mb-6 bg-blue-50 rounded-lg p-4">
                <h4 class="font-semibold text-blue-800 mb-3 flex items-center">
                    <i class="fas fa-target mr-2"></i>
                    What You'll Learn
                </h4>
                <div class="text-blue-700 whitespace-pre-line">
                    ${currentLesson.learningObjectives}
                </div>
            </div>
        </c:if>
        
        <!-- Main Content -->
        <div class="prose max-w-none mb-6">
            ${currentLesson.contentText}
        </div>
        
        <!-- References Section -->
        <c:if test="${not empty currentLesson.references}">
            <div class="border-t pt-6">
                <h4 class="font-semibold text-gray-800 mb-3 flex items-center">
                    <i class="fas fa-bookmark mr-2"></i>
                    Worthwhile Additional Popular Works
                </h4>
                <div class="bg-gray-50 rounded-lg p-4">
                    <div class="text-gray-700 whitespace-pre-line">
                        ${currentLesson.references}
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- Content Type Badge -->
        <div class="flex justify-between items-center mt-6 pt-4 border-t">
            <div class="text-sm text-gray-600">
                Content Type: 
                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                    <i class="fas fa-layer-group mr-1"></i> Mixed Content
                </span>
            </div>
            
            <button class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                <i class="fas fa-print mr-1"></i>
                Print Reading
            </button>
        </div>
    </div>
</c:if> 