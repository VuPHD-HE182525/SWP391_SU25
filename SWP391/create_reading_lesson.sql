-- Create Reading Lesson for Testing Navigation
-- This will add a reading lesson to the database

-- First, check current lessons
SELECT 'Current lessons:' as status;
SELECT id, title, lesson_order, type, course_id FROM lessons WHERE course_id = 1 ORDER BY lesson_order;

-- Add reading lesson after lesson 2
INSERT INTO lessons (
    course_id,
    title, 
    video_url,
    lesson_order, 
    status, 
    type, 
    parent_lesson_id
) VALUES (
    1,
    'Reading: Active Listening Fundamentals',
    NULL,
    3,
    1,
    'reading',
    NULL
);

-- Get the ID of the newly created reading lesson
SET @reading_lesson_id = LAST_INSERT_ID();

-- Update the lesson to add content fields if they exist
UPDATE lessons SET 
    content_type = 'reading',
    estimated_time = 15
WHERE id = @reading_lesson_id;

-- Show the result
SELECT 'Reading lesson created with ID:' as status, @reading_lesson_id as lesson_id;

-- Show updated lesson list
SELECT id, title, lesson_order, type, content_type FROM lessons WHERE course_id = 1 ORDER BY lesson_order; 