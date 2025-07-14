-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: swp391
-- ------------------------------------------------------
-- Server version	8.0.42
--
-- *********************************************************************
-- ** PHIÊN BẢN TỐI ƯU HÓA **
-- ** Các thay đổi chính: **
-- ** 1. Thêm các FOREIGN KEY còn thiếu (packages.course_id, subjects.category_id).**
-- ** 2. Sử dụng DECIMAL cho giá tiền để đảm bảo tính chính xác.**
-- ** 3. Chuẩn hóa và loại bỏ các cột người dùng bị lặp trong bảng `registrations`.**
-- ** 4. Thêm các INDEX để cải thiện hiệu suất truy vấn (courses.title, users.role, etc.).**
-- ** 5. Sửa lại tên cột `lessons.subject_id` thành `course_id` cho nhất quán.**
-- ** 6. Chuẩn hóa dữ liệu không nhất quán (ví dụ: cột gender).**
-- *********************************************************************
-- Thêm trường owner_id vào bảng subjects và tạo foreign key
ALTER TABLE subjects ADD COLUMN owner_id INT DEFAULT 1;
ALTER TABLE subjects ADD CONSTRAINT fk_subject_owner FOREIGN KEY (owner_id) REFERENCES users(id);

-- Cập nhật dữ liệu owner cho từng subject (sau khi INSERT INTO subjects)
-- (Nếu bạn import dữ liệu mẫu, hãy chạy các UPDATE này sau khi đã có dữ liệu subjects)
UPDATE subjects SET owner_id = 2 WHERE id = 1;
UPDATE subjects SET owner_id = 3 WHERE id = 2;
UPDATE subjects SET owner_id = 4 WHERE id = 3;
UPDATE subjects SET owner_id = 6 WHERE id = 4;
UPDATE subjects SET owner_id = 7 WHERE id = 5;
UPDATE subjects SET owner_id = 8 WHERE id = 6;
UPDATE subjects SET owner_id = 9 WHERE id = 7;
UPDATE subjects SET owner_id = 10 WHERE id = 8;
UPDATE subjects SET owner_id = 11 WHERE id = 9;
UPDATE subjects SET owner_id = 12 WHERE id = 10;
UPDATE subjects SET owner_id = 13 WHERE id = 11;
UPDATE subjects SET owner_id = 14 WHERE id = 12;
UPDATE subjects SET owner_id = 15 WHERE id = 13;
UPDATE subjects SET owner_id = 16 WHERE id = 14;

SELECT s.id, s.name, s.owner_id, u.full_name, s.category_id, c.name AS category_name
FROM subjects s
LEFT JOIN users u ON s.owner_id = u.id
LEFT JOIN categories c ON s.category_id = c.id;


SELECT s.id, s.name, c.name AS categoryName, s.status, u.full_name AS ownerName,
  (SELECT COUNT(*) FROM lessons l JOIN courses c2 ON l.course_id = c2.id WHERE c2.subject_id = s.id) AS lessonCount
FROM subjects s
LEFT JOIN categories c ON s.category_id = c.id
LEFT JOIN users u ON s.owner_id = u.id
WHERE 1=1
ORDER BY s.id DESC;

