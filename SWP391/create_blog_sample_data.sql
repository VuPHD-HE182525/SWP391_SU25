-- Script to create sample blog data for testing
-- Step 1: Check current blog table structure
DESCRIBE blogs;

-- Step 2: Add missing columns if they don't exist
-- Add category_id column
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'blogs' 
     AND COLUMN_NAME = 'category_id') = 0,
    'ALTER TABLE blogs ADD COLUMN category_id INT DEFAULT NULL',
    'SELECT "category_id column already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add published_at column if it doesn't exist
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'blogs' 
     AND COLUMN_NAME = 'published_at') = 0,
    'ALTER TABLE blogs ADD COLUMN published_at DATETIME DEFAULT CURRENT_TIMESTAMP',
    'SELECT "published_at column already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 3: Create categories table if it doesn't exist
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Step 4: Insert sample categories
INSERT IGNORE INTO categories (id, name, description) VALUES 
(1, 'Technology', 'Technology and programming articles'),
(2, 'Education', 'Educational content and learning tips'),
(3, 'Career', 'Career development and professional growth'),
(4, 'Soft Skills', 'Communication and interpersonal skills'),
(5, 'Industry News', 'Latest news and trends in the industry');

-- Step 5: Clear existing sample blogs (optional)
-- DELETE FROM blogs WHERE author_id = 1 AND title LIKE '%Programming%';

-- Step 6: Insert sample blogs (using only existing columns)
INSERT INTO blogs (title, content, author_id, published_at, thumbnail_url, category_id) VALUES 
('Getting Started with Java Programming', 
 'Java is one of the most popular programming languages in the world. In this comprehensive guide, we will explore the fundamentals of Java programming, from basic syntax to advanced concepts. Whether you are a complete beginner or looking to refresh your knowledge, this article will provide you with the essential information you need to start your Java journey.',
 1, 
 DATE_SUB(NOW(), INTERVAL 2 DAY),
 'https://via.placeholder.com/400x200/4CAF50/white?text=Java+Programming',
 1),

('Effective Communication Skills for Developers', 
 'Communication is a crucial skill for software developers that is often overlooked. In this article, we explore the importance of effective communication in the tech industry and provide practical tips for improving your communication skills.',
 1, 
 DATE_SUB(NOW(), INTERVAL 5 DAY),
 'https://via.placeholder.com/400x200/2196F3/white?text=Communication+Skills',
 4),

('The Future of Online Learning', 
 'Online learning has revolutionized education, making knowledge accessible to millions of people worldwide. This article examines the current trends in e-learning, the impact of technology on education, and what the future holds for online learning platforms.',
 1, 
 DATE_SUB(NOW(), INTERVAL 1 WEEK),
 'https://via.placeholder.com/400x200/FF9800/white?text=Online+Learning',
 2),

('Building Your First Web Application', 
 'Creating your first web application can be both exciting and challenging. This step-by-step guide will walk you through the process of building a simple web application from scratch. We will cover the essential technologies including HTML, CSS, JavaScript, and a backend framework.',
 1, 
 DATE_SUB(NOW(), INTERVAL 10 DAY),
 'https://via.placeholder.com/400x200/9C27B0/white?text=Web+Development',
 1),

('Career Growth in the Tech Industry', 
 'The technology industry offers numerous opportunities for career advancement, but navigating your career path requires strategic planning and continuous learning. In this article, we explore different career trajectories in tech.',
 1, 
 DATE_SUB(NOW(), INTERVAL 2 WEEK),
 'https://via.placeholder.com/400x200/F44336/white?text=Career+Growth',
 3),

('Understanding Database Design Principles', 
 'Database design is a fundamental skill for any developer working with data-driven applications. This comprehensive guide covers the essential principles of database design, including normalization, relationships, indexing, and performance optimization.',
 1, 
 DATE_SUB(NOW(), INTERVAL 3 WEEK),
 'https://via.placeholder.com/400x200/607D8B/white?text=Database+Design',
 1),

('The Importance of Continuous Learning', 
 'In the rapidly evolving world of technology, continuous learning is not just beneficial—it is essential for career survival and growth. This article explores strategies for staying current with new technologies, frameworks, and industry best practices.',
 1, 
 DATE_SUB(NOW(), INTERVAL 1 MONTH),
 'https://via.placeholder.com/400x200/795548/white?text=Continuous+Learning',
 2),

('Latest Trends in Software Development', 
 'The software development landscape is constantly changing, with new frameworks, tools, and methodologies emerging regularly. This article provides an overview of the latest trends shaping the industry.',
 1, 
 NOW(),
 'https://via.placeholder.com/400x200/3F51B5/white?text=Software+Trends',
 5);

-- Step 7: Verify the data was inserted
SELECT 'Sample blogs created successfully!' as status;
SELECT COUNT(*) as total_blogs FROM blogs;
SELECT id, title, author_id, published_at, category_id FROM blogs ORDER BY published_at DESC LIMIT 5;

-- Step 8: Check categories
SELECT 'Categories:' as info;
SELECT * FROM categories WHERE id IN (1,2,3,4,5);
