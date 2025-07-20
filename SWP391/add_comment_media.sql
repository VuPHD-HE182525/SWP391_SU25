-- Add media support to lesson_comments table
ALTER TABLE lesson_comments 
ADD COLUMN media_type VARCHAR(20) DEFAULT NULL COMMENT 'image, video, or null',
ADD COLUMN media_path VARCHAR(500) DEFAULT NULL COMMENT 'Path to uploaded media file',
ADD COLUMN media_filename VARCHAR(255) DEFAULT NULL COMMENT 'Original filename';

-- Add index for better performance
CREATE INDEX idx_lesson_comments_media ON lesson_comments(lesson_id, media_type);

-- Sample data for testing
INSERT INTO lesson_comments (lesson_id, user_id, comment_text, created_at, media_type, media_path, media_filename) 
VALUES 
(1, 1, 'Great lesson with image!', NOW(), 'image', '/uploads/comments/image_1_20250714.jpg', 'screenshot.png'),
(1, 1, 'Video explanation here', NOW(), 'video', '/uploads/comments/video_1_20250714.mp4', 'explanation.mp4'); 