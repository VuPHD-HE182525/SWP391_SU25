<!-- CLEAN LESSON VIEW - COPY THIS TO RESTORE LESSON_VIEW.JSP -->

<!-- Remove the broken content section from line 202-277 and replace with this simple version: -->

            </div>
            
            <!-- Comments & Reviews Section with Tabs -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <!-- Tab Navigation -->
                <div class="border-b border-gray-200 mb-6">
                    <nav class="-mb-px flex space-x-8">
                        <button id="commentsTab" 
                                class="tab-button active border-b-2 border-blue-500 py-2 px-1 text-sm font-medium text-blue-600"
                                onclick="switchTab('comments')">
                            <i class="fas fa-comments mr-2"></i>
                            Comments
                            <span class="ml-1 bg-gray-100 text-gray-900 py-0.5 px-2 rounded-full text-xs">
                                ${fn:length(comments)}
                            </span>
                        </button>
                        <button id="reviewsTab" 
                                class="tab-button border-b-2 border-transparent py-2 px-1 text-sm font-medium text-gray-500 hover:text-gray-700 hover:border-gray-300"
                                onclick="switchTab('reviews')">
                            <i class="fas fa-star mr-2"></i>
                            Reviews
                            <span class="ml-1 bg-gray-100 text-gray-900 py-0.5 px-2 rounded-full text-xs">
                                ${ratingStats.totalRatings != null ? ratingStats.totalRatings : 0}
                            </span>
                        </button>
                    </nav>
                </div>

<!-- INSTRUCTIONS TO FIX:
1. In your lesson_view.jsp, find line around 202: 
   "<!-- Lesson Content Section (Reading Materials) -->"
   
2. DELETE everything from that line until you find:
   "<!-- Comments & Reviews Section with Tabs -->"
   
3. Make sure the Navigation Buttons section ends with:
   </div>
   
4. Then copy the Comments section above to restore comments and reviews

This will restore your working comments, reviews, and sidebar!
--> 