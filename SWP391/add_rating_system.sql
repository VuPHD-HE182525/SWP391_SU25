-- Rating System for Lessons
-- This script adds the ability for users to rate lessons with stars (1-5)

-- Create lesson_ratings table
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
    INDEX idx_rating (rating),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add rating summary columns to lessons table (optional - for caching)
ALTER TABLE lessons 
ADD COLUMN average_rating DECIMAL(3,2) DEFAULT 0.00,
ADD COLUMN total_ratings INT DEFAULT 0,
ADD COLUMN rating_updated_at TIMESTAMP NULL;

-- Create view for lesson ratings with user info
CREATE OR REPLACE VIEW lesson_ratings_view AS
SELECT 
    lr.id,
    lr.lesson_id,
    lr.user_id,
    lr.rating,
    lr.review_text,
    lr.created_at,
    lr.updated_at,
    u.full_name as user_name,
    u.avatar_url as user_avatar,
    l.title as lesson_title
FROM lesson_ratings lr
LEFT JOIN users u ON lr.user_id = u.id
LEFT JOIN lessons l ON lr.lesson_id = l.id
ORDER BY lr.created_at DESC;

-- Function to update lesson rating summary (MySQL procedure)
DELIMITER //
CREATE PROCEDURE UpdateLessonRatingSummary(IN lesson_id_param INT)
BEGIN
    DECLARE avg_rating DECIMAL(3,2);
    DECLARE total_count INT;
    
    SELECT AVG(rating), COUNT(*) 
    INTO avg_rating, total_count
    FROM lesson_ratings 
    WHERE lesson_id = lesson_id_param;
    
    UPDATE lessons 
    SET average_rating = IFNULL(avg_rating, 0.00),
        total_ratings = IFNULL(total_count, 0),
        rating_updated_at = CURRENT_TIMESTAMP
    WHERE id = lesson_id_param;
END //
DELIMITER ;

-- Trigger to auto-update rating summary when rating is inserted/updated/deleted
DELIMITER //
CREATE TRIGGER rating_after_insert
AFTER INSERT ON lesson_ratings
FOR EACH ROW
BEGIN
    CALL UpdateLessonRatingSummary(NEW.lesson_id);
END //

CREATE TRIGGER rating_after_update
AFTER UPDATE ON lesson_ratings
FOR EACH ROW
BEGIN
    CALL UpdateLessonRatingSummary(NEW.lesson_id);
END //

CREATE TRIGGER rating_after_delete
AFTER DELETE ON lesson_ratings
FOR EACH ROW
BEGIN
    CALL UpdateLessonRatingSummary(OLD.lesson_id);
END //
DELIMITER ;

-- Insert some sample ratings for testing
INSERT INTO lesson_ratings (user_id, lesson_id, rating, review_text) VALUES
(3, 5, 5, 'Excellent introduction to AI! Very clear explanations and good examples.'),
(3, 1, 4, 'Good content but could use more practical examples.'),
(3, 2, 5, 'Perfect lesson for beginners. Well structured and easy to follow.');

-- Update rating summaries for existing lessons
CALL UpdateLessonRatingSummary(1);
CALL UpdateLessonRatingSummary(2);
CALL UpdateLessonRatingSummary(5);

-- Query examples:

-- Get average rating for a specific lesson
-- SELECT average_rating, total_ratings FROM lessons WHERE id = 5;

-- Get all ratings for a lesson with user details
-- SELECT * FROM lesson_ratings_view WHERE lesson_id = 5;

-- Get user's rating for a specific lesson
-- SELECT rating, review_text FROM lesson_ratings WHERE user_id = 3 AND lesson_id = 5;

-- Get top rated lessons
-- SELECT id, title, average_rating, total_ratings 
-- FROM lessons 
-- WHERE total_ratings > 0 
-- ORDER BY average_rating DESC, total_ratings DESC 
-- LIMIT 10;

-- Get lessons with ratings breakdown
-- SELECT 
--     l.id,
--     l.title,
--     l.average_rating,
--     l.total_ratings,
--     COUNT(CASE WHEN lr.rating = 5 THEN 1 END) as five_stars,
--     COUNT(CASE WHEN lr.rating = 4 THEN 1 END) as four_stars,
--     COUNT(CASE WHEN lr.rating = 3 THEN 1 END) as three_stars,
--     COUNT(CASE WHEN lr.rating = 2 THEN 1 END) as two_stars,
--     COUNT(CASE WHEN lr.rating = 1 THEN 1 END) as one_star
-- FROM lessons l
-- LEFT JOIN lesson_ratings lr ON l.id = lr.lesson_id
-- WHERE l.id = 5
-- GROUP BY l.id; 