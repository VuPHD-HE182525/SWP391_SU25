-- Create Quiz for Lesson 29 (First Video)
-- This will create a demo quiz for the first video lesson

-- First check if lesson 29 exists and what it is
SELECT id, title, type, video_url FROM lessons WHERE id = 29;

-- Check if quiz already exists for lesson 29
SELECT * FROM quizzes WHERE lesson_id = 29;

-- If quiz doesn't exist, create it
INSERT IGNORE INTO quizzes (lesson_id, title, description) VALUES
(29, 'Quiz: Lesson đầu tiên', 'Kiểm tra hiểu biết về nội dung video đầu tiên');

-- Get the quiz ID
SET @quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1);

-- Add questions for the quiz
INSERT IGNORE INTO questions (quiz_id, content) VALUES 
(@quiz_id, 'Lắng nghe chủ động là gì?'),
(@quiz_id, 'Tại sao lắng nghe chủ động quan trọng trong giao tiếp?'),
(@quiz_id, 'Kỹ thuật nào sau đây KHÔNG phải là kỹ thuật lắng nghe chủ động?'),
(@quiz_id, 'Khi lắng nghe chủ động, bạn nên làm gì?'),
(@quiz_id, 'Rào cản nào thường gặp nhất trong lắng nghe chủ động?');

-- Get question IDs
SET @q1_id = (SELECT id FROM questions WHERE quiz_id = @quiz_id AND content LIKE 'Lắng nghe chủ động là gì%' LIMIT 1);
SET @q2_id = (SELECT id FROM questions WHERE quiz_id = @quiz_id AND content LIKE 'Tại sao lắng nghe chủ động%' LIMIT 1);
SET @q3_id = (SELECT id FROM questions WHERE quiz_id = @quiz_id AND content LIKE 'Kỹ thuật nào sau đây KHÔNG%' LIMIT 1);
SET @q4_id = (SELECT id FROM questions WHERE quiz_id = @quiz_id AND content LIKE 'Khi lắng nghe chủ động%' LIMIT 1);
SET @q5_id = (SELECT id FROM questions WHERE quiz_id = @quiz_id AND content LIKE 'Rào cản nào thường gặp%' LIMIT 1);

-- Add answers for Question 1: Lắng nghe chủ động là gì?
INSERT IGNORE INTO answers (question_id, content, is_correct) VALUES 
(@q1_id, 'Chỉ nghe mà không phản hồi', 0),
(@q1_id, 'Tập trung hoàn toàn vào người nói và hiểu thông điệp của họ', 1),
(@q1_id, 'Nghe và chuẩn bị câu trả lời trong đầu', 0),
(@q1_id, 'Nghe một cách thụ động', 0);

-- Add answers for Question 2: Tại sao lắng nghe chủ động quan trọng?
INSERT IGNORE INTO answers (question_id, content, is_correct) VALUES 
(@q2_id, 'Giúp tiết kiệm thời gian', 0),
(@q2_id, 'Tạo mối quan hệ tốt và hiểu biết lẫn nhau', 1),
(@q2_id, 'Để tránh xung đột', 0),
(@q2_id, 'Để thể hiện sự lịch sự', 0);

-- Add answers for Question 3: Kỹ thuật KHÔNG phải lắng nghe chủ động
INSERT IGNORE INTO answers (question_id, content, is_correct) VALUES 
(@q3_id, 'Paraphrasing (diễn giải lại)', 0),
(@q3_id, 'Đặt câu hỏi làm rõ', 0),
(@q3_id, 'Suy nghĩ về câu trả lời trong khi người khác nói', 1),
(@q3_id, 'Phản ánh cảm xúc', 0);

-- Add answers for Question 4: Khi lắng nghe chủ động, bạn nên làm gì?
INSERT IGNORE INTO answers (question_id, content, is_correct) VALUES 
(@q4_id, 'Tập trung vào điện thoại', 0),
(@q4_id, 'Duy trì giao tiếp bằng mắt và ngôn ngữ cơ thể tích cực', 1),
(@q4_id, 'Ngắt lời để đưa ra ý kiến', 0),
(@q4_id, 'Suy nghĩ về việc khác', 0);

-- Add answers for Question 5: Rào cản thường gặp nhất
INSERT IGNORE INTO answers (question_id, content, is_correct) VALUES 
(@q5_id, 'Thiếu thời gian', 0),
(@q5_id, 'Định kiến và suy nghĩ trước về người nói', 1),
(@q5_id, 'Không biết ngôn ngữ', 0),
(@q5_id, 'Môi trường quá ồn', 0);

-- Verify the quiz was created successfully
SELECT 'Quiz created successfully!' as status;

-- Show quiz details
SELECT q.id, q.lesson_id, q.title, q.description,
       (SELECT COUNT(*) FROM questions WHERE quiz_id = q.id) as question_count,
       (SELECT COUNT(*) FROM answers a JOIN questions qu ON a.question_id = qu.id WHERE qu.quiz_id = q.id) as answer_count
FROM quizzes q
WHERE q.lesson_id = 29;

-- Show all questions and answers
SELECT 
    q.content as question,
    a.content as answer,
    a.is_correct
FROM questions q
JOIN answers a ON q.id = a.question_id
WHERE q.quiz_id = @quiz_id
ORDER BY q.id, a.id;
