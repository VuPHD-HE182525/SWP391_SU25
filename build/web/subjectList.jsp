<%-- 
    Document   : subjectList
    Created on : May 29, 2025, 6:59:07 AM
    Author     : thang
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Subject List - ELearning</title>
    <%-- Sử dụng Tailwind CSS từ CDN giống như trong header/footer của bạn --%>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

    <%-- ===== BAO GỒM HEADER ===== --%>
    <jsp:include page="header.jsp" />

    <%-- ===== NỘI DUNG CHÍNH CỦA TRANG ===== --%>
    <main class="flex-grow container mx-auto px-4 py-8">
        <div class="bg-white p-6 rounded-lg shadow-md">
            
            <form action="subject-list" method="get" class="mb-6">
                <div class="flex flex-wrap items-center gap-4">
                    <select name="category" onchange="this.form.submit()" class="p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">All Categories</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.id}" ${cat.id == selectedCategory ? 'selected' : ''}>
                                ${cat.name}
                            </option>
                        </c:forEach>
                    </select>

                    <select name="status" onchange="this.form.submit()" class="p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">All Status</option>
                        <option value="true" ${selectedStatus == 'true' ? 'selected' : ''}>Active</option>
                        <option value="false" ${selectedStatus == 'false' ? 'selected' : ''}>Inactive</option>
                    </select>

                    <div class="relative flex-grow">
                        <input type="text" name="search" placeholder="Search by name" value="${searchValue}" class="w-full p-2 pl-10 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"/>
                        <button type="submit" class="absolute left-2 top-1/2 -translate-y-1/2 text-gray-400">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>
                </div>
            </form>

            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead class="bg-gray-50 border-b-2 border-gray-200">
                        <tr>
                            <th class="px-6 py-3 text-xs font-semibold text-gray-600 uppercase tracking-wider">ID</th>
                            <th class="px-6 py-3 text-xs font-semibold text-gray-600 uppercase tracking-wider">Name</th>
                            <th class="px-6 py-3 text-xs font-semibold text-gray-600 uppercase tracking-wider">Category</th>
                            <th class="px-6 py-3 text-xs font-semibold text-gray-600 uppercase tracking-wider">Number Lesson</th>
                            <th class="px-6 py-3 text-xs font-semibold text-gray-600 uppercase tracking-wider">Owner</th>
                            <th class="px-6 py-3 text-xs font-semibold text-gray-600 uppercase tracking-wider">Status</th>
                            <th class="px-6 py-3 text-xs font-semibold text-gray-600 uppercase tracking-wider">Action</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach items="${subjects}" var="s">
                            <tr>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${s.id}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${s.name}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${s.category}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${s.numberOfLessons}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${s.owner}</td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full 
                                                  ${s.status ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                        ${s.status ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <a href="edit-subject?id=${s.id}" class="text-blue-600 hover:text-blue-900">Edit <i class="fa fa-pencil"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="mt-6 flex flex-col md:flex-row justify-between items-center gap-4">
                <nav class="flex items-center">
                    <c:if test="${currentPage > 1}">
                        <a href="subject-list?page=${currentPage - 1}&category=${selectedCategory}&status=${selectedStatus}&search=${searchValue}" class="px-3 py-1 border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 rounded-l-md">Previous</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="subject-list?page=${i}&category=${selectedCategory}&status=${selectedStatus}&search=${searchValue}" 
                           class="px-3 py-1 border-t border-b border-gray-300 text-sm font-medium 
                                  ${i == currentPage ? 'bg-blue-600 text-white border-blue-600 z-10' : 'bg-white text-gray-500 hover:bg-gray-50'}">
                            ${i}
                        </a>
                    </c:forEach>

                     <c:if test="${currentPage < totalPages}">
                        <a href="subject-list?page=${currentPage + 1}&category=${selectedCategory}&status=${selectedStatus}&search=${searchValue}" class="px-3 py-1 border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 rounded-r-md">Next</a>
                    </c:if>
                </nav>

                <a href="add-new-subject" class="px-4 py-2 bg-gray-800 text-white text-sm font-medium rounded-md hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-800">Add course</a>
            </div>

        </div>
    </main>
    
    <%-- ===== BAO GỒM FOOTER ===== --%>
    <jsp:include page="footer.jsp" />

</body>
</html>
