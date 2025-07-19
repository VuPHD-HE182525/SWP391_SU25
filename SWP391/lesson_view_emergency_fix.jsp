<!-- EMERGENCY FIX FOR JSP SYNTAX ERROR -->

<!-- REPLACE THE BROKEN VIDEO/READING SECTION (around line 100-300) WITH THIS SIMPLE VERSION: -->

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

<!-- COPY FROM HERE TO CONTINUE... -->
<!-- The rest should be the rating section, navigation buttons, comments, etc. -->

<!-- INSTRUCTIONS:
1. Find the broken c:choose section in your lesson_view.jsp
2. Replace with this simple video player section
3. This removes the reading/video conditional logic that's causing the error
4. Keep the rest of the file as-is
--> 