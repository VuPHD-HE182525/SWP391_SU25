-- Add content_text column to lessons table
-- This column will store the HTML content for reading lessons

-- First, check if the column exists
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'swp391' 
  AND TABLE_NAME = 'lessons' 
  AND COLUMN_NAME = 'content_text';

-- Add the content_text column if it doesn't exist
ALTER TABLE lessons 
ADD COLUMN content_text LONGTEXT NULL 
COMMENT 'HTML content for reading lessons';

-- Verify the column was added
DESCRIBE lessons;

-- Show current lessons structure
SELECT 'Current lessons after adding content_text column:' as status;
SELECT id, title, lesson_order, type, content_type, estimated_time,
       CASE 
         WHEN content_text IS NULL THEN 'No content' 
         ELSE CONCAT('Content length: ', LENGTH(content_text), ' chars')
       END as content_status
FROM lessons 
WHERE course_id = 1 
ORDER BY lesson_order; 