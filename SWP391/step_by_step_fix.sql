-- Step-by-Step Manual Fix
-- Copy and run each section separately

-- STEP 1: Drop existing table if it has issues
-- DROP TABLE IF EXISTS lesson_ratings;

-- STEP 2: Create table (run this first)
CREATE TABLE lesson_ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    rating INT NOT NULL,
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- STEP 3: Add indexes (run after table creation)
ALTER TABLE lesson_ratings ADD INDEX idx_lesson_id (lesson_id);
ALTER TABLE lesson_ratings ADD INDEX idx_user_id (user_id);
ALTER TABLE lesson_ratings ADD UNIQUE KEY unique_user_lesson (user_id, lesson_id);

-- STEP 4: Add sample data (run after indexes)
INSERT INTO lesson_ratings (user_id, lesson_id, rating, review_text) VALUES
(3, 5, 5, 'Excellent introduction to AI! Very clear explanations and good examples.');

-- STEP 5: Test if it works
SELECT * FROM lesson_ratings; 