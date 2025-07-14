package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/video/*")
public class VideoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Remove leading slash
        String fileName = pathInfo.substring(1);
        
        // Get the uploads directory path
        String uploadsPath = getServletContext().getRealPath("/uploads/videos/");
        Path videoPath = Paths.get(uploadsPath, fileName);
        
        System.out.println("Looking for video at: " + videoPath.toString());
        
        if (!Files.exists(videoPath)) {
            System.out.println("Video file not found: " + videoPath.toString());
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Set content type
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = "video/mp4";
        }
        response.setContentType(contentType);
        
        // Set content length
        long fileSize = Files.size(videoPath);
        response.setContentLengthLong(fileSize);
        
        // Set headers for video streaming
        response.setHeader("Accept-Ranges", "bytes");
        response.setHeader("Cache-Control", "no-cache");
        
        // Handle range requests for video seeking
        String range = request.getHeader("Range");
        if (range != null && range.startsWith("bytes=")) {
            handleRangeRequest(request, response, videoPath, fileSize);
        } else {
            // Serve the entire file
            try (InputStream in = Files.newInputStream(videoPath);
                 OutputStream out = response.getOutputStream()) {
                
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        }
    }
    
    private void handleRangeRequest(HttpServletRequest request, HttpServletResponse response, 
                                  Path videoPath, long fileSize) throws IOException {
        String range = request.getHeader("Range");
        String[] ranges = range.substring(6).split("-");
        long start = Long.parseLong(ranges[0]);
        long end = ranges.length > 1 && !ranges[1].isEmpty() ? 
                   Long.parseLong(ranges[1]) : fileSize - 1;
        
        if (start > end || start < 0 || end >= fileSize) {
            response.setStatus(HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);
            return;
        }
        
        response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
        response.setHeader("Content-Range", "bytes " + start + "-" + end + "/" + fileSize);
        response.setContentLengthLong(end - start + 1);
        
        try (InputStream in = Files.newInputStream(videoPath);
             OutputStream out = response.getOutputStream()) {
            
            in.skip(start);
            byte[] buffer = new byte[8192];
            long remaining = end - start + 1;
            
            while (remaining > 0) {
                int toRead = (int) Math.min(buffer.length, remaining);
                int bytesRead = in.read(buffer, 0, toRead);
                if (bytesRead == -1) break;
                
                out.write(buffer, 0, bytesRead);
                remaining -= bytesRead;
            }
        }
    }
} 