SELECT * FROM users WHERE id IN (2,3,4,6,7,8,9,10,11,12,13,14,15,16);
SELECT * FROM categories WHERE id IN (1,2,3,4);
SELECT * FROM subjects WHERE status = 'inactive';

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `role` enum('customer','expert','marketing','admin') DEFAULT 'customer',
  `avatar_url` varchar(255) DEFAULT '/images/default-avatar.png',
  `gender` enum('male','female','other') DEFAULT NULL, -- OPTIMIZED: Changed to ENUM for consistency
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_user_role` (`role`) -- OPTIMIZED: Added index for faster role-based lookups
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
-- OPTIMIZED: Standardized gender data
INSERT INTO `users` VALUES (1,'AdminTest','adminTest','admintest@gmail.com','hashed_pwd_admin','admin','/uploads/images/avatar_1_1749716660129.png','female','011111','Ha Noi Ha Noi',NULL,NULL,'2025-05-25 13:19:17'),(2,'Nguyen Van A','expertA','expert@elearn.com','hashed_pwd_expert','expert','','male','0912345678','Ho Chi Minh',NULL,NULL,'2025-05-25 13:19:17'),(3,'duc','lethib','vanduc06102005@gmail.com','duc123456','customer','/uploads/images/default-avatar.svg','female','0923456789','Da Nang',NULL,NULL,'2025-05-25 13:19:17'),(4,'Tran Van C','tranc','student2@elearn.com','hashed_pwd_stu2','customer','','male','0934567890','Hoi An',NULL,NULL,'2025-05-25 13:19:17'),(6,'Sarah Wilson','expert6','expert6@example.com','hash6','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(7,'Chris Lee','expert7','expert7@example.com','hash7','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(8,'Anna White','expert8','expert8@example.com','hash8','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(9,'James Harris','expert9','expert9@example.com','hash9','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(10,'Linda Clark','expert10','expert10@example.com','hash10','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(11,'Robert Lewis','expert11','expert11@example.com','hash11','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(12,'Patricia Walker','expert12','expert12@example.com','hash12','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(13,'Daniel Hall','expert13','expert13@example.com','hash13','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(14,'Laura Allen','expert14','expert14@example.com','hash14','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(15,'John Smith','expert15','expert1@example.com','hash15','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(16,'Jane Doe','expert16','expert2@example.com','hash16','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(17,'Michael Johnson','expert17','expert3@example.com','hash17','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(18,'Emily Davis','expert18','expert4@example.com','hash18','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29'),(19,'David Brown','expert19','expert5@example.com','hash19','expert','/images/default-avatar.png',NULL,NULL,NULL,NULL,NULL,'2025-06-20 22:19:29');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Soft Skills','Essential soft skills for personal and professional development','2025-06-20 22:16:31'),(2,'Programming','Programming courses for all levels','2025-06-20 22:16:31'),(3,'Data Science','Courses about AI and Data Science','2025-06-20 22:16:31'),(4,'Technology','Latest technology trends and practices','2025-06-20 22:16:31');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `tagline` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_subject_category` (`category_id`),
  CONSTRAINT `fk_subject_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL -- OPTIMIZED: Added foreign key
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,'Soft Skills','Essential soft skills for work and life','https://www.husson.edu/online/blog/2024/09/soft-skills-blog-image.jpg',1,'Personal development','active','2025-06-20 22:16:47'),
(2,'Basic Programming','Learn programming from scratch','https://artoftesting.com/wp-content/uploads/2020/03/Basics-of-Java-programming.jpg',2,'Start coding today','active','2025-06-20 22:16:47')
,(3,'Mathematics','Fundamental mathematics knowledge','https://i0.wp.com/learnwithexamples.org/wp-content/uploads/2024/09/Algebra-101.jpg?fit=800%2C480&ssl=1',2,'Math foundation','active','2025-06-20 22:16:47'),
(4,'Startup','Entrepreneurship knowledge','https://i.imgur.com/8Km9tLL.png',4,'Start your business','active','2025-06-20 22:16:47'),
(5,'Artificial Intelligence','AI and its applications','https://incubator.ucf.edu/wp-content/uploads/2023/07/artificial-intelligence-new-technology-science-futuristic-abstract-human-brain-ai-technology-cpu-central-processor-unit-chipset-big-data-machine-learning-cyber-mind-domination-generative-ai-scaled-1.jpg',3,'AI for everyone','active','2025-06-20 22:16:47'),
(6,'Data Science','Data Science essentials','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz_rLGqrIduC7c3WhZQCx6a6BuU6H6ewrcPA&s',3,'Power of data','active','2025-06-20 22:16:47'),
(7,'Cybersecurity','Cybersecurity basics','https://vietnetco.vn/wp-content/uploads/2020/12/cyber-security-la-gi-hinh1.jpg',4,'Protect your data','active','2025-06-20 22:16:47'),
(8,'Cloud Computing','Cloud technology fundamentals','https://onetech.jp/wp-content/uploads/2021/11/Cloud-Computing-la-gi.png',4,'Cloud for business','active','2025-06-20 22:16:47'),
(9,'Mobile Development','Mobile app development','https://topdev.vn/blog/wp-content/uploads/2023/02/mobile-app-developer.png',2,'Build mobile apps','active','2025-06-20 22:16:47'),
(10,'Game Design','Game design and creativity','https://cdn.prod.website-files.com/5b651f8b5fc94c4e27470a81/622227fd2ce3cc0455a88166_blog-gamedev-fullsize.png',4,'Create your own game','active','2025-06-20 22:16:47'),
(11,'Blockchain','Blockchain technology','https://cdnphoto.dantri.com.vn/uD1dARw57m0cpynTkzNW8Ktnb_U=/zoom/1200_630/2025/02/26/cong-nghe-blockchain-1-crop-1740509091220.jpeg',4,'Blockchain 101','active','2025-06-20 22:16:47'),
(12,'IoT','Internet of Things','https://s3-api.fpt.vn/fptvn-storage/2025-03-16/1742110049_1iotketnoicacthietbivatlyvathietbiao.jpg',4,'Connect everything','active','2025-06-20 22:16:47'),
(13,'DevOps','DevOps practices','https://topdev.vn/blog/wp-content/uploads/2019/11/blog1.jpg',4,'DevOps for projects','active','2025-06-20 22:16:47'),
(14,'UI/UX','User Interface and Experience','https://telos.vn/wp-content/uploads/2023/11/phan-biet-hai-khai-niem-ui-ux-design-la-gi.png',4,'User experience design','active','2025-06-20 22:16:47');
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int DEFAULT NULL,
  `expert_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `brief_info` text,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`),
  KEY `expert_id` (`expert_id`),
  KEY `idx_course_title` (`title`), -- OPTIMIZED: Added index for faster title searches
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`),
  CONSTRAINT `courses_ibfk_2` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,1,15,'Soft Skills Essentials','Soft Skills Essentials is a comprehensive course designed to help learners develop the interpersonal and communication skills necessary for success in both personal and professional environments. This course covers a wide range of topics including effective communication, teamwork, problem-solving, adaptability, emotional intelligence, and conflict resolution. Through interactive lessons, real-world scenarios, and practical exercises, students will learn how to collaborate effectively, manage time efficiently, and build strong relationships with colleagues and clients. The course also emphasizes the importance of self-awareness, empathy, and active listening, providing tools and techniques to enhance these critical skills. By the end of the course, participants will have a deeper understanding of how soft skills contribute to career advancement and organizational success, and will be equipped with actionable strategies to apply these skills in various situations. Whether you are a student, a working professional, or someone looking to improve your personal interactions, this course offers valuable insights and practical guidance to help you thrive in today's dynamic world.','Master the essential soft skills needed to excel in any career. This course covers communication, teamwork, problem-solving, and emotional intelligence, providing practical tools and strategies to enhance your professional and personal life. Ideal for anyone looking to boost their interpersonal effectiveness and workplace success.','https://www.husson.edu/online/blog/2024/09/soft-skills-blog-image.jpg','2025-06-21 02:23:17'),(2,2,16,'Java for Beginners','Java for Beginners is an in-depth introduction to the world of programming using the Java language. This course is tailored for individuals with little or no prior coding experience and provides a step-by-step approach to learning the fundamentals of Java. Topics include variables, data types, control structures, object-oriented programming concepts, exception handling, and basic data structures. Students will engage in hands-on coding exercises, real-world projects, and quizzes to reinforce their understanding. The course also covers best practices in software development, debugging techniques, and how to use popular development tools such as Eclipse or IntelliJ IDEA. By the end of the course, learners will be able to write, compile, and run Java programs, and will have a solid foundation to pursue more advanced topics in software engineering. This course is perfect for aspiring developers, students, or anyone interested in starting a career in technology.','Kickstart your programming journey with Java! This beginner-friendly course introduces you to the basics of Java, including syntax, object-oriented principles, and practical coding exercises. Gain the confidence to build your own Java applications and prepare for more advanced programming challenges.','https://artoftesting.com/wp-content/uploads/2020/03/Basics-of-Java-programming.jpg','2025-06-21 02:23:17'),(3,3,17,'Algebra Essentials','Algebra Essentials is a foundational course designed to strengthen your understanding of core algebraic concepts. The curriculum covers topics such as linear equations, inequalities, polynomials, factoring, quadratic equations, and functions. Through a combination of video lectures, interactive problem sets, and real-life applications, students will develop the skills needed to solve algebraic problems efficiently. The course emphasizes conceptual understanding as well as practical problem-solving strategies, making it suitable for high school students, college freshmen, or anyone looking to refresh their math skills. By the end of the course, learners will be able to approach algebraic challenges with confidence and apply their knowledge to more advanced mathematical studies or standardized tests.','Build a strong foundation in algebra with this essential course. Learn to solve equations, work with polynomials, and understand functions through clear explanations and practical exercises. Perfect for students and professionals seeking to improve their math skills.','https://i0.wp.com/learnwithexamples.org/wp-content/uploads/2024/09/Algebra-101.jpg?fit=800%2C480&ssl=1','2025-06-21 02:23:17'),(4,4,18,'Startup 101','Startup 101 is a dynamic course crafted for aspiring entrepreneurs and innovators who want to turn their ideas into successful businesses. The course covers the entire startup lifecycle, from ideation and market research to business planning, funding, and scaling. Students will learn how to validate their ideas, create a minimum viable product, and develop a go-to-market strategy. The curriculum includes case studies of successful startups, insights from industry experts, and practical exercises to help learners build their entrepreneurial mindset. By the end of the course, participants will have a clear understanding of the challenges and opportunities in the startup world and will be equipped with the tools and knowledge needed to launch and grow their own ventures.','Learn how to launch a startup from scratch. This course guides you through ideation, business planning, funding, and scaling, with real-world examples and actionable strategies for aspiring entrepreneurs.','https://img.kitapyurdu.com/v1/getImage/fn:11334300/wh:true/wi:800','2025-06-21 02:23:17'),(5,5,19,'Intro to AI','Intro to AI provides a thorough introduction to the fascinating world of artificial intelligence. The course explores the history, concepts, and applications of AI, including machine learning, neural networks, natural language processing, and robotics. Students will gain hands-on experience with AI tools and frameworks, and will learn how AI is transforming industries such as healthcare, finance, and transportation. The curriculum is designed for beginners and includes interactive projects, quizzes, and discussions to reinforce learning. By the end of the course, learners will have a solid understanding of AI fundamentals and will be prepared to explore more advanced topics in the field.','Discover the basics of Artificial Intelligence, including machine learning, neural networks, and real-world applications. Perfect for beginners interested in the future of technology.','https://incubator.ucf.edu/wp-content/uploads/2023/07/artificial-intelligence-new-technology-science-futuristic-abstract-human-brain-ai-technology-cpu-central-processor-unit-chipset-big-data-machine-learning-cyber-mind-domination-generative-ai-scaled-1.jpg','2025-06-21 02:23:17'),(6,6,6,'Data Science Bootcamp','Data Science Bootcamp is an intensive course designed to equip learners with the skills and knowledge needed to succeed in the rapidly growing field of data science. The course covers data analysis, visualization, statistics, machine learning, and big data technologies. Students will work on real-world projects using popular tools such as Python, R, and SQL, and will learn how to extract insights from complex datasets. The curriculum also includes modules on data ethics, communication, and career development. By the end of the bootcamp, participants will have a strong portfolio of projects and the confidence to pursue data science roles in various industries.','Gain hands-on experience in data science, from data analysis and visualization to machine learning and big data. Build a portfolio and prepare for a career in this high-demand field.','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz_rLGqrIduC7c3WhZQCx6a6BuU6H6ewrcPA&s','2025-06-21 02:23:17'),(7,7,7,'Cybersecurity Essentials','Cybersecurity Essentials is a vital course for anyone interested in protecting digital assets and understanding the threats facing today's technology landscape. The course covers the fundamentals of cybersecurity, including network security, cryptography, risk management, and ethical hacking. Students will learn how to identify vulnerabilities, implement security measures, and respond to cyber incidents. The curriculum includes hands-on labs, case studies, and expert interviews to provide practical insights. By the end of the course, learners will be able to assess security risks, develop protection strategies, and pursue further studies or careers in cybersecurity.','Protect your digital world with this essential cybersecurity course. Learn about threats, defenses, and best practices to keep information safe in today's connected environment.','https://vietnetco.vn/wp-content/uploads/2020/12/cyber-security-la-gi-hinh1.jpg','2025-06-21 02:23:17'),(8,8,8,'Cloud Fundamentals','Cloud Fundamentals introduces learners to the core concepts and technologies of cloud computing. The course covers cloud service models (IaaS, PaaS, SaaS), deployment models, virtualization, and cloud security. Students will explore leading cloud platforms such as AWS, Azure, and Google Cloud, and will gain practical experience through hands-on labs and projects. The curriculum also addresses cost management, compliance, and emerging trends in cloud technology. By the end of the course, participants will understand how cloud computing is transforming business and IT, and will be prepared to pursue cloud certifications or roles.','Understand the basics of cloud computing, including service models, platforms, and security. Ideal for IT professionals and beginners looking to leverage the power of the cloud.','https://onetech.jp/wp-content/uploads/2021/11/Cloud-Computing-la-gi.png','2025-06-21 02:23:17'),(9,9,9,'Mobile App Dev','Mobile App Dev is a practical course focused on teaching students how to design, develop, and deploy mobile applications for Android and iOS platforms. The course covers user interface design, programming languages (Java, Kotlin, Swift), app architecture, and testing. Students will build real apps from scratch, learn about app store deployment, and explore the latest trends in mobile technology. The curriculum includes project-based learning, peer reviews, and expert feedback. By the end of the course, learners will have the skills to create functional, user-friendly mobile apps and pursue opportunities in the mobile development industry.','Learn to build mobile apps for Android and iOS. This course covers design, development, and deployment, giving you the skills to create your own apps from start to finish.','https://topdev.vn/blog/wp-content/uploads/2023/02/mobile-app-developer.png','2025-06-21 02:23:17'),(10,10,10,'Game Design Basics','Game Design Basics is an engaging course for anyone interested in creating video games. The course covers game mechanics, storytelling, level design, graphics, and sound. Students will learn how to use popular game engines such as Unity or Unreal Engine, and will work on projects to bring their ideas to life. The curriculum emphasizes creativity, collaboration, and problem-solving, and includes guest lectures from industry professionals. By the end of the course, participants will have a solid understanding of the game development process and a portfolio of original games.','Explore the fundamentals of game design, from mechanics and storytelling to graphics and sound. Create your own games and learn what it takes to succeed in the gaming industry.','https://cdn.prod.website-files.com/5b651f8b5fc94c4e27470a81/622227fd2ce3cc0455a88166_blog-gamedev-fullsize.png','2025-06-21 02:23:17'),(11,11,11,'Blockchain 101','Blockchain 101 is a beginner-friendly course that demystifies the technology behind cryptocurrencies and decentralized applications. The course covers blockchain architecture, consensus mechanisms, smart contracts, and real-world use cases. Students will learn how to create and interact with blockchain networks, understand security implications, and explore the future of decentralized finance. The curriculum includes hands-on exercises, case studies, and discussions on regulatory and ethical considerations. By the end of the course, learners will have a foundational understanding of blockchain and its potential to transform industries.','Get started with blockchain technology. Learn how it works, why it matters, and how it's changing the world of finance, business, and beyond.','https://cdnphoto.dantri.com.vn/uD1dARw57m0cpynTkzNW8Ktnb_U=/zoom/1200_630/2025/02/26/cong-nghe-blockchain-1-crop-1740509091220.jpeg','2025-06-21 02:23:17'),(12,12,12,'IoT for Beginners','IoT for Beginners is an introductory course that explores the world of the Internet of Things. The course covers IoT architecture, sensors, connectivity, data processing, and security. Students will learn how to design and build IoT solutions using microcontrollers, cloud platforms, and mobile apps. The curriculum includes hands-on projects, industry case studies, and discussions on the impact of IoT on society. By the end of the course, participants will understand the opportunities and challenges of IoT and will be prepared to create their own smart devices and applications.','Explore the Internet of Things and learn how to connect devices, collect data, and build smart solutions. Perfect for beginners interested in the future of technology.','https://s3-api.fpt.vn/fptvn-storage/2025-03-16/1742110049_1iotketnoicacthietbivatlyvathietbiao.jpg','2025-06-21 02:23:17'),(13,13,13,'DevOps Practices','DevOps Practices is a comprehensive course that teaches the principles and tools of modern DevOps. The course covers continuous integration, continuous delivery, automation, monitoring, and collaboration between development and operations teams. Students will work with popular DevOps tools such as Git, Jenkins, Docker, and Kubernetes, and will learn how to implement best practices for faster, more reliable software delivery. The curriculum includes real-world projects, case studies, and expert insights. By the end of the course, learners will be able to streamline development workflows and drive organizational success through DevOps.','Master DevOps principles and tools to automate, monitor, and improve software delivery. Ideal for developers and IT professionals seeking to enhance their workflow.','https://topdev.vn/blog/wp-content/uploads/2019/11/blog1.jpg','2025-06-21 02:23:17'),(14,14,14,'UI/UX Principles','UI/UX Principles is a detailed course focused on the art and science of designing user-friendly digital interfaces. The course covers user research, wireframing, prototyping, usability testing, and visual design. Students will learn how to create intuitive, accessible, and visually appealing interfaces for web and mobile applications. The curriculum includes hands-on projects, design critiques, and feedback from industry experts. By the end of the course, participants will have a strong portfolio and the skills to pursue careers in UI/UX design.','Learn the fundamentals of user interface and user experience design. Create beautiful, functional, and accessible digital products that delight users.','https://telos.vn/wp-content/uploads/2023/11/phan-biet-hai-khai-niem-ui-ux-design-la-gi.png','2025-06-21 02:23:17');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lessons`
