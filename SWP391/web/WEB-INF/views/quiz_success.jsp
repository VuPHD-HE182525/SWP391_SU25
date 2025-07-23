<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Completed - ${quiz.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .quiz-success-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            color: white;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .score-circle {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 20px auto;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .score-excellent { background: linear-gradient(135deg, #4CAF50, #45a049); }
        .score-good { background: linear-gradient(135deg, #2196F3, #1976D2); }
        .score-average { background: linear-gradient(135deg, #FF9800, #F57C00); }
        .score-poor { background: linear-gradient(135deg, #f44336, #d32f2f); }
        
        .stats-card {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 20px;
            margin: 10px;
            backdrop-filter: blur(10px);
        }
        .action-buttons {
            margin-top: 30px;
        }
        .btn-custom {
            margin: 5px;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-primary-custom {
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.3);
            color: white;
        }
        .btn-primary-custom:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Include Header -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />
    
    <div class="container">
        <div class="quiz-success-container">
            <!-- Success Icon -->
            <div class="mb-4">
                <i class="fas fa-check-circle fa-4x text-success"></i>
            </div>
            
            <!-- Quiz Title -->
            <h1 class="display-4 mb-3">Quiz Completed!</h1>
            <h3 class="mb-4">${quiz.title}</h3>
            
            <!-- Score Display -->
            <div class="score-circle ${score >= 80 ? 'score-excellent' : score >= 60 ? 'score-good' : score >= 40 ? 'score-average' : 'score-poor'}">
                ${score}%
            </div>
            
            <!-- Performance Message -->
            <div class="mb-4">
                <c:choose>
                    <c:when test="${score >= 80}">
                        <h4><i class="fas fa-trophy text-warning"></i> Excellent Work!</h4>
                        <p class="lead">Outstanding performance! You've mastered this topic.</p>
                    </c:when>
                    <c:when test="${score >= 60}">
                        <h4><i class="fas fa-thumbs-up text-info"></i> Good Job!</h4>
                        <p class="lead">Well done! You have a solid understanding of the material.</p>
                    </c:when>
                    <c:when test="${score >= 40}">
                        <h4><i class="fas fa-lightbulb text-warning"></i> Keep Learning!</h4>
                        <p class="lead">You're on the right track. Review the material and try again.</p>
                    </c:when>
                    <c:otherwise>
                        <h4><i class="fas fa-book text-danger"></i> Need More Practice</h4>
                        <p class="lead">Don't give up! Review the lesson content and try again.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Statistics -->
            <div class="row">
                <div class="col-md-4">
                    <div class="stats-card">
                        <h5><i class="fas fa-check-circle text-success"></i> Correct</h5>
                        <h3>${correctAnswers}</h3>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <h5><i class="fas fa-times-circle text-danger"></i> Incorrect</h5>
                        <h3>${totalQuestions - correctAnswers}</h3>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <h5><i class="fas fa-list text-info"></i> Total</h5>
                        <h3>${totalQuestions}</h3>
                    </div>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="quiz-fixed?action=take&quizId=${quiz.id}" class="btn btn-primary-custom btn-custom">
                    <i class="fas fa-redo"></i> Retake Quiz
                </a>
                <a href="lesson-view?lessonId=${quiz.lessonId}" class="btn btn-primary-custom btn-custom">
                    <i class="fas fa-arrow-left"></i> Back to Lesson
                </a>
                <a href="course-list" class="btn btn-primary-custom btn-custom">
                    <i class="fas fa-home"></i> Course List
                </a>
            </div>
            
            <!-- Encouragement Message -->
            <div class="mt-4">
                <p class="text-light">
                    <i class="fas fa-quote-left"></i>
                    Learning is a journey, not a destination. Keep practicing and improving!
                    <i class="fas fa-quote-right"></i>
                </p>
            </div>
        </div>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Celebration Animation -->
    <script>
        // Add some celebration effects
        document.addEventListener('DOMContentLoaded', function() {
            const quizScore = ${score};
            
            // Add confetti effect for high scores
            if (quizScore >= 80) {
                // Simple confetti effect
                setTimeout(() => {
                    for(let i = 0; i < 50; i++) {
                        createConfetti();
                    }
                }, 500);
            }
        });
        
        function createConfetti() {
            const confetti = document.createElement('div');
            confetti.style.position = 'fixed';
            confetti.style.width = '10px';
            confetti.style.height = '10px';
            confetti.style.backgroundColor = getRandomColor();
            confetti.style.left = Math.random() * window.innerWidth + 'px';
            confetti.style.top = '-10px';
            confetti.style.zIndex = '9999';
            confetti.style.pointerEvents = 'none';
            confetti.style.borderRadius = '50%';
            
            document.body.appendChild(confetti);
            
            // Animate falling
            let position = -10;
            const interval = setInterval(() => {
                position += 5;
                confetti.style.top = position + 'px';
                
                if (position > window.innerHeight) {
                    clearInterval(interval);
                    document.body.removeChild(confetti);
                }
            }, 50);
        }
        
        function getRandomColor() {
            const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#ffeaa7', '#dda0dd', '#98d8c8'];
            return colors[Math.floor(Math.random() * colors.length)];
        }
    </script>
</body>
</html> 