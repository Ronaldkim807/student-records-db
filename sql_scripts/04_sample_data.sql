-- ==============================================
-- Replace old data with Kenyan students & courses
-- ==============================================

-- 1️⃣ Clear old data (keep table structures)
DELETE FROM acad.enrollments;
DELETE FROM acad.students;
DELETE FROM acad.courses;

-- 2️⃣ Insert sample courses
INSERT INTO acad.courses (course_code, course_name, credits) VALUES
('CS101', 'Introduction to Computer Science', 4),
('MATH101', 'Calculus I', 4),
('ENG101', 'English Composition', 3),
('BIO101', 'Biology I', 4),
('HIST101', 'Kenyan History', 3),
('CHEM101', 'Chemistry I', 4),
('PHYS101', 'Physics I', 4),
('PSY101', 'Introduction to Psychology', 3),
('ECON101', 'Principles of Economics', 3),
('AGRI101', 'Introduction to Agriculture', 2);

-- 3️⃣ Insert sample students
INSERT INTO acad.students (first_name, last_name, email, dob) VALUES
('Kevin', 'Mwangi', 'kevin.mwangi@ku.ac.ke', '2002-05-15'),
('Faith', 'Njeri', 'faith.njeri@ku.ac.ke', '2001-02-20'),
('James', 'Otieno', 'james.otieno@ku.ac.ke', '2000-11-30'),
('Aisha', 'Mohamed', 'aisha.mohamed@ku.ac.ke', '2001-08-22'),
('Brian', 'Kamau', 'brian.kamau@ku.ac.ke', '2002-04-17');

-- 4️⃣ Insert sample enrollments
INSERT INTO acad.enrollments (student_id, course_id, enrolled_on, status) VALUES
(1, 1, '2025-09-01', 'active'),
(1, 2, '2025-09-01', 'active'),
(2, 1, '2025-09-01', 'active'),
(2, 3, '2025-09-01', 'active'),
(3, 4, '2025-09-01', 'active'),
(3, 5, '2025-09-01', 'active'),
(4, 6, '2025-09-01', 'active'),
(4, 7, '2025-09-01', 'active'),
(5, 8, '2025-09-01', 'active'),
(5, 9, '2025-09-01', 'active');
