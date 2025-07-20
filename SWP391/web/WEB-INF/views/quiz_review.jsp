<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Review - ${quiz.title}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .review-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .question-card {
            border: none;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            border-radius: 15px;
            margin-bottom: 2rem;
            overflow: hidden;
        }
        .question-header {
            padding: 1.5rem;
            border-bottom: 1px solid #dee2e6;
        }
        .question-header.correct {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-left: 5px solid #28a745;
        }
        .question-header.incorrect {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border-left: 5px solid #dc3545;
        }
        .question-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 1rem;
        }
        .question-number.correct {
            background: #28a745;
            color: white;
        }
        .question-number.incorrect {
            background: #dc3545;
            color: white;
        }
        .answer-option {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f8f9fa;
            position: relative;
        }
        .answer-option:last-child {
            border-bottom: none;
        }
        .answer-option.correct {
            background: #d4edda;
            border-left: 4px solid #28a745;
        }
        .answer-option.incorrect {
            background: #f8d7da;
            border-left: 4px solid #dc3545;
        }
        .answer-option.user-selected {
            border-right: 4px solid #007bff;
        }
        .answer-badge {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 1rem;
        }
        .review-summary {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }
        .summary-stat {
            text-align: center;
            margin-bottom: 1rem;
        }
        .summary-stat .value {
            font-size: 2.5rem;
            font-weight: bold;
            display: block;
        }
        .summary-stat .label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .navigation-panel {
            position: sticky;
            top: 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            padding: 1.5rem;
        }
        .nav-question {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0.25rem;
            text-decoration: none;
            font-weight: bold;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        .nav-question.correct {
            background: #28a745;
            color: white;
        }
        .nav-question.incorrect {
            background: #dc3545;
            color: white;
        }
        .nav-question:hover {
            transform: scale(1.1);
        }
        .explanation-box {
            background: #e7f3ff;
            border-left: 4px solid #007bff;
            padding: 1rem 1.5rem;
            margin-top: 1rem;
            border-radius: 0 8px 8px 0;
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Include Header -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />
    
    <!-- Review Header -->
    <div class="review-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb text-white-50 mb-3">
                            <li class="breadcrumb-item"><a href="home" class="text-white">Home</a></li>
                            <li class="breadcrumb-item"><a href="quiz?action=view&quizId=${quiz.id}" class="text-white">${quiz.title}</a></li>
                            <li class="breadcrumb-item"><a href="quiz?action=result&submissionId=${submission.id}" class="text-white">Results</a></li>
                            <li class="breadcrumb-item active text-white" aria-current="page">Review</li>
                        </ol>
                    </nav>
                    <h1 class="display-5 fw-bold mb-0">Quiz Review</h1>
                    <p class="lead mt-2 mb-0">${quiz.title}</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="text-white">
                        <div class="fs-2 fw-bold">${submission.score}%</div>
                        <div class="fs-6">Your Score</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container py-4">
        
        <!-- Summary -->
        <div class="review-summary">
            <div class="row">
                <div class="col-md-3">
                    <div class="summary-stat">
                        <span class="value text-success">${submission.correctAnswers}</span>
                        <div class="label">Correct</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-stat">
                        <span class="value text-danger">${submission.totalQuestions - submission.correctAnswers}</span>
                        <div class="label">Incorrect</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-stat">
                        <span class="value text-primary">${submission.totalQuestions}</span>
                        <div class="label">Total Questions</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-stat">
                        <span class="value text-info">
                            <fmt:formatDate value="${submission.submittedAt}" pattern="HH:mm"/>
                        </span>
                        <div class="label">Submitted At</div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Questions Review -->
            <div class="col-lg-8">
                <c:forEach items="${questions}" var="question" varStatus="status">
                    <c:set var="userAnswerId" value="${submission.userAnswers[question.id]}" />
                    <c:set var="isCorrect" value="false" />
                    <c:set var="correctAnswer" value="" />
                    
                    <!-- Find the correct answer -->
                    <c:forEach items="${question.answers}" var="answer">
                        <c:if test="${answer.correct}">
                            <c:set var="correctAnswer" value="${answer}" />
                            <c:if test="${userAnswerId == answer.id}">
                                <c:set var="isCorrect" value="true" />
                            </c:if>
                        </c:if>
                    </c:forEach>
                    
                    <div class="question-card" id="question-${status.index + 1}">
                        <div class="question-header ${isCorrect ? 'correct' : 'incorrect'}">
                            <div class="d-flex align-items-center">
                                <div class="question-number ${isCorrect ? 'correct' : 'incorrect'}">
                                    <c:choose>
                                        <c:when test="${isCorrect}">
                                            <i class="fas fa-check"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-times"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex-grow-1">
                                    <h5 class="mb-1">Question ${status.index + 1} of ${fn:length(questions)}</h5>
                                    <small class="text-muted">
                                        <c:choose>
                                            <c:when test="${isCorrect}">
                                                <i class="fas fa-check-circle text-success me-1"></i>
                                                Correct Answer
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-times-circle text-danger me-1"></i>
                                                Incorrect Answer
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card-body p-0">
                            <div class="p-4">
                                <h6 class="question-text mb-4">${question.content}</h6>
                            </div>
                            
                            <c:forEach items="${question.answers}" var="answer" varStatus="answerStatus">
                                <c:set var="isUserSelected" value="${userAnswerId == answer.id}" />
                                <c:set var="isCorrectAnswer" value="${answer.correct}" />
                                
                                <div class="answer-option 
                                     ${isCorrectAnswer ? 'correct' : ''} 
                                     ${isUserSelected && !isCorrectAnswer ? 'incorrect' : ''} 
                                     ${isUserSelected ? 'user-selected' : ''}">
                                    
                                    <div class="d-flex align-items-center">
                                        <div class="answer-badge ${isCorrectAnswer ? 'bg-success text-white' : isUserSelected ? 'bg-danger text-white' : 'bg-light text-dark'}">
                                            ${answerStatus.index == 0 ? 'A' : answerStatus.index == 1 ? 'B' : answerStatus.index == 2 ? 'C' : 'D'}
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="fw-medium">${answer.content}</div>
                                        </div>
                                        <div class="ms-auto">
                                            <c:if test="${isCorrectAnswer}">
                                                <i class="fas fa-check-circle text-success fs-5"></i>
                                            </c:if>
                                            <c:if test="${isUserSelected && !isCorrectAnswer}">
                                                <i class="fas fa-times-circle text-danger fs-5"></i>
                                            </c:if>
                                            <c:if test="${isUserSelected}">
                                                <span class="badge bg-primary ms-2">Your Answer</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Explanation (if available) -->
                            <c:if test="${!isCorrect}">
                                <div class="explanation-box">
                                    <h6 class="mb-2">
                                        <i class="fas fa-lightbulb text-warning me-2"></i>
                                        Explanation
                                    </h6>
                                    <p class="mb-0">
                                        The correct answer is <strong>${correctAnswer.content}</strong>. 
                                        This question tests your understanding of the key concepts covered in the lesson.
                                    </p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
                
                <!-- Action Buttons -->
                <div class="text-center mt-4">
                    <a href="quiz?action=result&submissionId=${submission.id}" 
                       class="btn btn-primary btn-lg me-3">
                        <i class="fas fa-chart-bar me-2"></i>
                        View Results
                    </a>
                    <a href="quiz?action=take&quizId=${quiz.id}" 
                       class="btn btn-success btn-lg me-3">
                        <i class="fas fa-redo me-2"></i>
                        Retake Quiz
                    </a>
                    <a href="quiz?action=view&quizId=${quiz.id}" 
                       class="btn btn-outline-secondary btn-lg">
                        <i class="fas fa-arrow-left me-2"></i>
                        Back to Quiz
                    </a>
                </div>
            </div>
            
            <!-- Navigation Panel -->
            <div class="col-lg-4">
                <div class="navigation-panel">
                    <h6 class="mb-3">
                        <i class="fas fa-list me-2"></i>
                        Question Navigation
                    </h6>
                    
                    <div class="d-flex flex-wrap">
                        <c:forEach items="${questions}" var="question" varStatus="status">
                            <c:set var="userAnswerId" value="${submission.userAnswers[question.id]}" />
                            <c:set var="isCorrect" value="false" />
                            
                            <!-- Check if answer is correct -->
                            <c:forEach items="${question.answers}" var="answer">
                                <c:if test="${answer.correct && userAnswerId == answer.id}">
                                    <c:set var="isCorrect" value="true" />
                                </c:if>
                            </c:forEach>
                            
                            <a href="#question-${status.index + 1}" 
                               class="nav-question ${isCorrect ? 'correct' : 'incorrect'}"
                               onclick="scrollToQuestion(${status.index + 1})">
                                ${status.index + 1}
                            </a>
                        </c:forEach>
                    </div>
                    
                    <!-- Legend -->
                    <div class="mt-4">
                        <div class="d-flex align-items-center mb-2">
                            <div class="nav-question correct me-2" style="width: 20px; height: 20px; font-size: 0.7rem;">
                                <i class="fas fa-check"></i>
                            </div>
                            <small class="text-muted">Correct Answer</small>
                        </div>
                        <div class="d-flex align-items-center">
                            <div class="nav-question incorrect me-2" style="width: 20px; height: 20px; font-size: 0.7rem;">
                                <i class="fas fa-times"></i>
                            </div>
                            <small class="text-muted">Incorrect Answer</small>
                        </div>
                    </div>
                    
                    <!-- Summary Stats -->
                    <div class="mt-4 pt-3 border-top">
                        <div class="row text-center">
                            <div class="col-6">
                                <div class="fw-bold text-success">${submission.correctAnswers}</div>
                                <small class="text-muted">Correct</small>
                            </div>
                            <div class="col-6">
                                <div class="fw-bold text-danger">${submission.totalQuestions - submission.correctAnswers}</div>
                                <small class="text-muted">Incorrect</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function scrollToQuestion(questionNum) {
            document.getElementById('question-' + questionNum).scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
        
        // Highlight current question in navigation
        window.addEventListener('scroll', function() {
            const questions = document.querySelectorAll('.question-card');
            const navQuestions = document.querySelectorAll('.nav-question');
            
            questions.forEach((question, index) => {
                const rect = question.getBoundingClientRect();
                if (rect.top <= 100 && rect.bottom >= 100) {
                    navQuestions.forEach(nav => nav.classList.remove('active'));
                    if (navQuestions[index]) {
                        navQuestions[index].classList.add('active');
                    }
                }
            });
        });
    </script>
</body>
</html> 