<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reading: Active Listening Fundamentals - ELearning</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-50">
    <!-- Include Header -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />
    <div class="flex min-h-screen pt-16">
        <!-- Main Content Area -->
        <div class="flex-1 p-6">
            <!-- Course Title and Info -->
            <div class="mb-6">
                <div class="flex items-center text-sm text-gray-600 mb-2">
                    <a href="course-list" class="hover:text-blue-600">Courses</a>
                    <i class="fas fa-chevron-right mx-2"></i>
                    <span class="text-gray-800">Reading: Active Listening Fundamentals</span>
                </div>
                <h1 class="text-3xl font-bold text-gray-800 mb-2">Reading: Active Listening Fundamentals</h1>
                <div class="flex items-center">
                    <i class="fas fa-clock text-gray-500 mr-1"></i>
                    <span class="text-gray-600 mr-4">15 min read</span>
                </div>
            </div>
            <!-- Navigation Buttons -->
            <div class="flex justify-between mb-6">
                <a href="lesson-view?lessonId=2" class="nav-button flex items-center px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors">
                    <i class="fas fa-chevron-left mr-2"></i>
                    Previous: Video 2
                </a>
                <a href="lesson-view?lessonId=3" class="nav-button flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                    Next Lesson
                    <i class="fas fa-chevron-right ml-2"></i>
                </a>
            </div>
            <!-- Reading Content Section (Reading Materials) -->
            <div class="bg-white rounded-lg shadow-lg p-6 mb-6 border border-gray-200">
                <!-- Content Header -->
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center">
                        <i class="fas fa-book-open text-blue-600 text-xl mr-3"></i>
                        <h3 class="text-xl font-bold text-gray-800">Reading Materials</h3>
                    </div>
                    <div class="flex items-center text-sm text-gray-600">
                        <i class="fas fa-clock mr-1"></i>
                        <span>15 min read</span>
                    </div>
                </div>
                <!-- Learning Objectives -->
                <div class="mb-6 bg-blue-50 rounded-lg p-4">
                    <h4 class="font-semibold text-blue-800 mb-3 flex items-center">
                        <i class="fas fa-target mr-2"></i>
                        What You'll Learn
                    </h4>
                    <div class="text-blue-700">
                        <ul class="list-disc list-inside space-y-1">
                            <li>Understand the principles of active listening</li>
                            <li>Learn key techniques for effective listening</li>
                            <li>Identify common barriers to active listening</li>
                            <li>Practice active listening skills through exercises</li>
                            <li>Apply active listening in professional and personal contexts</li>
                        </ul>
                    </div>
                </div>
                <!-- Main Content -->
                <div class="prose max-w-none mb-6">
                    <h2>Active Listening Fundamentals</h2>
                    <p>Active listening is a crucial skill in effective communication. It involves fully concentrating, understanding, responding, and remembering what is being said.</p>
                    <h3>Key Components of Active Listening</h3>
                    <ul>
                        <li><strong>Give Full Attention:</strong> Focus completely on the speaker without distractions</li>
                        <li><strong>Show That You are Listening:</strong> Use body language and verbal cues to demonstrate engagement</li>
                        <li><strong>Provide Feedback:</strong> Reflect on what you have heard to ensure understanding</li>
                        <li><strong>Defer Judgment:</strong> Allow the speaker to finish before forming opinions</li>
                        <li><strong>Respond Appropriately:</strong> Give thoughtful responses that show comprehension</li>
                    </ul>
                    <h3>Benefits of Active Listening</h3>
                    <p>Active listening helps build trust, reduces conflicts, and improves relationships. It is essential in professional settings, personal relationships, and educational environments.</p>
                    <h3>Practice Exercise</h3>
                    <p>Try this with a partner:</p>
                    <ol>
                        <li>One person speaks for 2 minutes about a topic they care about</li>
                        <li>The other practices active listening techniques</li>
                        <li>The listener summarizes what they heard</li>
                        <li>Switch roles and discuss the experience</li>
                    </ol>
                    <h3>Common Barriers to Active Listening</h3>
                    <ul>
                        <li><strong>Distractions:</strong> Phone, noise, multitasking</li>
                        <li><strong>Prejudgment:</strong> Forming opinions before hearing the full message</li>
                        <li><strong>Emotional Reactions:</strong> Getting defensive or upset</li>
                        <li><strong>Mental Preparation:</strong> Thinking about your response instead of listening</li>
                    </ul>
                    <h3>Techniques for Better Listening</h3>
                    <ul>
                        <li><strong>Paraphrasing:</strong> "What I hear you saying is..."</li>
                        <li><strong>Asking Questions:</strong> "Can you help me understand..."</li>
                        <li><strong>Summarizing:</strong> "Let me make sure I understand the main points..."</li>
                        <li><strong>Reflecting Feelings:</strong> "It sounds like you're feeling..."</li>
                    </ul>
                </div>
                <!-- Progress Indicator -->
                <div class="flex justify-between items-center mt-6 pt-4 border-t">
                    <div class="text-sm text-gray-600">
                        Content Type: 
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                            <i class="fas fa-book mr-1"></i> Reading
                        </span>
                    </div>
                    <button class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                        <i class="fas fa-print mr-1"></i>
                        Print Reading
                    </button>
                </div>
            </div>
            <!-- Comments & Reviews Section with Tabs (copy from lesson_view.jsp) -->
            <div class="bg-white rounded-lg shadow-lg p-6 border border-gray-200">
                <div class="border-b border-gray-200 mb-6">
                    <nav class="-mb-px flex space-x-8">
                        <button id="commentsTab" class="tab-button active border-b-2 border-blue-500 py-2 px-1 text-sm font-medium text-blue-600" onclick="switchTab('comments')">
                            <i class="fas fa-comments mr-2"></i>
                            Comments
                        </button>
                        <button id="reviewsTab" class="tab-button border-b-2 border-transparent py-2 px-1 text-sm font-medium text-gray-500 hover:text-gray-700 hover:border-gray-300" onclick="switchTab('reviews')">
                            <i class="fas fa-star mr-2"></i>
                            Reviews
                        </button>
                    </nav>
                </div>
                <!-- Comments Tab Content -->
                <div id="commentsContent" class="tab-content">
                    <h3 class="text-xl font-bold text-gray-800 mb-4">Comments</h3>
                    <form action="lesson-view" method="post" enctype="multipart/form-data" class="mb-6" id="commentForm">
                        <input type="hidden" name="action" value="addComment">
                        <input type="hidden" name="lessonId" value="15">
                        <div class="flex space-x-4">
                            <img src="${currentUser.avatarUrl != null ? currentUser.avatarUrl : '/uploads/images/default-avatar.svg'}" alt="Your Avatar" class="w-10 h-10 rounded-full">
                            <div class="flex-1">
                                <textarea name="commentText" rows="3" class="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="Your comment here"></textarea>
                                <div class="mt-3 space-y-3">
                                    <div class="flex items-center space-x-3">
                                        <label for="mediaFile" class="cursor-pointer">
                                            <div class="flex items-center space-x-2 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                                                <i class="fas fa-paperclip text-gray-500"></i>
                                                <span class="text-sm text-gray-600">Attach Media</span>
                                            </div>
                                        </label>
                                        <input type="file" id="mediaFile" name="mediaFile" accept="image/*,video/*" class="hidden" onchange="handleFileSelect(this)">
                                        <span class="text-xs text-gray-500">Supports: JPG, PNG, GIF, MP4, AVI</span>
                                    </div>
                                    <div id="filePreview" class="hidden">
                                        <div class="flex items-center space-x-3 p-3 bg-gray-50 rounded-lg">
                                            <div id="previewContent" class="flex-1"></div>
                                            <button type="button" onclick="removeFile()" class="text-red-500 hover:text-red-700">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="mt-3 flex space-x-3">
                                    <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">Submit</button>
                                    <button type="button" onclick="clearForm()" class="px-6 py-2 border border-gray-300 text-gray-600 rounded-lg hover:bg-gray-50 transition-colors">Clear</button>
                                </div>
                            </div>
                        </div>
                    </form>
                    <div class="space-y-4">
                        <c:forEach items="${comments}" var="comment">
                            <div class="flex space-x-4 border-b border-gray-200 pb-4">
                                <img src="${comment.userAvatarUrl != null ? comment.userAvatarUrl : '/uploads/images/default-avatar.svg'}" alt="${comment.userFullName}" class="w-10 h-10 rounded-full">
                                <div class="flex-1">
                                    <div class="flex items-center space-x-2 mb-1">
                                        <span class="font-semibold text-gray-800">${comment.userFullName}</span>
                                        <span class="text-sm text-gray-500">${comment.createdAt}</span>
                                        <c:if test="${not empty comment.mediaType}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                <i class="fas ${comment.mediaType == 'image' ? 'fa-image' : 'fa-video'} mr-1"></i>
                                                ${comment.mediaType}
                                            </span>
                                        </c:if>
                                    </div>
                                    <p class="text-gray-700">${comment.commentText}</p>
                                    <c:if test="${not empty comment.mediaPath}">
                                        <div class="mt-3">
                                            <c:choose>
                                                <c:when test="${comment.mediaType == 'image'}">
                                                    <img src="${comment.mediaPath}" alt="Comment image" class="max-w-md rounded-lg shadow-sm cursor-pointer hover:opacity-90 transition-opacity" onclick="openMediaModal('${comment.mediaPath}', 'image')">
                                                </c:when>
                                                <c:when test="${comment.mediaType == 'video'}">
                                                    <video controls class="max-w-md rounded-lg shadow-sm">
                                                        <source src="${comment.mediaPath}" type="video/mp4">
                                                        Your browser does not support the video tag.
                                                    </video>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                    <c:if test="${comment.userId == currentUser.id}">
                                        <div class="mt-2 flex space-x-2">
                                            <button onclick="editComment(this)" data-comment-id="${comment.id}" data-comment-text="${comment.commentText}" class="text-sm text-blue-600 hover:text-blue-800">
                                                <i class="fas fa-edit mr-1"></i>Edit
                                            </button>
                                            <form action="lesson-view" method="post" style="display: inline;" onsubmit="return confirm('Delete this comment?')">
                                                <input type="hidden" name="action" value="deleteComment">
                                                <input type="hidden" name="lessonId" value="15">
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
                                        <c:when test="${ratingStats.averageRating >= (star - 0.5)}">
                                            <i class="fas fa-star-half-alt text-orange-500"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star text-gray-300"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <div class="text-sm text-orange-600 font-semibold">Lesson Rating</div>
                        </div>
                        <div class="flex-1 flex items-center justify-end">
                            <button id="ratingBtn" onclick="showRatingModal()" class="flex items-center px-4 py-2 border-2 border-orange-500 text-orange-500 rounded-lg hover:bg-orange-500 hover:text-white transition-colors">
                                <i class="fas fa-star mr-2"></i>
                                Leave a rating
                            </button>
                        </div>
                    </div>
                    <!-- Reviews Section -->
                    <div class="border-t pt-6">
                        <h4 class="text-lg font-bold text-gray-800 mb-4">Reviews</h4>
                        <div id="reviewsList">
                            <c:choose>
                                <c:when test="${not empty ratings}">
                                    <c:forEach items="${ratings}" var="rating">
                                        <div class="review-item border-b border-gray-200 py-4" data-rating="${rating.rating}">
                                            <div class="flex items-start space-x-4">
                                                <img src="${rating.userAvatar != null ? rating.userAvatar : '/uploads/images/default-avatar.svg'}" alt="${rating.userName}" class="w-12 h-12 rounded-full">
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
                                                        <p class="text-gray-700 review-text">${rating.reviewText}</p>
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
        </div>
        <!-- Course Content Sidebar (copy structure from lesson_view.jsp, static for now) -->
        <div class="w-80 bg-white shadow-lg course-sidebar border border-gray-200 rounded-lg">
            <div class="p-6">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Course content</h3>
                <div class="space-y-2">
                    <div class="border border-gray-200 rounded-lg overflow-hidden">
                        <div class="section-header text-white px-4 py-3">
                            <h4 class="font-semibold">Section 1: Introduction</h4>
                        </div>
                        <div class="bg-gray-50">
                            <div class="lesson-item px-4 py-3 border-b border-gray-200 cursor-pointer" onclick="location.href='lesson-view?lessonId=1'">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-3">
                                        <i class="fas fa-play text-red-600 text-sm mr-1"></i>
                                        <span class="text-sm font-medium text-gray-800">Video 1: What is AI?</span>
                                    </div>
                                    <div class="text-xs text-gray-500">12 min</div>
                                </div>
                            </div>
                            <div class="lesson-item px-4 py-3 border-b border-gray-200 cursor-pointer" onclick="location.href='lesson-view?lessonId=2'">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-3">
                                        <i class="fas fa-play text-red-600 text-sm mr-1"></i>
                                        <span class="text-sm font-medium text-gray-800">Video 2: Giải quyết xung đột</span>
                                    </div>
                                    <div class="text-xs text-gray-500">18 min</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="border border-gray-200 rounded-lg overflow-hidden">
                        <div class="section-header text-white px-4 py-3">
                            <h4 class="font-semibold">Section 2: Advanced Topics</h4>
                        </div>
                        <div class="bg-gray-50">
                            <div class="lesson-item reading px-4 py-3 border-b border-gray-200 cursor-pointer current" onclick="location.href='lesson-15-direct.jsp'">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-3">
                                        <i class="fas fa-book text-blue-600 text-sm mr-1"></i>
                                        <span class="text-sm font-medium text-gray-800">Reading: Active Listening Fundamentals</span>
                                    </div>
                                    <div class="text-xs text-gray-500">15 min</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Include AI Chat Assistant -->
    <jsp:include page="/WEB-INF/views/includes/ai_chat.jsp" />
    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    <!-- Rating Modal -->
    <div id="ratingModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-lg font-semibold text-gray-900">Rate this lesson</h3>
                    <button onclick="hideRatingModal()" class="text-gray-400 hover:text-gray-600">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <form id="ratingForm" action="lesson-view" method="post">
                    <input type="hidden" name="action" value="addRating">
                    <input type="hidden" name="lessonId" value="15">
                    <input type="hidden" name="rating" id="selectedRating" value="0">
                    <!-- Star Rating -->
                    <div class="mb-4">
                        <p class="text-sm text-gray-600 mb-2">How would you rate this lesson?</p>
                        <div class="flex space-x-1" id="starRating">
                            <i class="fas fa-star text-2xl text-gray-300 cursor-pointer hover:text-yellow-400" data-rating="1"></i>
                            <i class="fas fa-star text-2xl text-gray-300 cursor-pointer hover:text-yellow-400" data-rating="2"></i>
                            <i class="fas fa-star text-2xl text-gray-300 cursor-pointer hover:text-yellow-400" data-rating="3"></i>
                            <i class="fas fa-star text-2xl text-gray-300 cursor-pointer hover:text-yellow-400" data-rating="4"></i>
                            <i class="fas fa-star text-2xl text-gray-300 cursor-pointer hover:text-yellow-400" data-rating="5"></i>
                        </div>
                        <p class="text-sm text-gray-500 mt-1" id="ratingText">Click to rate</p>
                    </div>
                    <!-- Review Text -->
                    <div class="mb-4">
                        <label for="reviewText" class="block text-sm font-medium text-gray-700 mb-2">
                            Write a review (optional)
                        </label>
                        <textarea name="reviewText" id="reviewText" rows="3" class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="Share your thoughts about this lesson..."></textarea>
                    </div>
                    <!-- Buttons -->
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="hideRatingModal()" class="px-4 py-2 text-gray-600 border border-gray-300 rounded-md hover:bg-gray-50">Cancel</button>
                        <button type="submit" id="submitRating" disabled class="px-4 py-2 bg-orange-500 text-white rounded-md hover:bg-orange-600 disabled:bg-gray-300 disabled:cursor-not-allowed">Submit Rating</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tab Switching System
        function switchTab(tabName) {
            document.querySelectorAll('.tab-button').forEach(button => {
                button.classList.remove('active', 'border-blue-500', 'text-blue-600');
                button.classList.add('border-transparent', 'text-gray-500');
            });
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.add('hidden');
            });
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
        // File handling functions (for comment media)
        function handleFileSelect(input) {
            const file = input.files[0];
            if (!file) return;
            const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'video/mp4', 'video/avi', 'video/mov'];
            if (!allowedTypes.includes(file.type)) {
                alert('Please select a valid image (JPG, PNG, GIF) or video (MP4, AVI, MOV) file.');
                input.value = '';
                return;
            }
            if (file.size > 10 * 1024 * 1024) {
                alert('File size must be less than 10MB.');
                input.value = '';
                return;
            }
            const preview = document.getElementById('filePreview');
            const previewContent = document.getElementById('previewContent');
            if (file.type.startsWith('image/')) {
                const img = document.createElement('img');
                img.src = URL.createObjectURL(file);
                img.className = 'max-w-xs rounded-lg';
                img.alt = 'Preview';
                previewContent.innerHTML = '';
                previewContent.appendChild(img);
            } else if (file.type.startsWith('video/')) {
                const video = document.createElement('video');
                video.src = URL.createObjectURL(file);
                video.className = 'max-w-xs rounded-lg';
                video.controls = true;
                video.muted = true;
                previewContent.innerHTML = '';
                previewContent.appendChild(video);
            }
            preview.classList.remove('hidden');
        }
        function removeFile() {
            document.getElementById('mediaFile').value = '';
            document.getElementById('filePreview').classList.add('hidden');
            document.getElementById('previewContent').innerHTML = '';
        }
        function clearForm() {
            document.getElementById('commentForm').reset();
            removeFile();
        }
        // Rating Modal Functions
        function showRatingModal() {
            document.getElementById('ratingModal').classList.remove('hidden');
            document.body.style.overflow = 'hidden';
        }
        function hideRatingModal() {
            document.getElementById('ratingModal').classList.add('hidden');
            document.body.style.overflow = 'auto';
            resetRating();
        }
        function resetRating() {
            const stars = document.querySelectorAll('#starRating i');
            stars.forEach(star => {
                star.classList.remove('text-yellow-400');
                star.classList.add('text-gray-300');
            });
            document.getElementById('selectedRating').value = '0';
            document.getElementById('ratingText').textContent = 'Click to rate';
            document.getElementById('submitRating').disabled = true;
            document.getElementById('reviewText').value = '';
        }
        // Star Rating System
        const stars = document.querySelectorAll('#starRating i');
        const ratingText = document.getElementById('ratingText');
        const submitBtn = document.getElementById('submitRating');
        const ratingInput = document.getElementById('selectedRating');
        const ratingLabels = {
            1: 'Poor - Not helpful',
            2: 'Fair - Somewhat helpful',
            3: 'Good - Helpful',
            4: 'Very Good - Very helpful',
            5: 'Excellent - Extremely helpful'
        };
        stars.forEach((star, index) => {
            // Hover effect
            star.addEventListener('mouseenter', function() {
                const rating = parseInt(this.getAttribute('data-rating'));
                highlightStars(rating);
                ratingText.textContent = ratingLabels[rating];
            });
            // Click effect
            star.addEventListener('click', function() {
                const rating = parseInt(this.getAttribute('data-rating'));
                ratingInput.value = rating;
                highlightStars(rating);
                ratingText.textContent = ratingLabels[rating];
                submitBtn.disabled = false;
                submitBtn.classList.remove('disabled:bg-gray-300', 'disabled:cursor-not-allowed');
            });
        });
        document.getElementById('starRating').addEventListener('mouseleave', function() {
            const currentRating = parseInt(ratingInput.value);
            if (currentRating > 0) {
                highlightStars(currentRating);
                ratingText.textContent = ratingLabels[currentRating];
            } else {
                resetStars();
                ratingText.textContent = 'Click to rate';
            }
        });
        function highlightStars(rating) {
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.remove('text-gray-300');
                    star.classList.add('text-yellow-400');
                } else {
                    star.classList.remove('text-yellow-400');
                    star.classList.add('text-gray-300');
                }
            });
        }
        function resetStars() {
            stars.forEach(star => {
                star.classList.remove('text-yellow-400');
                star.classList.add('text-gray-300');
            });
        }
    </script>
</body>
</html>
