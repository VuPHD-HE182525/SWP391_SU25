<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="model.Blog, model.User, model.Category, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Blog List - ELearning</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .blog-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            border: none;
            height: 100%;
        }
        .blog-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            text-decoration: none;
        }
        .blog-image {
            height: 200px;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
        }
        .blog-excerpt {
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .category-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
        .search-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 4rem 0;
        }
        .sidebar-card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="includes/header.jsp" />
    
    <!-- Hero Section -->
    <section class="search-section">
        <div class="container">
            <div class="row justify-content-center text-center">
                <div class="col-lg-8">
                    <h1 class="display-5 fw-bold mb-3">Our Blog</h1>
                    <p class="lead mb-4">Discover insights, tips, and knowledge from our experts</p>
                    
                    <!-- Search Form -->
                    <form action="blog-list" method="get" class="d-flex justify-content-center">
                        <div class="input-group" style="max-width: 500px;">
                            <input type="text" name="search" class="form-control form-control-lg" 
                                   placeholder="Search articles..." value="${param.search}">
                            <button class="btn btn-light btn-lg" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <main class="container py-5">
        <div class="row g-4">
            <!-- Main Content -->
            <div class="col-lg-8">
                <!-- Filter Info -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="h4 mb-1">
                            <c:choose>
                                <c:when test="${not empty param.search}">
                                    Search results for "${param.search}"
                                </c:when>
                                <c:when test="${not empty param.category}">
                                    Category: ${selectedCategory.name}
                                </c:when>
                                <c:otherwise>
                                    All Articles
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="text-muted mb-0">${totalBlogs} articles found</p>
                    </div>
                    
                    <!-- Sort Options -->
                    <div class="dropdown">
                        <button class="btn btn-outline-secondary dropdown-toggle" type="button" 
                                data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-sort me-1"></i> Sort by
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="?sort=newest">Newest First</a></li>
                            <li><a class="dropdown-item" href="?sort=oldest">Oldest First</a></li>
                            <li><a class="dropdown-item" href="?sort=title">Title A-Z</a></li>
                        </ul>
                    </div>
                </div>

                <!-- Blog Grid -->
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${not empty blogs}">
                            <c:forEach var="blog" items="${blogs}">
                                <div class="col-md-6">
                                    <a href="blog_detail?id=${blog.id}" class="card blog-card text-decoration-none">
                                        <c:if test="${not empty blog.thumbnailUrl}">
                                            <img src="${blog.thumbnailUrl}" alt="${blog.title}" class="card-img-top blog-image">
                                        </c:if>
                                        <c:if test="${empty blog.thumbnailUrl}">
                                            <div class="card-img-top blog-image bg-light d-flex align-items-center justify-content-center">
                                                <i class="fas fa-image text-muted fa-3x"></i>
                                            </div>
                                        </c:if>
                                        
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${blog.publishedAt}" pattern="MMM dd, yyyy"/>
                                                </small>
                                            </div>
                                            
                                            <h5 class="card-title fw-bold text-dark mb-2">${blog.title}</h5>
                                            
                                            <p class="card-text text-muted blog-excerpt">
                                                <c:choose>
                                                    <c:when test="${fn:length(blog.content) > 150}">
                                                        ${fn:substring(blog.content, 0, 150)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${blog.content}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            
                                            <div class="d-flex align-items-center">
                                                <div class="me-2">
                                                    <img src="${authorMap[blog.authorId].avatarUrl != null ? authorMap[blog.authorId].avatarUrl : '/uploads/images/default-avatar.svg'}" 
                                                         alt="Author" class="rounded-circle" style="width: 24px; height: 24px; object-fit: cover;">
                                                </div>
                                                <small class="text-muted">
                                                    By ${authorMap[blog.authorId].fullName}
                                                </small>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="text-center py-5">
                                    <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                    <h3 class="text-muted">No articles found</h3>
                                    <p class="text-muted">Try adjusting your search criteria or browse all articles.</p>
                                    <a href="blog-list" class="btn btn-primary">View All Articles</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Blog pagination" class="mt-5">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&category=${param.category}">
                                        <i class="fas fa-chevron-left"></i> Previous
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${pageNum}&search=${param.search}&category=${param.category}">
                                        ${pageNum}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&category=${param.category}">
                                        Next <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Search Tips -->
                <div class="card sidebar-card mb-4">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-lightbulb me-2 text-primary"></i>Search Tips
                        </h5>
                    </div>
                    <div class="card-body">
                        <ul class="list-unstyled mb-0">
                            <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Use keywords from title or content</li>
                            <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Try different search terms</li>
                            <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Browse all articles below</li>
                        </ul>
                    </div>
                </div>

                <!-- Latest Posts -->
                <div class="card sidebar-card mb-4">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-clock me-2 text-primary"></i>Latest Posts
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:forEach var="latestBlog" items="${latestBlogs}">
                            <div class="d-flex mb-3">
                                <div class="flex-shrink-0 me-3">
                                    <img src="${latestBlog.thumbnailUrl != null ? latestBlog.thumbnailUrl : '/uploads/images/blog-placeholder.jpg'}" 
                                         alt="${latestBlog.title}" class="rounded" style="width: 60px; height: 60px; object-fit: cover;">
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">
                                        <a href="blog_detail?id=${latestBlog.id}" class="text-decoration-none text-dark">
                                            ${fn:length(latestBlog.title) > 50 ? fn:substring(latestBlog.title, 0, 50) : latestBlog.title}...
                                        </a>
                                    </h6>
                                    <small class="text-muted">
                                        <fmt:formatDate value="${latestBlog.publishedAt}" pattern="MMM dd, yyyy"/>
                                    </small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Newsletter Signup -->
                <div class="card sidebar-card">
                    <div class="card-body text-center">
                        <i class="fas fa-envelope fa-2x text-primary mb-3"></i>
                        <h5 class="card-title">Stay Updated</h5>
                        <p class="card-text text-muted">Subscribe to our newsletter for the latest articles and updates.</p>
                        <form>
                            <div class="mb-3">
                                <input type="email" class="form-control" placeholder="Enter your email">
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Subscribe</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
