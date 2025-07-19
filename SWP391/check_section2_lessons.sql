-- Check all lessons for the current subject (Java for Beginners = subjectId 1)
SELECT id, name, type, videoLink, orderIndex, subjectId 
FROM Lesson 
WHERE subjectId = 1 
ORDER BY orderIndex;

-- Check if any lessons have type = 'reading' 
SELECT id, name, type, videoLink 
FROM Lesson 
WHERE type = 'reading';

-- Check all lesson types that exist
SELECT DISTINCT type, COUNT(*) as count
FROM Lesson 
GROUP BY type;

-- Check the lesson structure
DESCRIBE Lesson; 