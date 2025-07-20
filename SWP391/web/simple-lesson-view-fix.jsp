<!-- Simple Comments & Reviews Section - Replace in lesson_view.jsp -->

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
    
    <!-- Comments Tab Content -->
    <div id="commentsContent" class="tab-content">
        <h3 class="text-xl font-bold text-gray-800 mb-4">Comments</h3>
        
        <!-- Add Comment Form -->
        <form action="lesson-view" method="post" class="mb-6">
            <input type="hidden" name="action" value="addComment">
            <input type="hidden" name="lessonId" value="${currentLesson.id}">
            <div class="flex space-x-4">
                <img src="${currentUser.avatarUrl != null ? currentUser.avatarUrl : '/uploads/images/default-avatar.svg'}" 
                     alt="Your Avatar" class="w-10 h-10 rounded-full">
                <div class="flex-1">
                    <textarea name="commentText" rows="3" 
                            class="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            placeholder="Your comment here"></textarea>
                    <button type="submit" 
                            class="mt-3 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                        Submit
                    </button>
                </div>
            </div>
        </form>
        
        <!-- Comments List -->
        <div class="space-y-4">
            <c:forEach items="${comments}" var="comment">
                <div class="flex space-x-4 border-b border-gray-200 pb-4">
                    <img src="${comment.userAvatarUrl != null ? comment.userAvatarUrl : '/uploads/images/default-avatar.svg'}" 
                         alt="${comment.userFullName}" class="w-10 h-10 rounded-full">
                    <div class="flex-1">
                        <div class="flex items-center space-x-2 mb-1">
                            <span class="font-semibold text-gray-800">${comment.userFullName}</span>
                            <span class="text-sm text-gray-500">${comment.createdAt}</span>
                        </div>
                        <p class="text-gray-700">${comment.commentText}</p>
                        
                        <!-- Edit/Delete for comment owner -->
                        <c:if test="${comment.userId == currentUser.id}">
                            <div class="mt-2 flex space-x-2">
                                <button onclick="editComment(this)" 
                                        data-comment-id="${comment.id}" 
                                        data-comment-text="${comment.commentText}"
                                        class="text-sm text-blue-600 hover:text-blue-800">
                                    <i class="fas fa-edit mr-1"></i>Edit
                                </button>
                                <form action="lesson-view" method="post" style="display: inline;" 
                                      onsubmit="return confirm('Delete this comment?')">
                                    <input type="hidden" name="action" value="deleteComment">
                                    <input type="hidden" name="lessonId" value="${currentLesson.id}">
                                    <input type="hidden" name="commentId" value="${comment.id}">
                                    <button type="submit" class="text-sm text-red-600 hover:text-red-800">
                                        <i class="fas fa-trash mr-1"></i>Delete
                                    </button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty comments}">
                <div class="text-center py-8 text-gray-500">
                    <i class="fas fa-comments text-4xl mb-3 opacity-30"></i>
                    <p>No comments yet. Be the first to comment!</p>
                </div>
            </c:if>
        </div>
    </div>
    
    <!-- Reviews Tab Content -->
    <div id="reviewsContent" class="tab-content hidden">
        <h3 class="text-xl font-bold text-gray-800 mb-6">Student feedback</h3>
        
        <!-- Rating Summary -->
        <div class="flex items-start space-x-8 mb-8">
            <!-- Overall Rating -->
            <div class="text-center">
                <div class="text-5xl font-bold text-orange-500 mb-2">
                    <c:choose>
                        <c:when test="${ratingStats.averageRating != null && ratingStats.averageRating > 0}">
                            ${ratingStats.averageRating}
                        </c:when>
                        <c:otherwise>
                            0.0
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="flex justify-center mb-1">
                    <c:forEach begin="1" end="5" var="star">
                        <c:choose>
                            <c:when test="${ratingStats.averageRating >= star}">
                                <i class="fas fa-star text-orange-500"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="far fa-star text-gray-300"></i>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <div class="text-sm text-orange-600 font-semibold">Lesson Rating</div>
            </div>
            
            <!-- Rating Breakdown -->
            <div class="flex-1">
                <c:forEach begin="1" end="5" var="starLevel">
                    <c:set var="percentage" value="${ratingStats.ratingPercentages[6-starLevel]}" />
                    <c:if test="${percentage == null}">
                        <c:set var="percentage" value="0" />
                    </c:if>
                    
                    <div class="flex items-center mb-2">
                        <!-- Stars -->
                        <div class="flex mr-3">
                            <c:forEach begin="1" end="${6-starLevel}" var="filledStar">
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                            </c:forEach>
                            <c:forEach begin="${7-starLevel}" end="5" var="emptyStar">
                                <i class="far fa-star text-gray-300 text-sm"></i>
                            </c:forEach>
                        </div>
                        
                        <!-- Progress Bar -->
                        <div class="flex-1 bg-gray-200 rounded-full h-2 mr-3">
                            <div class="bg-gray-400 h-2 rounded-full" style="width: ${percentage}%"></div>
                        </div>
                        
                        <!-- Percentage -->
                        <div class="text-sm text-gray-600 w-8">
                            ${percentage}%
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        
        <!-- Reviews List -->
        <div class="border-t pt-6">
            <h4 class="text-lg font-bold text-gray-800 mb-4">Reviews</h4>
            
            <div class="space-y-4">
                <c:choose>
                    <c:when test="${not empty ratings}">
                        <c:forEach items="${ratings}" var="rating">
                            <div class="border-b border-gray-200 py-4">
                                <div class="flex items-start space-x-4">
                                    <img src="${rating.userAvatar != null ? rating.userAvatar : '/uploads/images/default-avatar.svg'}" 
                                         alt="${rating.userName}" class="w-12 h-12 rounded-full">
                                    
                                    <div class="flex-1">
                                        <div class="flex items-center justify-between mb-2">
                                            <div class="flex items-center space-x-2">
                                                <span class="font-semibold text-gray-800">${rating.userName}</span>
                                                <div class="flex">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <c:choose>
                                                            <c:when test="${star <= rating.rating}">
                                                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="far fa-star text-gray-300 text-sm"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <span class="text-sm text-gray-500">
                                                ${rating.createdAt != null ? rating.createdAt : 'Recently'}
                                            </span>
                                        </div>
                                        
                                        <c:if test="${not empty rating.reviewText}">
                                            <p class="text-gray-700">${rating.reviewText}</p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-8 text-gray-500">
                            <i class="fas fa-comments text-4xl mb-3 opacity-30"></i>
                            <p>There are no written comments for this course yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
