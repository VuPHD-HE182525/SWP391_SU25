-- Fix video links for lessons to match transcript data
-- Update lesson 5 (AI lesson) with proper video link
UPDATE lessons 
SET video_url = '/video/AI 1.mp4'
WHERE id = 5;

-- Update lesson 10 (Java lesson) with proper video link  
UPDATE lessons 
SET video_url = '/video/java 2.mp4'
WHERE id = 10;

-- Alternative: Update using title column if video_url doesn't exist
-- UPDATE lessons 
-- SET title = CASE 
--     WHEN id = 5 THEN 'Lesson 1: What is AI?'
--     WHEN id = 10 THEN 'Lesson 2: Variables and Data Types'
--     ELSE title
-- END
-- WHERE id IN (5, 10);

-- Check the results
SELECT id, title, video_url, course_id, status 
FROM lessons 
WHERE id IN (5, 10);

-- Also check if we need to add missing lessons
-- SELECT * FROM lessons WHERE course_id = 1 ORDER BY id; 