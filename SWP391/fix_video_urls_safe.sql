-- Method 1: Disable safe update mode temporarily
SET SQL_SAFE_UPDATES = 0;

-- Fix video URLs in lessons table to match actual files in uploads/videos/
UPDATE lessons SET video_url = CASE 
    WHEN video_url = 'video1.mp4' THEN 'lesson1.mp4'
    WHEN video_url = 'video2.mp4' THEN 'lesson2.mp4' 
    WHEN video_url = 'video3.mp4' THEN 'lesson3.mp4'
    WHEN video_url = 'video4.mp4' THEN 'lesson4.mp4'
    ELSE video_url 
END;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

-- Check the results
SELECT id, title, video_url FROM lessons; 