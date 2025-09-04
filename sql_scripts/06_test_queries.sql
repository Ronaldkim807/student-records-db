-- Test query 1: Find all active enrollments for a student
EXPLAIN (ANALYZE, BUFFERS)
SELECT s.first_name, s.last_name, c.course_code, c.course_name, e.enrolled_on, e.status
FROM acad.students s
JOIN acad.enrollments e ON s.student_id = e.student_id
JOIN acad.courses c ON e.course_id = c.course_id
WHERE s.student_id = 12345 AND e.status = 'active';

-- Test query 2: Find all students enrolled in a specific course
EXPLAIN (ANALYZE, BUFFERS)
SELECT s.student_id, s.first_name, s.last_name, e.enrolled_on, e.status
FROM acad.students s
JOIN acad.enrollments e ON s.student_id = e.student_id
WHERE e.course_id = 3 AND e.status = 'active'
ORDER BY e.enrolled_on DESC
LIMIT 50;

-- Test query 3: Enrollment count by course
EXPLAIN (ANALYZE, BUFFERS)
SELECT c.course_code, c.course_name, COUNT(e.enrollment_id) as enrollment_count
FROM acad.courses c
LEFT JOIN acad.enrollments e ON c.course_id = e.course_id
WHERE e.enrolled_on BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY c.course_id, c.course_code, c.course_name
ORDER BY enrollment_count DESC;