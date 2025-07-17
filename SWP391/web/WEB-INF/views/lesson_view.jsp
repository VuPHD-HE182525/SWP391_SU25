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
                    </div>
                </div>
            </div>
            
            <!-- Navigation Buttons -->
            <div class="flex justify-between mb-6">
                <c:if test="${previousLesson != null}">
                    <a href="lesson-view?lessonId=${previousLesson.id}" 
                       class="flex items-center px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors">
                        <i class="fas fa-chevron-left mr-2"></i>
                        Previous Chap
                    </a>
                </c:if>
                <c:if test="${previousLesson == null}">
                    <div></div>
                </c:if>
                
                <c:if test="${nextLesson != null}">
                    <a href="lesson-view?lessonId=${nextLesson.id}" 
                       class="flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                        Next Chap
                        <i class="fas fa-chevron-right ml-2"></i>
                    </a>
                </c:if>
                <c:if test="${nextLesson == null}">
                    <div></div>
                </c:if>
            </div>
            
            <!-- Comments Section -->
            <div class="bg-white rounded-lg shadow-lg p-6">
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
                                    <span class="font-semibold text-gray-800">
                                        <c:choose>
                                            <c:when test="${not empty comment.userFullName}">
                                                ${comment.userFullName}
                                            </c:when>
                                            <c:otherwise>
                                                Anonymous User
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="text-sm text-gray-500">
                                        <c:choose>
                                                                                         <c:when test="${not empty comment.createdAt}">
                                                 ${comment.createdAt}
                                             </c:when>
                                            <c:otherwise>
                                                Just now
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <p class="text-gray-700">
                                    <c:choose>
                                        <c:when test="${not empty comment.commentText}">
                                            ${comment.commentText}
                                        </c:when>
                                        <c:otherwise>
                                            [No comment text]
                                        </c:otherwise>
                                    </c:choose>
                                </p>
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
                                         onclick="location.href='lesson-view?lessonId=${lesson.id}'">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <input type="checkbox" 
                                                       ${progressMap[lesson.id] != null && progressMap[lesson.id].completed ? 'checked' : ''}
                                                       class="w-4 h-4 text-blue-600">
                                                <span class="text-sm font-medium text-gray-800">
                                                    Video ${status.index + 1}: ${lesson.name}
                                                </span>
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
                            <c:forEach items="${courseLessons}" var="lesson" varStatus="status">
                                <c:if test="${lesson.type == 'video' && status.index >= 3}">
                                    <div class="lesson-item px-4 py-3 border-b border-gray-200 cursor-pointer ${lesson.id == currentLesson.id ? 'current' : ''}"
                                         onclick="location.href='lesson-view?lessonId=${lesson.id}'">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-3">
                                                <input type="checkbox" 
                                                       ${progressMap[lesson.id] != null && progressMap[lesson.id].completed ? 'checked' : ''}
                                                       class="w-4 h-4 text-blue-600">
                                                <span class="text-sm font-medium text-gray-800">
                                                    Video ${status.index + 1}: ${lesson.name}
                                                </span>
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
    
    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    
    <script>
        // Mark lesson as complete functionality
        document.getElementById('markCompleteBtn').addEventListener('click', function() {
            const lessonId = ${currentLesson.id};
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
        
        // Video progress tracking
        const video = document.getElementById('lessonVideo');
        if (video) {
            let lastProgress = 0;
            
            video.addEventListener('timeupdate', function() {
                const currentTime = Math.floor(video.currentTime);
                
                // Update progress every 10 seconds
                if (currentTime > lastProgress && currentTime % 10 === 0) {
                    lastProgress = currentTime;
                    
                    fetch('lesson-view', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=updateProgress&lessonId=${currentLesson.id}&viewDuration=' + currentTime
                    });
                }
            });
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