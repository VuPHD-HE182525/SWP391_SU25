<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Blog, model.User, model.Category, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Blog Details</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-light">
<jsp:include page="includes/header.jsp" />
<main class="container py-5">
    <div class="row g-4">
        <!-- Main Blog Content -->
        <section class="col-12 col-md-8">
            <div class="bg-white rounded shadow-sm p-4 mb-4">
                <h1 class="h3 fw-bold mb-2">${blog.title}</h1>
                <div class="text-secondary small mb-3">
                    Author: <b>${author.fullName}</b>
                    <span class="mx-2">·</span>
                    Category: <a href="#" class="text-primary text-decoration-none">${category != null ? category.name : 'Uncategorized'}</a>
                    <span class="mx-2">·</span>
                    Updated: <fmt:formatDate value="${blog.publishedAt}" pattern="dd MMM, yyyy"/>
                </div>
                <c:if test="${not empty blog.thumbnailUrl}">
                    <img src="${blog.thumbnailUrl}" alt="${blog.title}" class="rounded w-100 mb-4" style="max-height:350px;object-fit:cover;" />
                </c:if>
                <div class="mb-2" style="font-size:1.1em;">
                    ${blog.content}
                </div>
            </div>
        </section>
        <!-- Sidebar -->
        <aside class="col-12 col-md-4">
            <!-- Search -->
            <form action="/blog_list" method="get" class="bg-white rounded shadow-sm p-3 mb-4 d-flex align-items-center gap-2">
                <input type="text" name="q" placeholder="Search post" class="form-control" />
                <button type="submit" class="btn btn-dark"><i class="fa fa-search"></i></button>
            </form>
            <!-- Categories -->
            <div class="bg-white rounded shadow-sm p-3 mb-4">
                <h2 class="h6 fw-bold mb-2">Post Categories</h2>
                <ul class="list-unstyled mb-0">
                    <li><a href="/blog_list" class="text-decoration-none">All Categories</a></li>
                    <c:forEach var="cat" items="${categories}">
                        <li><a href="/blog_list?category=${cat.id}" class="text-decoration-none">${cat.name}</a></li>
                    </c:forEach>
                </ul>
            </div>
            <!-- Latest Posts -->
            <div class="bg-white rounded shadow-sm p-3 mb-4">
                <h2 class="h6 fw-bold mb-2">Latest Post</h2>
                <c:forEach var="post" items="${latestBlogs}">
                    <div class="mb-3 d-flex gap-3 align-items-center">
                        <img src="${post.thumbnailUrl}" alt="${post.title}" class="rounded" style="width:56px;height:56px;object-fit:cover;" />
                        <div>
                            <a href="/blog_detail?id=${post.id}" class="fw-medium text-decoration-none">${post.title}</a>
                            <div class="text-secondary small">
                                <fmt:formatDate value="${post.publishedAt}" pattern="dd MMM, yyyy"/>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <!-- Contact/Links -->
            <div class="bg-white rounded shadow-sm p-3 mb-4">
                <h2 class="h6 fw-bold mb-2">Contact</h2>
                <div class="small text-secondary">Link 1 (e.g., Support)</div>
                <h2 class="h6 fw-bold mt-3 mb-2">Address</h2>
                <div class="small text-secondary">Link 2 (e.g., Location)</div>
            </div>
        </aside>
    </div>
</main>
<jsp:include page="includes/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 