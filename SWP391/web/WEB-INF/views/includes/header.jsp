<%-- 
    Document   : header
    Created on : May 23, 2025, 8:46:24 AM
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

                  <!-- Avatar Dropdown -->
                  <div class="relative inline-block text-left">
                    <button id="avatarButton" class="rounded-full bg-transparent p-1 focus:outline-none">
                      <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center text-blue-800 font-semibold">
                          <svg
                              class="text-gray-400"
                              xmlns="http://www.w3.org/2000/svg"
                              viewBox="0 0 24 24"
                              width="24"
                              height="24"
                              fill="none"
                              stroke="currentColor"
                              stroke-width="2"
                              stroke-linecap="round"
                              stroke-linejoin="round"
                          >
                            <path d="M12 21a9 9 0 1 0 0-18a9 9 0 0 0 0 18m0 0a8.95 8.95 0 0 0 4.951-1.488A3.987 3.987 0 0 0 13 16h-2a3.987 3.987 0 0 0-3.951 3.512A8.95 8.95 0 0 0 12 21m3-11a3 3 0 1 1-6 0a3 3 0 0 1 6 0"/>
                          </svg>
                      </div>
                    </button>

                    <!-- Dropdown -->
                    <div id="avatarDropdown" class="hidden absolute right-0 mt-2 w-56 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 z-50">
                      <div class="py-2">
                        <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Tài khoản</a>
                        <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Khóa học của tôi</a>
                        <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Cài đặt</a>
                        <hr class="my-1" />
                        <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Đăng xuất</a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
        </header>

        <script>
          const avatarBtn = document.getElementById("avatarButton");
          const dropdown = document.getElementById("avatarDropdown");

          avatarBtn.addEventListener("click", function (e) {
            e.stopPropagation();
            dropdown.classList.toggle("hidden");
          });

          document.addEventListener("click", function () {
            dropdown.classList.add("hidden");
          });
        </script>
    </body>
</html>
