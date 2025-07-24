-- Add Reading Lessons Demo for Section 2
-- This script adds interactive reading lessons to demonstrate the functionality

-- First, check current lessons structure
SELECT 'Current lessons before adding reading demos:' as status;
SELECT id, title, lesson_order, type, content_type, estimated_time FROM lessons WHERE course_id = 1 ORDER BY lesson_order;

-- Add reading lesson 1: Active Listening Fundamentals
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

<h3>Benefits of Active Listening</h3>
<p>Active listening helps build trust, reduces conflicts, and improves relationships. It is essential in professional settings, personal relationships, and educational environments.</p>

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
</ol>

<h3>Common Barriers to Active Listening</h3>
<ul>
    <li><strong>Distractions:</strong> Phone, noise, multitasking</li>
    <li><strong>Prejudgment:</strong> Forming opinions before hearing the full message</li>
    <li><strong>Emotional Reactions:</strong> Getting defensive or upset</li>
    <li><strong>Mental Preparation:</strong> Thinking about your response instead of listening</li>
</ul>

<h3>Techniques for Better Listening</h3>
<ul>
    <li><strong>Paraphrasing:</strong> "What I hear you saying is..."</li>
    <li><strong>Asking Questions:</strong> "Can you help me understand..."</li>
    <li><strong>Summarizing:</strong> "Let me make sure I understand the main points..."</li>
    <li><strong>Reflecting Feelings:</strong> "It sounds like you''re feeling..."</li>
</ul>'
);

-- Add reading lesson 2: Communication Skills
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
    'Reading: Effective Communication Skills', 
    NULL, 
    4, 
    1, 
    'reading', 
    NULL,
    '/content/communication_skills.html',
    'reading',
    20,
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
    <p class="text-green-700">Communication is not just about speaking - it''s about being understood and understanding others.</p>
</div>

<h3>Verbal Communication</h3>
<p>Your words carry power. Here are tips for effective verbal communication:</p>
<ul>
    <li>Choose your words carefully</li>
    <li>Speak clearly and at an appropriate pace</li>
    <li>Use positive language</li>
    <li>Be concise and to the point</li>
    <li>Ask clarifying questions</li>
</ul>

<h3>Non-Verbal Communication</h3>
<p>Studies show that 55% of communication is body language, 38% is tone of voice, and only 7% is actual words.</p>
<ul>
    <li><strong>Body Language:</strong> Posture, gestures, facial expressions</li>
    <li><strong>Eye Contact:</strong> Shows engagement and sincerity</li>
    <li><strong>Tone of Voice:</strong> Conveys emotion and attitude</li>
    <li><strong>Personal Space:</strong> Respect cultural and individual boundaries</li>
</ul>

<h3>Digital Communication</h3>
<p>In today''s world, digital communication is essential:</p>
<ul>
    <li>Email etiquette and professionalism</li>
    <li>Video conferencing best practices</li>
    <li>Social media communication guidelines</li>
    <li>Text messaging appropriateness</li>
</ul>

<div class="bg-orange-50 p-4 rounded-lg my-4">
    <h4 class="font-semibold text-orange-800 mb-2">⚠️ Common Mistakes</h4>
    <ul class="text-orange-700">
        <li>Interrupting others while they speak</li>
        <li>Making assumptions about what others mean</li>
        <li>Using jargon or technical terms inappropriately</li>
        <li>Not considering cultural differences</li>
    </ul>
</div>'
);

-- Add reading lesson 3: Emotional Intelligence
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
    'Reading: Emotional Intelligence in Communication', 
    NULL, 
    5, 
    1, 
    'reading', 
    NULL,
    '/content/emotional_intelligence.html',
    'reading',
    18,
    '<h2>Emotional Intelligence in Communication</h2>
<p>Emotional Intelligence (EI) is the ability to understand and manage your own emotions, as well as recognize and respond appropriately to others'' emotions.</p>

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
<ul>
    <li>Think before you speak</li>
    <li>Stay calm under pressure</li>
    <li>Adapt to change positively</li>
</ul>

<h4>3. Social Awareness</h4>
<p>Understanding others'' emotions and the dynamics in your organization.</p>
<ul>
    <li>Read body language and facial expressions</li>
    <li>Listen to tone of voice</li>
    <li>Show empathy and understanding</li>
</ul>

<h4>4. Relationship Management</h4>
<p>The ability to develop and maintain good relationships.</p>
<ul>
    <li>Communicate clearly and persuasively</li>
    <li>Manage conflict effectively</li>
    <li>Work well in teams</li>
    <li>Inspire and influence others</li>
</ul>

<div class="bg-purple-50 p-4 rounded-lg my-4">
    <h4 class="font-semibold text-purple-800 mb-2">🧠 Research Insight</h4>
    <p class="text-purple-700">People with high emotional intelligence earn an average of $29,000 more per year than those with low emotional intelligence.</p>
</div>

<h3>Developing Emotional Intelligence</h3>
<p>EI can be developed through practice and conscious effort:</p>

<h4>Daily Practices:</h4>
<ul>
    <li><strong>Emotional Check-ins:</strong> Ask yourself "How am I feeling?" throughout the day</li>
    <li><strong>Pause Before Reacting:</strong> Take a breath before responding to emotional situations</li>
    <li><strong>Practice Empathy:</strong> Try to see situations from others'' perspectives</li>
    <li><strong>Seek Feedback:</strong> Ask trusted friends or colleagues about your emotional responses</li>
</ul>

<h3>EI in Different Contexts</h3>

<h4>In the Workplace:</h4>
<ul>
    <li>Better leadership and teamwork</li>
    <li>Improved customer relationships</li>
    <li>More effective conflict resolution</li>
    <li>Enhanced decision-making</li>
</ul>

<h4>In Personal Relationships:</h4>
<ul>
    <li>Deeper connections with family and friends</li>
    <li>Better conflict resolution</li>
    <li>Increased trust and intimacy</li>
    <li>More satisfying relationships</li>
</ul>

<div class="bg-red-50 p-4 rounded-lg my-4">
    <h4 class="font-semibold text-red-800 mb-2">🚫 EI Pitfalls to Avoid</h4>
    <ul class="text-red-700">
        <li>Using emotional intelligence to manipulate others</li>
        <li>Becoming overly focused on others'' emotions</li>
        <li>Ignoring logical thinking in favor of emotional responses</li>
        <li>Assuming you can read everyone''s emotions accurately</li>
    </ul>
</div>'
);

-- Update lesson orders for existing lessons to make room
UPDATE lessons SET lesson_order = lesson_order + 3 
WHERE course_id = 1 AND lesson_order >= 3 AND type = 'video' AND id NOT IN (
    SELECT id FROM (
        SELECT id FROM lessons WHERE course_id = 1 AND type = 'reading' AND title LIKE 'Reading:%'
    ) AS reading_lessons
);

-- Verify the results
SELECT 'Lessons after adding reading demos:' as status;
SELECT id, title, lesson_order, type, content_type, estimated_time 
FROM lessons 
WHERE course_id = 1 
ORDER BY lesson_order;

-- Get reading lesson IDs for reference
SELECT CONCAT('Reading lesson IDs: ', GROUP_CONCAT(id)) as reading_lesson_info
FROM lessons 
WHERE course_id = 1 AND type = 'reading' AND title LIKE 'Reading:%'; 