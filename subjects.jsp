<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    body {
        font-family: 'Segoe UI', Arial, sans-serif;
        margin: 0;
        background: #f7f7f7;
    }
    .container { display: flex; min-height: 100vh; }
    .sidebar {
        width: 320px;
        padding: 32px 24px;
        background: #fff;
        border-left: 1px solid #e0e0e0;
        box-shadow: -2px 0 8px #eee;
    }
    .main {
        flex: 1;
        padding: 40px 32px;
    }
    .subjects-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 32px;
        justify-content: center;
    }
    .subject-card {
        width: 100%;
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 2px 12px #e0e0e0;
        margin: 8px;
        cursor: pointer;
        transition: box-shadow 0.2s;
    }
    .subject-card:hover {
        box-shadow: 0 4px 24px #ccc;
    }
    .subject-card img {
        width: 100%;
        height: 140px;
        object-fit: cover;
        border-radius: 12px 12px 0 0;
        background: #d0eaff;
    }
    .subject-info {
        padding: 18px 16px 16px 16px;
    }
    .subject-title {
        font-size: 1.2em;
        font-weight: bold;
        margin-bottom: 4px;
    }
    .subject-tagline {
        color: #666;
        font-size: 0.98em;
        margin-bottom: 10px;
    }
    .price-info {
        margin-bottom: 10px;
    }
    .list-price {
        color: #888;
        text-decoration: line-through;
        margin-right: 8px;
    }
    .sale-price {
        color: #e74c3c;
        font-weight: bold;
        font-size: 1.1em;
    }
    .register-btn {
        background: #e74c3c;
        color: white;
        border: none;
        padding: 8px 18px;
        border-radius: 4px;
        cursor: pointer;
        float: right;
        font-weight: bold;
        transition: background 0.2s;
    }
    .register-btn:hover {
        background: #c0392b;
    }
    .pagination {
        margin-top: 32px;
        text-align: center;
    }
    .pagination button, .pagination a {
        margin: 0 4px;
        padding: 6px 14px;
        border: none;
        background: #eee;
        border-radius: 4px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        color: #333;
    }
    .pagination .active {
        background: #e74c3c;
        color: #fff;
    }
    .sidebar h3 {
        margin-top: 32px;
        margin-bottom: 10px;
        font-size: 1.1em;
        color: #222;
    }
    .sidebar ul {
        list-style: disc inside;
        margin: 0 0 18px 0;
        padding: 0 0 0 10px;
    }
    .sidebar li {
        margin-bottom: 6px;
        color: #444;
    }
    .sidebar label {
        font-weight: bold;
        color: #333;
    }
    .sidebar input[type='text'] {
        width: 100%;
        padding: 7px 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        margin: 8px 0 12px 0;
        font-size: 1em;
    }
    .sidebar button[type='submit'] {
        background: #e74c3c;
        color: #fff;
        border: none;
        padding: 7px 18px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
    }
    .sidebar button[type='submit']:hover {
        background: #c0392b;
    }
</style>

<div class="container">
    <!-- Sidebar -->
    <div class="sidebar">
        <form method="get" action="subjects" id="searchForm">
            <label>Subject Search</label>
            <div style="display: flex; gap: 5px; margin-bottom: 12px;">
                <input type="text" name="search" value="${param.search}" placeholder="Search subjects..." id="searchInput" style="flex: 1;" />
                <button type="button" id="directSearchBtn" class="btn btn-primary" style="white-space: nowrap;">Search</button>
            </div>
            <label style="margin-top: 10px;">Category</label>
            <select name="category" class="form-select" style="margin-bottom: 12px;">
                <option value="">All Categories</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.id}" ${param.category == cat.id ? 'selected' : ''}>${cat.name}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn btn-secondary" style="width: 100%;">Filter</button>
        </form>
        <script>
            // Parse the JSON string from the server
            const subjectsData = JSON.parse('${subjectsJson}');
            
            // Handle direct search button click
            document.getElementById('directSearchBtn').addEventListener('click', function() {
                const searchTerm = document.getElementById('searchInput').value.trim();
                
                if (!searchTerm) {
                    alert('Please enter a subject name to search');
                    return;
                }
                
                // Check if the search term matches any subject exactly
                const matchedSubject = subjectsData.find(function(subject) {
                    return subject && subject.name.toLowerCase() === searchTerm.toLowerCase();
                });
                
                if (matchedSubject) {
                    // If exact match found, redirect to course details
                    window.location.href = 'CourseDetailsServlet?subjectId=' + matchedSubject.id;
                } else {
                    alert('No exact match found for: ' + searchTerm);
                }
            });

            // Handle form submission for filtering
            document.getElementById('searchForm').addEventListener('submit', function(e) {
                e.preventDefault();
                this.submit();
            });
        </script>
        <h3>Subject Categories</h3>
        <ul>
            <c:forEach var="cat" items="${categories}">
                <li>${cat.name}</li>
            </c:forEach>
        </ul>
        <h3>Featured Subjects</h3>
        <ul>
            <c:forEach var="subj" items="${featuredSubjects}">
                <li>${subj.name}</li>
            </c:forEach>
        </ul>
        <h3>Contacts</h3>
        <ul>
            <c:forEach var="contact" items="${contacts}">
                <li>${contact.type}: ${contact.value}</li>
            </c:forEach>
        </ul>
    </div>
    <!-- Main Content -->
    <div class="main">
        <h1 style="text-align:center; margin-bottom: 32px;">Subjects List</h1>
        <div class="subjects-grid">
            <c:forEach var="subject" items="${subjects}">
                <c:choose>
                    <c:when test="${subject != null}">
                        <div class="subject-card" onclick="window.location.href='CourseDetailsServlet?subjectId=${subject.id}'">
                            <img src="${subject.thumbnailUrl}" alt="${subject.name}" />
                            <div class="subject-info">
                                <div class="subject-title">${subject.name}</div>
                                <div class="subject-tagline">${subject.tagline}</div>
                                <div class="price-info">
                                    <span class="list-price">
                                        <c:out value='${subject.lowestPackage.originalPrice}' default='--'/>$
                                    </span>
                                    <span class="sale-price">
                                        Sale Price: <c:out value='${subject.lowestPackage.salePrice}' default='--'/>$
                                    </span>
                                </div>
                                <form method="get" action="registerSubject" onClick="event.stopPropagation();">
                                    <input type="hidden" name="id" value="${subject.id}" />
                                    <button type="submit" class="register-btn">Register</button>
                                </form>
                                <div style="clear:both"></div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="subject-card" style="background: #f0f0f0; text-align: center; padding: 20px;">
                            <div style="font-size: 1.2em; color: #666;">No subject available</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
        <!-- Pagination -->
        <div class="pagination">
            <c:if test="${page > 1}">
                <a href="subjects?page=${page-1}&search=${param.search}&category=${param.category}">Previous</a>
            </c:if>
            <c:forEach begin="1" end="${(totalSubjects/pageSize) + (totalSubjects%pageSize==0?0:1)}" var="i">
                <a href="subjects?page=${i}&search=${param.search}&category=${param.category}" class="${i==page ? 'active' : ''}">${i}</a>
            </c:forEach>
            <c:if test="${page < (totalSubjects/pageSize) + (totalSubjects%pageSize==0?0:1)}">
                <a href="subjects?page=${page+1}&search=${param.search}&category=${param.category}">Next</a>
            </c:if>
        </div>
    </div>
</div>
