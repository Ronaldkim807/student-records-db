-- Update statistics for query planner
ANALYZE acad.students;
ANALYZE acad.courses;
ANALYZE acad.enrollments;

-- Create additional indexes for common query patterns
CREATE INDEX idx_enrollments_student_course ON acad.enrollments (student_id, course_id);
CREATE INDEX idx_enrollments_course_status ON acad.enrollments (course_id, status);
CREATE INDEX idx_students_dob ON acad.students (dob);

-- Create a materialized view for common reports
CREATE MATERIALIZED VIEW acad.student_enrollment_summary AS
SELECT 
  s.student_id,
  s.first_name,
  s.last_name,
  COUNT(e.enrollment_id) AS total_enrollments,
  COUNT(CASE WHEN e.status = 'completed' THEN 1 END) AS completed_courses,
  COUNT(CASE WHEN e.status = 'active' THEN 1 END) AS active_courses
FROM acad.students s
LEFT JOIN acad.enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name;

CREATE INDEX idx_student_summary ON acad.student_enrollment_summary (student_id);

-- Create a function to refresh materialized views
CREATE OR REPLACE FUNCTION acad.refresh_materialized_views()
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  REFRESH MATERIALIZED VIEW acad.student_enrollment_summary;
END;
$$;