<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<!-- Debug Information -->
<c:if test="${param.debug eq 'true'}">
    <div style="background: #f0f0f0; padding: 10px; margin: 10px; border: 1px solid #ccc;">
        <h4>Debug Info:</h4>
        <p>Course ID parameter: ${param.courseId}</p>
        <p>Subject ID parameter: ${param.subjectId}</p>
        <p>Course object: ${course != null ? 'Found' : 'NULL'}</p>
        <c:if test="${course != null}">
            <p>Course Title: ${course.title}</p>
            <p>Course ID: ${course.id}</p>
            <p>Subject ID: ${course.subjectId}</p>
        </c:if>
        <p>Error message: ${error}</p>
    </div>
</c:if>

<!-- Error Handling -->
<c:if test="${error != null}">
    <div class="alert alert-danger" role="alert">
        Error: ${error}
    </div>
</c:if>

<!-- Tailwind CSS for header and footer -->
<script src="https://cdn.tailwindcss.com"></script>
<!-- Bootstrap CSS to ensure grid system works -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome for icons -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<style>
    .course-details-container {
        background-color: #f8f9fa;
        font-family: Arial, sans-serif;
        padding-top: 30px;
        padding-bottom: 30px;
        min-height: 80vh;
    }
    
    /* Force proper layout */
    .course-layout {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
    }
    
    .main-content-wrapper {
        flex: 1 1 65%;
        min-width: 300px;
    }
    
    .sidebar-wrapper {
        flex: 1 1 30%;
        min-width: 280px;
    }
    
    .main-content {
        background-color: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        height: fit-content;
    }
    
    .sidebar {
        background-color: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        position: sticky;
        top: 100px;
        height: fit-content;
    }
    
    .subject-title {
        font-size: 2rem;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .subject-tagline {
        color: #007bff;
        font-size: 1.1rem;
        margin-bottom: 20px;
    }
    .subject-image {
        background-color: #e0f7fa;
        padding: 20px;
        border-radius: 8px;
        text-align: center;
        margin-bottom: 20px;
    }
    .subject-image img {
        max-width: 100%;
        max-height: 400px;
        object-fit: contain;
    }
    .price-box {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding: 15px;
        background-color: #f8f9fa;
        border-radius: 8px;
    }
    .price-info {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }
    .original-price {
        text-decoration: line-through;
        color: #6c757d;
        font-size: 1.2rem;
    }
    .sale-price {
        color: #dc3545;
        font-size: 1.5rem;
        font-weight: bold;
    }
    .register-btn {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        font-size: 1.1rem;
        transition: background-color 0.2s;
        cursor: pointer;
    }
    .register-btn:hover {
        background-color: #0056b3;
    }
    
    /* Login Required Button */
    .login-required-btn {
        background: linear-gradient(135deg, #17a2b8, #138496);
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        font-size: 1.1rem;
        transition: all 0.3s;
        cursor: pointer;
        position: relative;
        overflow: hidden;
    }
    
    .login-required-btn:hover {
        background: linear-gradient(135deg, #138496, #117a8b);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(23, 162, 184, 0.4);
    }
    
    .login-required-btn i {
        margin-right: 8px;
        animation: bounce 1.5s infinite;
    }
    
    .login-required-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.5s;
    }
    
    .login-required-btn:hover::before {
        left: 100%;
    }
    
    /* Already Registered Status */
    .registered-status {
        background: linear-gradient(135deg, #28a745, #20c997);
        color: white;
        border: none;
        padding: 12px 20px;
        border-radius: 8px;
        font-size: 1.1rem;
        text-align: center;
        min-width: 180px;
        box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
        animation: pulse 2s infinite;
    }
    
    .registered-status i {
        font-size: 1.2rem;
        margin-right: 5px;
        animation: bounce 2s infinite;
    }
    
    @keyframes pulse {
        0% { box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3); }
        50% { box-shadow: 0 4px 15px rgba(40, 167, 69, 0.5); }
        100% { box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3); }
    }
    
    @keyframes bounce {
        0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
        40% { transform: translateY(-3px); }
        60% { transform: translateY(-1px); }
    }
    
    /* Login Required Modal */
    .login-required-modal {
        display: none;
        position: fixed;
        z-index: 2000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.6);
        animation: fadeIn 0.3s;
    }
    
    .login-required-modal-content {
        background: linear-gradient(135deg, #f8f9fa, #ffffff);
        margin: 10% auto;
        padding: 0;
        border-radius: 15px;
        width: 90%;
        max-width: 450px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        animation: slideInDown 0.4s ease-out;
        overflow: hidden;
    }
    
    .login-modal-header {
        background: linear-gradient(135deg, #17a2b8, #138496);
        color: white;
        padding: 25px;
        text-align: center;
        position: relative;
    }
    
    .login-modal-header h3 {
        margin: 0;
        font-size: 1.6rem;
        font-weight: 600;
    }
    
    .login-modal-header i {
        font-size: 3rem;
        margin-bottom: 10px;
        animation: pulse 2s infinite;
    }
    
    .close-login-modal {
        position: absolute;
        right: 20px;
        top: 20px;
        color: white;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        opacity: 0.8;
        transition: opacity 0.3s;
    }
    
    .close-login-modal:hover {
        opacity: 1;
    }
    
    .login-modal-body {
        padding: 30px 25px;
        text-align: center;
    }
    
    .login-modal-body p {
        font-size: 1.1rem;
        color: #495057;
        margin-bottom: 25px;
        line-height: 1.6;
    }
    
    .login-modal-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        flex-wrap: wrap;
    }
    
    .btn-login-now {
        background: linear-gradient(135deg, #28a745, #20c997);
        color: white;
        border: none;
        padding: 12px 25px;
        border-radius: 8px;
        font-size: 1.1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .btn-login-now:hover {
        background: linear-gradient(135deg, #218838, #1e7e34);
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(40, 167, 69, 0.4);
        color: white;
        text-decoration: none;
    }
    
    .btn-cancel {
        background: #6c757d;
        color: white;
        border: none;
        padding: 12px 25px;
        border-radius: 8px;
        font-size: 1.1rem;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .btn-cancel:hover {
        background: #545b62;
        transform: translateY(-1px);
    }
    
    @keyframes slideInDown {
        from {
            transform: translateY(-50px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }
    
    /* Mobile responsive */
    @media (max-width: 480px) {
        .login-required-modal-content {
            width: 95%;
            margin: 20% auto;
        }
        
        .login-modal-buttons {
            flex-direction: column;
            align-items: center;
        }
        
        .btn-login-now,
        .btn-cancel {
            width: 100%;
            max-width: 200px;
        }
    }
    .section-title {
        font-size: 1.3rem;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .sidebar-section {
        margin-bottom: 20px;
    }
    .sidebar-section ul {
        list-style: none;
        padding: 0;
    }
    .sidebar-section ul li {
        margin-bottom: 10px;
    }
    .sidebar-section ul li a {
        color: #007bff;
        text-decoration: none;
    }
    .sidebar-section ul li a:hover {
        text-decoration: underline;
    }
    .search-box {
        width: 100%;
        padding: 8px;
        border: 1px solid #ced4da;
        border-radius: 5px;
    }
    
    /* Responsive design */
    @media (max-width: 768px) {
        .course-layout {
            flex-direction: column;
        }
        .main-content-wrapper,
        .sidebar-wrapper {
            flex: 1 1 100%;
        }
        .sidebar {
            position: static;
        }
    }
</style>

<div class="course-details-container">
    <div class="container-fluid">
        <c:if test="${course == null}">
            <div class="alert alert-danger">No course found for this ID. Please check the link or contact support.</div>
        </c:if>
        
        <div class="course-layout">
            <!-- Main Content -->
            <div class="main-content-wrapper">
                <div class="main-content">
                    <c:choose>
                        <c:when test="${course != null}">
                            <h1 class="subject-title">${course.title}</h1>

                            <!-- Tagline -->
                            <p class="subject-tagline">${course.tagline}</p>

                            <!-- Image -->
                            <div class="subject-image">
                                <img src="${course.thumbnailUrl}" alt="${course.title}"/>
                            </div>

                            <!-- Pricing -->
                            <div class="price-box">
                                <div class="price-info">
                                    <c:if test="${not empty course.packages}">
                                        <c:set var="firstPackage" value="${course.packages[0]}" />
                                        <span class="original-price">$${firstPackage.originalPrice}</span>
                                        <span class="sale-price">$${firstPackage.salePrice}</span>
                                    </c:if>
                                </div>
                                
                                <!-- Registration Status -->
                                <c:choose>
                                    <c:when test="${isAlreadyRegistered}">
                                        <!-- User already registered -->
                                        <div class="registered-status">
                                            <i class="fas fa-check-circle"></i>
                                            <strong>Already Registered</strong>
                                            <br><small style="font-size: 0.9em; opacity: 0.9;">You are enrolled in this course</small>
                                        </div>
                                        
                                        <!-- Start Learning Buttons -->
                                        <div style="margin-top: 20px; text-align: center;">
                                            <a href="lesson-view?lessonId=1" 
                                               style="display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                                                      color: white; padding: 12px 24px; text-decoration: none; 
                                                      border-radius: 8px; font-weight: 600; margin-right: 10px;
                                                      transition: transform 0.2s ease;">
                                                <i class="fas fa-play-circle" style="margin-right: 8px;"></i>
                                                Start Learning
                                            </a>
                                            <a href="my-course" 
                                               style="display: inline-block; background: #6b7280; 
                                                      color: white; padding: 12px 24px; text-decoration: none; 
                                                      border-radius: 8px; font-weight: 600;
                                                      transition: transform 0.2s ease;">
                                                <i class="fas fa-book" style="margin-right: 8px;"></i>
                                                My Courses
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Check if user is logged in -->
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user}">
                                                <!-- User is logged in, show register button -->
                                                <button type="button" class="register-btn" onclick="openRegistrationModal()">Register Now</button>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- User not logged in, show login required button -->
                                                <button type="button" class="login-required-btn" onclick="showLoginRequiredModal()">
                                                    <i class="fas fa-sign-in-alt"></i>
                                                    Login to Register
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Brief Info -->
                            <div class="section-title">Brief information</div>
                            <c:if test="${not empty course.briefInfo}">
                                <div class="alert alert-info" style="font-size:1.1rem; margin-bottom:15px;">${course.briefInfo}</div>
                            </c:if>

                            <!-- Description -->
                            <div class="section-title">Description:</div>
                            <p>${course.description}</p>
                        </c:when>
                        <c:otherwise>
                            <!-- Course not found content -->
                            <div class="alert alert-warning" role="alert">
                                <h3>Course Not Found</h3>
                                <p>Sorry, the course you're looking for could not be found or may not be available at this time.</p>
                                <p>This could be because:</p>
                                <ul>
                                    <li>The course ID or subject ID is invalid</li>
                                    <li>The course has been temporarily removed</li>
                                    <li>There's no course associated with this subject yet</li>
                                </ul>
                                <p>
                                    <a href="subjects" class="btn btn-primary">Browse All Subjects</a>
                                    <a href="home" class="btn btn-secondary">Go to Home</a>
                                </p>
                            </div>
                            
                            <!-- Debug info for development -->
                            <div class="alert alert-info" role="alert">
                                <h4>Debug Information:</h4>
                                <p><strong>Subject ID:</strong> ${param.subjectId}</p>
                                <p><strong>Course ID:</strong> ${param.courseId}</p>
                                <p><strong>Error:</strong> ${error}</p>
                                <a href="course-details?subjectId=${param.subjectId}&debug=true" class="btn btn-sm btn-outline-info">View Debug Details</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="sidebar-wrapper">
                <div class="sidebar">
                    <!-- Subject Search -->
                    <div class="sidebar-section">
                        <h5>Subject Search</h5>
                        <form method="get" action="course_list">
                            <input type="text" name="search" class="search-box form-control" placeholder="Search subjects...">
                            <button type="submit" class="btn btn-primary mt-2 w-100">Search</button>
                        </form>
                    </div>

                    <!-- Subject Categories -->
                    <div class="sidebar-section">
                        <h5>Subject Categories</h5>
                        <ul>
                            <c:forEach var="cat" items="${categories}">
                                <li><a href="course_list?category=${cat.id}" class="text-decoration-none">${cat.name}</a></li>
                            </c:forEach>
                        </ul>
                    </div>

                    <!-- Featured Subjects -->
                    <div class="sidebar-section">
                        <h5>Featured Subjects</h5>
                        <ul>
                            <c:forEach var="subj" items="${featuredSubjects}">
                                <li><a href="course-details?subjectId=${subj.id}">${subj.name}</a></li>
                            </c:forEach>
                        </ul>
                    </div>

                    <!-- Contacts -->
                    <div class="sidebar-section">
                        <h5>Contacts</h5>
                        <ul>
                            <c:forEach var="contact" items="${contacts}">
                                <li>${contact.type}: ${contact.value}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Login Required Modal -->
<div id="loginRequiredModal" class="login-required-modal">
    <div class="login-required-modal-content">
        <div class="login-modal-header">
            <span class="close-login-modal" onclick="closeLoginRequiredModal()">&times;</span>
            <i class="fas fa-sign-in-alt"></i>
            <h3>Login Required</h3>
        </div>
        <div class="login-modal-body">
            <p>You need to be logged in to register for courses.</p>
            <p>Please login to your account or create a new account to continue.</p>
            <div class="login-modal-buttons">
                <a href="login" class="btn-login-now">
                    <i class="fas fa-sign-in-alt"></i>
                    Login Now
                </a>
                <button class="btn-cancel" onclick="closeLoginRequiredModal()">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!-- Include Registration Modal -->
<jsp:include page="/WEB-INF/views/includes/registration_modal.jsp" />

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Header JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Let Bootstrap handle the dropdown automatically
    // Bootstrap dropdown will work with data-bs-toggle="dropdown" attribute
});
</script>

<!-- Login Required Modal JavaScript -->
<script>
// Show login required modal
function showLoginRequiredModal() {
    const modal = document.getElementById('loginRequiredModal');
    modal.style.display = 'block';
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
    
    // Add smooth entrance animation
    setTimeout(() => {
        modal.style.opacity = '1';
    }, 10);
}

// Close login required modal
function closeLoginRequiredModal() {
    const modal = document.getElementById('loginRequiredModal');
    modal.style.display = 'none';
    document.body.style.overflow = 'auto'; // Restore scrolling
}

// Close modal when clicking outside of it
window.addEventListener('click', function(event) {
    const modal = document.getElementById('loginRequiredModal');
    if (event.target === modal) {
        closeLoginRequiredModal();
    }
});

// Close modal with Escape key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        const modal = document.getElementById('loginRequiredModal');
        if (modal.style.display === 'block') {
            closeLoginRequiredModal();
        }
    }
});

// Prevent modal content clicks from closing the modal
document.querySelector('.login-required-modal-content')?.addEventListener('click', function(e) {
    e.stopPropagation();
});
</script>

<!-- Registration Success/Error Handling -->
<c:if test="${not empty registrationSuccess}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof showSuccessNotification === 'function') {
                showSuccessNotification('${registrationSuccess}');
            }
        });
    </script>
