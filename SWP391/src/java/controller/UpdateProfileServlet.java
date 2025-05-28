/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import model.User;


/**
 *
 * @author Kaonashi
 */

@WebServlet("/updateProfile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 5 * 1024 * 1024,      // 5 MB
    maxRequestSize = 10 * 1024 * 1024   // 10 MB
)
public class UpdateProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy user hiện tại từ session (bạn cần lưu user khi login)
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        if (user == null) {
            // Tạo user giả để demo
            user = new User();
            user.setId(1); // giả id
            user.setEmail("demo@example.com"); // giả email
            session.setAttribute("user", user);
        }

        // Lấy thông tin fullname
        String fullName = request.getParameter("fullName");

        // Xử lý upload avatar (nếu có)
        Part avatarPart = request.getPart("avatar");
        String avatarFileName = null;
        if (avatarPart != null && avatarPart.getSize() > 0) {
            // Lấy tên file gốc (hoặc tạo tên mới để tránh trùng)
            String submittedFileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
            // Tạo tên file mới ví dụ: userId-timestamp.ext
            String ext = submittedFileName.substring(submittedFileName.lastIndexOf("."));
            avatarFileName = "avatar_" + user.getId() + "_" + System.currentTimeMillis() + ext;

            // Đường dẫn lưu file (ví dụ trong folder "uploads/images" trong app)
            String uploadPath = "D:/Projects/FPTU/SWP391/SWP391/web/uploads/images/"; //Cái này cần thay thành đường dẫn của máy
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Lưu file
            avatarPart.write(uploadPath + avatarFileName);
        }

        // Cập nhật thông tin user vào database
        UserDAO userDAO = new UserDAO();

        if (avatarFileName != null) {
            user.setAvatarUrl("/uploads/images/" + avatarFileName);
        }
        user.setFullName(fullName);

        userDAO.updateUser(user);

        // Cập nhật user trong session
        session.setAttribute("user", user);

        //reload
        response.sendRedirect(request.getHeader("Referer"));
    }
}
