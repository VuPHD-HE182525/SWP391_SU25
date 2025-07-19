<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Registration Modal CSS -->
<style>
    /* Registration Modal Styles */
    .registration-modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
        animation: fadeIn 0.3s;
        overflow-y: auto;
        padding: 20px 0;
    }
    
    .registration-modal-content {
        background-color: #fefefe;
        margin: 0 auto;
        padding: 0;
        border-radius: 12px;
        width: 90%;
        max-width: 500px;
        min-height: auto;
        max-height: none;
        box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        animation: slideIn 0.3s;
        position: relative;
    }
    
    .modal-header {
        background: linear-gradient(135deg, #007bff, #0056b3);
        color: white;
        padding: 20px;
        border-radius: 12px 12px 0 0;
        position: relative;
    }
    
    .modal-header h2 {
        margin: 0;
        font-size: 1.5rem;
    }
    
    .close-modal {
        color: white;
        float: right;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        position: absolute;
        right: 15px;
        top: 15px;
    }
    
    .close-modal:hover {
        opacity: 0.7;
    }
    
    .modal-body {
        padding: 25px;
        max-height: calc(80vh - 100px);
        overflow-y: auto;
        scroll-behavior: smooth;
        scrollbar-width: thin;
        scrollbar-color: #007bff #f1f1f1;
    }
    
    /* Custom scrollbar for webkit browsers */
    .modal-body::-webkit-scrollbar {
        width: 8px;
    }
    
    .modal-body::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 4px;
    }
    
    .modal-body::-webkit-scrollbar-thumb {
        background: #007bff;
        border-radius: 4px;
    }
    
    .modal-body::-webkit-scrollbar-thumb:hover {
        background: #0056b3;
    }
    
    /* Success Notification Styles */
    .success-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        background: linear-gradient(135deg, #28a745, #20c997);
        color: white;
        padding: 15px 25px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        z-index: 2000;
        display: none;
        animation: slideInRight 0.5s ease-out;
        font-weight: 500;
        min-width: 300px;
    }
    
    .success-notification.show {
        display: block;
    }
    
    .success-notification .notification-icon {
        display: inline-block;
        width: 20px;
        height: 20px;
        margin-right: 10px;
        vertical-align: middle;
        background-color: white;
        border-radius: 50%;
        text-align: center;
        line-height: 20px;
        color: #28a745;
        font-weight: bold;
    }
    
    .success-notification .notification-text {
        display: inline-block;
        vertical-align: middle;
    }
    
    .success-notification .close-notification {
        float: right;
        background: none;
        border: none;
        color: white;
        font-size: 18px;
        cursor: pointer;
        margin-left: 15px;
        opacity: 0.8;
    }
    
    .success-notification .close-notification:hover {
        opacity: 1;
    }
    
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    .success-notification.hide {
        animation: slideOutRight 0.5s ease-in;
    }
    
    /* Error Notification Styles */
    .error-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        background: linear-gradient(135deg, #dc3545, #c82333);
        color: white;
        padding: 15px 25px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        z-index: 2000;
        display: none;
        animation: slideInRight 0.5s ease-out;
        font-weight: 500;
        min-width: 300px;
    }
    
    .error-notification.show {
        display: block;
    }
    
    .error-notification .notification-icon {
        display: inline-block;
        width: 20px;
        height: 20px;
        margin-right: 10px;
        vertical-align: middle;
        background-color: white;
        border-radius: 50%;
        text-align: center;
        line-height: 20px;
        color: #dc3545;
        font-weight: bold;
    }
    
    .error-notification .notification-text {
        display: inline-block;
        vertical-align: middle;
    }
    
    .error-notification .close-notification {
        float: right;
        background: none;
        border: none;
        color: white;
        font-size: 18px;
        cursor: pointer;
        margin-left: 15px;
        opacity: 0.8;
    }
    
    .error-notification .close-notification:hover {
        opacity: 1;
    }
    
    .error-notification.hide {
        animation: slideOutRight 0.5s ease-in;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
        color: #333;
    }
    
    .form-group input,
    .form-group select {
        width: 100%;
        padding: 12px;
        border: 2px solid #e1e5e9;
        border-radius: 8px;
        box-sizing: border-box;
        font-size: 14px;
        transition: all 0.3s ease;
    }
    
    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 3px rgba(0,123,255,0.1);
        transform: translateY(-1px);
    }
    
    .btn-register-modal {
        background: linear-gradient(135deg, #28a745, #20c997);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 6px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        width: 100%;
        transition: all 0.3s;
    }
    
    .btn-register-modal:hover {
        background: linear-gradient(135deg, #218838, #1e7e34);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }
    
    .user-info-display {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
    }
    
    .user-info-display h5 {
        margin-bottom: 10px;
        color: #007bff;
    }
    
    .user-info-display p {
        margin: 5px 0;
        color: #333;
    }
    
    .file-upload-group {
        margin-bottom: 15px;
    }
    
    .file-upload-button {
        background-color: #f8f9fa;
        border: 2px dashed #dee2e6;
        padding: 10px 15px;
        border-radius: 5px;
        cursor: pointer;
        width: 100%;
        text-align: center;
        transition: all 0.3s;
    }
    
    .file-upload-button:hover {
        background-color: #e9ecef;
        border-color: #007bff;
    }
    
    .file-upload-input {
        display: none;
    }
    
    .file-info {
        font-size: 12px;
        color: #6c757d;
        margin-top: 5px;
    }
    
    .file-preview {
        margin-top: 10px;
        padding: 10px;
        background-color: #f8f9fa;
        border-radius: 5px;
        display: none;
    }
    
    .file-preview img {
        max-width: 100%;
        max-height: 200px;
        border-radius: 5px;
    }
    
    .file-preview video {
        max-width: 100%;
        max-height: 200px;
        border-radius: 5px;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    @keyframes slideIn {
        from { transform: translateY(-50px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    
    /* Responsive Modal Design */
    @media (max-width: 768px) {
        .registration-modal {
            padding: 10px 0;
        }
        
        .registration-modal-content {
            width: 95%;
            margin: 0 auto;
        }
        
        .modal-body {
            padding: 20px 15px;
            max-height: calc(85vh - 80px);
        }
        
        .modal-header {
            padding: 15px 20px;
        }
        
        .modal-header h2 {
            font-size: 1.3rem;
        }
    }
    
    @media (max-width: 480px) {
        .registration-modal {
            padding: 5px 0;
        }
        
        .registration-modal-content {
            width: 98%;
            border-radius: 8px;
        }
        
        .modal-body {
            padding: 15px 10px;
            max-height: calc(90vh - 60px);
        }
        
        .modal-header {
            padding: 12px 15px;
            border-radius: 8px 8px 0 0;
        }
        
        .modal-header h2 {
            font-size: 1.2rem;
        }
        
        .close-modal {
            font-size: 24px;
            right: 10px;
            top: 10px;
        }
    }
    
    @media (max-height: 600px) {
        .modal-body {
            max-height: calc(70vh - 80px);
        }
    }
    
    /* Mobile Responsive for Notifications */
    @media (max-width: 768px) {
        .success-notification,
        .error-notification {
            top: 10px;
            right: 10px;
            left: 10px;
            min-width: auto;
            padding: 12px 20px;
            font-size: 14px;
        }
        
        /* Stack notifications if both appear */
        .error-notification.show ~ .success-notification.show {
            top: 80px;
        }
    }
</style>

<!-- Success Notification -->
<div id="successNotification" class="success-notification">
    <span class="notification-icon">✓</span>
    <span class="notification-text">Registration successful! Welcome to our platform.</span>
    <button class="close-notification" onclick="hideSuccessNotification()">&times;</button>
</div>

<!-- Error Notification -->
<div id="errorNotification" class="error-notification">
    <span class="notification-icon">!</span>
    <span class="notification-text">An error occurred during registration.</span>
    <button class="close-notification" onclick="hideErrorNotification()">&times;</button>
</div>

<!-- Registration Modal -->
<div id="registrationModal" class="registration-modal">
    <div class="registration-modal-content">
        <div class="modal-header">
            <h2>Register for ${course.title}</h2>
            <span class="close-modal" onclick="closeRegistrationModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form id="registrationForm" method="post" action="register" enctype="multipart/form-data">
                <input type="hidden" name="subjectId" value="${course.subjectId}" />
                
                <!-- Package Selection -->
                <div class="form-group">
                    <label for="packageId">Choose Package:</label>
                    <select name="packageId" id="packageId" required>
                        <c:forEach var="pkg" items="${packages}">
                            <option value="${pkg.id}">${pkg.name} - $${pkg.salePrice} (${pkg.duration} months)</option>
                        </c:forEach>
                    </select>
                </div>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <!-- User is logged in, show info as read-only -->
                        <div class="user-info-display">
                            <h5>Registration Information:</h5>
                            <p><strong>Name:</strong> ${not empty sessionScope.user.fullName ? sessionScope.user.fullName : 'Not provided'}</p>
                            <p><strong>Email:</strong> ${not empty sessionScope.user.email ? sessionScope.user.email : 'Not provided'}</p>
                            <p><strong>Mobile:</strong> ${not empty sessionScope.user.phone ? sessionScope.user.phone : 'Not provided'}</p>
                            <p><strong>Gender:</strong> ${not empty sessionScope.user.gender ? sessionScope.user.gender : 'Not provided'}</p>
                        </div>
                        
                        <!-- Check if user has required info, if not show input fields -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.fullName and not empty sessionScope.user.email and not empty sessionScope.user.phone and not empty sessionScope.user.gender}">
                                <!-- User has complete info, use hidden fields -->
                                <input type="hidden" name="fullName" value="${sessionScope.user.fullName}" />
                                <input type="hidden" name="email" value="${sessionScope.user.email}" />
                                <input type="hidden" name="mobile" value="${sessionScope.user.phone}" />
                                <input type="hidden" name="gender" value="${sessionScope.user.gender}" />
                            </c:when>
                            <c:otherwise>
                                <!-- User has incomplete info, show input fields with defaults -->
                                <p style="color: #dc3545; margin: 15px 0;"><strong>⚠ Please complete your profile information:</strong></p>
                                
                                <div class="form-group">
                                    <label for="fullName">Full Name:</label>
                                    <input type="text" name="fullName" id="fullName" value="${sessionScope.user.fullName}" required />
                                </div>
                                <div class="form-group">
                                    <label for="email">Email:</label>
                                    <input type="email" name="email" id="email" value="${sessionScope.user.email}" required />
                                </div>
                                <div class="form-group">
                                    <label for="mobile">Mobile:</label>
                                    <input type="text" name="mobile" id="mobile" value="${sessionScope.user.phone}" required />
                                </div>
                                <div class="form-group">
                                    <label for="gender">Gender:</label>
                                    <select name="gender" id="gender" required>
                                        <option value="">Select Gender</option>
                                        <option value="Male" ${sessionScope.user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${sessionScope.user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                        <option value="Other" ${sessionScope.user.gender == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- User is not logged in, show input fields -->
                        <div class="form-group">
                            <label for="fullName">Full Name:</label>
                            <input type="text" name="fullName" id="fullName" required />
                        </div>
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" name="email" id="email" required />
                        </div>
                        <div class="form-group">
                            <label for="mobile">Mobile:</label>
                            <input type="text" name="mobile" id="mobile" required />
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender:</label>
                            <select name="gender" id="gender" required>
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <!-- Optional Media Uploads -->
                <div class="form-group">
                    <label>Image About Yourself (Optional):</label>
                    <div class="file-upload-group" id="imageUploadArea">
                        <button type="button" class="file-upload-button" onclick="document.getElementById('imageUpload').click()">
                            📷 Choose Image
                        </button>
                        <input type="file" id="imageUpload" name="profileImage" class="file-upload-input" accept="image/*" onchange="previewImage(this)">
                        <div class="file-info">Supported formats: JPG, PNG, GIF (Max: 5MB)</div>
                        <div id="imagePreview" class="file-preview"></div>
                    </div>
                    <input type="text" name="imageCaption" placeholder="Caption for your image (optional)" class="form-control" style="margin-top: 10px;">
                </div>
                
                <div class="form-group">
                    <label>Video About Yourself (Optional):</label>
                    <div class="file-upload-group" id="videoUploadArea">
                        <button type="button" class="file-upload-button" onclick="document.getElementById('videoUpload').click()">
                            🎥 Choose Video
                        </button>
                        <input type="file" id="videoUpload" name="profileVideo" class="file-upload-input" accept="video/*" onchange="previewVideo(this)">
                        <div class="file-info">Supported formats: MP4, AVI, MOV (Max: 50MB)</div>
                        <div id="videoPreview" class="file-preview"></div>
                    </div>
                    <input type="text" name="videoCaption" placeholder="Caption for your video (optional)" class="form-control" style="margin-top: 10px;">
                </div>
                
                <button type="submit" class="btn-register-modal">Complete Registration</button>
            </form>
        </div>
    </div>
</div>

<!-- Registration Modal JavaScript -->
<script>
function openRegistrationModal() {
    const modal = document.getElementById('registrationModal');
    modal.style.display = 'block';
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
    
    // Scroll modal to top and focus on first input
    setTimeout(() => {
        scrollModalToTop();
        const firstInput = modal.querySelector('input[type="text"], input[type="email"], select');
        if (firstInput) {
            firstInput.focus();
        }
    }, 100);
}

function closeRegistrationModal() {
    document.getElementById('registrationModal').style.display = 'none';
    document.body.style.overflow = 'auto'; // Restore scrolling
}

// Close modal when clicking outside of it
window.onclick = function(event) {
    var modal = document.getElementById('registrationModal');
    if (event.target == modal) {
        closeRegistrationModal();
    }
}

// Prevent modal from closing when clicking on modal content
document.querySelector('.registration-modal-content').addEventListener('click', function(e) {
    e.stopPropagation();
});

// Smooth scroll to top when modal opens
function scrollModalToTop() {
    const modalBody = document.querySelector('.modal-body');
    if (modalBody) {
        modalBody.scrollTop = 0;
    }
}

// Close modal with Escape key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeRegistrationModal();
    }
});

// Image preview function
function previewImage(input) {
    const preview = document.getElementById('imagePreview');
    if (input.files && input.files[0]) {
        const file = input.files[0];
        
        // Check file size (5MB limit)
        if (file.size > 5 * 1024 * 1024) {
            alert('Image file size must be less than 5MB');
            input.value = '';
            preview.style.display = 'none';
            return;
        }
        
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.innerHTML = `
                <p><strong>Selected:</strong> ${file.name}</p>
                <img src="${e.target.result}" alt="Preview" style="max-width: 100%; max-height: 200px;">
            `;
            preview.style.display = 'block';
        }
        reader.readAsDataURL(file);
    } else {
        preview.style.display = 'none';
    }
}

// Video preview function
function previewVideo(input) {
    const preview = document.getElementById('videoPreview');
    if (input.files && input.files[0]) {
        const file = input.files[0];
        
        // Check file size (50MB limit)
        if (file.size > 50 * 1024 * 1024) {
            alert('Video file size must be less than 50MB');
            input.value = '';
            preview.style.display = 'none';
            return;
        }
        
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.innerHTML = `
                <p><strong>Selected:</strong> ${file.name}</p>
                <video controls style="max-width: 100%; max-height: 200px;">
                    <source src="${e.target.result}" type="${file.type}">
                    Your browser does not support the video tag.
                </video>
            `;
            preview.style.display = 'block';
        }
        reader.readAsDataURL(file);
    } else {
        preview.style.display = 'none';
    }
}

// Success Notification Functions
function showSuccessNotification(message = 'Registration successful! Welcome to our platform.') {
    const notification = document.getElementById('successNotification');
    const textElement = notification.querySelector('.notification-text');
    
    // Update message if provided
    textElement.textContent = message;
    
    // Show notification
    notification.classList.remove('hide');
    notification.classList.add('show');
    
    // Auto hide after 5 seconds
    setTimeout(() => {
        hideSuccessNotification();
    }, 5000);
}

function hideSuccessNotification() {
    const notification = document.getElementById('successNotification');
    notification.classList.add('hide');
    
    // Remove from DOM after animation
    setTimeout(() => {
        notification.classList.remove('show', 'hide');
    }, 500);
}

// Error Notification Functions
function showErrorNotification(message = 'An error occurred during registration.') {
    const notification = document.getElementById('errorNotification');
    const textElement = notification.querySelector('.notification-text');
    
    // Update message if provided
    textElement.textContent = message;
    
    // Show notification
    notification.classList.remove('hide');
    notification.classList.add('show');
    
    // Auto hide after 5 seconds
    setTimeout(() => {
        hideErrorNotification();
    }, 5000);
}

function hideErrorNotification() {
    const notification = document.getElementById('errorNotification');
    notification.classList.add('hide');
    
    // Remove from DOM after animation
    setTimeout(() => {
        notification.classList.remove('show', 'hide');
    }, 500);
}

// Form validation and submission
document.getElementById('registrationForm').addEventListener('submit', function(e) {
    const packageId = document.getElementById('packageId').value;
    if (!packageId) {
        e.preventDefault();
        alert('Please select a package');
        return false;
    }
    
    // Check if required fields are filled (for both logged in and not logged in users)
    // We check if input fields exist (they may exist if user profile is incomplete)
    const fullNameField = document.getElementById('fullName');
    const emailField = document.getElementById('email');
    const mobileField = document.getElementById('mobile');
    const genderField = document.getElementById('gender');
    
    // If input fields exist, validate them
    if (fullNameField || emailField || mobileField || genderField) {
        const fullName = fullNameField ? fullNameField.value : '';
        const email = emailField ? emailField.value : '';
        const mobile = mobileField ? mobileField.value : '';
        const gender = genderField ? genderField.value : '';
        
        if (!fullName || !email || !mobile || !gender) {
            e.preventDefault();
            alert('Please fill in all required fields');
            return false;
        }
        
        // Basic email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            e.preventDefault();
            alert('Please enter a valid email address');
            return false;
        }
    }
    
    // For actual form submission
    return true;
});
</script> 