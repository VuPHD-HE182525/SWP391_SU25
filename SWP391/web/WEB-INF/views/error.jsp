<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Online Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 3rem;
            text-align: center;
            max-width: 600px;
            width: 90%;
        }
        
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 1.5rem;
        }
        
        .error-title {
            color: #333;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .error-message {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .error-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            text-align: left;
        }
        
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-back {
            background: transparent;
            border: 2px solid #6c757d;
            color: #6c757d;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            margin-right: 1rem;
        }
        
        .btn-back:hover {
            background: #6c757d;
            color: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <i class="fas fa-exclamation-triangle error-icon"></i>
            <h1 class="error-title">Oops! Something went wrong</h1>
            <p class="error-message">
                We encountered an error while processing your request. Please try again or contact support if the problem persists.
            </p>
            
            <c:if test="${not empty errorMessage}">
                <div class="error-details">
                    <h5><i class="fas fa-info-circle me-2"></i>Error Details:</h5>
                    <p class="mb-0 text-muted">${errorMessage}</p>
                </div>
            </c:if>
            
            <div class="mt-4">
                <button onclick="history.back()" class="btn btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Go Back
                </button>
                <a href="home" class="btn btn-home text-white">
                    <i class="fas fa-home me-2"></i>Home Page
                </a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 