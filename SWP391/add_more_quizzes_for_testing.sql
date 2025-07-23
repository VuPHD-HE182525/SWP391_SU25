-- Add more quizzes for testing the quiz system
-- This will help users see quiz buttons in more lessons

-- Add quiz for lesson 2
INSERT INTO quizzes (lesson_id, title, description) VALUES 
(2, 'Quiz Giao tiếp 2', 'Kiểm tra kỹ năng nói để người khác nghe');

-- Add quiz for lesson 4  
INSERT INTO quizzes (lesson_id, title, description) VALUES 
(4, 'Quiz Xung đột', 'Kiểm tra kỹ năng giải quyết xung đột');

-- Add quiz for lesson 5 (if exists)
INSERT INTO quizzes (lesson_id, title, description) VALUES 
(5, 'Quiz Tổng hợp', 'Kiểm tra tổng hợp các kỹ năng đã học');

-- Add questions for Quiz 3 (lesson 2)
INSERT INTO questions (quiz_id, content) VALUES 
(3, 'Khi nói chuyện với người khác, điều quan trọng nhất là gì?'),
(3, 'Làm thế nào để thu hút sự chú ý của người nghe?'),
(3, 'Tại sao cần phải lắng nghe phản hồi từ người nghe?');

-- Add answers for Quiz 3 questions
INSERT INTO answers (question_id, content, is_correct) VALUES 
-- Question 1 answers
(5, 'Nói to và rõ ràng', 0),
(5, 'Hiểu được nhu cầu và quan điểm của người nghe', 1),
(5, 'Sử dụng nhiều từ ngữ phức tạp', 0),
(5, 'Nói nhanh để tiết kiệm thời gian', 0),

-- Question 2 answers  
(6, 'Sử dụng ngôn ngữ cơ thể phù hợp', 1),
(6, 'Nói liên tục không ngừng', 0),
(6, 'Tránh giao tiếp bằng mắt', 0),
(6, 'Chỉ tập trung vào nội dung', 0),

-- Question 3 answers
(7, 'Để biết mình nói đúng hay sai', 1),
(7, 'Để tránh im lặng khó chịu', 0),
(7, 'Để có thể tranh luận', 0),
(7, 'Để kết thúc cuộc trò chuyện sớm', 0);

-- Add questions for Quiz 4 (lesson 4)
INSERT INTO questions (quiz_id, content) VALUES 
(4, 'Bước đầu tiên trong giải quyết xung đột là gì?'),
(4, 'Khi nào nên sử dụng phương pháp hòa giải?'),
(4, 'Điều quan trọng nhất khi đối mặt với xung đột là gì?');

-- Add answers for Quiz 4 questions
INSERT INTO answers (question_id, content, is_correct) VALUES 
-- Question 1 answers (quiz 4)
(8, 'Xác định nguyên nhân gốc rễ của xung đột', 1),
(8, 'Chỉ trích người gây ra xung đột', 0),
(8, 'Tránh né vấn đề', 0),
(8, 'Tìm người có thẩm quyền can thiệp ngay', 0),

-- Question 2 answers
(9, 'Khi cả hai bên đều sẵn sàng tìm giải pháp', 1),
(9, 'Khi một bên đã thắng', 0),
(9, 'Khi xung đột quá nghiêm trọng', 0),
(9, 'Khi có nhiều người chứng kiến', 0),

-- Question 3 answers  
(10, 'Giữ bình tĩnh và khách quan', 1),
(10, 'Chứng minh mình đúng', 0),
(10, 'Tránh giao tiếp trực tiếp', 0),
(10, 'Tìm người ủng hộ mình', 0);

-- Check if quizzes were added successfully
SELECT 'Quiz Summary:' as info;
SELECT q.id, q.lesson_id, q.title, q.description, 
       (SELECT COUNT(*) FROM questions WHERE quiz_id = q.id) as question_count
FROM quizzes q 
ORDER BY q.id; 