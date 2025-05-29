<%-- 
    Document   : postDetail
    Created on : May 29, 2025, 7:19:16 AM
    Author     : thang
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><c:out value="${post.title}" default="Post Details"/> - FPT EduLearn</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <%-- Bạn có thể thêm link FontAwesome nếu header/footer của bạn có dùng --%>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body class="bg-gray-100 flex flex-col min-h-screen">

        <jsp:include page="header.jsp" />

        <main class="flex-grow container mx-auto px-4 py-8">
            <div class="flex flex-col lg:flex-row gap-8">

                <%-- Kiểm tra xem có đối tượng 'post' không trước khi hiển thị --%>
                <c:if test="${not empty post}">
                    <%-- ===== CỘT TRÁI: NỘI DUNG BÀI VIẾT ===== --%>
                    <article class="w-full lg:w-2/3 bg-white p-6 md:p-8 rounded-lg shadow-md">
                        <%-- Tiêu đề và thông tin meta --%>
                        <div class="mb-6">
                            <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-2"><c:out value="${post.title}"/></h1>
                            <div class="flex flex-wrap items-center text-sm text-gray-500">
                                <span>Author: <span class="font-medium text-gray-700"><c:out value="${post.author}" default="N/A"/></span></span>
                                <span class="mx-2 text-gray-300 hidden md:inline">&bull;</span>
                                <span class="mt-1 md:mt-0">Category: <span class="font-medium text-blue-600"><c:out value="${post.categoryName}" default="Uncategorized"/></span></span>
                                <span class="mx-2 text-gray-300 hidden md:inline">&bull;</span>
                                <span class="mt-1 md:mt-0">Updated: <fmt:formatDate value="${post.updatedAt}" pattern="dd MMM, yyyy"/></span>
                            </div>
                        </div>

                        <%-- Ảnh thumbnail (nếu có) --%>
                        <c:if test="${not empty post.thumbnailUrl}">
                            <img src="${post.thumbnailUrl}" alt="<c:out value="${post.title}"/>" class="w-full h-auto max-h-[500px] object-cover rounded-lg shadow-md mb-6 md:mb-8">
                        </c:if>

                        <%-- Nội dung chi tiết của bài viết --%>
                        <div class="prose prose-lg max-w-none text-gray-800 leading-relaxed">
                            <%-- 
                                QUAN TRỌNG: Nếu nội dung post.content của bạn là HTML, 
                                và bạn tin tưởng nguồn HTML đó, hãy dùng: ${post.content} 
                                hoặc <c:out value="${post.content}" escapeXml="false"/>.
                                CẨN THẬN VỚI LỖI XSS (Cross-Site Scripting) NẾU NGUỒN HTML KHÔNG ĐÁNG TIN CẬY.
                                Nếu chỉ là text thuần, dùng <p><c:out value="${post.content}"/></p> hoặc các thẻ tương tự.
                            --%>
                            ${post.content}
                        </div>
                    </article>

                    <%-- ===== CỘT PHẢI: SIDEBAR ===== --%>
                    <aside class="w-full lg:w-1/3">
                        <div class="sticky top-24 space-y-6">
                            <div class="bg-white p-6 rounded-lg shadow-md">
                                <form action="${pageContext.request.contextPath}/blogs" method="get" class="flex items-center border border-gray-300 rounded-md overflow-hidden">
                                    <input type="text" name="search" placeholder="Search post" 
                                           class="w-full p-3 text-sm text-gray-700 focus:outline-none"
                                           value="<c:out value="${param.search}"/>" >
                                    <button type="submit" class="bg-gray-800 text-white p-3 hover:bg-gray-700 focus:outline-none">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </form>
                            </div>

                            <div class="bg-white p-6 rounded-lg shadow-md">
                                <h3 class="font-semibold text-xl text-gray-800 mb-4 border-b pb-2">Post Categories</h3>
                                <ul class="space-y-2">
                                    <li><a href="${pageContext.request.contextPath}/blogs" class="block py-1 text-gray-600 hover:text-blue-600 hover:bg-gray-50 rounded px-2 transition-colors">All Categories</a></li>
                                        <c:forEach items="${categoryList}" var="cat">
                                            <%-- Dòng này sẽ lặp qua các category bạn vừa thêm vào DB --%>
                                        <li><a href="${pageContext.request.contextPath}/blogs?category=${cat.id}" class="block py-1 text-gray-600 hover:text-blue-600 hover:bg-gray-50 rounded px-2 transition-colors">${cat.name}</a></li>
                                        </c:forEach>
                                </ul>
                            </div>

                            <div class="bg-white p-6 rounded-lg shadow-md">
                                <h3 class="font-semibold text-xl text-gray-800 mb-4 border-b pb-2">Latest Post</h3>
                                <div class="space-y-4">
                                    <c:forEach items="${latestPosts}" var="latest"> <%-- latestPosts được truyền từ Servlet --%>
                                        <a href="${pageContext.request.contextPath}/post-detail?id=${latest.id}" class="flex items-center gap-3 group hover:bg-gray-50 p-2 rounded-md transition-colors">
                                            <c:if test="${not empty latest.thumbnailUrl}">
                                                <img src="${latest.thumbnailUrl}" alt="<c:out value="${latest.title}"/>" class="w-16 h-16 rounded-md object-cover flex-shrink-0">
                                            </c:if>
                                            <%-- Dòng này sẽ hiển thị các "Post title 1", "Post title 2", "Post title 3" --%>
                                            <p class="text-sm font-medium text-gray-700 group-hover:text-blue-600 leading-tight"><c:out value="${latest.title}"/></p>
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="bg-white p-6 rounded-lg shadow-md">
                                <h3 class="font-semibold text-xl text-gray-800 mb-3 border-b pb-2">Contact</h3>
                                <ul class="space-y-2 text-sm text-gray-600">
                                    <li><a href="#" class="hover:text-blue-600">Link 1 (e.g., Support)</a></li>
                                </ul>
                                <h3 class="font-semibold text-xl text-gray-800 mb-3 mt-4 border-b pb-2">Address</h3>
                                <ul class="space-y-2 text-sm text-gray-600">
                                    <li><a href="#" class="hover:text-blue-600">Link 2 (e.g., Location)</a></li>
                                </ul>
                            </div>
                        </div>
                    </aside>
                </c:if>

                <%-- Thông báo nếu không tìm thấy bài viết --%>
                <c:if test="${empty post}">
                    <div class="w-full bg-white p-8 rounded-lg shadow-md text-center col-span-full"> <%-- col-span-full để chiếm toàn bộ nếu không có post --%>
                        <h2 class="text-2xl font-bold text-red-600">Post Not Found</h2>
                        <p class="text-gray-600 mt-4">The post you are looking for does not exist or may have been removed.</p>
                        <a href="${pageContext.request.contextPath}/blogs" class="mt-6 inline-block bg-blue-600 text-white px-6 py-3 rounded-md hover:bg-blue-700 transition-colors">
                            Back to Blog List
                        </a>
                    </div>
                </c:if>
            </div>
        </main>

        <jsp:include page="footer.jsp" />

    </body>
</html>

