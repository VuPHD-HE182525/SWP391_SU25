<%-- 
    Document   : footer
    Created on : May 23, 2025, 8:46:29 AM
    Author     : Kaonashi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body>
        <footer class="bg-gray-800 text-white mt-12">
            <div class="container mx-auto px-4 py-8">
              <div class="grid grid-cols-1 md:grid-cols-4 gap-8">

                <!-- Company Info -->
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

                <!-- Quick Links -->
                <div>
                  <h4 class="font-bold mb-4">Liên kết nhanh</h4>
                  <ul class="space-y-2 text-sm">
                    <li><a href="<%= request.getContextPath() %>/" class="text-gray-300 hover:text-white transition-colors">Trang chủ</a></li>
                    <li><a href="<%= request.getContextPath() %>/courses" class="text-gray-300 hover:text-white transition-colors">Khóa học</a></li>
                    <li><a href="<%= request.getContextPath() %>/articles" class="text-gray-300 hover:text-white transition-colors">Bài viết</a></li>
                    <li><a href="<%= request.getContextPath() %>/about" class="text-gray-300 hover:text-white transition-colors">Giới thiệu</a></li>
                    <li><a href="<%= request.getContextPath() %>/contact" class="text-gray-300 hover:text-white transition-colors">Liên hệ</a></li>
                  </ul>
                </div>

                <!-- Categories -->
                <div>
                  <h4 class="font-bold mb-4">Danh mục</h4>
                  <ul class="space-y-2 text-sm">
                    <li><a href="#" class="text-gray-300 hover:text-white transition-colors">Communication Skills</a></li>
                    <li><a href="#" class="text-gray-300 hover:text-white transition-colors">Collaboration Leadership Time Management</a></li>
                    <li><a href="#" class="text-gray-300 hover:text-white transition-colors">Problem-Solving Critical Thinking</a></li>
                    <li><a href="#" class="text-gray-300 hover:text-white transition-colors">Problem-Solving</a></li>
                    <li><a href="#" class="text-gray-300 hover:text-white transition-colors">Critical Thinking</a></li>
                  </ul>
                </div>

                <!-- Contact -->
                <div>
                  <h4 class="font-bold mb-4">Liên hệ</h4>
                  <div class="space-y-2 text-sm text-gray-300">
                    <p>📧 vuphdhe182525@fpt.edu.vn</p>
                    <p>📞 +84 123 456 789</p>
                    <p>📍 Khu Công nghệ cao Hòa Lạc, Km29 Đại lộ Thăng Long, huyện Thạch Thất, Hà Nội</p>
                  </div>
                  <div class="flex space-x-4 mt-4">
                    <a href="#" class="text-gray-300 hover:text-white transition-colors">Facebook</a>
                    <a href="#" class="text-gray-300 hover:text-white transition-colors">YouTube</a>
                    <a href="#" class="text-gray-300 hover:text-white transition-colors">Twitter</a>
                  </div>
                </div>

              </div>

              <!-- Copyright -->
              <div class="border-t border-gray-700 mt-8 pt-6 text-center text-sm text-gray-300">
                <p>&copy; 2025 ELearning. Tất cả quyền được bảo lưu.</p>
              </div>
            </div>
        </footer>
    </body>
</html>
