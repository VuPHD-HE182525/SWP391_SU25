<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-light bg-light shadow mb-4">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">ELearning</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a></li>
        <li class="nav-item">
          <!-- Courses link with role-based navigation -->
          <c:choose>
            <c:when test="${not empty user and (user.role == 'admin' or user.role == 'expert')}">
              <a class="nav-link" href="${pageContext.request.contextPath}/subject-list">Courses</a>
            </c:when>
            <c:otherwise>
              <a class="nav-link" href="${pageContext.request.contextPath}/course_list">Courses</a>
            </c:otherwise>
          </c:choose>
        </li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/blog-list">Blog</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Overview</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
      </ul>
      <form class="d-flex">
        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
        <button class="btn btn-outline-primary" type="submit">Search</button>
      </form>
    </div>
  </div>
</nav> 