--

DROP TABLE IF EXISTS `lessons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lessons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int DEFAULT NULL, -- OPTIMIZED: Renamed from subject_id for clarity
  `title` varchar(255) DEFAULT NULL,
  `video_url` varchar(255) DEFAULT NULL,
  `lesson_order` int DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `type` varchar(50) DEFAULT 'video',
  `parent_lesson_id` int DEFAULT NULL, -- OPTIMIZED: Changed default from 0 to NULL
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `lessons_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lessons`
--

LOCK TABLES `lessons` WRITE;
/*!40000 ALTER TABLE `lessons` DISABLE KEYS */;
INSERT INTO `lessons` VALUES (1,1,'Lắng nghe chủ động','video1.mp4',1,1,'video',NULL),(2,1,'Nói để người khác nghe','video2.mp4',2,1,'video',NULL),(3,1,'Phân vai trong nhóm','video3.mp4',1,1,'video',NULL),(4,2,'Giải quyết xung đột','video4.mp4',2,1,'video',NULL);
/*!40000 ALTER TABLE `lessons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `package_name` varchar(255) DEFAULT NULL,
  `original_price` decimal(10,2) DEFAULT NULL, -- OPTIMIZED: Changed to DECIMAL for accuracy
  `sale_price` decimal(10,2) DEFAULT NULL,     -- OPTIMIZED: Changed to DECIMAL for accuracy
  `duration_months` int DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `fk_package_course` (`course_id`),
  CONSTRAINT `fk_package_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE -- OPTIMIZED: Added foreign key
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packages`
--

