<%-- 
    Document   : header
    Created on : May 23, 2025, 8:46:24 AM
    Author     : Kaonashi
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 text-gray-800">
        <header class="bg-white shadow-md sticky top-0 z-50">
            <div class="container mx-auto px-4">
              <div class="flex items-center justify-between h-16">

                <!-- Logo -->
                <div class="flex items-center space-x-2">
                    <div class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center">
                        <span class="text-white font-bold text-sm">E</span>
                    </div>
                    <span class="text-xl font-bold text-gray-800">ELearning</span>
                </div>

                <!-- Navigation -->
                <nav class="flex items-center space-x-8">
                    <a href="#" class="text-gray-600 hover:text-blue-600 transition-colors">Trang chủ</a>
                    <a href="#" class="text-gray-600 hover:text-blue-600 transition-colors">Khóa học</a>
                    <a href="#" class="text-gray-600 hover:text-blue-600 transition-colors">Bài viết</a>
                    <a href="#" class="text-gray-600 hover:text-blue-600 transition-colors">Giới thiệu</a>
                    <a href="#" class="text-gray-600 hover:text-blue-600 transition-colors">Liên hệ</a>
                </nav>

                <!-- Actions -->
                <div class="flex items-center space-x-4">
                    <!-- Search -->
                    <div class="relative">
                        <input 
                          type="search" 
                          placeholder="Tìm kiếm..."
                          class="w-64 h-9 pl-9 pr-3 rounded-md border border-gray-300 focus:outline-none focus:ring focus:ring-blue-200"
                        />
                        <svg 
                            class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400"
                            xmlns="http://www.w3.org/2000/svg" 
                            x="0px" 
                            y="0px" 
                            width="24" 
                            height="24" 
                            viewBox="0 0 30 30"
                        >
                          <path d="M 13 3 C 7.4889971 3 3 7.4889971 3 13 C 3 18.511003 7.4889971 23 13 23 C 15.396508 23 17.597385 22.148986 19.322266 20.736328 L 25.292969 26.707031 A 1.0001 1.0001 0 1 0 26.707031 25.292969 L 20.736328 19.322266 C 22.148986 17.597385 23 15.396508 23 13 C 23 7.4889971 18.511003 3 13 3 z M 13 5 C 17.430123 5 21 8.5698774 21 13 C 21 17.430123 17.430123 21 13 21 C 8.5698774 21 5 17.430123 5 13 C 5 8.5698774 8.5698774 5 13 5 z"/>
                        </svg>
                    </div>

                  <c:choose>
                    <c:when test="${not empty user}">
                      <!-- Avatar Dropdown -->
                      <div class="relative inline-block text-left">
                        <button id="avatarButton" class="rounded-full bg-transparent p-1 focus:outline-none">
                          <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center text-blue-800 font-semibold">
                            <img 
                                src="${empty user.avatarUrl ? '/uploads/images/default-avatar.svg' : user.avatarUrl}"
                                alt="User Avatar" 
                                class="w-8 h-8 rounded-full object-cover border border-gray-300"
                            />
                          </div>
                        </button>

                        <!-- Dropdown -->
                        <div id="avatarDropdown" class="hidden absolute right-0 mt-2 w-56 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 z-50">
                          <div class="py-2">
                            <button 
                              id="openProfileModal"
                              class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                            >
                              Tài khoản
                            </button>
                            <a href="my-course" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Khóa học của tôi</a>
                            <a href="settings" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Cài đặt</a>
                            <hr class="my-1" />
                            <a href="Logout" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Đăng xuất</a>
                          </div>
                        </div>
                      </div>
                    </c:when>

                    <c:otherwise>
                      <!-- Login Button -->
                      <a href="login" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Đăng nhập</a>
                    </c:otherwise>
                  </c:choose>

                </div>
              </div>
            </div>
        </header>

        <!-- Profile Edit Modal -->
        <div id="profileModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 hidden">
            <div class="bg-white w-full max-w-md rounded-lg p-6 shadow-lg relative">
                <h3 class="text-xl font-semibold mb-4">Cập nhật thông tin cá nhân</h3>

                <form id="profileForm" method="post" action="updateProfile" enctype="multipart/form-data">
                    <!-- Avatar -->
                    <div class="mb-4">
                      <label class="block text-sm font-medium mb-1">Ảnh đại diện</label>
                      <input type="file" name="avatar" accept="image/*" class="w-full border border-gray-300 rounded p-2" />
                    </div>

                    <!-- Name -->
                    <div class="mb-4">
                      <label class="block text-sm font-medium mb-1">Họ và tên</label>
                      <input 
                        type="text" 
                        name="fullName" 
                        value="${user.fullName}" 
                        class="w-full border border-gray-300 rounded p-2" 
                        required
                      />
                    </div>

                    <!-- Email (disabled) -->
                    <div class="mb-4">
                      <label class="block text-sm font-medium mb-1">Email</label>
                      <input 
                        type="email" 
                        name="email" 
                        value="${user.email}" 
                        disabled 
                        class="w-full bg-gray-100 border border-gray-300 rounded p-2" 
                      />
                      <p class="text-xs text-gray-500 mt-1">Không thể thay đổi email.</p>
                    </div>

                    <!-- Buttons -->
                    <div class="flex justify-end space-x-2">
                      <button type="button" id="closeProfileModal" class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300">Hủy</button>
                      <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Lưu</button>
                    </div>
                </form>


                <!-- Close Icon -->
                <button id="closeIcon" class="absolute top-2 right-2 text-gray-500 hover:text-gray-800">
                  ✕
                </button>
            </div>
        </div>

        <script>
          // Dropdown Avatar
          const avatarBtn = document.getElementById("avatarButton");
          const dropdown = document.getElementById("avatarDropdown");

          avatarBtn.addEventListener("click", function (e) {
            e.stopPropagation();
            dropdown.classList.toggle("hidden");
          });

          document.addEventListener("click", function () {
            dropdown.classList.add("hidden");
          });

          // Modal popup
          const openBtn = document.getElementById('openProfileModal');
          const closeBtn = document.getElementById('closeProfileModal');
          const closeIcon = document.getElementById('closeIcon');
          const modal = document.getElementById('profileModal');

          openBtn.addEventListener('click', () => {
            modal.classList.remove('hidden');
            dropdown.classList.add('hidden');
          });

          closeBtn.addEventListener('click', () => {
            modal.classList.add('hidden');
          });

          closeIcon.addEventListener('click', () => {
            modal.classList.add('hidden');
          });

          window.addEventListener('click', (e) => {
            if (e.target === modal) modal.classList.add('hidden');
          });

          document.getElementById('profileForm').addEventListener('submit', function(e){
//            e.preventDefault();
//            alert('Đây là demo, bạn cần tự xử lý gửi dữ liệu lên server.');
//            modal.classList.add('hidden');
          });
        </script>
    </body>
</html>
