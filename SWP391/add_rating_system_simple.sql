-- Simple Rating System for Lessons (No Triggers/Procedures)
-- Run this step by step to avoid conflicts

-- Step 1: Create lesson_ratings table
CREATE TABLE IF NOT EXISTS lesson_ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Ensure one rating per user per lesson
    UNIQUE KEY unique_user_lesson (user_id, lesson_id),
    
    -- Foreign keys
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    
    -- Indexes for performance
    INDEX idx_lesson_id (lesson_id),
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Step 2: Add sample data for testing
INSERT IGNORE INTO lesson_ratings (user_id, lesson_id, rating, review_text) VALUES
(3, 5, 5, 'Excellent introduction to AI! Very clear explanations and good examples.'),
(3, 1, 4, 'Good content but could use more practical examples.'),
(3, 2, 5, 'Perfect lesson for beginners. Well structured and easy to follow.');

-- Step 3: Check if it worked
SELECT 'lesson_ratings table created successfully' as status;
SELECT COUNT(*) as total_ratings FROM lesson_ratings;
SELECT * FROM lesson_ratings LIMIT 5; 