</c:if>

<c:if test="${not empty registrationError}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof showErrorNotification === 'function') {
                showErrorNotification('${registrationError}');
            } else {
                alert('Error: ${registrationError}');
            }
        });
    </script>
</c:if>

<!-- Quick Access to Lessons Section -->
<c:if test="${not empty sessionScope.user}">
    <div class="fixed bottom-4 right-4 z-50">
        <div class="bg-blue-600 text-white p-4 rounded-lg shadow-lg max-w-sm">
            <h4 class="font-bold mb-2">📚 Quick Access to Lessons</h4>
            <div class="space-y-1">
                <a href="lesson-view?lessonId=1" class="block text-blue-200 hover:text-white text-sm">
                    ▶️ Lesson 1: Lắng nghe chủ động
                </a>
                <a href="lesson-view?lessonId=2" class="block text-blue-200 hover:text-white text-sm">
                    ▶️ Lesson 2: Nói để người khác nghe
                </a>
                <a href="lesson-view?lessonId=3" class="block text-blue-200 hover:text-white text-sm">
                    ▶️ Lesson 3: Phân vai trong nhóm
                </a>
                <a href="lesson-view?lessonId=4" class="block text-blue-200 hover:text-white text-sm">
                    ▶️ Lesson 4: Giải quyết xung đột
                </a>
            </div>
            <button onclick="this.parentElement.style.display='none'" 
                    class="mt-2 text-xs text-blue-200 hover:text-white">
                ✕ Close
            </button>
        </div>
    </div>
</c:if>

</body>
</html>

