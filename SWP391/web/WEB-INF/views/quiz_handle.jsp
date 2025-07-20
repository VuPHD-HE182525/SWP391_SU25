<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Taking Quiz: ${quiz.title}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .quiz-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .question-card {
            border: none;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            border-radius: 15px;
            margin-bottom: 2rem;
            overflow: hidden;
        }
        .question-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 1.5rem;
            border-bottom: 1px solid #dee2e6;
        }
        .question-number {
            background: #667eea;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 1rem;
        }
        .answer-option {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f8f9fa;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .answer-option:hover {
            background: #f8f9fa;
        }
        .answer-option:last-child {
            border-bottom: none;
        }
        .answer-option input[type="radio"] {
            margin-right: 1rem;
            transform: scale(1.2);
        }
        .timer {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 25px;
            padding: 0.5rem 1rem;
            font-weight: bold;
        }
        .progress-bar {
            height: 8px;
            border-radius: 4px;
        }
        .submit-section {
            background: #f8f9fa;
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
            margin-top: 2rem;
        }
        .btn-submit-quiz {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            padding: 15px 40px;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 50px;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-submit-quiz:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            color: white;
        }
        .question-navigation {
            position: sticky;
            top: 120px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            padding: 1.5rem;
        }
        .nav-question {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0.25rem;
            border: 2px solid #dee2e6;
            background: white;
            color: #6c757d;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .nav-question:hover {
            border-color: #667eea;
            color: #667eea;
        }
        .nav-question.answered {
            background: #28a745;
            border-color: #28a745;
            color: white;
        }
        .nav-question.current {
            background: #667eea;
            border-color: #667eea;
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Quiz Header -->
    <div class="quiz-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h4 class="mb-0">
                        <i class="fas fa-clipboard-question me-2"></i>
                        ${quiz.title}
                    </h4>
                </div>
                <div class="col-md-6 text-end">
                    <c:if test="${quiz.duration > 0}">
                        <div class="timer">
                            <i class="fas fa-clock me-2"></i>
                            <span id="timer">${quiz.duration}:00</span>
                        </div>
                    </c:if>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-12">
                    <div class="progress">
                        <div class="progress-bar" role="progressbar" style="width: 0%" id="progress-bar"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container py-4">
        <form id="quizForm" action="quiz" method="post">
            <input type="hidden" name="action" value="submit">
            <input type="hidden" name="quizId" value="${quiz.id}">
            
            <div class="row">
                <!-- Questions -->
                <div class="col-lg-8">
                    <c:forEach items="${questions}" var="question" varStatus="status">
                        <div class="question-card" id="question-${status.index + 1}">
                            <div class="question-header">
                                <div class="d-flex align-items-center">
                                    <div class="question-number">${status.index + 1}</div>
                                    <div class="flex-grow-1">
                                        <h5 class="mb-0">Question ${status.index + 1} of ${fn:length(questions)}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <div class="p-4">
                                    <h6 class="question-text mb-4">${question.content}</h6>
                                </div>
                                
                                <c:forEach items="${question.answers}" var="answer" varStatus="answerStatus">
                                    <label class="answer-option d-flex align-items-center" for="answer_${question.id}_${answer.id}">
                                        <input type="radio" 
                                               id="answer_${question.id}_${answer.id}"
                                               name="question_${question.id}" 
                                               value="${answer.id}"
                                               onchange="updateProgress(); markQuestionAnswered('${status.index + 1}')">
                                        <div class="flex-grow-1">
                                            <div class="fw-medium">
                                                <span class="badge bg-light text-dark me-2">${answerStatus.index == 0 ? 'A' : answerStatus.index == 1 ? 'B' : answerStatus.index == 2 ? 'C' : 'D'}</span>
                                                ${answer.content}
                                            </div>
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Submit Section -->
                    <div class="submit-section">
                        <h5 class="mb-3">Ready to submit your answers?</h5>
                        <p class="text-muted mb-4">
                            Make sure you've answered all questions before submitting. 
                            You can review your answers using the navigation panel.
                        </p>
                        <button type="button" class="btn btn-submit-quiz" onclick="confirmSubmit()">
                            <i class="fas fa-paper-plane me-2"></i>
                            Submit Quiz
                        </button>
                    </div>
                </div>
                
                <!-- Question Navigation -->
                <div class="col-lg-4">
                    <div class="question-navigation">
                        <h6 class="mb-3">
                            <i class="fas fa-list me-2"></i>
                            Questions Overview
                        </h6>
                        <div class="d-flex flex-wrap">
                            <c:forEach items="${questions}" var="question" varStatus="status">
                                <a href="#question-${status.index + 1}" 
                                   class="nav-question" 
                                   id="nav-q-${status.index + 1}"
                                    onclick="scrollToQuestion('${status.index + 1}')">
                                    ${status.index + 1}
                                </a>
                            </c:forEach>
                        </div>
                        
                        <div class="mt-4">
                            <div class="d-flex align-items-center mb-2">
                                <div class="nav-question answered me-2" style="width: 20px; height: 20px; font-size: 0.7rem;"></div>
                                <small class="text-muted">Answered</small>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <div class="nav-question current me-2" style="width: 20px; height: 20px; font-size: 0.7rem;"></div>
                                <small class="text-muted">Current</small>
                            </div>
                            <div class="d-flex align-items-center">
                                <div class="nav-question me-2" style="width: 20px; height: 20px; font-size: 0.7rem;"></div>
                                <small class="text-muted">Not answered</small>
                            </div>
                        </div>
                        
                        <div class="mt-4 pt-3 border-top">
                            <div class="text-center">
                                <div class="fw-bold text-primary" id="answered-count">0</div>
                                <small class="text-muted">of ${fn:length(questions)} answered</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    
    <!-- Confirmation Modal -->
    <div class="modal fade" id="submitModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-question-circle text-warning me-2"></i>
                        Confirm Submission
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to submit your quiz?</p>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        You have answered <span id="final-answered-count">0</span> out of ${fn:length(questions)} questions.
                    </div>
                    <p class="text-muted mb-0">Once submitted, you cannot change your answers.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-arrow-left me-2"></i>
                        Continue Quiz
                    </button>
                    <button type="button" class="btn btn-primary" onclick="submitQuiz()">
                        <i class="fas fa-paper-plane me-2"></i>
                        Submit Now
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
                 let answeredQuestions = 0;
                  const totalQuestions = parseInt('${fn:length(questions)}');
         let timeRemaining = parseInt('${quiz.duration > 0 ? quiz.duration * 60 : 0}'); // Convert to seconds
         
         // Timer functionality
         if (timeRemaining > 0) {
            const timerInterval = setInterval(function() {
                timeRemaining--;
                
                const minutes = Math.floor(timeRemaining / 60);
                const seconds = timeRemaining % 60;
                document.getElementById('timer').textContent = 
                    minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
                
                if (timeRemaining <= 0) {
                    clearInterval(timerInterval);
                    alert('Time is up! Submitting your quiz automatically.');
                    document.getElementById('quizForm').submit();
                }
            }, 1000);
        }
        
        function updateProgress() {
            const progressBar = document.getElementById('progress-bar');
            const percentage = (answeredQuestions / totalQuestions) * 100;
            progressBar.style.width = percentage + '%';
        }
        
        function markQuestionAnswered(questionNum) {
            const navElement = document.getElementById('nav-q-' + questionNum);
            if (!navElement.classList.contains('answered')) {
                navElement.classList.add('answered');
                answeredQuestions++;
                document.getElementById('answered-count').textContent = answeredQuestions;
                updateProgress();
            }
        }
        
        function scrollToQuestion(questionNum) {
            document.getElementById('question-' + questionNum).scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
            
            // Update current question indicator
            document.querySelectorAll('.nav-question').forEach(el => el.classList.remove('current'));
            document.getElementById('nav-q-' + questionNum).classList.add('current');
        }
        
        function confirmSubmit() {
            document.getElementById('final-answered-count').textContent = answeredQuestions;
            const modal = new bootstrap.Modal(document.getElementById('submitModal'));
            modal.show();
        }
        
        function submitQuiz() {
            document.getElementById('quizForm').submit();
        }
        
        // Initialize first question as current
        document.addEventListener('DOMContentLoaded', function() {
            if (document.getElementById('nav-q-1')) {
                document.getElementById('nav-q-1').classList.add('current');
            }
        });
        
        // Prevent accidental page refresh
        window.addEventListener('beforeunload', function (e) {
            if (answeredQuestions > 0) {
                e.preventDefault();
                e.returnValue = '';
            }
        });
    </script>
</body>
</html> 