// Tab Switching System
function switchTab(tabName) {
    // Remove active class from all tabs
    document.querySelectorAll('.tab-button').forEach(button => {
        button.classList.remove('active', 'border-blue-500', 'text-blue-600');
        button.classList.add('border-transparent', 'text-gray-500');
    });
    
    // Hide all tab contents
    document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.add('hidden');
    });
    
    // Show selected tab content and activate button
    if (tabName === 'comments') {
        document.getElementById('commentsContent').classList.remove('hidden');
        const commentsTab = document.getElementById('commentsTab');
        commentsTab.classList.add('active', 'border-blue-500', 'text-blue-600');
        commentsTab.classList.remove('border-transparent', 'text-gray-500');
    } else if (tabName === 'reviews') {
        document.getElementById('reviewsContent').classList.remove('hidden');
        const reviewsTab = document.getElementById('reviewsTab');
        reviewsTab.classList.add('active', 'border-blue-500', 'text-blue-600');
        reviewsTab.classList.remove('border-transparent', 'text-gray-500');
    }
}

// Edit comment function
function editComment(button) {
    const commentId = button.getAttribute('data-comment-id');
    const commentText = button.getAttribute('data-comment-text');
    
    const newText = prompt('Edit your comment:', commentText);
    if (newText && newText.trim() !== '' && newText !== commentText) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'lesson-view';
        
        form.innerHTML = `
            <input type="hidden" name="action" value="editComment">
            <input type="hidden" name="lessonId" value="${currentLesson.id}">
            <input type="hidden" name="commentId" value="${commentId}">
            <input type="hidden" name="commentText" value="${newText}">
        `;
        
        document.body.appendChild(form);
        form.submit();
    }
}
</script> 