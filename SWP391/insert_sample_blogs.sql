-- Insert sample blogs based on existing table structure
-- Table structure: id, title, content, author_id, published_at, thumbnail_url

-- Create categories table if it doesn't exist (for future use)
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample categories
INSERT IGNORE INTO categories (id, name, description) VALUES 
(1, 'Technology', 'Technology and programming articles'),
(2, 'Education', 'Educational content and learning tips'),
(3, 'Career', 'Career development and professional growth'),
(4, 'Soft Skills', 'Communication and interpersonal skills'),
(5, 'Industry News', 'Latest news and trends in the industry');

-- Insert sample blogs (without category_id since it doesn't exist in current table)
INSERT INTO blogs (title, content, author_id, published_at, thumbnail_url) VALUES 
('Getting Started with Java Programming', 
 'Java is one of the most popular programming languages in the world. In this comprehensive guide, we will explore the fundamentals of Java programming, from basic syntax to advanced concepts. Whether you are a complete beginner or looking to refresh your knowledge, this article will provide you with the essential information you need to start your Java journey. We will cover variables, data types, control structures, object-oriented programming principles, and much more. By the end of this article, you will have a solid foundation in Java programming and be ready to tackle more complex projects.',
 1, 
 DATE_SUB(NOW(), INTERVAL 2 DAY),
 'https://via.placeholder.com/400x200/4CAF50/white?text=Java+Programming'),

('Effective Communication Skills for Developers', 
 'Communication is a crucial skill for software developers that is often overlooked. In this article, we explore the importance of effective communication in the tech industry and provide practical tips for improving your communication skills. From writing clear documentation to presenting technical concepts to non-technical stakeholders, good communication can significantly impact your career growth. We will discuss various communication channels, active listening techniques, and how to give and receive constructive feedback. These skills are essential for working in teams, leading projects, and advancing in your career.',
 1, 
 DATE_SUB(NOW(), INTERVAL 5 DAY),
 'https://via.placeholder.com/400x200/2196F3/white?text=Communication+Skills'),

('The Future of Online Learning', 
 'Online learning has revolutionized education, making knowledge accessible to millions of people worldwide. This article examines the current trends in e-learning, the impact of technology on education, and what the future holds for online learning platforms. We will discuss the benefits and challenges of remote learning, the role of artificial intelligence in personalized education, and how virtual reality is changing the way we learn. As we move forward, online learning will continue to evolve, offering new opportunities for students and educators alike.',
 1, 
 DATE_SUB(NOW(), INTERVAL 1 WEEK),
 'https://via.placeholder.com/400x200/FF9800/white?text=Online+Learning'),

('Building Your First Web Application', 
 'Creating your first web application can be both exciting and challenging. This step-by-step guide will walk you through the process of building a simple web application from scratch. We will cover the essential technologies including HTML, CSS, JavaScript, and a backend framework. You will learn about project structure, database design, user authentication, and deployment strategies. By following this tutorial, you will gain hands-on experience and confidence to build more complex web applications in the future.',
 1, 
 DATE_SUB(NOW(), INTERVAL 10 DAY),
 'https://via.placeholder.com/400x200/9C27B0/white?text=Web+Development'),

('Career Growth in the Tech Industry', 
 'The technology industry offers numerous opportunities for career advancement, but navigating your career path requires strategic planning and continuous learning. In this article, we explore different career trajectories in tech, from individual contributor roles to management positions. We will discuss the importance of building a strong professional network, developing both technical and soft skills, and staying current with industry trends. Whether you are just starting your career or looking to make a transition, this guide will help you make informed decisions about your professional development.',
 1, 
 DATE_SUB(NOW(), INTERVAL 2 WEEK),
 'https://via.placeholder.com/400x200/F44336/white?text=Career+Growth'),

('Understanding Database Design Principles', 
 'Database design is a fundamental skill for any developer working with data-driven applications. This comprehensive guide covers the essential principles of database design, including normalization, relationships, indexing, and performance optimization. We will explore different types of databases, when to use them, and best practices for designing efficient and scalable database schemas. Whether you are working with SQL or NoSQL databases, understanding these principles will help you build better applications and avoid common pitfalls.',
 1, 
 DATE_SUB(NOW(), INTERVAL 3 WEEK),
 'https://via.placeholder.com/400x200/607D8B/white?text=Database+Design'),

('The Importance of Continuous Learning', 
 'In the rapidly evolving world of technology, continuous learning is not just beneficial—it is essential for career survival and growth. This article explores strategies for staying current with new technologies, frameworks, and industry best practices. We will discuss various learning resources, from online courses and tutorials to conferences and community events. Additionally, we will cover how to create a personal learning plan, set achievable goals, and measure your progress. Embracing a mindset of lifelong learning will keep you competitive and engaged in your career.',
 1, 
 DATE_SUB(NOW(), INTERVAL 1 MONTH),
 'https://via.placeholder.com/400x200/795548/white?text=Continuous+Learning'),

('Latest Trends in Software Development', 
 'The software development landscape is constantly changing, with new frameworks, tools, and methodologies emerging regularly. This article provides an overview of the latest trends shaping the industry, including cloud computing, microservices architecture, DevOps practices, and artificial intelligence integration. We will examine how these trends are impacting development workflows, team structures, and project outcomes. Staying informed about these trends will help you make better technology choices and remain competitive in the job market.',
 1, 
 NOW(),
 'https://via.placeholder.com/400x200/3F51B5/white?text=Software+Trends'),

('Mastering Problem-Solving Skills', 
 'Problem-solving is at the heart of programming and software development. This article explores effective problem-solving techniques and methodologies that every developer should master. We will cover breaking down complex problems, algorithmic thinking, debugging strategies, and collaborative problem-solving approaches. These skills are not only essential for writing better code but also for advancing in your career and tackling increasingly complex challenges.',
 2, 
 DATE_SUB(NOW(), INTERVAL 4 DAY),
 'https://via.placeholder.com/400x200/8BC34A/white?text=Problem+Solving'),

('Introduction to Cloud Computing', 
 'Cloud computing has transformed the way we build, deploy, and scale applications. This comprehensive introduction covers the fundamental concepts of cloud computing, including Infrastructure as a Service (IaaS), Platform as a Service (PaaS), and Software as a Service (SaaS). We will explore major cloud providers, discuss the benefits and challenges of cloud adoption, and provide practical guidance for getting started with cloud technologies.',
 2, 
 DATE_SUB(NOW(), INTERVAL 6 DAY),
 'https://via.placeholder.com/400x200/00BCD4/white?text=Cloud+Computing');

-- Verify the data was inserted
SELECT 'Sample blogs inserted successfully!' as status;
SELECT COUNT(*) as total_blogs FROM blogs;
SELECT id, title, author_id, published_at FROM blogs ORDER BY published_at DESC LIMIT 5;
