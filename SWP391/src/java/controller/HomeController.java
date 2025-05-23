/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
/**
 *
 * @author Kaonashi
 */
@WebServlet("/home")
public class HomeController extends HttpServlet{
    
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("message", "Chào mừng đến trang chủ!");
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/home.jsp");
        rd.forward(request, response);
    }
}