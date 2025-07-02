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
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    </head>
    <body class="bg-gray-100 text-gray-800 font-sans">
        <jsp:include page="/WEB-INF/views/includes/header.jsp" />

        <div class="max-w-6xl mx-auto px-4 py-10">
            <!-- Slider Section -->
            <div class="mb-16">
                <div class="relative swiper mySlider">
                    <div class="swiper-wrapper">
                        <c:forEach var="s" items="${sliders}">
                            <div class="swiper-slide h-64">
                              <a href="${s.linkUrl}" class="block w-full h-full bg-white rounded-lg overflow-hidden shadow hover:shadow-lg transition-all duration-200">
                                <img src="${pageContext.request.contextPath}${s.imageUrl}" alt="${s.title}" class="w-full h-full object-cover" />
                                <div class="p-4 bg-white/70 absolute bottom-0 w-full">
                                  <h4 class="text-lg font-semibold text-gray-800">${s.title}</h4>
                                </div>
                              </a>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Navigation Buttons -->
                    <div class="swiper-button-prev absolute left-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 bg-white border rounded-full flex items-center justify-center shadow hover:bg-gray-100 cursor-pointer"></div>
                    <div class="swiper-button-next absolute right-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 bg-white border rounded-full flex items-center justify-center shadow hover:bg-gray-100 cursor-pointer"></div>
                </div>
            </div>

            <!-- Blog Section -->
            <div class="mb-16">
                <h2 class="text-xl font-semibold border-l-4 border-blue-600 pl-4 mb-6 text-blue-600">Blogs</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    <c:forEach var="b" items="${latestBlogs}" varStatus="loop">
                          <a href="blog-detail.jsp?id=${b.id}" class="bg-white rounded-lg overflow-hidden shadow hover:shadow-lg transition-all duration-200 block">
                              <img src="${b.thumbnailUrl}" alt="${b.title}" class="w-full h-48 object-cover" />
                              <div class="p-4">
                                  <h4 class="text-lg font-semibold">${b.title}</h4>
                                  <p class="text-sm text-gray-500">${b.publishedAt}</p>
                              </div>
                          </a>
                    </c:forEach>
                </div>
            </div>

            <!-- Recent Subjects -->
            <div class="mb-16">
                <h2 class="text-xl font-semibold border-l-4 border-green-600 pl-4 mb-6 text-green-600">Latest Subjects</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    <c:forEach var="sub" items="${recentSubjects}" varStatus="loop">
                          <a href="subjectDetails?id=${sub.id}" class="bg-white rounded-lg overflow-hidden shadow hover:shadow-lg transition-all duration-200 block">
                              <img src="${sub.thumbnailUrl}" alt="${sub.name}" class="w-full h-48 object-cover" />
                              <div class="p-4">
                                  <h4 class="text-lg font-semibold">${sub.name}</h4>
                                  <p class="text-sm text-gray-600">${sub.description}</p>
                              </div>
                          </a>
                    </c:forEach>
                </div>
            </div>

            <!-- Featured Subjects -->
            <div>
                <h2 class="text-xl font-semibold border-l-4 border-blue-600 pl-4 mb-6 text-blue-600">Featured Subjects</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    <c:forEach var="sub" items="${featuredSubjects}" varStatus="loop">
                          <a href="subjectDetails?id=${sub.id}" class="bg-white rounded-lg overflow-hidden shadow hover:shadow-lg transition-all duration-200 block">
                              <img src="${sub.thumbnailUrl}" alt="${sub.name}" class="w-full h-48 object-cover" />
                              <div class="p-4">
                                  <h4 class="text-lg font-semibold">${sub.name}</h4>
                                  <p class="text-sm text-blue-600">${sub.description}</p>
                              </div>
                          </a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

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
