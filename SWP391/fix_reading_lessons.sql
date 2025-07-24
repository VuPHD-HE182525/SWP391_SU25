-- Fix Reading Lessons - Remove duplicates and add missing ones
-- Step 1: Remove existing reading lessons to avoid duplicates
DELETE FROM lessons WHERE course_id = 1 AND type = 'reading' AND title LIKE 'Reading:%';

-- Step 2: Reset lesson orders for video lessons
UPDATE lessons SET lesson_order = 1 WHERE course_id = 1 AND id = 1; -- First video
UPDATE lessons SET lesson_order = 2 WHERE course_id = 1 AND id = 2; -- Second video

-- Step 3: Add all 3 reading lessons properly
INSERT INTO lessons (
    course_id, title, video_url, lesson_order, status, type, parent_lesson_id,
    content_file_path, content_type, estimated_time, content_text
) VALUES 
-- Reading Lesson 1: Active Listening Fundamentals
(1, 'Reading: Active Listening Fundamentals', NULL, 3, 1, 'reading', NULL,
'/content/active_listening.html', 'reading', 15,
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

<div class="bg-blue-50 p-4 rounded-lg my-4">
    <h4 class="font-semibold text-blue-800 mb-2">💡 Quick Tip</h4>
    <p class="text-blue-700">Practice the "mirror technique" - repeat back what you heard in your own words to confirm understanding.</p>
</div>

<h3>Practice Exercise</h3>
<p>Try this with a partner:</p>
<ol>
    <li>One person speaks for 2 minutes about a topic they care about</li>
    <li>The other practices active listening techniques</li>
    <li>The listener summarizes what they heard</li>
    <li>Switch roles and discuss the experience</li>
</ol>'),

-- Reading Lesson 2: Communication Skills  
(1, 'Reading: Effective Communication Skills', NULL, 4, 1, 'reading', NULL,
'/content/communication_skills.html', 'reading', 20,
'<h2>Effective Communication Skills</h2>
<p>Communication is the foundation of all human relationships. Developing strong communication skills can improve your personal and professional life significantly.</p>

<h3>The Communication Process</h3>
<p>Effective communication involves several key elements:</p>
<ul>
    <li><strong>Sender:</strong> The person initiating the communication</li>
    <li><strong>Message:</strong> The information being conveyed</li>
    <li><strong>Medium:</strong> The channel through which the message is sent</li>
    <li><strong>Receiver:</strong> The person receiving the message</li>
    <li><strong>Feedback:</strong> The response from the receiver</li>
</ul>

<div class="bg-green-50 p-4 rounded-lg my-4">
    <h4 class="font-semibold text-green-800 mb-2">🎯 Key Insight</h4>
    <p class="text-green-700">Communication is not just about speaking - it is about being understood and understanding others.</p>
</div>

<h3>Verbal vs Non-Verbal Communication</h3>
<p>Studies show that 55% of communication is body language, 38% is tone of voice, and only 7% is actual words.</p>'),

-- Reading Lesson 3: Emotional Intelligence
(1, 'Reading: Emotional Intelligence in Communication', NULL, 5, 1, 'reading', NULL,
'/content/emotional_intelligence.html', 'reading', 18,
'<h2>Emotional Intelligence in Communication</h2>
<p>Emotional Intelligence (EI) is the ability to understand and manage your own emotions, as well as recognize and respond appropriately to others emotions.</p>

<h3>The Four Components of Emotional Intelligence</h3>

<h4>1. Self-Awareness</h4>
<p>Understanding your own emotions and their impact on others.</p>
<ul>
    <li>Recognize your emotional triggers</li>
    <li>Understand your strengths and weaknesses</li>
    <li>Practice mindfulness and self-reflection</li>
</ul>

<h4>2. Self-Management</h4>
<p>The ability to control and redirect disruptive emotions and impulses.</p>

<div class="bg-purple-50 p-4 rounded-lg my-4">
    <h4 class="font-semibold text-purple-800 mb-2">🧠 Research Insight</h4>
    <p class="text-purple-700">People with high emotional intelligence earn an average of $29,000 more per year than those with low emotional intelligence.</p>
</div>');

-- Step 4: Update video lesson orders to make room
UPDATE lessons SET lesson_order = 6 
WHERE course_id = 1 AND type = 'video' AND lesson_order > 2;

-- Step 5: Verify results
SELECT 'Final lesson structure:' as status;
SELECT id, title, lesson_order, type, content_type, estimated_time 
FROM lessons 
WHERE course_id = 1 
ORDER BY lesson_order;

-- Step 6: Count reading lessons
SELECT CONCAT('Total reading lessons: ', COUNT(*)) as reading_count
FROM lessons 
WHERE course_id = 1 AND type = 'reading'; 