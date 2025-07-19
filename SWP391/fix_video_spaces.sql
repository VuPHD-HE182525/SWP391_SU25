-- Fix video URLs that have spaces which might cause issues
UPDATE lessons SET video_url = '/video/AI_1.mp4' WHERE id = 5;
UPDATE lessons SET video_url = '/video/java_2.mp4' WHERE id = 10;

-- Alternative: Try without /video/ prefix to match JSP logic
UPDATE lessons SET video_url = 'AI 1.mp4' WHERE id = 5;
UPDATE lessons SET video_url = 'java 2.mp4' WHERE id = 10;

-- Check the results
SELECT id, title, video_url FROM lessons WHERE id IN (5, 10); 