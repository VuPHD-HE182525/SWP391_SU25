<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khóa học của tôi - E-Learning</title>
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
        
        .course-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        .progress-bar-custom {
            background: linear-gradient(90deg, #4ade80 0%, #22c55e 100%);
        }
        .course-thumbnail {
            height: 200px;
            object-fit: cover;
        }
        body {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    
    <!-- Include Header -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />
    
    <div class="container my-5 pt-4">
        <!-- Page Header -->
        <div class="mb-5">
            <h1 class="display-4 fw-bold text-dark mb-2">Khóa học của tôi</h1>
            <p class="text-muted fs-5">Tiếp tục học tập và phát triển kỹ năng của bạn</p>
        </div>
        
        <!-- Debug Info -->
        <c:if test="${not empty sessionScope.user}">
            <div class="alert alert-info mb-4">
                <strong>Debug:</strong> User ID: ${sessionScope.user.id}, Total courses found: ${fn:length(myCourses)}
            </div>
        </c:if>
        
        <!-- Courses Grid -->
        <c:choose>
            <c:when test="${not empty myCourses}">
                <div class="row g-4">
                    <c:forEach items="${myCourses}" var="courseInfo">
                        <div class="col-12 col-md-6 col-lg-4">
                            <div class="course-card card h-100 border-0 shadow-sm">
                                <!-- Course Thumbnail -->
                                <div class="position-relative">
                                    <img src="${courseInfo.course.thumbnailUrl != null ? courseInfo.course.thumbnailUrl : '/uploads/images/default-course.jpg'}" 
                                         alt="${courseInfo.course.title}" 
                                         class="course-thumbnail card-img-top">
                                    
                                    <!-- Progress Badge -->
                                    <div class="position-absolute top-0 end-0 m-3">
                                        <span class="badge bg-white text-dark fw-bold">${courseInfo.progressPercentage}%</span>
                                    </div>
                                    
                                    <!-- Status Badge -->
                                    <div class="position-absolute bottom-0 start-0 m-3">
                                        <c:choose>
                                            <c:when test="${courseInfo.progressPercentage == 100}">
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check-circle me-1"></i>Hoàn thành
                                                </span>
                                            </c:when>
                                            <c:when test="${courseInfo.progressPercentage > 0}">
                                                <span class="badge bg-primary">
                                                    <i class="fas fa-play-circle me-1"></i>Đang học
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning">
                                                    <i class="fas fa-star me-1"></i>Bắt đầu
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <!-- Course Content -->
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title fw-bold mb-2">${courseInfo.course.title}</h5>
                                    <p class="card-text text-muted small mb-3 flex-grow-1">${courseInfo.course.briefInfo}</p>
                                    
                                    <!-- Progress Bar -->
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between small text-muted mb-1">
                                            <span>Tiến độ</span>
                                            <span>${courseInfo.completedLessons}/${courseInfo.totalLessons} bài học</span>
                                        </div>
                                        <div class="progress" style="height: 8px;">
                                            <div class="progress-bar-custom" 
                                                 role="progressbar" 
                                                 data-progress="${courseInfo.progressPercentage}"
                                                 aria-valuenow="${courseInfo.progressPercentage}" 
                                                 aria-valuemin="0" 
                                                 aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                    
                                    <!-- Course Meta -->
                                    <div class="d-flex justify-content-between small text-muted mb-3">
                                        <span>
                                            <i class="fas fa-play-circle me-1"></i>
                                            ${courseInfo.totalLessons} bài học
                                        </span>
                                        <span>
                                            <i class="fas fa-calendar me-1"></i>
                                            <fmt:formatDate value="${courseInfo.registration.registrationDate}" pattern="dd/MM/yyyy"/>
                                        </span>
                                    </div>
                                    
                                    <!-- Action Buttons -->
                                    <div class="d-grid gap-2 d-md-flex">
                                        <c:choose>
                                            <c:when test="${courseInfo.progressPercentage == 100}">
                                                <a href="lesson-view?lessonId=${courseInfo.firstLessonId}" 
                                                   class="btn btn-success flex-fill">
                                                    <i class="fas fa-redo me-2"></i>Xem lại
                                                </a>
                                            </c:when>
                                            <c:when test="${courseInfo.progressPercentage > 0}">
                                                <a href="lesson-view?lessonId=${courseInfo.firstLessonId}" 
                                                   class="btn btn-primary flex-fill">
                                                    <i class="fas fa-play me-2"></i>Tiếp tục học
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="lesson-view?lessonId=${courseInfo.firstLessonId}" 
                                                   class="btn btn-success flex-fill">
                                                    <i class="fas fa-play-circle me-2"></i>Bắt đầu học
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <a href="course-details?id=${courseInfo.course.id}" 
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-info-circle"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="text-center py-5">
                    <div class="mb-4">
                        <i class="fas fa-graduation-cap" style="font-size: 4rem; color: #dee2e6;"></i>
                    </div>
                    <h3 class="h4 text-muted mb-3">Bạn chưa đăng ký khóa học nào</h3>
                    <p class="text-muted mb-4">Khám phá các khóa học thú vị và bắt đầu hành trình học tập của bạn</p>
                    <a href="course-list" class="btn btn-primary btn-lg">
                        <i class="fas fa-search me-2"></i>
                        Khám phá khóa học
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
        
        <!-- Quick Stats -->
        <c:if test="${not empty myCourses}">
            <div class="mt-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white border-0">
                        <h2 class="h4 mb-0 fw-bold">Thống kê học tập</h2>
                    </div>
                    <div class="card-body">
                        <div class="row text-center g-4">
                            <div class="col-6 col-md-3">
                                <div class="h2 fw-bold text-primary mb-1">${fn:length(myCourses)}</div>
                                <div class="text-muted small">Khóa học đã đăng ký</div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="h2 fw-bold text-success mb-1">
                                    <c:set var="completedCourses" value="0" />
                                    <c:forEach items="${myCourses}" var="courseInfo">
                                        <c:if test="${courseInfo.progressPercentage == 100}">
                                            <c:set var="completedCourses" value="${completedCourses + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${completedCourses}
                                </div>
                                <div class="text-muted small">Khóa học hoàn thành</div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="h2 fw-bold text-warning mb-1">
                                    <c:set var="totalLessons" value="0" />
                                    <c:set var="completedLessons" value="0" />
                                    <c:forEach items="${myCourses}" var="courseInfo">
                                        <c:set var="totalLessons" value="${totalLessons + courseInfo.totalLessons}" />
                                        <c:set var="completedLessons" value="${completedLessons + courseInfo.completedLessons}" />
                                    </c:forEach>
                                    ${completedLessons}
                                </div>
                                <div class="text-muted small">Bài học hoàn thành</div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="h2 fw-bold text-info mb-1">
                                    <c:choose>
                                        <c:when test="${totalLessons > 0}">
                                            ${(completedLessons * 100) / totalLessons}%
                                        </c:when>
                                        <c:otherwise>0%</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="text-muted small">Tiến độ tổng thể</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Set progress bar widths and add animations
        document.addEventListener('DOMContentLoaded', function() {
            // Set progress bar widths
            const progressBars = document.querySelectorAll('.progress-bar-custom[data-progress]');
            progressBars.forEach(bar => {
                const progress = bar.getAttribute('data-progress');
                bar.style.width = progress + '%';
            });
            
            // Add smooth animations
            const cards = document.querySelectorAll('.course-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 