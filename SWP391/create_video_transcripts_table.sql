-- Create video_transcripts table to store AI-generated video analysis
CREATE TABLE IF NOT EXISTS video_transcripts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT NOT NULL,
    video_path VARCHAR(500) NOT NULL,
    transcript TEXT NOT NULL,
    key_topics TEXT,
    learning_objectives TEXT,
    timestamps JSON,
    summary TEXT,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    file_size BIGINT,
    duration_seconds INT,
    status ENUM('pending', 'processing', 'completed', 'failed') DEFAULT 'pending',
    error_message TEXT,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    INDEX idx_lesson_id (lesson_id),
    INDEX idx_status (status),
    INDEX idx_processed_at (processed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add some sample data for existing lessons
INSERT INTO video_transcripts (lesson_id, video_path, transcript, key_topics, learning_objectives, summary, status) VALUES
(5, '/video/AI 1.mp4', 
'This lesson introduces the fundamentals of Artificial Intelligence. We explore what AI is, its applications in modern technology, machine learning basics, and how AI is transforming various industries.',
'Introduction to AI, Machine Learning, AI Applications, Technology Transformation',
'Understand what AI is, Learn about AI applications, Explore machine learning concepts, Recognize AI impact on society',
'A comprehensive introduction to Artificial Intelligence covering basic concepts, applications, and societal impact.',
'completed'),

(10, '/video/java 2.mp4',
'This lesson covers Java variables and data types. We learn about primitive data types like int, double, boolean, and String. The lesson explains variable declaration, initialization, naming conventions, and scope.',
'Java Variables, Data Types, Primitive Types, Variable Declaration, Scope, Naming Conventions',
'Learn Java variable syntax, Understand different data types, Master variable declaration, Apply naming conventions, Understand variable scope',
'Complete guide to Java variables covering data types, declaration syntax, and best practices for variable usage.',
'completed');

-- Show the created table structure
DESCRIBE video_transcripts; 