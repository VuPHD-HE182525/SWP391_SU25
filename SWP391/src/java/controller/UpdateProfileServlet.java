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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Trường hợp không có user trong session
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Xử lý avatar (nếu có upload)
        Part avatarPart = request.getPart("avatar");
        String avatarFileName = null;

        if (avatarPart != null && avatarPart.getSize() > 0) {
            String submittedFileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
            String ext = submittedFileName.substring(submittedFileName.lastIndexOf("."));
            avatarFileName = "avatar_" + user.getId() + "_" + System.currentTimeMillis() + ext;

            String uploadPath = "D:/Projects/FPTU/SWP391/SWP391/web/uploads/images/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            avatarPart.write(uploadPath + avatarFileName);
            user.setAvatarUrl("/uploads/images/" + avatarFileName);
        }

        // Cập nhật thông tin người dùng
        user.setFullName(fullName);
        user.setUsername(username);
        user.setGender(gender);
        user.setPhone(phone);
        user.setAddress(address);

        // Gọi DAO để update
        UserDAO userDAO = new UserDAO();
        userDAO.updateUser(user);

        // Cập nhật lại user trong session
        session.setAttribute("user", user);

        //reload
        response.sendRedirect(request.getHeader("Referer"));
    }
}
