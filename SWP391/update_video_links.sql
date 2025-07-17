-- This script updates the video URLs for lessons in different courses.
-- It assumes a specific mapping between lesson titles and video files.
-- Please back up your database before running this script.

-- Course: Introduction to Programing (Assuming course_id = 1)
UPDATE lessons SET video_url = '/uploads/videos/java 1.mp4' WHERE course_id = 1 AND title = 'Lesson 1: Introduction to Java';
UPDATE lessons SET video_url = '/uploads/videos/java 2.mp4' WHERE course_id = 1 AND title = 'Lesson 2: Variables and Data Types';

-- Course: Introduction to AI (Assuming course_id = 2)
UPDATE lessons SET video_url = '/uploads/videos/AI 1.mp4' WHERE course_id = 2 AND title = 'Lesson 1: What is AI?';
UPDATE lessons SET video_url = '/uploads/videos/AI 2.mp4' WHERE course_id = 2 AND title = 'Lesson 2: Machine Learning Fundamentals';
UPDATE lessons SET video_url = '/uploads/videos/AI 3.mp4' WHERE course_id = 2 AND title = 'Lesson 3: Neural Networks';
UPDATE lessons SET video_url = '/uploads/videos/AI 4.mp4' WHERE course_id = 2 AND title = 'Lesson 4: Deep Learning';
UPDATE lessons SET video_url = '/uploads/videos/AI in Early Childhood.mp4' WHERE course_id = 2 AND title = 'Lesson 5: AI Applications';

-- Course: Basic English (Assuming course_id = 3)
UPDATE lessons SET video_url = '/uploads/videos/English Lesson 1 -  Hello. What''s your name_ _ English with cartoons and songs from Gogo.mp4' WHERE course_id = 3 AND title = 'Lesson 1: Greetings';

-- Course: Principle of Engineering (Assuming course_id = 4)
UPDATE lessons SET video_url = '/uploads/videos/Understanding Engineering Drawings.mp4' WHERE course_id = 4 AND title = 'Lesson 1: Introduction to Engineering Drawings';

-- Note: You may need to adjust the course_id values if they are different in your database.
-- You can find the correct course_id by running: SELECT id, title FROM courses; 