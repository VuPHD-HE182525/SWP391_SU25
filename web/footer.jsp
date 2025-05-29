<%-- 
    Document   : footer
    Created on : May 29, 2025, 7:01:38 AM
    Author     : thang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- footer.jsp --%>
<footer class="bg-gray-800 text-white mt-12">
    <div class="container mx-auto px-4 py-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">

            <div>
                <div class="flex items-center space-x-2 mb-4">
                    <div class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center">
                        <span class="text-white font-bold text-sm">E</span>
                    </div>
                    <span class="text-xl font-bold">ELearning</span>
                </div>
                <p class="text-gray-300 text-sm">
                    Nền tảng học trực tuyến hàng đầu Việt Nam, cung cấp các khóa học chất lượng cao về công nghệ thông tin.
                </p>
            </div>

            <div>
                <h4 class="font-bold mb-4">Others</h4>
                <ul class="space-y-2 text-sm">
                    <li><a href="<%= request.getContextPath() %>/home" class="text-gray-300 hover:text-white transition-colors">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/courses" class="text-gray-300 hover:text-white transition-colors">Courses</a></li>
                    <li><a href="<%= request.getContextPath() %>/blogs" class="text-gray-300 hover:text-white transition-colors">Blogs</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-bold mb-4">Category</h4>
                <ul class="space-y-2 text-sm">
                    <li><a href="#" class="text-gray-300 hover:text-white transition-colors">Communication Skills</a></li>
                    <li><a href="#" class="text-gray-300 hover:text-white transition-colors">Time Management</a></li>
                    <li><a href="#" class="text-gray-300 hover:text-white transition-colors">Critical Thinking</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-bold mb-4">Contact</h4>
                <div class="space-y-2 text-sm text-gray-300">
                    <p>📧 vuphdhe182525@fpt.edu.vn</p>
                    <p>📞 +84 123 456 789</p>
                    <p>📍 Khu Công nghệ cao Hòa Lạc, Hà Nội</p>
                </div>
                <div class="flex space-x-4 mt-4">
                    <a href="#" class="text-gray-300 hover:text-white transition-colors">Facebook</a>
                    <a href="#" class="text-gray-300 hover:text-white transition-colors">YouTube</a>
                    <a href="#" class="text-gray-300 hover:text-white transition-colors">Twitter</a>
                </div>
            </div>

        </div>

        <div class="border-t border-gray-700 mt-8 pt-6 text-center text-sm text-gray-300">
            <p>&copy; 2025 ELearning. Tất cả quyền được bảo lưu.</p>
        </div>
    </div>
</footer>
