<%-- 
    Document   : home
    Created on : May 23, 2025, 8:45:56 AM
    Author     : Kaonashi
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>SWP391 Home</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    </head>
    <body class="bg-light">
        <jsp:include page="/WEB-INF/views/includes/header.jsp" />

        <div class="container py-5">
            <!-- Slider Section -->
            <div class="mb-5">
                <div class="swiper mySlider position-relative">
                    <div class="swiper-wrapper">
                        <c:forEach var="s" items="${sliders}">
                            <div class="swiper-slide" style="height: 260px;">
                              <a href="${s.linkUrl}" class="d-block w-100 h-100 bg-white rounded shadow-sm overflow-hidden text-decoration-none">
                                <img src="${pageContext.request.contextPath}${s.imageUrl}" alt="${s.title}" class="w-100 h-100 object-fit-cover" style="object-fit:cover;" />
                                <div class="p-3 bg-white bg-opacity-75 position-absolute bottom-0 w-100">
                                  <h4 class="h5 fw-bold text-dark mb-0">${s.title}</h4>
                                </div>
                              </a>
                            </div>
                        </c:forEach>
                    </div>
                    <!-- Navigation Buttons -->
                    <div class="swiper-button-prev position-absolute top-50 start-0 translate-middle-y z-2 bg-white border rounded-circle d-flex align-items-center justify-content-center shadow" style="width:40px;height:40px;"></div>
                    <div class="swiper-button-next position-absolute top-50 end-0 translate-middle-y z-2 bg-white border rounded-circle d-flex align-items-center justify-content-center shadow" style="width:40px;height:40px;"></div>
                </div>
            </div>

            <!-- Blog Section -->
            <div class="mb-5">
                <h2 class="h4 fw-bold border-start border-4 border-primary ps-3 mb-4 text-primary">Blogs</h2>
                <div class="row g-4">
                    <c:forEach var="b" items="${latestBlogs}" varStatus="loop">
                        <div class="col-12 col-sm-6 col-md-4">
                          <a href="${pageContext.request.contextPath}/blog_detail?id=${b.id}" class="bg-white rounded shadow-sm overflow-hidden d-block text-decoration-none h-100">
                              <img src="${pageContext.request.contextPath}/${b.thumbnailUrl}" alt="${b.title}" class="w-100" style="height:180px;object-fit:cover;" />
                              <div class="p-3">
                                  <h4 class="h6 fw-bold mb-1">${b.title}</h4>
                                  <p class="mb-0 text-muted small">${b.publishedAt}</p>
                              </div>
                          </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Recent Subjects -->
            <div class="mb-5">
                <h2 class="h4 fw-bold border-start border-4 border-success ps-3 mb-4 text-success">Latest Subjects</h2>
                <div class="row g-4">
                    <c:forEach var="sub" items="${recentSubjects}" varStatus="loop">
                        <div class="col-12 col-sm-6 col-md-4">
                          <c:choose>
                            <c:when test="${not empty user and (user.role == 'admin' or user.role == 'expert')}">
                              <a href="${pageContext.request.contextPath}/subject-details?id=${sub.id}" class="bg-white rounded shadow-sm overflow-hidden d-block text-decoration-none h-100">
                            </c:when>
                            <c:otherwise>
                              <a href="${pageContext.request.contextPath}/course_list?subjectId=${sub.id}" class="bg-white rounded shadow-sm overflow-hidden d-block text-decoration-none h-100">
                            </c:otherwise>
                          </c:choose>
                              <img src="${sub.thumbnailUrl}" alt="${sub.name}" class="w-100" style="height:180px;object-fit:cover;" />
                              <div class="p-3">
                                  <h4 class="h6 fw-bold mb-1">${sub.name}</h4>
                                  <p class="mb-0 text-muted small">${sub.description}</p>
                              </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Featured Subjects -->
            <div>
                <h2 class="h4 fw-bold border-start border-4 border-primary ps-3 mb-4 text-primary">Featured Subjects</h2>
                <div class="row g-4">
                    <c:forEach var="sub" items="${featuredSubjects}" varStatus="loop">
                        <div class="col-12 col-sm-6 col-md-4">
                          <c:choose>
                            <c:when test="${not empty user and (user.role == 'admin' or user.role == 'expert')}">
                              <a href="${pageContext.request.contextPath}/subject-details?id=${sub.id}" class="bg-white rounded shadow-sm overflow-hidden d-block text-decoration-none h-100">
                            </c:when>
                            <c:otherwise>
                              <a href="${pageContext.request.contextPath}/course_list?subjectId=${sub.id}" class="bg-white rounded shadow-sm overflow-hidden d-block text-decoration-none h-100">
                            </c:otherwise>
                          </c:choose>
                              <img src="${sub.thumbnailUrl}" alt="${sub.name}" class="w-100" style="height:180px;object-fit:cover;" />
                              <div class="p-3">
                                  <h4 class="h6 fw-bold mb-1">${sub.name}</h4>
                                  <p class="mb-0 text-primary small">${sub.description}</p>
                              </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
          const swiper = new Swiper('.mySlider', {
            slidesPerView: 1,
            spaceBetween: 20,
            loop: true,
            navigation: {
              nextEl: '.swiper-button-next',
              prevEl: '.swiper-button-prev'
            }
          });
        </script>
    </body>
</html>
