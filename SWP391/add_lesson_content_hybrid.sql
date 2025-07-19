-- HYBRID APPROACH: Store file paths instead of content
-- More scalable and CDN-friendly like Coursera

ALTER TABLE lessons 
ADD COLUMN content_file_path VARCHAR(255) COMMENT 'Path to HTML content file',
ADD COLUMN objectives_file_path VARCHAR(255) COMMENT 'Path to learning objectives file',
ADD COLUMN references_file_path VARCHAR(255) COMMENT 'Path to references file',
ADD COLUMN content_type ENUM('video', 'reading', 'mixed') DEFAULT 'video' COMMENT 'Type of lesson content',
ADD COLUMN estimated_time INT DEFAULT 0 COMMENT 'Estimated time in minutes',
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Update existing lessons with file paths
UPDATE lessons SET 
    content_file_path = '/uploads/texts/lessons/lesson-1-active-listening.html',
    objectives_file_path = '/uploads/texts/objectives/lesson-1-objectives.md',
    references_file_path = '/uploads/texts/references/lesson-1-refs.md',
    content_type = 'mixed',
    estimated_time = 15
WHERE id = 1;

UPDATE lessons SET 
    content_file_path = '/uploads/texts/lessons/lesson-2-effective-speaking.html',
    objectives_file_path = '/uploads/texts/objectives/lesson-2-objectives.md', 
    references_file_path = '/uploads/texts/references/lesson-2-refs.md',
    content_type = 'mixed',
    estimated_time = 20
WHERE id = 2;

SELECT 'Hybrid lesson content system ready!' AS status; 