LOCK TABLES `packages` WRITE;
/*!40000 ALTER TABLE `packages` DISABLE KEYS */;
INSERT INTO `packages` VALUES (1,1,'Basic',50.00,40.00,3,'Basic access for 3 months.'),(2,1,'Standard',90.00,75.00,6,'Standard access for 6 months.'),(3,1,'Premium',150.00,120.00,12,'Premium access for 12 months with extra benefits.'),(4,2,'Basic',55.00,45.00,3,'Basic access for 3 months.'),(5,2,'Standard',100.00,85.00,6,'Standard access for 6 months.'),(6,2,'Premium',160.00,130.00,12,'Premium access for 12 months with extra benefits.'),(7,3,'Basic',60.00,50.00,3,'Basic access for 3 months.'),(8,3,'Standard',110.00,95.00,6,'Standard access for 6 months.'),(9,3,'Premium',170.00,140.00,12,'Premium access for 12 months with extra benefits.'),(10,4,'Basic',65.00,55.00,3,'Basic access for 3 months.'),(11,4,'Standard',120.00,105.00,6,'Standard access for 6 months.'),(12,4,'Premium',180.00,150.00,12,'Premium access for 12 months with extra benefits.'),(13,5,'Basic',70.00,60.00,3,'Basic access for 3 months.'),(14,5,'Standard',130.00,115.00,6,'Standard access for 6 months.'),(15,5,'Premium',190.00,160.00,12,'Premium access for 12 months with extra benefits.'),(16,6,'Basic',75.00,65.00,3,'Basic access for 3 months.'),(17,6,'Standard',140.00,125.00,6,'Standard access for 6 months.'),(18,6,'Premium',200.00,170.00,12,'Premium access for 12 months with extra benefits.'),(19,7,'Basic',80.00,70.00,3,'Basic access for 3 months.'),(20,7,'Standard',150.00,135.00,6,'Standard access for 6 months.'),(21,7,'Premium',210.00,180.00,12,'Premium access for 12 months with extra benefits.'),(22,8,'Basic',85.00,75.00,3,'Basic access for 3 months.'),(23,8,'Standard',160.00,145.00,6,'Standard access for 6 months.'),(24,8,'Premium',220.00,190.00,12,'Premium access for 12 months with extra benefits.'),(25,9,'Basic',90.00,80.00,3,'Basic access for 3 months.'),(26,9,'Standard',170.00,155.00,6,'Standard access for 6 months.'),(27,9,'Premium',230.00,200.00,12,'Premium access for 12 months with extra benefits.'),(28,10,'Basic',95.00,85.00,3,'Basic access for 3 months.'),(29,10,'Standard',180.00,165.00,6,'Standard access for 6 months.'),(30,10,'Premium',240.00,210.00,12,'Premium access for 12 months with extra benefits.'),(31,11,'Basic',100.00,90.00,3,'Basic access for 3 months.'),(32,11,'Standard',190.00,175.00,6,'Standard access for 6 months.'),(33,11,'Premium',250.00,220.00,12,'Premium access for 12 months with extra benefits.'),(34,12,'Basic',105.00,95.00,3,'Basic access for 3 months.'),(35,12,'Standard',200.00,185.00,6,'Standard access for 6 months.'),(36,12,'Premium',260.00,230.00,12,'Premium access for 12 months with extra benefits.'),(37,13,'Basic',110.00,100.00,3,'Basic access for 3 months.'),(38,13,'Standard',210.00,195.00,6,'Standard access for 6 months.'),(39,13,'Premium',270.00,240.00,12,'Premium access for 12 months with extra benefits.'),(40,14,'Basic',115.00,105.00,3,'Basic access for 3 months.'),(41,14,'Standard',220.00,205.00,6,'Standard access for 6 months.'),(42,14,'Premium',280.00,250.00,12,'Premium access for 12 months with extra benefits.');
/*!40000 ALTER TABLE `packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registrations`
--

DROP TABLE IF EXISTS `registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `course_id` int NOT NULL,
  `package_id` int NOT NULL,
  `registered_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','active','completed') DEFAULT 'pending',
  -- OPTIMIZED: Removed redundant user information columns
  -- full_name, email, mobile, gender are now fetched from the users table via user_id
  `image_url` varchar(500) DEFAULT NULL, -- For specific course requirements
  `image_description` text,
  `video_url` varchar(500) DEFAULT NULL, -- For specific course requirements
  `video_description` text,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `course_id` (`course_id`),
  KEY `idx_package_id` (`package_id`),
  UNIQUE KEY `uq_user_course` (`user_id`,`course_id`), -- A user should only register for a course once
  CONSTRAINT `registrations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `registrations_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_registrations_package_id` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registrations`
--

LOCK TABLES `registrations` WRITE;
/*!40000 ALTER TABLE `registrations` DISABLE KEYS */;
-- OPTIMIZED: Insert statement now only contains relevant, non-redundant data
INSERT INTO `registrations` VALUES (1,3,5,13,'2025-07-03 03:58:45','pending',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quizzes`
--

DROP TABLE IF EXISTS `quizzes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quizzes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lesson_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `lesson_id` (`lesson_id`),
  CONSTRAINT `quizzes_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quizzes`
--

LOCK TABLES `quizzes` WRITE;
/*!40000 ALTER TABLE `quizzes` DISABLE KEYS */;
INSERT INTO `quizzes` VALUES (1,1,'Quiz Giao tiếp 1','Kiểm tra nội dung bài 1'),(2,3,'Quiz Nhóm 1','Kiểm tra vai trò nhóm');
/*!40000 ALTER TABLE `quizzes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,1,'Lắng nghe chủ động là gì?'),(2,1,'Điều gì cản trở lắng nghe?'),(3,2,'Team leader có vai trò gì?'),(4,2,'Xung đột nên được xử lý thế nào?');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int DEFAULT NULL,
  `content` text,
  `is_correct` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
INSERT INTO `answers` VALUES (1,1,'Tập trung và phản hồi phù hợp',1),(2,1,'Làm việc riêng khi nghe',0),(3,2,'Thiếu kiên nhẫn',1),(4,2,'Ngồi gần người nói',0),(5,3,'Hướng dẫn và kết nối các thành viên',1),(6,3,'Làm hết việc nhóm',0),(7,4,'Giao tiếp thẳng thắn và cùng giải quyết',1),(8,4,'Lờ đi vấn đề',0);
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_submissions`
--

DROP TABLE IF EXISTS `quiz_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `quiz_id` int DEFAULT NULL,
  `submitted_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `score` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `quiz_id` (`quiz_id`),
  KEY `idx_user_quiz` (`user_id`,`quiz_id`), -- OPTIMIZED: Composite index for performance
  CONSTRAINT `quiz_submissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `quiz_submissions_ibfk_2` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_submissions`
--

LOCK TABLES `quiz_submissions` WRITE;
/*!40000 ALTER TABLE `quiz_submissions` DISABLE KEYS */;
INSERT INTO `quiz_submissions` VALUES (1,3,1,'2025-05-25 13:19:17',80),(2,4,1,'2025-05-25 13:19:17',90),(3,3,2,'2025-05-25 13:19:17',70);
/*!40000 ALTER TABLE `quiz_submissions` ENABLE KEYS */;
UNLOCK TABLES;


-- Remaining tables (blogs, sliders, images) are left as they were, with minor adjustments.

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `content` text,
  `author_id` int DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `blogs_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (1,'5 kỹ năng mềm nên có trong công việc','Nội dung blog...',2,'2025-05-25 13:19:17','/uploads/images/blog1.jpg'),(2,'10 soft skill trong học tập','Nội dung blog...',2,'2025-05-28 22:09:18','/uploads/images/blog2.jpg'),(3,'Top 10 Soft Skils','Nội dung blog...',1,'2025-05-28 22:10:43','/uploads/images/blog3.png');
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sliders`
--

DROP TABLE IF EXISTS `sliders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sliders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `link_url` varchar(255) DEFAULT NULL,
  `display_order` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sliders`
--

LOCK TABLES `sliders` WRITE;
/*!40000 ALTER TABLE `sliders` DISABLE KEYS */;
INSERT INTO `sliders` VALUES (1,'Khóa học mới: Giao tiếp công sở','/uploads/images/banner1.jpg','/courses/1',1),(2,'Học teamwork hiệu quả','/uploads/images/banner2.webp','/courses/2',2);
/*!40000 ALTER TABLE `sliders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `images`
-- NOTE: This table is potentially redundant due to specific thumbnail/avatar columns
-- in other tables. Consider simplifying your image management strategy.
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `uploaded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES (1,'slider',1,'banner1.jpg','/uploads/images/banner1.jpg','Ảnh banner slider 1','2025-05-25 19:39:56');
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

-- Bổ sung bảng dimensions cho subject
CREATE TABLE IF NOT EXISTS dimensions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id INT,
    type VARCHAR(100),
    name VARCHAR(255),
    FOREIGN KEY (subject_id) REFERENCES subjects(id)
);

-- Bổ sung cột is_featured cho bảng subjects nếu chưa có
ALTER TABLE subjects ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT 0;

-- Dữ liệu mẫu cho bảng dimensions
INSERT INTO dimensions (subject_id, type, name) VALUES
(1, 'Domain', 'Teamwork'),
(1, 'Domain', 'Collaboration'),
(1, 'Group', 'Planning'),
(1, 'Group', 'Execution'),
(2, 'Domain', 'Teamwork'),
(2, 'Domain', 'Collaboration');

-- Dữ liệu mẫu cho bảng packages (price package)
INSERT INTO packages (course_id, package_name, original_price, sale_price, duration_months, description) VALUES
(1, 'Gói truy cập 6 tháng', 7000, 6500, 6, 'Gói truy cập 6 tháng'),
(1, 'Gói truy cập 12 tháng', 12000, 10000, 12, 'Gói truy cập 12 tháng'),
(1, 'Gói truy cập 1 tháng', 2000, 1800, 1, 'Gói truy cập 1 tháng'),
(2, 'Gói truy cập 6 tháng', 7000, 6500, 6, 'Gói truy cập 6 tháng'),
(2, 'Gói truy cập 3 tháng', 4000, 3500, 3, 'Gói truy cập 3 tháng'),
(2, 'Gói truy cập 12 tháng', 12000, 10000, 12, 'Gói truy cập 12 tháng');

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-03 (Optimized Version)

-- Additional tables for lesson viewing and progress tracking

-- Table for tracking user progress on lessons
CREATE TABLE IF NOT EXISTS lesson_progress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    last_viewed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    view_duration_seconds INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_lesson (user_id, lesson_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table for lesson comments
CREATE TABLE IF NOT EXISTS lesson_comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    INDEX idx_lesson_comments_lesson (lesson_id),
    INDEX idx_lesson_comments_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Update lessons table to use course_id instead of subject_id (if not already done)
-- ALTER TABLE lessons CHANGE COLUMN subject_id course_id INT;

-- Add video_url column to lessons table if using video_link
-- ALTER TABLE lessons ADD COLUMN video_url VARCHAR(255) AFTER parent_lesson_id;
-- UPDATE lessons SET video_url = video_link WHERE video_link IS NOT NULL;