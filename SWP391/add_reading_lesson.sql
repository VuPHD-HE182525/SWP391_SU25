-- Add Reading Lesson to Database for Proper Navigation
-- This fixes the navigation issue from Video 2 to Reading content

-- First, let's see current lessons
SELECT * FROM lessons WHERE course_id = 1 ORDER BY lesson_order;

-- Add reading lesson as lesson_order = 3 (between Video 2 and other videos)
INSERT INTO lessons (course_id, title, video_url, lesson_order, status, type, parent_lesson_id, content_file_path, content_type, estimated_time) 
VALUES (
    1, 
    'Reading: Active Listening Fundamentals', 
    NULL, 
    3, 
    1, 
    'reading', 
    NULL, 
    '/uploads/texts/lessons/lesson-1-active-listening.html', 
    'reading', 
    15
);

-- Update lesson orders for existing lessons to make room
-- Shift other lessons down
UPDATE lessons SET lesson_order = lesson_order + 1 WHERE course_id = 1 AND lesson_order >= 3 AND type = 'video';

-- Verify the new structure
SELECT id, title, lesson_order, type, content_type FROM lessons WHERE course_id = 1 ORDER BY lesson_order;

-- Expected result:
-- lesson_order 1: Video 1: What is AI? 
-- lesson_order 2: Video 2: Giải quyết xung đột
-- lesson_order 3: Reading: Active Listening Fundamentals (NEW)
-- lesson_order 4+: Other video lessons shifted down

SELECT 'Reading lesson added successfully! Navigation should work now.' AS status; 