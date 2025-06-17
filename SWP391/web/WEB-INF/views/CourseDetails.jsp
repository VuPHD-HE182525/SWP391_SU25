<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Course Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: Arial, sans-serif;
            }
            .container {
                margin-top: 30px;
                margin-bottom: 30px;
            }
            .main-content {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .sidebar {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
            }
            .register-btn:hover {
                background-color: #0056b3;
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
        </style>
    </head>
    <body>
        <div class="container">
            <c:if test="${course == null}">
                <div class="alert alert-danger">No course found for this ID. Please check the link or contact support.</div>
            </c:if>
            <div class="row">
                <!-- Main Content -->
                <div class="col-md-8">
                    <div class="main-content">
                        <!-- Subject Title -->
                        <c:if test="${course != null}">
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
                                    <c:if test="${course.coursePackage != null}">
                                        <span class="original-price">$${course.coursePackage.originalPrice}</span>
                                        <span class="sale-price">$${course.coursePackage.salePrice}</span>
                                    </c:if>
                                </div>
                                <form method="get" action="registerSubject">
                                    <input type="hidden" name="id" value="${course.subjectId}" />
                                    <button type="submit" class="register-btn">Register Now</button>
                                </form>
                            </div>

                            <!-- Brief Info -->
                            <div class="section-title">Brief information</div>
                            <c:if test="${not empty course.briefInfo}">
                                <div class="alert alert-info" style="font-size:1.1rem; margin-bottom:15px;">${course.briefInfo}</div>
                            </c:if>

                            <!-- Description -->
                            <div class="section-title">Description:</div>
                            <p>${course.description}</p>
                        </c:if>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="col-md-4">
                    <div class="sidebar">
                        <!-- Subject Search -->
                        <div class="sidebar-section">
                            <form method="get" action="subjects">
                                <input type="text" name="search" class="search-box" placeholder="Subject Search">
                                <button type="submit" class="btn btn-primary mt-2">Search</button>
                            </form>
                        </div>

                        <!-- Subject Categories -->
                        <div class="sidebar-section">
                            <h5>Subject Categories</h5>
                            <ul>
                                <c:forEach var="cat" items="${categories}">
                                    <li><a href="subjects?category=${cat.id}">${cat.name}</a></li>
                                </c:forEach>
                            </ul>
                        </div>

                        <!-- Featured Subjects -->
                        <div class="sidebar-section">
                            <h5>Featured Subjects</h5>
                            <ul>
                                <c:forEach var="subj" items="${featuredSubjects}">
                                    <li><a href="CourseDetailsServlet?subjectId=${subj.id}">${subj.name}</a></li>
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
    </body>
</html>
