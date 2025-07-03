<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Blog, model.User, model.Category, java.util.List" %>
<jsp:include page="includes/header.jsp" />

<main class="main-content flex flex-col md:flex-row gap-8 max-w-7xl mx-auto py-8 px-4">
    <!-- Main Blog Content -->
    <section class="flex-1 bg-white rounded-xl shadow p-8">
        <h1 class="text-3xl font-bold mb-2">${blog.title}</h1>
        <div class="text-sm text-gray-500 mb-4">
            Author: <b>${author.fullName}</b>
            <span class="mx-2">·</span>
            Category: <a href="#" class="text-blue-600 hover:underline">${category != null ? category.name : 'Uncategorized'}</a>
            <span class="mx-2">·</span>
            Updated: <fmt:formatDate value="${blog.publishedAt}" pattern="dd MMM, yyyy"/>
        </div>
        <c:if test="${not empty blog.thumbnailUrl}">
            <img src="${blog.thumbnailUrl}" alt="${blog.title}" class="rounded-lg w-full max-h-96 object-cover mb-6" />
        </c:if>
        <div class="prose max-w-none text-lg">
            ${blog.content}
        </div>
    </section>

    <!-- Sidebar -->
    <aside class="w-full md:w-80 flex-shrink-0 flex flex-col gap-6">
        <!-- Search -->
        <form action="/blog_list" method="get" class="bg-white rounded-xl shadow p-4 flex items-center gap-2">
            <input type="text" name="q" placeholder="Search post" class="flex-1 border rounded px-3 py-2 focus:outline-none" />
            <button type="submit" class="bg-gray-800 text-white px-3 py-2 rounded hover:bg-blue-600">
                <i class="fa fa-search"></i>
            </button>
        </form>
        <!-- Categories -->
        <div class="bg-white rounded-xl shadow p-4">
            <h2 class="font-semibold mb-2">Post Categories</h2>
            <ul class="text-gray-700 text-sm">
                <li><a href="/blog_list" class="hover:underline">All Categories</a></li>
                <c:forEach var="cat" items="${categories}">
                    <li><a href="/blog_list?category=${cat.id}" class="hover:underline">${cat.name}</a></li>
                </c:forEach>
            </ul>
        </div>
        <!-- Latest Posts -->
        <div class="bg-white rounded-xl shadow p-4">
            <h2 class="font-semibold mb-2">Latest Post</h2>
            <c:forEach var="post" items="${latestBlogs}">
                <div class="mb-3 flex gap-3 items-center">
                    <img src="${post.thumbnailUrl}" alt="${post.title}" class="w-14 h-14 object-cover rounded" />
                    <div>
                        <a href="/blog_detail?id=${post.id}" class="font-medium hover:underline">${post.title}</a>
                        <div class="text-xs text-gray-500">
                            <fmt:formatDate value="${post.publishedAt}" pattern="dd MMM, yyyy"/>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <!-- Contact/Links -->
        <div class="bg-white rounded-xl shadow p-4">
            <h2 class="font-semibold mb-2">Contact</h2>
            <div class="text-sm text-gray-700">Link 1 (e.g., Support)</div>
            <h2 class="font-semibold mt-4 mb-2">Address</h2>
            <div class="text-sm text-gray-700">Link 2 (e.g., Location)</div>
        </div>
    </aside>
</main>

<jsp:include page="includes/footer.jsp" />

<!-- Thêm các thẻ link/script cho Tailwind, FontAwesome nếu cần -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet"> 