<%-- 
    Document   : footer
    Created on : May 23, 2025, 8:46:29 AM
    Author     : Kaonashi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Bắt đầu footer -->
<footer style="background:#222c36;color:#fff;" class="mt-5 pt-4 pb-2">
  <div class="container">
    <div class="row gy-4">
      <!-- Company Info -->
      <div class="col-12 col-md-4">
        <div class="d-flex align-items-center gap-2 mb-3">
          <div style="width:32px;height:32px;background:#2563eb;border-radius:50%;display:flex;align-items:center;justify-content:center;">
            <span style="color:#fff;font-weight:bold;font-size:1rem;">E</span>
          </div>
          <span style="font-size:1.5rem;font-weight:bold;">ELearning</span>
        </div>
        <p style="color:#bfc9d1;font-size:0.95rem;">Nền tảng học trực tuyến hàng đầu Việt Nam, cung cấp các khóa học chất lượng cao về công nghệ thông tin.</p>
      </div>
      <!-- Quick Links -->
      <div class="col-6 col-md-2">
        <h6 class="fw-bold mb-3">Others</h6>
        <ul class="list-unstyled">
          <li><a href="<%= request.getContextPath() %>/" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Home</a></li>
          <li><a href="<%= request.getContextPath() %>/courses" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Courses</a></li>
          <li><a href="<%= request.getContextPath() %>/articles" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Blogs</a></li>
          <li><a href="<%= request.getContextPath() %>/about" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">About</a></li>
          <li><a href="<%= request.getContextPath() %>/contact" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Contacts</a></li>
        </ul>
      </div>
      <!-- Categories -->
      <div class="col-6 col-md-3">
        <h6 class="fw-bold mb-3">Category</h6>
        <ul class="list-unstyled">
          <li><a href="#" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Communication Skills</a></li>
          <li><a href="#" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Collaboration Leadership Time Management</a></li>
          <li><a href="#" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Problem-Solving Critical Thinking</a></li>
          <li><a href="#" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Problem-Solving</a></li>
          <li><a href="#" class="text-decoration-none text-secondary" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Critical Thinking</a></li>
        </ul>
      </div>
      <!-- Contact -->
      <div class="col-12 col-md-3">
        <h6 class="fw-bold mb-3">Contact</h6>
        <div style="color:#bfc9d1;font-size:0.95rem;">
          <p><span style="font-size:1.1em;">📧</span> thangma999@gmail.com</p>
          <p><span style="font-size:1.1em;">📧</span> </p>
          <p><span style="font-size:1.1em;">📞</span> +84 123 456 789</p>
          <p><span style="font-size:1.1em;">📍</span> Khu Công nghệ cao Hòa Lạc, Km29 Đại lộ Thăng Long, huyện Thạch Thất, Hà Nội</p>
        </div>
        <div class="d-flex gap-3 mt-3">
          <a href="#" class="text-secondary text-decoration-none" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Facebook</a>
          <a href="#" class="text-secondary text-decoration-none" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">YouTube</a>
          <a href="#" class="text-secondary text-decoration-none" style="color:#bfc9d1!important;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='#bfc9d1'">Twitter</a>
        </div>
      </div>
    </div>
    <div class="border-top mt-4 pt-3 text-center" style="border-color:#334155!important;color:#bfc9d1;">
      <small>&copy; 2025 ELearning. Tất cả quyền được bảo lưu.</small>
    </div>
  </div>
</footer>
<!-- Kết thúc footer -->
