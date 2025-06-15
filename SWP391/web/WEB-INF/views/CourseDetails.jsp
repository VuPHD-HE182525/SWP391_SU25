<%-- 
    Document   : subjectDetails
    Created on : May 28, 2025, 3:59 PM
    Author     : [Your Name]
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Subject Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: Arial, sans-serif;
            }
            .container {
                margin-top: 30px;
            }
            .main-content {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .sidebar {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .subject-title {
                font-size: 2rem;
                font-weight: bold;
                margin-bottom: 10px;
            }
            .subject-tagline {
                color: #007bff;
                font-size: 1.1rem;
                margin-bottom: 20px;
            }
            .subject-image {
                background-color: #e0f7fa;
                padding: 20px;
                border-radius: 8px;
                text-align: center;
                font-size: 2rem;
                font-weight: bold;
                color: #0288d1;
                margin-bottom: 20px;
            }
            .price-box {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .original-price {
                text-decoration: line-through;
                color: #6c757d;
                font-size: 1.2rem;
            }
            .sale-price {
                color: #dc3545;
                font-size: 1.5rem;
                font-weight: bold;
            }
            .register-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                font-size: 1.1rem;
            }
            .register-btn:hover {
                background-color: #0056b3;
            }
            .section-title {
                font-size: 1.3rem;
                font-weight: bold;
                margin-bottom: 10px;
            }
            .sidebar-section {
                margin-bottom: 20px;
            }
            .sidebar-section ul {
                list-style: none;
                padding: 0;
            }
            .sidebar-section ul li {
                margin-bottom: 10px;
            }
            .sidebar-section ul li a {
                color: #007bff;
                text-decoration: none;
            }
            .sidebar-section ul li a:hover {
                text-decoration: underline;
            }
            .search-box {
                width: 100%;
                padding: 8px;
                border: 1px solid #ced4da;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
                <jsp:include page="/views/includes/header.jsp" />

        <div class="container">
            <div class="row">
                <!-- Main Content -->
                <div class="col-md-8">
                    <div class="main-content">
                        <!-- Subject Title -->
                        <h1 class="subject-title">Improve Your Academic Writing Skills for Essay Writing in English</h1>

                        <!-- Tagline -->
                        <p class="subject-tagline">SOFT SKILLS</p>

                        <!-- Image Placeholder -->
                        <div class="subject-image">
                            SOFT SKILLS
                        </div>

                        <!-- Pricing -->
                        <div class="price-box">
                            <div>
                                <span class="original-price">300$</span>
                                <span class="sale-price">100$</span>
                            </div>
                            <button class="register-btn">Register</button>
                        </div>

                        <!-- Brief Info -->
                        <div class="section-title">Brief Info:</div>
                        <p>
                            This course is designed to help students and professionals enhance
                            their academic writing abilities, specifically for crafting essays in English.
                            It covers various essay types—such as argumentative, descriptive, and expository—while
                            offering practical strategies for effective structure and organization.
                            By the end, participants will be equipped to produce clear, well-organized
                            essays that meet academic standards.
                        </p>

                        <!-- Description -->
                        <div class="section-title">Description:</div>
                        <p><strong>Course Objectives:</strong></p>
                        <p>By the end of this course, participants will be able to:</p>
                        <ul>
                            <li>Understand the structure and components of academic essays.</li>
                            <li>Write clear, concise, and coherent thesis statements.</li>
                            <li>Develop well-structured body paragraphs with supporting evidence.</li>
                            <li>Use transition words and academic vocabulary effectively.</li>
                            <li>Avoid common grammar and punctuation errors in academic writing.</li>
                            <li>Properly integrate and cite sources using academic referencing styles.</li>
                        </ul>
                        <p><strong>Course Duration:</strong></p>
                        <p>6 weeks (can be adapted for intensive 3-week or extended 12-week format)</p>
                        <p><strong>Course Outline:</strong></p>
                        <ul>
                            <li><strong>Week 1: Introduction to Academic Writing</strong>
                                <ul>
                                    <li>Purpose and characteristics of academic writing</li>
                                    <li>Essay types (argumentative, descriptive, expository, analytical)</li>
                                    <li>Understanding the writing process (prewriting, drafting, revising, editing)</li>
                                </ul>
                            </li>
                            <li><strong>Week 2: Essay Structure and Thesis Statements</strong>
                                <ul>
                                    <li>Introduction, body, and conclusion</li>
                                    <li>Crafting effective thesis statements</li>
                                    <li>Identifying and avoiding vague or broad claims</li>
                                </ul>
                            </li>
                            <li><strong>Week 3: Developing Body Paragraphs</strong>
                                <ul>
                                    <li>Topic sentences and unity</li>
                                    <li>Supporting ideas with evidence</li>
                                    <li>Using examples, statistics, and references</li>
                                </ul>
                            </li>
                            <li><strong>Week 4: Coherence and Cohesion</strong>
                                <ul>
                                    <li>Logical flow and paragraph transitions</li>
                                    <li>Linking words and phrases</li>
                                    <li>Sentence structure and variety</li>
                                </ul>
                            </li>
                            <li><strong>Week 5: Academic Style and Grammar</strong>
                                <ul>
                                    <li>Formal tone and word choice</li>
                                    <li>Common grammar mistakes (subject-verb agreement, verb tenses, articles)</li>
                                    <li>Avoiding plagiarism and paraphrasing techniques</li>
                                </ul>
                            </li>
                            <li><strong>Week 6: Referencing and Final Essay Project</strong>
                                <ul>
                                    <li>In-text citations and referencing styles (APA, MLA, Chicago)</li>
                                    <li>Writing and peer-reviewing a complete academic essay</li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="col-md-4">
                    <div class="sidebar">
                        <!-- Subject Search -->
                        <div class="sidebar-section">
                            <input type="text" class="search-box" placeholder="Subject Search">
                        </div>

                        <!-- Subject Categories -->
                        <div class="sidebar-section">
                            <h5>Subject Categories</h5>
                            <ul>
                                <li><a href="#">Programming</a></li>
                                <li><a href="#">Mathematics</a></li>
                                <li><a href="#">Academic Writing Skills</a></li>
                            </ul>
                        </div>

                        <!-- Featured Subjects -->
                        <div class="sidebar-section">
                            <h5>Featured Subjects</h5>
                            <ul>
                                <li><a href="#">Soft Skills</a></li>
                                <li><a href="#">Programming</a></li>
                                <li><a href="#">Mathematics</a></li>
                            </ul>
                        </div>

                        <!-- Contacts/Links -->
                        <div class="sidebar-section">
                            <h5>Contacts</h5>
                            <ul>
                                <li><a href="mailto:vanduc06102005@email.com">Email:vanduc06102005@gmail.com</a></li>
                                <li><a href="tel:+123456789">Phone:+84961122806</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/views/includes/footer.jsp" />
    </body>
</html>