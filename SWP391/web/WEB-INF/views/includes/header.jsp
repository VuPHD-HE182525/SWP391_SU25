<%-- 
    Document   : header
    Created on : May 23, 2025, 8:46:24 AM
    Author     : Kaonashi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Bắt đầu header -->
<header class="bg-white shadow-sm sticky-top">
  <div class="container py-2">
    <div class="d-flex align-items-center justify-content-between">
      <!-- Logo -->
      <div class="d-flex align-items-center gap-2">
        <div style="width:32px;height:32px;background:#2563eb;border-radius:50%;display:flex;align-items:center;justify-content:center;">
          <span style="color:#fff;font-weight:bold;font-size:1rem;">E</span>
        </div>
        <span style="font-size:1.5rem;font-weight:bold;color:#222;">ELearning</span>
      </div>
      <!-- Navigation -->
      <nav class="d-none d-md-flex align-items-center gap-4">
        <a href="${pageContext.request.contextPath}/home" class="text-secondary text-decoration-none fw-semibold">Home</a>

        <!-- Courses link with role-based navigation -->
        <c:choose>
          <c:when test="${not empty user and (user.role == 'admin' or user.role == 'expert')}">
            <a href="${pageContext.request.contextPath}/subject-list" class="text-secondary text-decoration-none fw-semibold">Courses</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/course_list" class="text-secondary text-decoration-none fw-semibold">Courses</a>
          </c:otherwise>
        </c:choose>

        <a href="${pageContext.request.contextPath}/blog-list" class="text-secondary text-decoration-none fw-semibold">Blog</a>
        <a href="${pageContext.request.contextPath}/about" class="text-secondary text-decoration-none fw-semibold">About</a>
        <a href="${pageContext.request.contextPath}/contact" class="text-secondary text-decoration-none fw-semibold">Contact</a>
      </nav>
      <!-- Actions -->
      <div class="d-flex align-items-center gap-3">
        <!-- Search -->
        <form class="position-relative d-none d-md-block">
          <input type="search" placeholder="Search..." class="form-control ps-5" style="width:180px;height:36px;" />
          <span class="position-absolute top-50 start-0 translate-middle-y ps-2" style="color:#888;">
            <svg width="18" height="18" fill="currentColor" viewBox="0 0 30 30"><path d="M 13 3 C 7.4889971 3 3 7.4889971 3 13 C 3 18.511003 7.4889971 23 13 23 C 15.396508 23 17.597385 22.148986 19.322266 20.736328 L 25.292969 26.707031 A 1.0001 1.0001 0 1 0 26.707031 25.292969 L 20.736328 19.322266 C 22.148986 17.597385 23 15.396508 23 13 C 23 7.4889971 18.511003 3 13 3 z M 13 5 C 17.430123 5 21 8.5698774 21 13 C 21 17.430123 17.430123 21 13 21 C 8.5698774 21 5 17.430123 5 13 C 5 8.5698774 8.5698774 5 13 5 z"/></svg>
          </span>
        </form>
        <c:choose>
          <c:when test="${not empty user}">
            <!-- Avatar Dropdown -->
            <div class="dropdown">
              <button class="btn p-0 border-0 bg-transparent dropdown-toggle" type="button" id="avatarDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="${empty user.avatarUrl ? '/uploads/images/default-avatar.svg' : user.avatarUrl}" alt="User Avatar" class="rounded-circle border" style="width:36px;height:36px;object-fit:cover;" />
              </button>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="avatarDropdown">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Tài khoản</a></li>
                <li><a class="dropdown-item" href="my-course">Khóa học của tôi</a></li>
                <li><a class="dropdown-item" href="settings">Cài đặt</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
              </ul>
            </div>
          </c:when>
          <c:otherwise>
            <a href="login" class="btn btn-primary px-4">Login</a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</header>
<!-- Kết thúc header -->
