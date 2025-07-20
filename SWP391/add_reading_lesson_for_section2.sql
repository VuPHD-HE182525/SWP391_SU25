-- Add a reading lesson for Section 2: Advanced Topics
INSERT INTO Lesson (
    id, 
    name, 
    type, 
    videoLink, 
    contentFilePath,
    learningObjectives,
    references,
    estimatedTime,
    orderIndex,
    subjectId,
    isActive
) VALUES (
    999, -- temporary ID, adjust based on your auto-increment
    'Active Listening Fundamentals',
    'reading', 
    NULL, -- no video for reading lesson
    '/content/active_listening.txt', -- path to content file
    'Understand active listening principles and techniques',
    'The Lost Art of Listening by Michael P. Nichols; Harvard Business Review articles',
    15, -- 15 minutes reading time
    3, -- order after the 2 video lessons
    1, -- subject ID (Java for Beginners)
    1 -- active
);

-- Check what lessons exist
SELECT id, name, type, videoLink, orderIndex, subjectId 
FROM Lesson 
WHERE subjectId = 1 
ORDER BY orderIndex; 