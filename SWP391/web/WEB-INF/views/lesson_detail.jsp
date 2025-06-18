<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<html>
    <head>
        <title>Lesson Detail</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 text-gray-900">

        <jsp:include page="/WEB-INF/views/includes/header.jsp" />

        <div class="max-w-4xl mx-auto px-4 py-10">
            <h2 class="text-3xl font-bold mb-6">Lesson Detail</h2>

            <form action="lesson-detail" method="post" class="space-y-6 bg-white p-6 rounded-xl shadow">
                <input type="hidden" name="id" value="${lesson.id}" />

                <div>
                    <label class="block font-semibold mb-1">Lesson Title</label>
                    <input type="text" name="name" value="${lesson.name}" required
                           class="w-full border border-gray-300 p-2 rounded" />
                </div>

                <div>
                    <label class="block font-semibold mb-1">Order</label>
                    <input type="number" name="orderNum" value="${lesson.orderNum}" required
                           class="w-full border border-gray-300 p-2 rounded" />
                </div>

                <div>
                    <label class="block font-semibold mb-1">Type</label>
                    <select name="type" id="lessonType" class="w-full border border-gray-300 p-2 rounded">
                        <option value="Topic" ${lesson.type == 'Topic' ? 'selected' : ''}>Subject Topic</option>
                        <option value="Video" ${lesson.type == 'Video' ? 'selected' : ''}>Video Lesson</option>
                        <option value="Text" ${lesson.type == 'Text' ? 'selected' : ''}>Text Lesson</option>
                        <option value="Quiz" ${lesson.type == 'Quiz' ? 'selected' : ''}>Quiz</option>
                    </select>
                </div>

                <div>
                    <label class="block font-semibold mb-1">Status</label>
                    <select name="status" class="w-full border border-gray-300 p-2 rounded">
                        <option value="true" ${lesson.status ? 'selected' : ''}>Active</option>
                        <option value="false" ${!lesson.status ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div>
                    <label class="block font-semibold mb-1">Subject</label>
                    <input type="text" value="${subject.name}" readonly
                           class="w-full border border-gray-200 p-2 bg-gray-100 rounded" />
                    <input type="hidden" name="subjectId" value="${lesson.subjectId}" />
                </div>

                <div>
                    <label class="block font-semibold mb-1">Parent Lesson</label>
                    <select name="parentLessonId" class="w-full border border-gray-300 p-2 rounded">
                        <option value="0">None</option>
                        <c:forEach items="${lessonList}" var="l">
                            <option value="${l.id}" ${l.id == lesson.parentLessonId ? 'selected' : ''}>${l.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div id="videoLinkGroup">
                    <label class="block font-semibold mb-1">Video Link</label>
                    <input type="text" name="videoLink" value="${lesson.videoLink}"
                           class="w-full border border-gray-300 p-2 rounded" />
                </div>

                <div id="htmlContentGroup">
                    <label class="block font-semibold mb-1">HTML Content</label>
                    <textarea name="htmlContent" rows="6"
                              class="w-full border border-gray-300 p-2 rounded">${lesson.htmlContent}</textarea>
                </div>

                <div id="quizSelectGroup">
                    <label class="block font-semibold mb-1">Select Quiz</label>
                    <select name="quizId" class="w-full border border-gray-300 p-2 rounded">
                        <c:forEach var="q" items="${quizList}">
                            <option value="${q.id}" ${lesson.quizId == q.id ? 'selected' : ''}>${q.title}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="flex gap-4">
                    <button type="submit" class="bg-green-500 text-white px-6 py-2 rounded hover:bg-green-600">Submit</button>
                    <a href="lesson-list?subjectId=${lesson.subjectId}" 
                       class="bg-gray-300 px-6 py-2 rounded hover:bg-gray-400">Back</a>
                </div>
            </form>
        </div>

        <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

        <script>
            function updateLessonTypeUI() {
                const typeSelect = document.getElementById("lessonType");
                if (!typeSelect)
                    return;

                const type = typeSelect.value.toLowerCase();
                document.getElementById("videoLinkGroup").style.display = (type === "video") ? "block" : "none";
                document.getElementById("htmlContentGroup").style.display = (type === "video" || type === "text") ? "block" : "none";
                document.getElementById("quizSelectGroup").style.display = (type === "quiz") ? "block" : "none";
            }

            document.addEventListener("DOMContentLoaded", function () {
                updateLessonTypeUI();

                const lessonTypeSelect = document.getElementById("lessonType");
                if (lessonTypeSelect) {
                    lessonTypeSelect.addEventListener("change", updateLessonTypeUI);
                }
            });
        </script>

    </body>
</html>
