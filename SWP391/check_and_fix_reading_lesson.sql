-- Check and Fix Reading Lesson Issue
-- This script will check if lesson ID 15 exists and create/update it if needed

-- Step 1: Check current lessons table structure
DESCRIBE lessons;

-- Step 2: Check if lesson ID 15 exists
SELECT * FROM lessons WHERE id = 15;

-- Step 3: Check all lessons for course_id = 1 to see current structure
SELECT id, title, lesson_order, type, content_file_path, objectives_file_path, content_type, estimated_time 
FROM lessons 
WHERE course_id = 1 
ORDER BY lesson_order;

-- Step 4: If lesson 15 doesn't exist, create it
-- First check if ID 15 is available
SELECT CASE 
    WHEN EXISTS (SELECT 1 FROM lessons WHERE id = 15) 
    THEN 'Lesson ID 15 already exists' 
    ELSE 'Lesson ID 15 is available' 
END AS status;

-- Step 5: Insert lesson 15 if it doesn't exist (adjust based on above check)
INSERT INTO lessons (
    id,
    title, 
    lesson_order, 
    type, 
    status, 
    course_id, 
    parent_lesson_id,
    video_url,
    content_file_path,
    objectives_file_path,
    content_type,
    estimated_time
) 
SELECT 15, 'Reading: Active Listening Fundamentals', 3, 'reading', 1, 1, NULL, NULL, 
       '/content/active_listening.txt', NULL, 'reading', 15
WHERE NOT EXISTS (SELECT 1 FROM lessons WHERE id = 15);

-- Step 6: If lesson 15 exists but missing content paths, update it
UPDATE lessons 
SET 
    content_file_path = '/content/active_listening.txt',
    content_type = 'reading',
    estimated_time = 15,
    type = 'reading'
WHERE id = 15 AND (content_file_path IS NULL OR content_file_path = '');

-- Step 7: Verify the fix
SELECT id, title, lesson_order, type, content_file_path, content_type, estimated_time 
FROM lessons 
WHERE id = 15;

-- Step 8: Check all lessons again to see the complete structure
SELECT id, title, lesson_order, type, content_file_path, content_type 
FROM lessons 
WHERE course_id = 1 
ORDER BY lesson_order;
