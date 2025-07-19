-- Check Database Structure First
-- Run this to see what tables exist

-- Check if users table exists
SHOW TABLES LIKE 'users';
DESCRIBE users;

-- Check if lessons table exists  
SHOW TABLES LIKE 'lessons';
DESCRIBE lessons;

-- Check if lesson_ratings already exists
SHOW TABLES LIKE 'lesson_ratings';

-- Check current user ID 3 exists
SELECT id, full_name FROM users WHERE id = 3 LIMIT 1;

-- Check lesson 5 exists
SELECT id, title FROM lessons WHERE id = 5 LIMIT 1; 