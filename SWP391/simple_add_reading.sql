-- Simple Add Reading Lessons
-- Since there are 0 reading lessons, we just need to add them

INSERT INTO lessons (
    course_id, title, video_url, lesson_order, status, type, 
    content_file_path, content_type, estimated_time, content_text
) VALUES 
(1, 'Reading: Active Listening Fundamentals', NULL, 3, 1, 'reading', 
 '/content/active_listening.html', 'reading', 15,
 '<h2>Active Listening Fundamentals</h2><p>Active listening is a crucial skill in effective communication.</p><h3>Key Components:</h3><ul><li><strong>Give Full Attention</strong></li><li><strong>Show Engagement</strong></li><li><strong>Provide Feedback</strong></li></ul>'),

(1, 'Reading: Communication Skills', NULL, 4, 1, 'reading',
 '/content/communication_skills.html', 'reading', 20,
 '<h2>Effective Communication Skills</h2><p>Communication is the foundation of relationships.</p><h3>Elements:</h3><ul><li><strong>Sender & Receiver</strong></li><li><strong>Message & Feedback</strong></li></ul>'),

(1, 'Reading: Emotional Intelligence', NULL, 5, 1, 'reading',
 '/content/emotional_intelligence.html', 'reading', 18,
 '<h2>Emotional Intelligence</h2><p>Understanding and managing emotions in communication.</p><h3>Components:</h3><ul><li><strong>Self-Awareness</strong></li><li><strong>Self-Management</strong></li></ul>');

-- Verify the addition
SELECT 'Reading lessons added successfully!' as status;
SELECT id, title, lesson_order, type, content_type, estimated_time 
FROM lessons 
WHERE course_id = 1 
ORDER BY lesson_order; 