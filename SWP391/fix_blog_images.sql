-- Fix blog images by updating thumbnail URLs to working images
-- First check current blog data
SELECT 'Current blog data:' as info;
SELECT id, title, thumbnail_url FROM blogs LIMIT 10;

-- Update blog thumbnails with working image URLs
UPDATE blogs SET thumbnail_url = CASE 
    WHEN id = 1 THEN 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400&h=200&fit=crop'
    WHEN id = 2 THEN 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop'
    WHEN id = 3 THEN 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400&h=200&fit=crop'
    WHEN id = 4 THEN 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=200&fit=crop'
    WHEN id = 5 THEN 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=400&h=200&fit=crop'
    WHEN id = 6 THEN 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=200&fit=crop'
    WHEN id = 7 THEN 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&h=200&fit=crop'
    WHEN id = 8 THEN 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400&h=200&fit=crop'
    WHEN id = 9 THEN 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=200&fit=crop'
    WHEN id = 10 THEN 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400&h=200&fit=crop'
    ELSE thumbnail_url
END
WHERE id BETWEEN 1 AND 10;

-- If no blogs exist, insert sample blogs with working images
INSERT IGNORE INTO blogs (id, title, content, author_id, published_at, thumbnail_url) VALUES 
(1, 'Latest Trends in Software Development', 
 'The software development landscape is constantly changing, with new frameworks, tools, and methodologies emerging regularly. This article explores the most significant trends shaping the industry today, from artificial intelligence integration to low-code platforms and DevOps practices.',
 1, 
 DATE_SUB(NOW(), INTERVAL 1 DAY),
 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400&h=200&fit=crop'),

(2, 'Getting Started with Java Programming', 
 'Java is one of the most popular programming languages in the world. In this comprehensive guide, we will explore the fundamentals of Java programming, from basic syntax to advanced concepts. Perfect for beginners and those looking to refresh their knowledge.',
 1, 
 DATE_SUB(NOW(), INTERVAL 2 DAY),
 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop'),

(3, 'Mastering Problem-Solving Skills', 
 'Problem-solving is at the heart of programming and software development. This article provides practical strategies and techniques to improve your analytical thinking and approach complex challenges with confidence.',
 1, 
 DATE_SUB(NOW(), INTERVAL 3 DAY),
 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400&h=200&fit=crop'),

(4, 'Effective Communication Skills for Developers', 
 'Technical skills alone are not enough in today\'s collaborative development environment. Learn how to communicate effectively with team members, stakeholders, and clients to advance your career.',
 1, 
 DATE_SUB(NOW(), INTERVAL 4 DAY),
 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=200&fit=crop'),

(5, 'Introduction to Cloud Computing', 
 'Cloud computing has revolutionized how we build and deploy applications. This introduction covers the fundamental concepts, major providers, and practical guidance for getting started with cloud technologies.',
 1, 
 DATE_SUB(NOW(), INTERVAL 5 DAY),
 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=400&h=200&fit=crop');

-- Verify the updates
SELECT 'Updated blog data:' as info;
SELECT id, title, thumbnail_url FROM blogs ORDER BY id LIMIT 10;

SELECT 'Total blogs:' as info;
SELECT COUNT(*) as total_blogs FROM blogs;
