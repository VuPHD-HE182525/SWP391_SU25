<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Results - ${quiz.title}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .result-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .score-circle {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: bold;
            color: white;
            margin: 0 auto 1rem;
        }
        .score-excellent {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .score-good {
            background: linear-gradient(135deg, #17a2b8 0%, #007bff 100%);
        }
        .score-average {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
        .score-poor {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
        }
        .result-card {
            border: none;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            border-radius: 15px;
            overflow: hidden;
            margin-bottom: 2rem;
        }
        .stat-item {
            text-align: center;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        .stat-item.initiation {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1976d2;
        }
        .stat-item.planning {
            background: linear-gradient(135deg, #f3e5f5 0%, #ce93d8 100%);
            color: #7b1fa2;
        }
        .stat-item.executing {
            background: linear-gradient(135deg, #e8f5e8 0%, #a5d6a7 100%);
            color: #388e3c;
        }
        .stat-item.monitoring {
            background: linear-gradient(135deg, #fff3e0 0%, #ffcc02 100%);
            color: #f57c00;
        }
        .stat-item.closing {
            background: linear-gradient(135deg, #fce4ec 0%, #f8bbd9 100%);
            color: #c2185b;
        }
        .stat-item.business {
            background: linear-gradient(135deg, #e0f2f1 0%, #80cbc4 100%);
            color: #00695c;
        }
        .stat-item.people {
            background: linear-gradient(135deg, #f1f8e9 0%, #aed581 100%);
            color: #558b2f;
        }
        .stat-item.process {
            background: linear-gradient(135deg, #e8eaf6 0%, #9fa8da 100%);
            color: #3f51b5;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            display: block;
        }
        .stat-label {
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.8;
        }
        .time-stats {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .btn-action {
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin: 0.5rem;
            transition: all 0.3s ease;
        }
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .progress-ring {
            position: relative;
            width: 100px;
            height: 100px;
            margin: 0 auto;
        }
        .progress-ring svg {
            width: 100%;
            height: 100%;
            transform: rotate(-90deg);
        }
        .progress-ring circle {
            fill: none;
            stroke-width: 8;
            r: 40;
            cx: 50;
            cy: 50;
        }
        .progress-ring .background {
            stroke: #f1f3f4;
        }
        .progress-ring .progress {
            stroke: #4285f4;
            stroke-linecap: round;
            transition: stroke-dasharray 0.5s ease;
        }
        .progress-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-weight: bold;
            font-size: 1.2rem;
        }
    </style>
</head>
<body class="bg-light">
    
    <!-- Include Header -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />
    
    <!-- Result Header -->
    <div class="result-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb text-white-50 mb-3">
                            <li class="breadcrumb-item"><a href="home" class="text-white">Home</a></li>
                            <li class="breadcrumb-item"><a href="quiz?action=view&quizId=${quiz.id}" class="text-white">${quiz.title}</a></li>
                            <li class="breadcrumb-item active text-white" aria-current="page">Results</li>
                        </ol>
                    </nav>
                    <h1 class="display-5 fw-bold mb-0">${quiz.title}</h1>
                    <p class="lead mt-2 mb-0">Quiz Results</p>
                </div>
                <div class="col-md-4 text-center">
                    <div class="score-circle ${submission.score >= 85 ? 'score-excellent' : submission.score >= 70 ? 'score-good' : submission.score >= 50 ? 'score-average' : 'score-poor'}">
                        ${submission.score}%
                    </div>
                    <div class="text-center">
                        <c:choose>
                            <c:when test="${submission.score >= 85}">
                                <h5 class="text-white">Excellent!</h5>
                                <p class="text-white-50 mb-0">Outstanding performance</p>
                            </c:when>
                            <c:when test="${submission.score >= 70}">
                                <h5 class="text-white">Good Job!</h5>
                                <p class="text-white-50 mb-0">Well done</p>
                            </c:when>
                            <c:when test="${submission.score >= 50}">
                                <h5 class="text-white">Keep Trying!</h5>
                                <p class="text-white-50 mb-0">You can do better</p>
                            </c:when>
                            <c:otherwise>
                                <h5 class="text-white">Need Improvement</h5>
                                <p class="text-white-50 mb-0">Study more and retry</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container py-5">
        
        <!-- Score Summary -->
        <div class="result-card">
            <div class="card-body p-4">
                <div class="row text-center">
                    <div class="col-md-3">
                        <div class="progress-ring">
                            <svg>
                                <circle class="background"></circle>
                                <circle class="progress" stroke-dasharray="${(submission.score / 100) * 251.2}, 251.2"></circle>
                            </svg>
                            <div class="progress-text">${submission.score}%</div>
                        </div>
                        <h6 class="mt-3">SCORE</h6>
                    </div>
                    <div class="col-md-3">
                        <div class="display-6 fw-bold text-success">${submission.correctAnswers}</div>
                        <h6 class="text-muted">Correct</h6>
                        <small class="text-muted">out of ${submission.totalQuestions}</small>
                    </div>
                    <div class="col-md-3">
                        <div class="display-6 fw-bold text-danger">${submission.totalQuestions - submission.correctAnswers}</div>
                        <h6 class="text-muted">Incorrect</h6>
                        <small class="text-muted">questions</small>
                    </div>
                    <div class="col-md-3">
                        <div class="display-6 fw-bold text-primary">
                            <c:choose>
                                <c:when test="${submission.submittedAt != null}">
                                    ${submission.submittedAt.toString().substring(14, 16)}
                                </c:when>
                                <c:otherwise>
                                    --
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h6 class="text-muted">Time Taken</h6>
                        <small class="text-muted">minutes (approx.)</small>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Results by Group & Domain (Simulated based on image) -->
        <div class="result-card">
            <div class="card-body p-4">
                <h5 class="card-title mb-4">
                    <i class="fas fa-chart-bar text-primary me-2"></i>
                    Results by Group & Domain
                </h5>
                
                <div class="row">
                    <div class="col-md-6">
                        <h6 class="text-muted mb-3">RESULTS BY THE GROUP</h6>
                        <div class="row">
                            <div class="col-6">
                                <div class="stat-item initiation">
                                    <span class="stat-value">35%</span>
                                    <div class="stat-label">Initiation</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stat-item planning">
                                    <span class="stat-value">59%</span>
                                    <div class="stat-label">Planning</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stat-item executing">
                                    <span class="stat-value">46%</span>
                                    <div class="stat-label">Executing</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stat-item monitoring">
                                    <span class="stat-value">72%</span>
                                    <div class="stat-label">M&C</div>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="stat-item closing">
                                    <span class="stat-value">75%</span>
                                    <div class="stat-label">Closing</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <h6 class="text-muted mb-3">RESULTS BY THE DOMAIN</h6>
                        <div class="row">
                            <div class="col-12">
                                <div class="stat-item business">
                                    <span class="stat-value">65%</span>
                                    <div class="stat-label">Business</div>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="stat-item people">
                                    <span class="stat-value">32%</span>
                                    <div class="stat-label">People</div>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="stat-item process">
                                    <span class="stat-value">86%</span>
                                    <div class="stat-label">Process</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Additional Stats -->
        <div class="result-card">
            <div class="card-body p-4">
                <div class="row text-center">
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded">
                            <i class="fas fa-clock text-primary mb-2" style="font-size: 2rem;"></i>
                            <div class="fw-bold">55 sec</div>
                            <small class="text-muted">AVERAGE TIME PER QUESTION</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded">
                            <i class="fas fa-stopwatch text-warning mb-2" style="font-size: 2rem;"></i>
                            <div class="fw-bold">00:27:38</div>
                            <small class="text-muted">TOTAL TIME</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded">
                            <i class="fas fa-question-circle text-info mb-2" style="font-size: 2rem;"></i>
                            <div class="fw-bold">${submission.totalQuestions - submission.correctAnswers} questions</div>
                            <small class="text-muted">UNANSWERED QUESTIONS</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="text-center">
            <a href="quiz?action=review&submissionId=${submission.id}" 
               class="btn btn-primary btn-action">
                <i class="fas fa-eye me-2"></i>
                REVIEW TEST
            </a>
            <a href="quiz?action=take&quizId=${quiz.id}" 
               class="btn btn-success btn-action">
                <i class="fas fa-redo me-2"></i>
                REDO TEST
            </a>
            <a href="quiz?action=view&quizId=${quiz.id}" 
               class="btn btn-outline-secondary btn-action">
                <i class="fas fa-arrow-left me-2"></i>
                Back to Quiz
            </a>
        </div>
        
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Animate progress ring on page load
        document.addEventListener('DOMContentLoaded', function() {
            const progressRing = document.querySelector('.progress-ring .progress');
            <c:choose>
                <c:when test="${submission.score != null}">
                    const score = ${submission.score};
                </c:when>
                <c:otherwise>
                    const score = 0;
                </c:otherwise>
            </c:choose>
            const circumference = 2 * Math.PI * 40; // radius = 40
            const offset = circumference - (score / 100) * circumference;
            
            progressRing.style.strokeDasharray = circumference + ' ' + circumference;
            progressRing.style.strokeDashoffset = circumference;
            
            setTimeout(() => {
                progressRing.style.strokeDashoffset = offset;
            }, 500);
        });
    </script>
</body>
</html> 