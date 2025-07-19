-- Fix lesson 5 video issue
-- First check if lesson 5 exists
SELECT COUNT(*) as lesson_5_count FROM lessons WHERE id = 5;

-- If lesson 5 doesn't exist, create it
INSERT IGNORE INTO lessons (id, course_id, title, video_url, lesson_order, status, type) 
VALUES (5, 2, 'Lesson 1: What is AI?', '/video/AI 1.mp4', 1, 1, 'video');

-- If it exists but video_url is wrong, update it
UPDATE lessons 
SET video_url = '/video/AI 1.mp4',
    title = 'Lesson 1: What is AI?',
    course_id = 2,
    type = 'video',
    status = 1
WHERE id = 5;

-- Also ensure lesson 10 exists for Java video
INSERT IGNORE INTO lessons (id, course_id, title, video_url, lesson_order, status, type) 
VALUES (10, 1, 'Lesson 2: Variables and Data Types', '/video/java 2.mp4', 2, 1, 'video');

UPDATE lessons 
SET video_url = '/video/java 2.mp4',
    title = 'Lesson 2: Variables and Data Types',
    course_id = 1,
    type = 'video',
    status = 1
WHERE id = 10;

-- Check results
SELECT id, title, video_url, course_id, status FROM lessons WHERE id IN (5, 10);

-- Also check what lessons currently exist
SELECT id, title, video_url FROM lessons ORDER BY id; 