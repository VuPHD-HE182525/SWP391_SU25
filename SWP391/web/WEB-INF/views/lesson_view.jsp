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
                                        <c:choose>
                                            <c:when test="${fn:startsWith(currentLesson.videoLink, '/video/')}">
                                                <source src="${pageContext.request.contextPath}${currentLesson.videoLink}" type="video/mp4">
                                            </c:when>
                                            <c:otherwise>
                                                <source src="${pageContext.request.contextPath}/video/${currentLesson.videoLink}" type="video/mp4">
                                            </c:otherwise>
                                        </c:choose>
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
                            
                            <!-- Rating Section -->
                            <div class="flex items-center space-x-4">
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
                        body: 'action=updateProgress&lessonId=${currentLesson.id}&viewDuration=' + currentTime
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