<%-- 
    Document   : subject_lessons
    Created on : Jun 11, 2025, 9:13:17 PM
    Author     : Kaonashi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
    <head>
        <title>Subject Lessons</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 text-gray-900">

        <jsp:include page="/WEB-INF/views/includes/header.jsp" />

        <div class="max-w-6xl mx-auto px-4 py-10 h-dvh">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-3xl font-bold">Subject Lessons</h1>
                <button 
                    type="button" 
                    onclick="document.getElementById('addLessonModal').classList.remove('hidden')" 
                    class="bg-lime-400 hover:bg-lime-500 text-white font-bold py-2 px-4 rounded">
                    Add +
                </button>
            </div>

            <p class="mb-4 text-xl">Subject name: <span class="font-semibold">${subject.name}</span></p>

            <!-- Filters -->
            <form method="get" action="lesson-list">
                <input type="hidden" name="subjectId" value="${subject.id}" />
                <div class="flex gap-4 mb-4">
                    <select name="groupId" class="border p-2 rounded">
                        <option value="">All lessons groups</option>
                        <c:forEach var="group" items="${lessonGroups}">
                            <option value="${group.id}" ${param.groupId == group.id ? 'selected' : ''}>
                                ${group.name}
                            </option>
                        </c:forEach>
                    </select>

                    <select name="status" class="border p-2 rounded">
                        <option value="">All status</option>
                        <option value="true" ${param.status == 'true' ? 'selected' : ''}>Active</option>
                        <option value="false" ${param.status == 'false' ? 'selected' : ''}>Inactive</option>
                    </select>

                    <div class="flex items-center border rounded">
                        <input type="text" name="keyword" value="${param.keyword}" class="p-2 w-full outline-none" placeholder="Type to search" />
                    </div>

                    <button type="submit" class="bg-blue-500 text-white px-4 rounded">Filter</button>
                </div>
            </form>


            <!-- Table -->
            <table class="w-full table-auto border">
                <thead class="bg-gray-200 text-left">
                    <tr>
                        <th class="p-2">ID</th>
                        <th class="p-2">Lesson</th>
                        <th class="p-2">Order</th>
                        <th class="p-2">Type</th>
                        <th class="p-2">Status</th>
                        <th class="p-2">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="lesson" items="${lessonList}">
                        <tr class="border-b ${lesson.parentLessonId != 0 ? 'bg-gray-50' : ''}">
                            <td class="p-2">${lesson.id}</td>
                            <td class="p-2">
                                <c:if test="${lesson.parentLessonId != 0}">-- </c:if>${lesson.name}
                                </td>
                                <td class="p-2">${lesson.orderNum}</td>
                            <td class="p-2">${lesson.type}</td>
                            <td class="p-2">${lesson.status ? "Active" : "Inactive"}</td>
                            <td class="p-2">
                                <a href="lesson-detail?id=${lesson.id}" class="text-blue-500 hover:underline">Edit</a> |
                                <a href="toggleStatus?id=${lesson.id}&subjectId=${subject.id}"
                                   class="${lesson.status ? 'text-red-500' : 'text-green-500'} hover:underline">
                                    ${lesson.status ? "Inactive" : "Active"}
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

        <div id="addLessonModal" class="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center hidden z-50">
            <div class="bg-white p-6 rounded-xl shadow-lg w-full max-w-md relative">
                <h2 class="text-xl font-bold mb-4">Add Existing Lesson</h2>

                <form method="post" action="addExistingLesson" class="flex flex-col gap-4">
                    <select name="lessonId" class="border p-2 rounded" required>
                        <c:forEach var="l" items="${unassignedLessons}">
                            <option value="${l.id}">${l.name}</option>
                        </c:forEach>
                    </select>
                    <input type="hidden" name="subjectId" value="${subject.id}" />
                    <div class="flex justify-end gap-2">
                        <button 
                            type="button" 
                            onclick="document.getElementById('addLessonModal').classList.add('hidden')" 
                            class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400">
                            Cancel
                        </button>
                        <button 
                            type="submit" 
                            class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
                            Add
                        </button>
                    </div>
                </form>
            </div>
        </div>

    </body>
</html>

