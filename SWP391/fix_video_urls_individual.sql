-- Method 2: Individual updates using WHERE with KEY column (safer)

-- Update each video individually using the primary key
UPDATE lessons SET video_url = 'lesson1.mp4' WHERE id = 1 AND video_url = 'video1.mp4';
UPDATE lessons SET video_url = 'lesson2.mp4' WHERE id = 2 AND video_url = 'video2.mp4';
UPDATE lessons SET video_url = 'lesson3.mp4' WHERE id = 3 AND video_url = 'video3.mp4';
UPDATE lessons SET video_url = 'lesson4.mp4' WHERE id = 4 AND video_url = 'video4.mp4';

-- Check the results
SELECT id, title, video_url FROM lessons; 