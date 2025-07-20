<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${currentLesson.name} - ${course.title}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Resolve Bootstrap and Tailwind conflicts */
        .container { max-width: 1200px; }
        .btn { display: inline-block; }
        
        .course-sidebar {
            height: calc(100vh - 120px);
            overflow-y: auto;
        }
        .video-container {
            position: relative;
            width: 100%;
            height: 0;
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
        }
        .video-container video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        .lesson-item {
            transition: all 0.3s ease;
        }
        .lesson-item:hover {
            background-color: #f3f4f6;
        }
        .lesson-item.current {
            background-color: #dbeafe;
            border-left: 4px solid #3b82f6;
        }
        .section-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        /* Responsive Video Styles */
        .video-container {
            position: relative;
            width: 100%;
            aspect-ratio: 16/9;
            overflow: hidden;
        }
        
        .video-container video {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        @media (max-width: 768px) {
            .video-container {
                aspect-ratio: 16/9;
                margin: 0 -1rem;
                border-radius: 0;
            }
            
            .video-container video {
                border-radius: 0;
            }
        }
        
        /* FIXED: Enhanced Reading Content Styles - Override any conflicts */
        .lesson-item {
            transition: all 0.3s ease !important;
            border-left: 3px solid transparent !important;
            pointer-events: auto !important;
            cursor: pointer !important;
            position: relative !important;
            z-index: 1000 !important;
            display: block !important;
            background: transparent !important;
        }
        
        .lesson-item:hover {
            background-color: #f8fafc !important;
            transform: translateX(4px) !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
        }
        
        .lesson-item.current {
            background-color: #eff6ff !important;
            border-left: 3px solid #3b82f6 !important;
            font-weight: 600 !important;
        }
        
        .lesson-item.reading {
            border-left: 3px solid #10b981 !important;
        }
        
        .lesson-item.reading.current {
            background-color: #f0fdf4 !important;
            border-left: 3px solid #10b981 !important;
        }
        
        /* FIX: Force reading lesson highlight */
        .lesson-item[onclick*="navigateToLesson(15)"].current {
            background-color: #f0fdf4 !important;
            border-left: 3px solid #10b981 !important;
            font-weight: 600 !important;
        }
        
        /* FIX: Alternative selector for reading lesson */
        .lesson-item[data-lesson-id="15"].current {
            background-color: #f0fdf4 !important;
            border-left: 3px solid #10b981 !important;
            font-weight: 600 !important;
        }
        
        /* Ensure sidebar is interactive */
        .course-sidebar {
            position: relative !important;
            z-index: 100 !important;
        }
        
        /* Fix any overlay issues */
        .course-sidebar * {
            pointer-events: auto !important;
        }
        
        .prose h2 {
            color: #1f2937;
            margin-bottom: 1rem;
        }
        
        .prose h3 {
            color: #374151;
            margin-top: 1.5rem;
            margin-bottom: 0.75rem;
        }
        
        .reading-animation {
            animation: slideInUp 0.5s ease-out;
        }
        
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Navigation Button Enhancements */
        .nav-button {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .nav-button:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .nav-button:hover:before {
            left: 100%;
        }
        
        /* Smooth Scrolling */
        html {
            scroll-behavior: smooth;
        }
    </style>
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
                    <a href="course-details?id=${course.id}" class="hover:text-blue-600">${course.title}</a>
                    <i class="fas fa-chevron-right mx-2"></i>
                    <span class="text-gray-800">${currentLesson.name}</span>
                </div>
                <h1 class="text-3xl font-bold text-gray-800 mb-2">${course.title}</h1>
                <div class="flex items-center">
                    <i class="fas fa-star text-yellow-400 mr-1"></i>
                    <span class="text-gray-600 mr-4">4.5</span>
                    <i class="fas fa-users text-gray-500 mr-1"></i>
                    <span class="text-gray-600 mr-4">3,500 Students</span>
                    <i class="fas fa-clock text-gray-500 mr-1"></i>
                    <span class="text-gray-600 mr-4">2.5 Hours</span>
                    <i class="fas fa-globe text-gray-500 mr-1"></i>
                    <span class="text-gray-600">Language: English</span>
                </div>
            </div>
            
            <!-- Video Player -->
            <div class="bg-white rounded-lg shadow-lg mb-6">
                <div class="video-container bg-black rounded-t-lg">
                    <c:choose>
                        <c:when test="${not empty currentLesson.videoLink}">
                            <video id="lessonVideo" controls class="rounded-t-lg">
                                <c:choose>
                                    <c:when test="${currentLesson.videoLink == 'lesson1.mp4' || currentLesson.videoLink == 'video1.mp4'}">
                                        <source src="${pageContext.request.contextPath}/video/lesson1.mp4" type="video/mp4">
                                    </c:when>
                                    <c:when test="${currentLesson.videoLink == 'lesson2.mp4' || currentLesson.videoLink == 'video2.mp4'}">
                                        <source src="${pageContext.request.contextPath}/video/lesson2.mp4" type="video/mp4">
                                    </c:when>
                                    <c:when test="${currentLesson.videoLink == 'lesson3.mp4' || currentLesson.videoLink == 'video3.mp4'}">
                                        <source src="${pageContext.request.contextPath}/video/lesson3.mp4" type="video/mp4">
                                    </c:when>
                                    <c:when test="${currentLesson.videoLink == 'lesson4.mp4' || currentLesson.videoLink == 'video4.mp4'}">
                                        <source src="${pageContext.request.contextPath}/video/lesson4.mp4" type="video/mp4">
                                    </c:when>
                                    <c:otherwise>
                                        <source src="${pageContext.request.contextPath}/video/${currentLesson.videoLink}" type="video/mp4">
                                    </c:otherwise>
                                </c:choose>
                                Your browser does not support the video tag.
                            </video>
                        </c:when>
                        <c:otherwise>
                            <div class="absolute inset-0 flex items-center justify-center bg-gray-800 text-white rounded-t-lg">
                                <div class="text-center">
                                    <i class="fas fa-play-circle text-6xl mb-4 opacity-50"></i>
                                    <p class="text-lg">No video available for this lesson</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Lesson Title and Info -->
                <div class="p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-2">${currentLesson.name}</h2>

                    <div class="flex items-center justify-between">
                        <div class="flex items-center justify-between w-full">
                            <div class="flex items-center space-x-4">
                                <span class="text-sm text-gray-600">Last updated January 2024</span>
                                <button id="markCompleteBtn" class="flex items-center px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors">
                                    <i class="fas fa-check-circle mr-2"></i>
                                    <span id="markCompleteText">
                                        <c:choose>
                                            <c:when test="${progressMap[currentLesson.id] != null && progressMap[currentLesson.id].completed}">
                                                Completed
                                            </c:when>
                                            <c:otherwise>
                                                Mark as Complete
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </button>
                            </div>
                            
                            <!-- Action Buttons Section -->
                            <div class="flex items-center space-x-4">
                                <!-- Take Quiz Button (if quiz exists for this lesson) -->
                                <c:if test="${currentLesson.quizId != null && currentLesson.quizId > 0}">
                                    <a href="quiz?action=view&quizId=${currentLesson.quizId}" 
                                       class="flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                        <i class="fas fa-clipboard-question mr-2"></i>
                                        Take Quiz
                                    </a>
                                </c:if>
                                
                                <!-- Leave a Rating Button -->
                                <button id="ratingBtn" onclick="showRatingModal()" 
                                        class="flex items-center px-4 py-2 border-2 border-orange-500 text-orange-500 rounded-lg hover:bg-orange-500 hover:text-white transition-colors">
                                    <i class="fas fa-star mr-2"></i>
                                    Leave a rating
                                </button>
                                
                                <!-- Get Certificate Button (placeholder) -->
                                <button class="flex items-center px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors">
                                    <i class="fas fa-certificate mr-2"></i>
                                    Get certificate
                                    <i class="fas fa-chevron-down ml-2"></i>
                                </button>
                                
                                <!-- Share Button -->
                                <button class="flex items-center px-3 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                                    <i class="fas fa-share mr-2"></i>
                                    Share
                                </button>
                                

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Navigation Buttons -->
            <div class="flex justify-between mb-6">
                <c:if test="${previousLesson != null}">
                    <a href="lesson-view?lessonId=${previousLesson.id}" 
                       class="nav-button flex items-center px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors">
                        <i class="fas fa-chevron-left mr-2"></i>
                        Previous Chap
                    </a>
                </c:if>
                <c:if test="${previousLesson == null}">
                    <div></div>
                </c:if>
                
                <!-- Enhanced Next Navigation -->
                <c:choose>
                    <c:when test="${currentLesson.id == 2 || currentLesson.id == 4}">
                        <!-- Special case: Last video in section → navigate to reading -->
                        <button onclick="console.log('Next Reading clicked!'); navigateToLesson(15);" 
                               class="nav-button flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                            Next: Reading
                            <i class="fas fa-chevron-right ml-2"></i>
                        </button>
                    </c:when>
                    <c:when test="${nextLesson != null}">
                        <a href="lesson-view?lessonId=${nextLesson.id}" 
                           class="nav-button flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                            Next Chap
                            <i class="fas fa-chevron-right ml-2"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <div></div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Lesson Content Section (Reading Materials) -->
            <c:if test="${not empty currentLesson.contentFilePath or not empty currentLesson.objectivesFilePath or not empty currentLesson.referencesFilePath}">
                <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
                    <!-- Content Header -->
                    <div class="flex items-center justify-between mb-6">
                        <div class="flex items-center">
                            <i class="fas fa-book-open text-blue-600 text-xl mr-3"></i>
                            <h3 class="text-xl font-bold text-gray-800">Reading Materials</h3>
                        </div>
                        <div class="flex items-center text-sm text-gray-600">
                            <i class="fas fa-clock mr-1"></i>
                            <span>${currentLesson.estimatedTime > 0 ? currentLesson.estimatedTime : '15'} min read</span>
                        </div>
                    </div>
                    
                    <!-- Learning Objectives -->
                    <c:if test="${not empty currentLesson.learningObjectives}">
                        <div class="mb-6 bg-blue-50 rounded-lg p-4">
                            <h4 class="font-semibold text-blue-800 mb-3 flex items-center">
                                <i class="fas fa-target mr-2"></i>
                                Learning Objectives
                            </h4>
                            <div class="text-blue-700">
                                ${fn:replace(currentLesson.learningObjectives, "•", "<li>")}
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Main Content -->
                    <c:if test="${not empty currentLesson.contentText}">
                        <div class="prose max-w-none mb-6">
                            ${currentLesson.contentText}
                        </div>
                    </c:if>
                    
                    <!-- References and Additional Resources -->
                    <c:if test="${not empty currentLesson.references}">
                        <div class="border-t pt-6">
                            <h4 class="font-semibold text-gray-800 mb-3 flex items-center">
                                <i class="fas fa-bookmark mr-2"></i>
                                Additional References
                            </h4>
                            <div class="bg-gray-50 rounded-lg p-4">
                                <div class="text-gray-700 whitespace-pre-line">
                                    ${currentLesson.references}
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Progress Indicator -->
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
                    <form action="lesson-view" method="post" enctype="multipart/form-data" class="mb-6" id="commentForm">
                        <input type="hidden" name="action" value="addComment">
                        <input type="hidden" name="lessonId" value="${currentLesson.id}">
                        <div class="flex space-x-4">
                            <img src="${currentUser.avatarUrl != null ? currentUser.avatarUrl : '/uploads/images/default-avatar.svg'}" 
                                 alt="Your Avatar" class="w-10 h-10 rounded-full">
                            <div class="flex-1">
                                <textarea name="commentText" rows="3" 
                                        class="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                        placeholder="Your comment here"></textarea>
                                
                                <!-- Media Upload Section -->
                                <div class="mt-3 space-y-3">
                                    <!-- File Upload -->
                                    <div class="flex items-center space-x-3">
                                        <label for="mediaFile" class="cursor-pointer">
                                            <div class="flex items-center space-x-2 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                                                <i class="fas fa-paperclip text-gray-500"></i>
                                                <span class="text-sm text-gray-600">Attach Media</span>
                                            </div>
                                        </label>
                                        <input type="file" id="mediaFile" name="mediaFile" accept="image/*,video/*" 
                                               class="hidden" onchange="handleFileSelect(this)">
                                        <span class="text-xs text-gray-500">Supports: JPG, PNG, GIF, MP4, AVI</span>
                                    </div>
                                    
                                    <!-- File Preview -->
                                    <div id="filePreview" class="hidden">
                                        <div class="flex items-center space-x-3 p-3 bg-gray-50 rounded-lg">
                                            <div id="previewContent" class="flex-1"></div>
                                            <button type="button" onclick="removeFile()" 
                                                    class="text-red-500 hover:text-red-700">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-3 flex space-x-3">
                                    <button type="submit" 
                                            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                        Submit
                                    </button>
                                    <button type="button" onclick="clearForm()" 
                                            class="px-6 py-2 border border-gray-300 text-gray-600 rounded-lg hover:bg-gray-50 transition-colors">
                                        Clear
                                    </button>
                                </div>
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
                                        <c:if test="${not empty comment.mediaType}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                <i class="fas ${comment.mediaType == 'image' ? 'fa-image' : 'fa-video'} mr-1"></i>
                                                ${comment.mediaType}
                                            </span>
                                        </c:if>
                                    </div>
                                    <p class="text-gray-700">${comment.commentText}</p>
                                    
                                    <!-- Media Display -->
                                    <c:if test="${not empty comment.mediaPath}">
                                        <div class="mt-3">
                                            <c:choose>
                                                <c:when test="${comment.mediaType == 'image'}">
                                                    <img src="${comment.mediaPath}" alt="Comment image" 
                                                         class="max-w-md rounded-lg shadow-sm cursor-pointer hover:opacity-90 transition-opacity"
                                                         onclick="openMediaModal('${comment.mediaPath}', 'image')">
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
                    
                    <!-- Rating Breakdown -->
                    <div class="flex-1">
                        <%
                            // Calculate rating breakdown directly using SQL
                            java.util.Map<Integer, Double> percentages = new java.util.HashMap<>();
                            try {
                                // Get lesson ID from request attribute
                                model.Lesson currentLesson = (model.Lesson) request.getAttribute("currentLesson");
                                int lessonId = currentLesson.getId();
                                
                                java.sql.Connection conn = utils.DBContext.getConnection();
                                
                                // Get total count first
                                java.sql.PreparedStatement ps1 = conn.prepareStatement(
                                    "SELECT COUNT(*) as total FROM lesson_ratings WHERE lesson_id = ?"
                                );
                                ps1.setInt(1, lessonId);
                                java.sql.ResultSet rs1 = ps1.executeQuery();
                                int totalRatings = 0;
                                if (rs1.next()) {
                                    totalRatings = rs1.getInt("total");
                                }
                                
                                // Initialize all percentages to 0
                                for (int i = 1; i <= 5; i++) {
                                    percentages.put(i, 0.0);
                                }
                                
                                // Get rating breakdown if there are ratings
                                if (totalRatings > 0) {
                                    java.sql.PreparedStatement ps2 = conn.prepareStatement(
                                        "SELECT rating, COUNT(*) as count FROM lesson_ratings WHERE lesson_id = ? GROUP BY rating"
                                    );
                                    ps2.setInt(1, lessonId);
                                    java.sql.ResultSet rs2 = ps2.executeQuery();
                                    
                                    while (rs2.next()) {
                                        int rating = rs2.getInt("rating");
                                        int count = rs2.getInt("count");
                                        double percentage = (count * 100.0) / totalRatings;
                                        percentages.put(rating, Math.round(percentage * 10.0) / 10.0);
                                    }
                                }
                                
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                                // Initialize with default values on error
                                for (int i = 1; i <= 5; i++) {
                                    percentages.put(i, 0.0);
                                }
                            }
                        %>
                        
                        <!-- 5 Stars -->
                        <div class="flex items-center mb-2">
                            <div class="flex mr-3">
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                            </div>
                            <div class="flex-1 bg-gray-200 rounded-full h-2 mr-3">
                                <div class="bg-gray-400 h-2 rounded-full" style="width: <%= percentages.get(5) %>%"></div>
                            </div>
                            <div class="text-sm text-gray-600 w-8">
                                <%= percentages.get(5) %>%
                            </div>
                        </div>
                        
                        <!-- 4 Stars -->
                        <div class="flex items-center mb-2">
                            <div class="flex mr-3">
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                            </div>
                            <div class="flex-1 bg-gray-200 rounded-full h-2 mr-3">
                                <div class="bg-gray-400 h-2 rounded-full" style="width: <%= percentages.get(4) %>%"></div>
                            </div>
                            <div class="text-sm text-gray-600 w-8">
                                <%= percentages.get(4) %>%
                            </div>
                        </div>
                        
                        <!-- 3 Stars -->
                        <div class="flex items-center mb-2">
                            <div class="flex mr-3">
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                            </div>
                            <div class="flex-1 bg-gray-200 rounded-full h-2 mr-3">
                                <div class="bg-gray-400 h-2 rounded-full" style="width: <%= percentages.get(3) %>%"></div>
                            </div>
                            <div class="text-sm text-gray-600 w-8">
                                <%= percentages.get(3) %>%
                            </div>
                        </div>
                        
                        <!-- 2 Stars -->
                        <div class="flex items-center mb-2">
                            <div class="flex mr-3">
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                            </div>
                            <div class="flex-1 bg-gray-200 rounded-full h-2 mr-3">
                                <div class="bg-gray-400 h-2 rounded-full" style="width: <%= percentages.get(2) %>%"></div>
                            </div>
                            <div class="text-sm text-gray-600 w-8">
                                <%= percentages.get(2) %>%
                            </div>
                        </div>
                        
                        <!-- 1 Star -->
                        <div class="flex items-center mb-2">
                            <div class="flex mr-3">
                                <i class="fas fa-star text-orange-500 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                                <i class="far fa-star text-gray-300 text-sm"></i>
                            </div>
                            <div class="flex-1 bg-gray-200 rounded-full h-2 mr-3">
                                <div class="bg-gray-400 h-2 rounded-full" style="width: <%= percentages.get(1) %>%"></div>
                            </div>
                            <div class="text-sm text-gray-600 w-8">
                                <%= percentages.get(1) %>%
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Reviews Section -->
                <div class="border-t pt-6">
                    <h4 class="text-lg font-bold text-gray-800 mb-4">Reviews</h4>
                    
                    <!-- Search and Filter -->
                    <div class="flex space-x-4 mb-6">
                        <!-- Search Reviews -->
                        <div class="flex-1 relative">
                            <input type="text" id="reviewSearch" 
                                   placeholder="Search reviews" 
                                   class="w-full border border-gray-300 rounded-lg px-4 py-2 pr-10 focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <button class="absolute right-2 top-2 bg-purple-600 text-white px-3 py-1 rounded">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                        
                        <!-- Filter Ratings -->
                        <div class="relative">
                            <select id="ratingFilter" class="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                <option value="">All ratings</option>
                                <option value="5">5 stars</option>
                                <option value="4">4 stars</option>
                                <option value="3">3 stars</option>
                                <option value="2">2 stars</option>
                                <option value="1">1 star</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Reviews List -->
                    <div id="reviewsList">
                        <c:choose>
                            <c:when test="${not empty ratings}">
                                <c:forEach items="${ratings}" var="rating">
                                    <div class="review-item border-b border-gray-200 py-4" data-rating="${rating.rating}">
                                        <div class="flex items-start space-x-4">
                                            <!-- User Avatar -->
                                            <img src="${rating.userAvatar != null ? rating.userAvatar : '/uploads/images/default-avatar.svg'}" 
                                                 alt="${rating.userName}" class="w-12 h-12 rounded-full">
                                            
                                            <!-- Review Content -->
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
        
        <!-- Course Content Sidebar -->
        <div class="w-80 bg-white shadow-lg course-sidebar">
            <div class="p-6">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Course content</h3>
                
                <!-- Course Sections -->
                <div class="space-y-2">
                    <!-- Section 1: Introduction -->
                    <div class="border border-gray-200 rounded-lg overflow-hidden">
                        <div class="section-header text-white px-4 py-3">
                            <h4 class="font-semibold">Section 1: Introduction</h4>
                        </div>
                        <div class="bg-gray-50">
                            <c:forEach items="${courseLessons}" var="lesson" varStatus="status">
                                <c:if test="${lesson.type == 'video' && status.index < 3}">
                                    <div class="lesson-item px-4 py-3 border-b border-gray-200 cursor-pointer ${lesson.id == currentLesson.id ? 'current' : ''}"
                                         onclick="console.log('Section 1 video clicked, ID:', ${lesson.id}); navigateToLesson(${lesson.id})"
                                         data-lesson-id="${lesson.id}"
                                         style="pointer-events: auto !important; position: relative !important; z-index: 1000 !important;">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <i class="fas fa-play text-red-600 text-sm mr-1"></i>
                                                <span class="text-sm font-medium text-gray-800">
                                                    Video ${status.index + 1}: ${lesson.name}
                                                </span>
                                            </div>
                                            <div class="text-xs text-gray-500">
                                                ${status.index + 1 == 1 ? '12' : status.index + 1 == 2 ? '18' : '15'} min
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <!-- Section 2: Advanced Topics -->
                    <div class="border border-gray-200 rounded-lg overflow-hidden">
                        <div class="section-header text-white px-4 py-3">
                            <h4 class="font-semibold">Section 2: Advanced Topics</h4>
                        </div>
                        <div class="bg-gray-50">
                            <!-- Reading Lessons from Database -->
                            <c:forEach items="${courseLessons}" var="lesson" varStatus="status">
                                <c:if test="${not empty lesson.contentFilePath or not empty lesson.objectivesFilePath}">
                                    <div class="lesson-item px-4 py-3 border-b border-gray-200 cursor-pointer ${lesson.id == currentLesson.id ? 'current' : ''}"
                                         onclick="navigateToLesson(${lesson.id}); console.log('Database reading lesson clicked, ID:', ${lesson.id})">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <i class="fas fa-book text-blue-600 text-sm mr-1"></i>
                                                <span class="text-sm font-medium text-gray-800">
                                                    Reading: ${lesson.title}
                                                </span>
                                            </div>
                                            <div class="text-xs text-gray-500">${lesson.estimatedTime > 0 ? lesson.estimatedTime : 15} min</div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            
                            <!-- Fallback: Hardcoded Reading Lesson if none found -->
                            <div class="lesson-item reading px-4 py-3 border-b border-gray-200 cursor-pointer"
                                 onclick="console.log('Section 2 reading clicked, ID: 15'); navigateToLesson(15)"
                                 data-lesson-id="15"
                                 style="pointer-events: auto !important; position: relative !important; z-index: 1000 !important;">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-3">
                                        <i class="fas fa-book text-blue-600 text-sm mr-1"></i>
                                        <span class="text-sm font-medium text-gray-800">
                                            Reading: Active Listening Fundamentals
                                        </span>
                                    </div>
                                    <div class="text-xs text-gray-500">15 min</div>
                                </div>
                            </div>
                            
                            <!-- Video Lessons -->
                            <c:forEach items="${courseLessons}" var="lesson" varStatus="status">
                                <c:if test="${lesson.type == 'video' && status.index >= 3}">
                                    <div class="lesson-item px-4 py-3 border-b border-gray-200 cursor-pointer ${lesson.id == currentLesson.id ? 'current' : ''}"
                                         onclick="navigateToLesson(${lesson.id})">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <i class="fas fa-play text-red-600 text-sm mr-1"></i>
                                                <span class="text-sm font-medium text-gray-800">
                                                    Video ${status.index + 1}: ${lesson.name}
                                                </span>
                                            </div>
                                            <div class="text-xs text-gray-500">
                                                ${status.index + 1 == 4 ? '22' : status.index + 1 == 5 ? '16' : '14'} min
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
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
                    <input type="hidden" name="lessonId" value="${currentLesson.id}">
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
                        <textarea name="reviewText" id="reviewText" rows="3" 
                                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                placeholder="Share your thoughts about this lesson..."></textarea>
                    </div>
                    
                    <!-- Buttons -->
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="hideRatingModal()" 
                                class="px-4 py-2 text-gray-600 border border-gray-300 rounded-md hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit" id="submitRating" disabled
                                class="px-4 py-2 bg-orange-500 text-white rounded-md hover:bg-orange-600 disabled:bg-gray-300 disabled:cursor-not-allowed">
                            Submit Rating
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Media Modal -->
    <div id="mediaModal" class="fixed inset-0 bg-black bg-opacity-75 hidden z-50 flex items-center justify-center">
        <div class="relative max-w-4xl max-h-full p-4">
            <button onclick="closeMediaModal()" class="absolute top-4 right-4 text-white text-2xl hover:text-gray-300 z-10">
                <i class="fas fa-times"></i>
            </button>
            <div id="modalContent" class="bg-white rounded-lg overflow-hidden"></div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    
    <script>
        // File handling functions
        function handleFileSelect(input) {
            const file = input.files[0];
            if (!file) return;
            
            // Validate file type
            const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'video/mp4', 'video/avi', 'video/mov'];
            if (!allowedTypes.includes(file.type)) {
                alert('Please select a valid image (JPG, PNG, GIF) or video (MP4, AVI, MOV) file.');
                input.value = '';
                return;
            }
            
            // Validate file size (max 10MB)
            if (file.size > 10 * 1024 * 1024) {
                alert('File size must be less than 10MB.');
                input.value = '';
                return;
            }
            
            // Show preview
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
        
        // Media modal functions
        function openMediaModal(src, type) {
            const modal = document.getElementById('mediaModal');
            const modalContent = document.getElementById('modalContent');
            
            if (type === 'image') {
                modalContent.innerHTML = `<img src="${src}" alt="Full size image" class="max-w-full max-h-full object-contain">`;
            } else if (type === 'video') {
                modalContent.innerHTML = `
                    <video controls class="max-w-full max-h-full">
                        <source src="${src}" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                `;
            }
            
            modal.classList.remove('hidden');
        }
        
        function closeMediaModal() {
            document.getElementById('mediaModal').classList.add('hidden');
        }
        
        // Close modal on background click
        document.getElementById('mediaModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeMediaModal();
            }
        });
        
        // Mark lesson as complete functionality
        document.getElementById('markCompleteBtn').addEventListener('click', function() {
            const lessonId = '${currentLesson.id}';
            const button = this;
            const text = document.getElementById('markCompleteText');
            
            fetch('lesson-view', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markCompleted&lessonId=' + lessonId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    text.textContent = 'Completed';
                    button.classList.remove('bg-green-500', 'hover:bg-green-600');
                    button.classList.add('bg-gray-500', 'cursor-not-allowed');
                    button.disabled = true;
                    
                    // Update checkbox in sidebar
                    const checkbox = document.querySelector(`input[type="checkbox"][data-lesson-id="${lessonId}"]`);
                    if (checkbox) {
                        checkbox.checked = true;
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        });
        
        // Video progress tracking with auto-complete at 95%
        const video = document.getElementById('lessonVideo');
        if (video) {
            let lastProgress = 0;
            let autoCompleted = false;
            
            video.addEventListener('timeupdate', function() {
                const currentTime = Math.floor(video.currentTime);
                const duration = video.duration;
                const progressPercent = (currentTime / duration) * 100;
                
                // Update progress every 10 seconds
                if (currentTime > lastProgress && currentTime % 10 === 0) {
                    lastProgress = currentTime;
                    
                    fetch('lesson-view', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=updateProgress&lessonId=' + '${currentLesson.id}' + '&viewDuration=' + currentTime
                    });
                }
                
                // Auto-complete at 95% progress
                if (progressPercent >= 95 && !autoCompleted) {
                    autoCompleted = true;
                    
                    fetch('lesson-view', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=markCompleted&lessonId=${currentLesson.id}'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const button = document.getElementById('markCompleteBtn');
                            const text = document.getElementById('markCompleteText');
                            
                            text.textContent = 'Completed';
                            button.classList.remove('bg-green-500', 'hover:bg-green-600');
                            button.classList.add('bg-gray-500', 'cursor-not-allowed');
                            button.disabled = true;
                            
                            // Update checkbox in sidebar
                            const checkbox = document.querySelector('input[type="checkbox"][data-lesson-id="${currentLesson.id}"]');
                            if (checkbox) {
                                checkbox.checked = true;
                            }
                            
                            // Show notification
                            showNotification('Lesson automatically completed! 🎉');
                        }
                    });
                }
            });
        }
        
        // Edit comment function
        function editComment(button) {
            const commentId = button.getAttribute('data-comment-id');
            const commentText = button.getAttribute('data-comment-text');
            
            const newText = prompt('Edit your comment:', commentText);
            if (newText && newText.trim() !== '' && newText !== commentText) {
                // Create form to submit edit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'lesson-view';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'editComment';
                
                const lessonIdInput = document.createElement('input');
                lessonIdInput.type = 'hidden';
                lessonIdInput.name = 'lessonId';
                lessonIdInput.value = '${currentLesson.id}';
                
                const commentIdInput = document.createElement('input');
                commentIdInput.type = 'hidden';
                commentIdInput.name = 'commentId';
                commentIdInput.value = commentId;
                
                const commentTextInput = document.createElement('input');
                commentTextInput.type = 'hidden';
                commentTextInput.name = 'commentText';
                commentTextInput.value = newText;
                
                form.appendChild(actionInput);
                form.appendChild(lessonIdInput);
                form.appendChild(commentIdInput);
                form.appendChild(commentTextInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Show notification function
        function showNotification(message) {
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: #10B981;
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 1000;
                font-weight: 500;
            `;
            notification.textContent = message;
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 5000);
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
        
        // Navigation and Highlighting Functions
        function navigateToLesson(lessonId) {
            console.log('navigateToLesson called with ID:', lessonId);
            
            // Remove current highlighting from all lessons
            document.querySelectorAll('.lesson-item').forEach(item => {
                item.classList.remove('current');
            });
            
            // Check if it's a reading lesson (ID 15 for now, expand later)
            if (lessonId === 15) {
                console.log('Showing reading content for lesson 15');
                // For reading lessons, show content inline instead of redirecting
                showReadingContent();
                
                // Highlight the reading lesson
                const readingItem = document.querySelector(`[onclick="navigateToLesson(${lessonId})"]`);
                if (readingItem) {
                    readingItem.classList.add('current');
                }
                
                // Scroll to reading content
                setTimeout(() => {
                    const readingSection = document.getElementById('readingContentSection');
                    if (readingSection) {
                        readingSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }, 300);
            } else {
                // For video lessons, navigate normally
                location.href = 'lesson-view?lessonId=' + lessonId;
            }
        }
        
        function clearAllHighlighting() {
            console.log('Clearing all highlighting');
            
            // Remove current class from all lesson items
            document.querySelectorAll('.lesson-item').forEach(item => {
                item.classList.remove('current');
            });
            
            // Remove any reading content that might exist
            const existingReadingContent = document.getElementById('readingContentSection');
            if (existingReadingContent) {
                existingReadingContent.remove();
                console.log('Removed existing reading content');
            }
        }
        
        // Removed goToReadingLesson() - now using navigateToLesson(15) instead

        // Reading Content Display
        function showReadingContent() {
            console.log('showReadingContent function called');
            
            // Clear all highlighting first
            clearAllHighlighting();
            
            // Highlight the reading item (with null check)
            const readingItem = document.querySelector('.lesson-item');
            if (readingItem) {
                readingItem.classList.add('current');
                console.log('Reading item highlighted');
            } else {
                console.log('No reading item found to highlight');
            }
            
            // Hide video player (with null check)
            const videoContainer = document.querySelector('.video-container');
            if (videoContainer && videoContainer.parentElement) {
                videoContainer.parentElement.style.display = 'none';
                console.log('Video player hidden');
            } else {
                console.log('Video container not found');
            }
            
            // Create reading content section
            const readingContent = document.createElement('div');
            readingContent.id = 'readingContentSection';
            readingContent.className = 'bg-white rounded-lg shadow-lg p-6 mb-6 reading-animation';
            readingContent.innerHTML = `
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center">
                        <i class="fas fa-book-open text-blue-600 text-xl mr-3"></i>
                        <h3 class="text-xl font-bold text-gray-800">Reading: Active Listening Fundamentals</h3>
                    </div>
                    <div class="flex items-center space-x-4">
                        <div class="flex items-center text-sm text-gray-600">
                            <i class="fas fa-clock mr-1"></i>
                            <span>15 min read</span>
                        </div>
                        <button onclick="hideReadingContent()" class="text-gray-500 hover:text-gray-700">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Learning Objectives -->
                <div class="mb-6 bg-blue-50 rounded-lg p-4">
                    <h4 class="font-semibold text-blue-800 mb-3 flex items-center">
                        <i class="fas fa-target mr-2"></i>
                        What You'll Learn
                    </h4>
                    <ul class="text-blue-700 space-y-1">
                        <li>• Understand the fundamentals of active listening</li>
                        <li>• Identify barriers that prevent effective listening</li>
                        <li>• Practice active listening techniques</li>
                        <li>• Apply listening skills in real-world scenarios</li>
                    </ul>
                </div>
                
                <!-- Main Content -->
                <div class="prose max-w-none mb-6">
                    <h2>Active Listening Fundamentals</h2>
                    <p class="text-lg text-gray-700 mb-4">Active listening is a crucial skill in effective communication. It involves fully concentrating, understanding, responding, and remembering what is being said.</p>
                    
                    <div class="bg-orange-50 border-l-4 border-orange-400 p-4 mb-6">
                        <p class="font-semibold text-orange-800">Important:</p>
                        <p class="text-orange-700">Active listening is not just hearing words - it's about understanding the complete message being conveyed.</p>
                    </div>
                    
                    <h3>Key Components of Active Listening</h3>
                    <ul class="space-y-2 mb-6">
                        <li><strong>Give Full Attention:</strong> Focus completely on the speaker without distractions</li>
                        <li><strong>Show That You are Listening:</strong> Use body language and verbal cues to demonstrate engagement</li>
                        <li><strong>Provide Feedback:</strong> Reflect on what you have heard to ensure understanding</li>
                        <li><strong>Defer Judgment:</strong> Allow the speaker to finish before forming opinions</li>
                        <li><strong>Respond Appropriately:</strong> Give thoughtful responses that show comprehension</li>
                    </ul>
                    
                    <h3>Benefits of Active Listening</h3>
                    <p class="mb-4">Active listening helps build trust, reduces conflicts, and improves relationships. It is essential in professional settings, personal relationships, and educational environments.</p>
                    
                    <div class="bg-green-50 rounded-lg p-4 mb-6">
                        <h4 class="font-semibold text-green-800 mb-2">Practice Exercise</h4>
                        <p class="text-green-700 mb-2">Try this with a partner:</p>
                        <ol class="text-green-700 space-y-1">
                            <li>1. One person speaks for 2 minutes about a topic they care about</li>
                            <li>2. The other practices active listening techniques</li>
                            <li>3. The listener summarizes what they heard</li>
                            <li>4. Switch roles and discuss the experience</li>
                        </ol>
                    </div>
                </div>
                
                <!-- References -->
                <div class="border-t pt-6">
                    <h4 class="font-semibold text-gray-800 mb-3 flex items-center">
                        <i class="fas fa-bookmark mr-2"></i>
                        Additional References
                    </h4>
                    <div class="bg-gray-50 rounded-lg p-4">
                        <ul class="text-gray-700 space-y-2">
                            <li>• <strong>"The Lost Art of Listening"</strong> by Michael P. Nichols</li>
                            <li>• <strong>Harvard Business Review:</strong> "What Great Listeners Actually Do"</li>
                            <li>• <strong>TED Talk:</strong> "How to Speak So That People Want to Listen"</li>
                        </ul>
                    </div>
                </div>
                
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
            `;
            
            // Insert before comments section (with null check)
            const commentsSection = document.querySelector('.bg-white.rounded-lg.shadow-lg.p-6');
            if (commentsSection && commentsSection.parentNode) {
                commentsSection.parentNode.insertBefore(readingContent, commentsSection);
                console.log('Reading content inserted before comments');
            } else {
                // Fallback: insert after navigation buttons
                const navigationSection = document.querySelector('.flex.justify-between.mb-6');
                if (navigationSection && navigationSection.parentNode) {
                    navigationSection.parentNode.insertBefore(readingContent, navigationSection.nextSibling);
                    console.log('Reading content inserted after navigation (fallback)');
                } else {
                    // Last resort: append to body
                    document.body.appendChild(readingContent);
                    console.log('Reading content appended to body (last resort)');
                }
            }
            
            // Show completion notification
            console.log('📖 Reading content loaded successfully!');
            
            // Force highlight reading lesson after content loads
            setTimeout(() => {
                const readingLessonItem = document.querySelector('[onclick*="navigateToLesson(15)"]');
                if (readingLessonItem) {
                    // Clear all highlights first
                    document.querySelectorAll('.lesson-item').forEach(item => {
                        item.classList.remove('current');
                    });
                    
                    // Highlight reading lesson
                    readingLessonItem.classList.add('current');
                    console.log('Reading lesson highlighted after content load');
                    
                    // Force CSS update
                    readingLessonItem.style.backgroundColor = '#f0fdf4';
                    readingLessonItem.style.borderLeft = '3px solid #10b981';
                    readingLessonItem.style.fontWeight = '600';
                }
            }, 100);
        }
        
        function hideReadingContent() {
            // Show video player again
            const videoContainer = document.querySelector('.video-container').parentElement;
            videoContainer.style.display = 'block';
            
            // Remove reading content
            const readingSection = document.getElementById('readingContentSection');
            if (readingSection) {
                readingSection.remove();
            }
        }

        // Page Load Initialization
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Page loaded, checking functions...');
            console.log('navigateToLesson function exists:', typeof navigateToLesson);
            console.log('showReadingContent function exists:', typeof showReadingContent);
            
            // FORCE: Add backup event listeners for sidebar clicks
            console.log('Adding backup event listeners...');
            document.querySelectorAll('.lesson-item').forEach((item, index) => {
                // Remove any existing event listeners
                item.style.pointerEvents = 'auto';
                item.style.zIndex = '1000';
                item.style.position = 'relative';
                
                // Add backup click listener
                item.addEventListener('click', function(e) {
                    console.log('Backup click listener triggered for lesson item:', index);
                    
                    // Get lesson ID from onclick attribute
                    const onclickAttr = this.getAttribute('onclick');
                    if (onclickAttr) {
                        console.log('Onclick attribute:', onclickAttr);
                        
                        // Extract lesson ID
                        const match = onclickAttr.match(/navigateToLesson\((\d+)\)/);
                        if (match) {
                            const lessonId = parseInt(match[1]);
                            console.log('Extracted lesson ID:', lessonId);
                            navigateToLesson(lessonId);
                        }
                    }
                    
                    e.preventDefault();
                    e.stopPropagation();
                });
                
                console.log('Added backup listener to lesson item:', index);
            });
            
            // Clear any stuck highlighting on page load
            clearAllHighlighting();
            
            // Check if we're on a reading lesson page
            const readingContentExists = document.getElementById('readingContentSection');
            const currentLessonId = ${currentLesson.id};
            
            console.log('Current lesson ID:', currentLessonId);
            console.log('Reading content exists:', !!readingContentExists);
            
            if (readingContentExists) {
                // We're on reading page, highlight reading lesson in sidebar
                console.log('On reading page - highlighting reading lesson');
                
                // Try multiple selectors for reading lesson
                let readingLessonItem = document.querySelector('[onclick*="navigateToLesson(15)"]');
                if (!readingLessonItem) {
                    readingLessonItem = document.querySelector('[data-lesson-id="15"]');
                }
                if (!readingLessonItem) {
                    readingLessonItem = document.querySelector('.lesson-item:has(i.fas.fa-book)');
                }
                
                if (readingLessonItem) {
                    readingLessonItem.classList.add('current');
                    console.log('Reading lesson highlighted in sidebar');
                } else {
                    console.log('No reading lesson found to highlight');
                }
                
                // Clear any video highlights
                document.querySelectorAll('.lesson-item').forEach(item => {
                    if (item.onclick && item.onclick.toString().includes('navigateToLesson(') && 
                        !item.onclick.toString().includes('navigateToLesson(15)')) {
                        item.classList.remove('current');
                    }
                });
            } else {
                // We're on video page, highlight current video lesson
                console.log('On video page - highlighting video lesson');
                document.querySelectorAll('.lesson-item').forEach(item => {
                    if (item.onclick && item.onclick.toString().includes(currentLessonId)) {
                        item.classList.add('current');
                        console.log('Video lesson highlighted:', currentLessonId);
                    }
                });
            }
        });

        // Star Rating System
        document.addEventListener('DOMContentLoaded', function() {
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
            
            // Reset on mouse leave
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
         });
         
         // Reviews Search and Filter
         document.addEventListener('DOMContentLoaded', function() {
             const searchInput = document.getElementById('reviewSearch');
             const filterSelect = document.getElementById('ratingFilter');
             const reviewItems = document.querySelectorAll('.review-item');
             
             function filterReviews() {
                 const searchTerm = searchInput.value.toLowerCase();
                 const selectedRating = filterSelect.value;
                 
                 reviewItems.forEach(item => {
                     const reviewText = item.querySelector('.review-text');
                     const userName = item.querySelector('.font-semibold').textContent.toLowerCase();
                     const rating = item.getAttribute('data-rating');
                     
                     let showItem = true;
                     
                     // Search filter
                     if (searchTerm) {
                         const hasSearchMatch = userName.includes(searchTerm) || 
                                               (reviewText && reviewText.textContent.toLowerCase().includes(searchTerm));
                         if (!hasSearchMatch) {
                             showItem = false;
                         }
                     }
                     
                     // Rating filter
                     if (selectedRating && rating !== selectedRating) {
                         showItem = false;
                     }
                     
                     item.style.display = showItem ? 'block' : 'none';
                 });
                 
                 // Show "no results" message if needed
                 const visibleItems = Array.from(reviewItems).filter(item => item.style.display !== 'none');
                 const reviewsList = document.getElementById('reviewsList');
                 
                 let noResultsMsg = document.getElementById('noResultsMsg');
                 if (visibleItems.length === 0 && reviewItems.length > 0) {
                     if (!noResultsMsg) {
                         noResultsMsg = document.createElement('div');
                         noResultsMsg.id = 'noResultsMsg';
                         noResultsMsg.className = 'text-center py-8 text-gray-500';
                         noResultsMsg.innerHTML = '<p>No reviews match your search criteria.</p>';
                         reviewsList.appendChild(noResultsMsg);
                     }
                     noResultsMsg.style.display = 'block';
                 } else if (noResultsMsg) {
                     noResultsMsg.style.display = 'none';
                 }
             }
             
             if (searchInput) {
                 searchInput.addEventListener('input', filterReviews);
             }
             
             if (filterSelect) {
                 filterSelect.addEventListener('change', filterReviews);
             }
         });
         
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
                 
                 form.innerHTML = '<input type="hidden" name="action" value="editComment">' +
                                 '<input type="hidden" name="lessonId" value="${currentLesson.id}">' +
                                 '<input type="hidden" name="commentId" value="' + commentId + '">' +
                                 '<input type="hidden" name="commentText" value="' + newText + '">';
                 
                 document.body.appendChild(form);
                 form.submit();
             }
         }

         // Smooth scrolling for sidebar
        document.querySelectorAll('.lesson-item').forEach(item => {
            item.addEventListener('click', function() {
                const currentItem = document.querySelector('.lesson-item.current');
                if (currentItem) {
                    currentItem.classList.remove('current');
                }
                this.classList.add('current');
            });
        });
    </script>
    
    <!-- Include AI Chat Assistant -->
    <jsp:include page="/WEB-INF/views/includes/ai_chat.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 