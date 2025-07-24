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
        /* Enhanced Layout with Coursera-like Interaction */
        .container { max-width: 1200px; }
        .btn { display: inline-block; }
        
        .course-sidebar {
            height: calc(100vh - 120px);
            overflow-y: auto;
            position: sticky;
            top: 120px;
        }
        
        /* Unified Content Container */
        .content-container {
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        /* Video Container */
        .video-container {
            position: relative;
            width: 100%;
            aspect-ratio: 16/9;
            background: black;
        }
        
        .video-container video {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        
        /* Reading Content Container */
        .reading-container {
            padding: 2rem;
            background: white;
            min-height: 500px;
        }
        
        .reading-container h2 {
            color: #1f2937;
            font-size: 1.875rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .reading-container h3 {
            color: #374151;
            font-size: 1.25rem;
            font-weight: 600;
            margin-top: 2rem;
            margin-bottom: 0.75rem;
        }
        
        .reading-container p {
            color: #4b5563;
            line-height: 1.7;
            margin-bottom: 1rem;
        }
        
        .reading-container ul, .reading-container ol {
            color: #4b5563;
            line-height: 1.7;
            margin-bottom: 1rem;
            padding-left: 1.5rem;
        }
        
        /* Lesson Item Styles */
        .lesson-item {
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            cursor: pointer;
            position: relative;
        }
        
        .lesson-item:hover {
            background-color: #f8fafc;
            transform: translateX(4px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .lesson-item.current {
            background-color: #eff6ff;
            border-left: 3px solid #3b82f6;
            font-weight: 600;
        }
        
        .lesson-item.reading.current {
            background-color: #f0fdf4;
            border-left: 3px solid #10b981;
        }
        
        /* Content Type Indicators */
        .content-type-indicator {
            position: absolute;
            top: 1rem;
            right: 1rem;
            z-index: 10;
        }
        
        .type-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .type-badge.video {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }
        
        .type-badge.reading {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
        }
        
        /* Learning Objectives Box */
        .objectives-box {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            border-left: 4px solid #3b82f6;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-radius: 0.5rem;
        }
        
        .objectives-box h4 {
            color: #1e40af;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }
        
        .objectives-box ul {
            color: #1e40af;
            margin: 0;
        }
        
        /* Smooth Transitions */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Navigation Enhancement */
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

        /* Button Enhancements */
        .btn, button, a.btn {
            cursor: pointer;
            user-select: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .btn:hover, button:hover, a.btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .btn:active, button:active, a.btn:active {
            transform: translateY(0);
        }

        /* Ensure clickable elements are properly styled */
        .cursor-pointer {
            cursor: pointer !important;
            pointer-events: auto !important;
        }

        /* Fix any overlay issues */
        .lesson-item, .quiz-button, .ai-chat-toggle {
            position: relative;
            z-index: 1;
        }

        /* Ensure buttons are interactive */
        button, a, .clickable {
            pointer-events: auto;
            user-select: none;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .video-container {
                aspect-ratio: 16/9;
                margin: 0 -1rem;
                border-radius: 0;
            }
            
            .reading-container {
                padding: 1rem;
            }
        }
        
        /* Section Headers */
        .section-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            
            <!-- Unified Content Container -->
            <div class="content-container mb-6">
                <!-- Content Type Indicator -->
                <div class="content-type-indicator">
                    <c:choose>
                        <c:when test="${currentLesson.type == 'reading' || currentLesson.contentType == 'reading' || not empty currentLesson.contentFilePath}">
                            <span class="type-badge reading">
                                <i class="fas fa-book mr-1"></i>
                                Reading
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="type-badge video">
                                <i class="fas fa-play mr-1"></i>
                                Video
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Dynamic Content Area -->
                <div id="dynamicContent">
                    <c:choose>
                        <c:when test="${currentLesson.type == 'reading' || currentLesson.contentType == 'reading' || not empty currentLesson.contentFilePath}">
                            <!-- Reading Content -->
                            <div class="reading-container fade-in">
                                <!-- Learning Objectives -->
                                <div class="objectives-box">
                                    <h4>
                                        <i class="fas fa-target mr-2"></i>
                                        What You'll Learn
                                    </h4>
                                    <ul>
                                        <li>Understand the principles of active listening</li>
                                        <li>Learn key techniques for effective listening</li>
                                        <li>Identify common barriers to active listening</li>
                                        <li>Practice active listening skills through exercises</li>
                                        <li>Apply active listening in professional and personal contexts</li>
                                    </ul>
                                </div>
                                
                                <!-- Main Reading Content -->
                                <c:choose>
                                    <c:when test="${not empty currentLesson.contentText}">
                                        <c:out value="${currentLesson.contentText}" escapeXml="false" />
                                    </c:when>
                                    <c:otherwise>
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
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Video Content -->
                            <div class="video-container">
                                <c:choose>
                                    <c:when test="${not empty currentLesson.videoLink}">
                                        <video id="lessonVideo" controls>
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
                                        <div class="flex items-center justify-center h-full text-white">
                                            <div class="text-center">
                                                <i class="fas fa-play-circle text-6xl mb-4 opacity-50"></i>
                                                <p class="text-lg">No video available for this lesson</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Lesson Info and Actions -->
                <div class="p-6">
                    <h2 class="text-2xl font-bold text-gray-800 mb-2">${currentLesson.name}</h2>
                    <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-4">
                            <span class="text-sm text-gray-600">Last updated January 2024</span>
                            <span class="text-sm text-gray-600">
                                <c:choose>
                                    <c:when test="${currentLesson.type == 'reading' || currentLesson.contentType == 'reading'}">
                                        <i class="fas fa-clock mr-1"></i>
                                        ${currentLesson.estimatedTime > 0 ? currentLesson.estimatedTime : 15} min read
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-clock mr-1"></i>
                                        15 min watch
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="flex items-center space-x-4">
                            <!-- Take Quiz Button -->
                            <c:if test="${currentLesson.quizId != null && currentLesson.quizId > 0}">
                                <button onclick="takeQuiz()"
                                   class="flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                    <i class="fas fa-clipboard-question mr-2"></i>
                                    Take Quiz
                                </button>
                            </c:if>
                            <c:if test="${currentLesson.quizId == null || currentLesson.quizId <= 0}">
                                <button onclick="takeQuiz()"
                                   class="flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                    <i class="fas fa-clipboard-question mr-2"></i>
                                    Take Quiz
                                </button>
                            </c:if>
                            
                            <!-- Mark Complete Button -->
                            <button id="markCompleteBtn" onclick="markComplete()"
                                    class="mark-complete-btn flex items-center px-4 py-2 ${progressMap[currentLesson.id] != null && progressMap[currentLesson.id].completed ? 'bg-gray-500 cursor-not-allowed' : 'bg-green-500 hover:bg-green-600'} text-white rounded-lg transition-colors"
                                    ${progressMap[currentLesson.id] != null && progressMap[currentLesson.id].completed ? 'disabled' : ''}>
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
                            
                            <!-- Leave a Rating Button -->
                            <button id="ratingBtn" onclick="showRatingModal()" 
                                    class="flex items-center px-4 py-2 border-2 border-orange-500 text-orange-500 rounded-lg hover:bg-orange-500 hover:text-white transition-colors">
                                <i class="fas fa-star mr-2"></i>
                                Leave a rating
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Navigation Buttons -->
            <div class="flex justify-between mb-6">
                <c:if test="${previousLesson != null}">
                    <button onclick="navigateToLesson(${previousLesson.id})" 
                       class="nav-button flex items-center px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors">
                        <i class="fas fa-chevron-left mr-2"></i>
                        Previous
                    </button>
                </c:if>
                <c:if test="${previousLesson == null}">
                    <div></div>
                </c:if>
                
                <!-- Enhanced Next Navigation -->
                <c:choose>
                    <c:when test="${currentLesson.id == 2 || currentLesson.id == 4}">
                        <!-- Special case: Last video in section → navigate to reading -->
                        <c:set var="readingLessonId" value="" />
                        <c:forEach items="${courseLessons}" var="lesson">
                            <c:if test="${lesson.type == 'reading' || lesson.contentType == 'reading' || not empty lesson.contentFilePath}">
                                <c:set var="readingLessonId" value="${lesson.id}" />
                            </c:if>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${not empty readingLessonId}">
                                <button onclick="navigateToLesson(${readingLessonId});" 
                                       class="nav-button flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                    Next: Reading
                                    <i class="fas fa-chevron-right ml-2"></i>
                                </button>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${nextLesson != null}">
                                    <button onclick="navigateToLesson(${nextLesson.id})" 
                                           class="nav-button flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                        Next
                                        <i class="fas fa-chevron-right ml-2"></i>
                                    </button>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${nextLesson != null}">
                        <button onclick="navigateToLesson(${nextLesson.id})" 
                               class="nav-button flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                            Next
                            <i class="fas fa-chevron-right ml-2"></i>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <div></div>
                    </c:otherwise>
                </c:choose>
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
                                        placeholder="Share your thoughts about this lesson..."></textarea>
                                
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
                                        <span class="text-xs text-gray-500">Supports: JPG, PNG, GIF, MP4, AVI (Max 10MB)</span>
                                    </div>
                                    
                                    <!-- File Preview -->
                                    <div id="filePreview" class="hidden">
                                        <div class="flex items-center space-x-3 p-3 bg-gray-50 rounded-lg border">
                                            <div id="previewContent" class="flex-1"></div>
                                            <button type="button" onclick="removeFile()" 
                                                    class="text-red-500 hover:text-red-700 p-1">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-3 flex space-x-3">
                                    <button type="submit" 
                                            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                        <i class="fas fa-paper-plane mr-2"></i>
                                        Submit
                                    </button>
                                    <button type="button" onclick="clearForm()" 
                                            class="px-6 py-2 border border-gray-300 text-gray-600 rounded-lg hover:bg-gray-50 transition-colors">
                                        <i class="fas fa-eraser mr-2"></i>
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
                                    <p class="text-gray-700 mb-3">${comment.commentText}</p>
                                    
                                    <!-- Media Display -->
                                    <c:if test="${not empty comment.mediaPath}">
                                        <div class="mt-3">
                                            <c:choose>
                                                <c:when test="${comment.mediaType == 'image'}">
                                                    <img src="${comment.mediaPath}" alt="Comment image" 
                                                         class="max-w-md max-h-64 rounded-lg shadow-sm cursor-pointer hover:opacity-90 transition-opacity border"
                                                         onclick="openMediaModal('${comment.mediaPath}', 'image')">
                                                </c:when>
                                                <c:when test="${comment.mediaType == 'video'}">
                                                    <video controls class="max-w-md max-h-64 rounded-lg shadow-sm border">
                                                        <source src="${comment.mediaPath}" type="video/mp4">
                                                        Your browser does not support the video tag.
                                                    </video>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Comment Actions -->
                                    <div class="mt-2 flex items-center space-x-3 text-sm">
                                        <button class="text-gray-500 hover:text-blue-600 transition-colors">
                                            <i class="fas fa-thumbs-up mr-1"></i>
                                            Like
                                        </button>
                                        <button class="text-gray-500 hover:text-blue-600 transition-colors">
                                            <i class="fas fa-reply mr-1"></i>
                                            Reply
                                        </button>
                                        <c:if test="${comment.userId == currentUser.id}">
                                            <button onclick="editComment(this)" 
                                                    data-comment-id="${comment.id}" 
                                                    data-comment-text="${comment.commentText}"
                                                    class="text-gray-500 hover:text-orange-600 transition-colors">
                                                <i class="fas fa-edit mr-1"></i>Edit
                                            </button>
                                            <form action="lesson-view" method="post" style="display: inline;" 
                                                  onsubmit="return confirm('Delete this comment?')">
                                                <input type="hidden" name="action" value="deleteComment">
                                                <input type="hidden" name="lessonId" value="${currentLesson.id}">
                                                <input type="hidden" name="commentId" value="${comment.id}">
                                                <button type="submit" class="text-gray-500 hover:text-red-600 transition-colors">
                                                    <i class="fas fa-trash mr-1"></i>Delete
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <c:if test="${empty comments}">
                            <div class="text-center py-8 text-gray-500">
                                <i class="fas fa-comments text-4xl mb-3 opacity-30"></i>
                                <p>No comments yet. Be the first to comment!</p>
                                <p class="text-sm mt-2">Share your thoughts, questions, or media about this lesson</p>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Reviews Tab Content -->
                <div id="reviewsContent" class="tab-content hidden">
                    <h3 class="text-xl font-bold text-gray-800 mb-6">Student feedback</h3>
                    
                    <!-- Rating Summary -->
                    <div class="flex items-start space-x-8 mb-8">
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
                    </div>
                    
                    <!-- Reviews List -->
                    <div id="reviewsList">
                        <c:choose>
                            <c:when test="${not empty ratings}">
                                <c:forEach items="${ratings}" var="rating">
                                    <div class="review-item border-b border-gray-200 py-4">
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
                                    <i class="fas fa-star text-4xl mb-3 opacity-30"></i>
                                    <p>No reviews yet. Be the first to review!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
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
                                         onclick="navigateToLesson(${lesson.id})"
                                         data-lesson-id="${lesson.id}">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <i class="fas fa-play text-red-600 text-sm mr-1"></i>
                                                <span class="text-sm font-medium text-gray-800">
                                                    ${lesson.name}
                                                </span>
                                                <c:if test="${lesson.quizId != null && lesson.quizId > 0}">
                                                    <i class="fas fa-clipboard-question text-blue-600 text-xs" title="Quiz available"></i>
                                                </c:if>
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
                            <!-- Reading Lessons -->
                            <c:set var="hasReadingLesson" value="false" />
                            <c:forEach items="${courseLessons}" var="lesson">
                                <c:if test="${lesson.type == 'reading' || lesson.contentType == 'reading' || not empty lesson.contentFilePath}">
                                    <c:set var="hasReadingLesson" value="true" />
                                    <div class="lesson-item reading px-4 py-3 border-b border-gray-200 cursor-pointer ${lesson.id == currentLesson.id ? 'current' : ''}"
                                         onclick="navigateToLesson(${lesson.id})"
                                         data-lesson-id="${lesson.id}">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <i class="fas fa-book text-green-600 text-sm mr-1"></i>
                                                <span class="text-sm font-medium text-gray-800">
                                                    ${lesson.name}
                                                </span>
                                            </div>
                                            <div class="text-xs text-gray-500">${lesson.estimatedTime > 0 ? lesson.estimatedTime : 15} min</div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            
                            <!-- Additional Video Lessons -->
                            <c:forEach items="${courseLessons}" var="lesson" varStatus="status">
                                <c:if test="${lesson.type == 'video' && status.index >= 3}">
                                    <div class="lesson-item px-4 py-3 border-b border-gray-200 cursor-pointer ${lesson.id == currentLesson.id ? 'current' : ''}"
                                         onclick="navigateToLesson(${lesson.id})"
                                         data-lesson-id="${lesson.id}">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <i class="fas fa-play text-red-600 text-sm mr-1"></i>
                                                <span class="text-sm font-medium text-gray-800">
                                                    ${lesson.name}
                                                </span>
                                            </div>
                                            <div class="text-xs text-gray-500">
                                                ${status.index + 1 == 4 ? '22' : status.index + 1 == 5 ? '16' : '14'} min
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            
                            <!-- No Reading Lesson Message -->
                            <c:if test="${!hasReadingLesson}">
                                <div class="px-4 py-3 text-center text-gray-500 text-sm">
                                    <i class="fas fa-info-circle mr-2"></i>
                                    No reading lessons available. 
                                    <a href="create-reading-lesson" class="text-blue-600 hover:underline">Create one</a>
                                </div>
                            </c:if>
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
        // Debug logging
        console.log('Lesson view script loading...');

        // Enhanced Navigation with Coursera-like Interaction
        function navigateToLesson(lessonId) {
            console.log('Navigating to lesson:', lessonId);

            // Prevent multiple clicks
            if (window.navigating) return;
            window.navigating = true;

            // Show loading state
            const dynamicContent = document.getElementById('dynamicContent');
            if (dynamicContent) {
                dynamicContent.style.opacity = '0.5';
            }

            // Update URL and reload content
            setTimeout(() => {
                window.location.href = 'lesson-view?lessonId=' + lessonId;
                window.navigating = false; // Reset flag
            }, 100);
        }
        
        // Fix course content navigation clicks and initialize all interactive elements
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM Content Loaded - Initializing interactive elements');

            // Make all lesson items clickable
            const lessonItems = document.querySelectorAll('.course-sidebar .cursor-pointer');
            lessonItems.forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    // Extract lesson ID from onclick attribute or data attribute
                    const onclickAttr = this.getAttribute('onclick');
                    if (onclickAttr) {
                        const lessonId = onclickAttr.match(/navigateToLesson\((\d+)\)/);
                        if (lessonId) {
                            navigateToLesson(parseInt(lessonId[1]));
                        }
                    }
                });
            });

            console.log('Navigation fixed for', lessonItems.length, 'lesson items');

            // Initialize AI Chat Toggle
            const aiToggle = document.getElementById('aiChatToggle');
            if (aiToggle) {
                console.log('AI Chat toggle found and initialized');
                aiToggle.style.display = 'flex';
            } else {
                console.warn('AI Chat toggle not found');
            }

            // Initialize Quiz buttons
            const quizButtons = document.querySelectorAll('a[href*="quiz"]');
            quizButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    console.log('Quiz button clicked:', this.href);
                });
            });

            console.log('Found', quizButtons.length, 'quiz buttons');

            // Add global error handler
            window.addEventListener('error', function(e) {
                console.error('JavaScript error:', e.error);
                console.error('Error details:', {
                    message: e.message,
                    filename: e.filename,
                    lineno: e.lineno,
                    colno: e.colno
                });
            });

            // Test all interactive elements
            setTimeout(() => {
                console.log('Testing interactive elements...');
                const allClickable = document.querySelectorAll('[onclick], .cursor-pointer, button, a');
                console.log('Found', allClickable.length, 'clickable elements');

                allClickable.forEach((element, index) => {
                    if (!element.style.pointerEvents || element.style.pointerEvents !== 'none') {
                        console.log('Clickable element', index, ':', element);
                    }
                });
            }, 1000);
        });
        
        // Mark lesson as complete functionality
        document.addEventListener('DOMContentLoaded', function() {
            const markCompleteBtn = document.getElementById('markCompleteBtn');
            if (markCompleteBtn) {
                markCompleteBtn.addEventListener('click', function() {
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

                            // Show notification
                            showNotification('Lesson completed! 🎉');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    });
                });
            }
        });
        
        // Video progress tracking
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
                            
                            showNotification('Lesson automatically completed! 🎉');
                        }
                    });
                }
            });
        }
        
        // Show notification function
        function showNotification(message) {
            const notification = document.createElement('div');
            notification.style.cssText =
                'position: fixed;' +
                'top: 20px;' +
                'right: 20px;' +
                'background: #10B981;' +
                'color: white;' +
                'padding: 15px 20px;' +
                'border-radius: 8px;' +
                'box-shadow: 0 4px 12px rgba(0,0,0,0.15);' +
                'z-index: 1000;' +
                'font-weight: 500;';
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

        // ===== INTERACTIVE COMPONENTS FUNCTIONS =====

        // Quiz Button Function
        function takeQuiz() {
            console.log('Quiz button clicked!');

            // Get current lesson ID
            const currentLessonId = ${currentLesson.id};

            // Check if quiz exists for this lesson
            <c:if test="${not empty currentLesson.quizId}">
                // Navigate to quiz page
                window.location.href = 'quiz?lessonId=' + currentLessonId + '&quizId=${currentLesson.quizId}';
            </c:if>
            <c:if test="${empty currentLesson.quizId}">
                // Show message if no quiz available
                showNotification('Quiz not available for this lesson yet.', 'info');
            </c:if>
        }

        // Mark Complete Function
        function markComplete() {
            console.log('Mark Complete button clicked!');

            const button = document.getElementById('markCompleteBtn');
            const buttonText = document.getElementById('markCompleteText');
            const currentLessonId = ${currentLesson.id};

            if (button && buttonText && buttonText.textContent.includes('Mark as Complete')) {
                // Mark as complete
                fetch('lesson-progress', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'lessonId=' + currentLessonId + '&action=complete'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        buttonText.innerHTML = 'Completed';
                        button.className = 'mark-complete-btn flex items-center px-4 py-2 bg-gray-500 cursor-not-allowed text-white rounded-lg transition-colors';
                        button.disabled = true;
                        showNotification('Lesson marked as complete!', 'success');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    // Fallback: just update UI without server call
                    buttonText.innerHTML = 'Completed';
                    button.className = 'mark-complete-btn flex items-center px-4 py-2 bg-gray-500 cursor-not-allowed text-white rounded-lg transition-colors';
                    button.disabled = true;
                    showNotification('Lesson marked as complete!', 'success');
                });
            }
        }

        // AI Chat Function - Use existing AI Chat system
        function openAIChat() {
            console.log('AI Chat button clicked!');
            toggleAiChat(); // Use the existing AI chat system
        }

        // Notification Function
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = 'fixed top-4 right-4 p-4 rounded-lg text-white z-50 ' +
                (type === 'success' ? 'bg-green-500' :
                 type === 'error' ? 'bg-red-500' :
                 'bg-blue-500');
            notification.innerHTML =
                '<div class="flex items-center">' +
                    '<i class="fas fa-' + (type === 'success' ? 'check' : type === 'error' ? 'exclamation-triangle' : 'info-circle') + ' mr-2"></i>' +
                    '<span>' + message + '</span>' +
                '</div>';

            document.body.appendChild(notification);

            // Auto remove after 3 seconds
            setTimeout(() => {
                notification.remove();
            }, 3000);
        }
        
                 // Media Upload Functions
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
                 img.className = 'max-w-xs max-h-32 rounded-lg object-cover';
                 img.alt = 'Preview';
                 previewContent.innerHTML =
                     '<div class="flex items-center space-x-3">' +
                         '<div class="flex-shrink-0">' +
                             '<img src="' + img.src + '" alt="Preview" class="w-16 h-16 rounded-lg object-cover">' +
                         '</div>' +
                         '<div>' +
                             '<p class="text-sm font-medium text-gray-900">' + file.name + '</p>' +
                             '<p class="text-xs text-gray-500">' + (file.size / 1024 / 1024).toFixed(2) + ' MB</p>' +
                             '<p class="text-xs text-blue-600">Image ready to upload</p>' +
                         '</div>' +
                     '</div>';
             } else if (file.type.startsWith('video/')) {
                 const video = document.createElement('video');
                 video.src = URL.createObjectURL(file);
                 video.className = 'w-16 h-16 rounded-lg object-cover';
                 video.controls = false;
                 video.muted = true;
                 previewContent.innerHTML =
                     '<div class="flex items-center space-x-3">' +
                         '<div class="flex-shrink-0">' +
                             '<video src="' + video.src + '" class="w-16 h-16 rounded-lg object-cover" muted></video>' +
                         '</div>' +
                         '<div>' +
                             '<p class="text-sm font-medium text-gray-900">' + file.name + '</p>' +
                             '<p class="text-xs text-gray-500">' + (file.size / 1024 / 1024).toFixed(2) + ' MB</p>' +
                             '<p class="text-xs text-green-600">Video ready to upload</p>' +
                         '</div>' +
                     '</div>';
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
                 modalContent.innerHTML = '<img src="' + src + '" alt="Full size image" class="max-w-full max-h-full object-contain">';
             } else if (type === 'video') {
                 modalContent.innerHTML =
                     '<video controls class="max-w-full max-h-full">' +
                         '<source src="' + src + '" type="video/mp4">' +
                         'Your browser does not support the video tag.' +
                     '</video>';
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

         // Page Load Initialization
         document.addEventListener('DOMContentLoaded', function() {
             console.log('Enhanced lesson view loaded');
             
             // Add smooth transitions to content
             const dynamicContent = document.getElementById('dynamicContent');
             if (dynamicContent) {
                 dynamicContent.classList.add('fade-in');
             }
             
             // Fix Bootstrap dropdown manually if needed
             const dropdownToggle = document.getElementById('avatarDropdown');
             if (dropdownToggle) {
                 dropdownToggle.addEventListener('click', function(e) {
                     e.preventDefault();
                     const dropdownMenu = this.nextElementSibling;
                     if (dropdownMenu) {
                         const isShown = dropdownMenu.classList.contains('show');
                         if (isShown) {
                             dropdownMenu.classList.remove('show');
                         } else {
                             dropdownMenu.classList.add('show');
                         }
                     }
                 });
                 
                 // Close dropdown when clicking outside
                 document.addEventListener('click', function(e) {
                     if (!dropdownToggle.contains(e.target)) {
                         const dropdownMenu = dropdownToggle.nextElementSibling;
                         if (dropdownMenu) {
                             dropdownMenu.classList.remove('show');
                         }
                     }
                 });
             }
         });
    </script>
    
    <!-- Include AI Chat Assistant -->
    <jsp:include page="/WEB-INF/views/includes/ai_chat.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 