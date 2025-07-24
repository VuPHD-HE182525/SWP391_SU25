-- Fix lessons table - Add content_text column
-- Check current structure first
DESCRIBE lessons;

-- Add content_text column if it doesn't exist
ALTER TABLE lessons 
ADD COLUMN content_text LONGTEXT NULL 
COMMENT 'HTML content for reading lessons';

-- Verify the structure after adding
DESCRIBE lessons;

-- Show current lessons count
SELECT COUNT(*) as total_lessons FROM lessons;

-- Show lessons structure with new column
SELECT 'Lessons table updated successfully!' as status; 