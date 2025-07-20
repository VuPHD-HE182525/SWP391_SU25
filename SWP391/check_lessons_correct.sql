-- Check all lessons for current course (Java for Beginners = course_id 1)
SELECT id, title, type, video_url, lesson_order, course_id, content_type
FROM Lessons 
WHERE course_id = 1 
ORDER BY lesson_order;

-- Check all lesson types that exist  
SELECT DISTINCT type, COUNT(*) as count
FROM Lessons 
GROUP BY type;

-- Check content types
SELECT DISTINCT content_type, COUNT(*) as count
FROM Lessons 
GROUP BY content_type;

-- Check lessons with content files (potential reading lessons)
SELECT id, title, type, content_file_path, objectives_file_path, references_file_path
FROM Lessons 
WHERE content_file_path IS NOT NULL 
   OR objectives_file_path IS NOT NULL 
   OR references_file_path IS NOT NULL; 