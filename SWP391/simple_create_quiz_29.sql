-- Simple script to create quiz for lesson 29
-- Run this in your MySQL database

-- Check if lesson 29 exists
SELECT id, title, type FROM lessons WHERE id = 29;

-- Create quiz for lesson 29
INSERT INTO quizzes (lesson_id, title, description) VALUES 
(29, 'Quiz: Video đầu tiên', 'Kiểm tra hiểu biết về nội dung video đầu tiên');

-- Add questions
INSERT INTO questions (quiz_id, content) VALUES 
((SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1), 'Điều quan trọng nhất trong giao tiếp là gì?'),
((SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1), 'Kỹ năng nào giúp cải thiện giao tiếp hiệu quả?'),
((SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1), 'Tại sao cần lắng nghe trong giao tiếp?'),
((SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1), 'Cách thể hiện sự quan tâm khi giao tiếp?'),
((SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1), 'Yếu tố nào ảnh hưởng đến chất lượng giao tiếp?');

-- Add answers for question 1
INSERT INTO answers (question_id, content, is_correct) VALUES 
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Điều quan trọng nhất%' LIMIT 1), 'Nói to và rõ ràng', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Điều quan trọng nhất%' LIMIT 1), 'Hiểu và lắng nghe người khác', 1),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Điều quan trọng nhất%' LIMIT 1), 'Sử dụng từ ngữ phức tạp', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Điều quan trọng nhất%' LIMIT 1), 'Nói nhanh để tiết kiệm thời gian', 0);

-- Add answers for question 2
INSERT INTO answers (question_id, content, is_correct) VALUES 
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Kỹ năng nào giúp%' LIMIT 1), 'Lắng nghe chủ động', 1),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Kỹ năng nào giúp%' LIMIT 1), 'Nói liên tục không ngừng', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Kỹ năng nào giúp%' LIMIT 1), 'Tránh giao tiếp bằng mắt', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Kỹ năng nào giúp%' LIMIT 1), 'Chỉ quan tâm đến bản thân', 0);

-- Add answers for question 3
INSERT INTO answers (question_id, content, is_correct) VALUES 
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Tại sao cần lắng nghe%' LIMIT 1), 'Để hiểu quan điểm và cảm xúc của người khác', 1),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Tại sao cần lắng nghe%' LIMIT 1), 'Để tỏ ra lịch sự', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Tại sao cần lắng nghe%' LIMIT 1), 'Để có thời gian suy nghĩ câu trả lời', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Tại sao cần lắng nghe%' LIMIT 1), 'Để tránh xung đột', 0);

-- Add answers for question 4
INSERT INTO answers (question_id, content, is_correct) VALUES 
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Cách thể hiện sự quan tâm%' LIMIT 1), 'Giao tiếp bằng mắt và gật đầu', 1),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Cách thể hiện sự quan tâm%' LIMIT 1), 'Nhìn vào điện thoại', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Cách thể hiện sự quan tâm%' LIMIT 1), 'Ngắt lời liên tục', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Cách thể hiện sự quan tâm%' LIMIT 1), 'Suy nghĩ về việc khác', 0);

-- Add answers for question 5
INSERT INTO answers (question_id, content, is_correct) VALUES 
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Yếu tố nào ảnh hưởng%' LIMIT 1), 'Môi trường và thái độ của người tham gia', 1),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Yếu tố nào ảnh hưởng%' LIMIT 1), 'Chỉ có ngôn ngữ nói', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Yếu tố nào ảnh hưởng%' LIMIT 1), 'Chỉ có thời gian', 0),
((SELECT id FROM questions WHERE quiz_id = (SELECT id FROM quizzes WHERE lesson_id = 29 LIMIT 1) AND content LIKE 'Yếu tố nào ảnh hưởng%' LIMIT 1), 'Chỉ có địa điểm', 0);

-- Check results
SELECT 'Quiz created successfully for lesson 29!' as status;
SELECT q.id, q.lesson_id, q.title, 
       (SELECT COUNT(*) FROM questions WHERE quiz_id = q.id) as question_count
FROM quizzes q WHERE q.lesson_id = 29;
