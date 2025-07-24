-- Fix Reading Lesson Navigation Issue
-- Add reading lesson and update existing lessons structure

-- Step 1: Check current lessons structure
SELECT 'Current lessons before fix:' as status;
SELECT id, title, lesson_order, type, course_id FROM lessons WHERE course_id = 1 ORDER BY lesson_order;

-- Step 2: Add columns for reading content if not exists
ALTER TABLE lessons 
ADD COLUMN IF NOT EXISTS content_file_path VARCHAR(255) COMMENT 'Path to reading content file',
ADD COLUMN IF NOT EXISTS objectives_file_path VARCHAR(255) COMMENT 'Path to learning objectives file', 
ADD COLUMN IF NOT EXISTS references_file_path VARCHAR(255) COMMENT 'Path to references file',
ADD COLUMN IF NOT EXISTS content_type ENUM('video', 'reading', 'mixed') DEFAULT 'video' COMMENT 'Type of lesson content',
ADD COLUMN IF NOT EXISTS estimated_time INT DEFAULT 0 COMMENT 'Estimated time in minutes',
ADD COLUMN IF NOT EXISTS content_text TEXT COMMENT 'Reading content text';

-- Step 3: Insert reading lesson with proper order
INSERT INTO lessons (
    course_id, 
    title, 
    video_url, 
    lesson_order, 
    status, 
    type, 
    parent_lesson_id,
    content_file_path,
    content_type,
    estimated_time,
    content_text
) VALUES (
    1, 
    'Reading: Active Listening Fundamentals', 
    NULL, 
    3, 
    1, 
    'reading', 
    NULL,
    '/content/active_listening.html',
    'reading',
    15,
    '<h2>Active Listening Fundamentals</h2>
<p>Active listening is a crucial skill in effective communication. It involves fully concentrating, understanding, responding, and remembering what is being said.</p>

<h3>Key Components of Active Listening</h3>
<ul>
    <li><strong>Give Full Attention:</strong> Focus completely on the speaker without distractions</li>
    <li><strong>Show That You are Listening:</strong> Use body language and verbal cues to demonstrate engagement</li>
    <li><strong>Provide Feedback:</strong> Reflect on what you have heard to ensure understanding</li>
    <li><strong>Defer Judgment:</strong> Allow the speaker to finish before forming opinions</li>
    <li><strong>Respond Appropriately:</strong> Give thoughtful responses that show comprehension</li>
</ul>

<h3>Barriers to Active Listening</h3>
<ul>
    <li>Distractions and noise</li>
    <li>Preconceived notions</li>
    <li>Emotional reactions</li>
    <li>Information overload</li>
</ul>

<h3>Techniques for Better Listening</h3>
<ul>
    <li>Maintain eye contact</li>
    <li>Ask clarifying questions</li>
    <li>Summarize what you heard</li>
    <li>Avoid interrupting</li>
    <li>Show empathy and understanding</li>
</ul>'
);

-- Step 4: Update lesson orders for existing lessons to make room
UPDATE lessons SET lesson_order = lesson_order + 1 
WHERE course_id = 1 AND lesson_order >= 3 AND type = 'video' AND id != LAST_INSERT_ID();

-- Step 5: Update existing lessons to have proper content_type
UPDATE lessons SET content_type = 'video' WHERE type = 'video' AND content_type IS NULL;
UPDATE lessons SET content_type = 'reading' WHERE type = 'reading' AND content_type IS NULL;

-- Step 6: Verify the fix
SELECT 'Lessons after fix:' as status;
SELECT id, title, lesson_order, type, content_type, estimated_time 
FROM lessons 
WHERE course_id = 1 
ORDER BY lesson_order;

-- Step 7: Get the new reading lesson ID for updating JSP
SELECT CONCAT('New reading lesson ID: ', id) as reading_lesson_info
FROM lessons 
WHERE course_id = 1 AND type = 'reading' AND title LIKE '%Active Listening%'
LIMIT 1; 