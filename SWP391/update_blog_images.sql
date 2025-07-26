-- Update Blog Images - Simple SQL Script
-- This script updates blog thumbnails with local image paths

-- Step 1: Check current blog data
SELECT 'Current blog thumbnails:' as info;
SELECT id, title, thumbnail_url FROM blogs ORDER BY id LIMIT 15;

-- Step 2: Update blog thumbnails with local images
UPDATE blogs SET thumbnail_url = 'uploads/images/blog1.jpg' WHERE id = 1;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog2.jpg' WHERE id = 2;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog3.png' WHERE id = 3;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog4.png' WHERE id = 4;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog5.png' WHERE id = 5;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog6.jpg' WHERE id = 6;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog7.jpg' WHERE id = 7;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog8.jpg' WHERE id = 8;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog9.png' WHERE id = 9;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog10.jpg' WHERE id = 10;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog11.jpg' WHERE id = 11;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog12.png' WHERE id = 12;
UPDATE blogs SET thumbnail_url = 'uploads/images/blog13.webp' WHERE id = 13;

-- Step 3: Insert sample blogs if table is empty
INSERT IGNORE INTO blogs (id, title, content, author_id, published_at, thumbnail_url) VALUES 
(1, 'Latest Trends in Software Development', 'The software development landscape is constantly changing...', 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'uploads/images/blog1.jpg'),
(2, 'Getting Started with Java Programming', 'Java is one of the most popular programming languages...', 1, DATE_SUB(NOW(), INTERVAL 2 DAY), 'uploads/images/blog2.jpg'),
(3, 'Mastering Problem-Solving Skills', 'Problem-solving is at the heart of programming...', 1, DATE_SUB(NOW(), INTERVAL 3 DAY), 'uploads/images/blog3.png'),
(4, 'Effective Communication Skills for Developers', 'Technical skills alone are not enough...', 1, DATE_SUB(NOW(), INTERVAL 4 DAY), 'uploads/images/blog4.png'),
(5, 'Introduction to Cloud Computing', 'Cloud computing has revolutionized how we build...', 1, DATE_SUB(NOW(), INTERVAL 5 DAY), 'uploads/images/blog5.png'),
(6, 'Understanding Database Design Principles', 'Database design is a fundamental skill...', 1, DATE_SUB(NOW(), INTERVAL 6 DAY), 'uploads/images/blog6.jpg'),
(7, 'Building Your First Web Application', 'Creating your first web application can be exciting...', 1, DATE_SUB(NOW(), INTERVAL 7 DAY), 'uploads/images/blog7.jpg'),
(8, 'The Future of Online Learning', 'Online learning has revolutionized education...', 1, DATE_SUB(NOW(), INTERVAL 8 DAY), 'uploads/images/blog8.jpg'),
(9, 'Teamwork Skills for Developers', 'Working effectively with others...', 1, DATE_SUB(NOW(), INTERVAL 9 DAY), 'uploads/images/blog9.png'),
(10, 'Startup and Entrepreneurship', 'Entrepreneurship knowledge and skills...', 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 'uploads/images/blog10.jpg'),
(11, 'Presentation & Public Speaking', 'Learn to communicate clearly and confidently...', 1, DATE_SUB(NOW(), INTERVAL 11 DAY), 'uploads/images/blog11.jpg'),
(12, '10 Soft Skills for IT World', 'Nội dung blog về 10 kỹ năng mềm quan trọng...', 1, DATE_SUB(NOW(), INTERVAL 12 DAY), 'uploads/images/blog12.png'),
(13, 'The Importance of Continuous Learning', 'In the rapidly evolving world of technology...', 1, DATE_SUB(NOW(), INTERVAL 13 DAY), 'uploads/images/blog13.webp');

-- Step 4: Verify the updates
SELECT 'Updated blog thumbnails:' as info;
SELECT id, title, thumbnail_url FROM blogs ORDER BY id LIMIT 15;

-- Step 5: Check total blogs
SELECT COUNT(*) as total_blogs FROM blogs;

SELECT 'Blog images updated successfully!' as status;
