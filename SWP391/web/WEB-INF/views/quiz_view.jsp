<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${quiz.title} - Quiz Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .quiz-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .quiz-card {
            border: none;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            border-radius: 15px;
            overflow: hidden;
        }
        .quiz-info-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }
        .quiz-info-item i {
            width: 30px;
            text-align: center;
            margin-right: 15px;
            color: #667eea;
        }
        .btn-start-quiz {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 15px 40px;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-start-quiz:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .previous-attempt {
            background: #f8f9fa;
            border-left: 4px solid #28a745;
            padding: 1rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Include Header -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />
    
    <!-- Quiz Header -->
    <div class="quiz-header">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb text-white-50 mb-3">
                            <li class="breadcrumb-item"><a href="home" class="text-white">Home</a></li>
                            <c:if test="${course != null}">
                                <li class="breadcrumb-item"><a href="course-details?id=${course.id}" class="text-white">${course.title}</a></li>
                            </c:if>
                            <c:if test="${lesson != null}">
                                <li class="breadcrumb-item"><a href="lesson-view?lessonId=${lesson.id}" class="text-white">${lesson.name}</a></li>
                            </c:if>
                            <li class="breadcrumb-item active text-white" aria-current="page">Quiz</li>
                        </ol>
                    </nav>
                    <h1 class="display-4 fw-bold mb-0">${quiz.title}</h1>
                    <c:if test="${not empty quiz.description}">
                        <p class="lead mt-3 mb-0">${quiz.description}</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                
                <!-- Quiz Details Card -->
                <div class="card quiz-card mb-4">
                    <div class="card-body p-4">
                        <div class="row">
                            <div class="col-md-8">
                                <h3 class="card-title mb-4">
                                    <i class="fas fa-clipboard-question text-primary me-2"></i>
                                    ${quiz.title}
                                </h3>
                                
                                <div class="quiz-info-item">
                                    <i class="fas fa-question-circle"></i>
                                    <span><strong>${quiz.totalQuestions}</strong> questions</span>
                                </div>
                                
                                <c:if test="${quiz.duration > 0}">
                                    <div class="quiz-info-item">
                                        <i class="fas fa-clock"></i>
                                        <span><strong>${quiz.duration}</strong> minutes</span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${quiz.passRate > 0}">
                                    <div class="quiz-info-item">
                                        <i class="fas fa-target"></i>
                                        <span>Pass rate: <strong>${quiz.passRate}%</strong></span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty quiz.level}">
                                    <div class="quiz-info-item">
                                        <i class="fas fa-signal"></i>
                                        <span>Level: <strong>${quiz.level}</strong></span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty quiz.description}">
                                    <div class="mt-4">
                                        <h5>Description</h5>
                                        <p class="text-muted">${quiz.description}</p>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="col-md-4 text-center">
                                <div class="d-flex flex-column align-items-center justify-content-center h-100">
                                    <i class="fas fa-play-circle text-primary mb-3" style="font-size: 4rem;"></i>
                                    <a href="quiz?action=take&quizId=${quiz.id}" class="btn btn-primary btn-start-quiz text-white">
                                        <i class="fas fa-play me-2"></i>
                                        Start Test
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Previous Attempts -->
                <c:if test="${latestSubmission != null}">
                    <div class="card quiz-card">
                        <div class="card-body p-4">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-history text-success me-2"></i>
                                Your Latest Attempt
                            </h5>
                            
                            <div class="previous-attempt">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-calendar-alt text-muted me-2"></i>
                                            <span class="text-muted">
                                                <c:choose>
                                                    <c:when test="${latestSubmission.submittedAt != null}">
                                                        ${latestSubmission.submittedAt.toString().replace('T', ' ').substring(0, 16)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Recently completed
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-check-circle text-success me-2"></i>
                                            <span>
                                                <strong>
                                                    <c:choose>
                                                        <c:when test="${latestSubmission.correctAnswers != null and latestSubmission.totalQuestions != null}">
                                                            ${latestSubmission.correctAnswers}/${latestSubmission.totalQuestions}
                                                        </c:when>
                                                        <c:otherwise>
                                                            -/-
                                                        </c:otherwise>
                                                    </c:choose>
                                                </strong> 
                                                correct answers
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="text-center">
                                            <div class="display-6 fw-bold text-primary">
                                                <c:choose>
                                                    <c:when test="${latestSubmission.score != null}">
                                                        ${latestSubmission.score}%
                                                    </c:when>
                                                    <c:otherwise>
                                                        --%
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <small class="text-muted">Score</small>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="d-grid gap-2">
                                            <a href="quiz?action=result&submissionId=${latestSubmission.id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-chart-bar me-1"></i>
                                                View Results
                                            </a>
                                            <a href="quiz?action=review&submissionId=${latestSubmission.id}" 
                                               class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-eye me-1"></i>
                                                Review Test
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-3">
                                <p class="text-muted mb-0">
                                    <i class="fas fa-info-circle me-1"></i>
                                    You can retake this quiz to improve your score.
                                </p>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- No Previous Attempts -->
                <c:if test="${latestSubmission == null}">
                    <div class="card quiz-card">
                        <div class="card-body p-4 text-center">
                            <i class="fas fa-rocket text-primary mb-3" style="font-size: 3rem;"></i>
                            <h5>Ready to Start?</h5>
                            <p class="text-muted">This will be your first attempt at this quiz. Good luck!</p>
                        </div>
                    </div>
                </c:if>
                
            </div>
        </div>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 