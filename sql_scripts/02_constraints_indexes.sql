-- Add foreign keys
ALTER TABLE acad.enrollments 
  ADD CONSTRAINT fk_enrollments_students 
  FOREIGN KEY (student_id) REFERENCES acad.students(student_id);

ALTER TABLE acad.enrollments 
  ADD CONSTRAINT fk_enrollments_courses 
  FOREIGN KEY (course_id) REFERENCES acad.courses(course_id);

-- Create indexes for performance
CREATE INDEX idx_students_name ON acad.students (last_name, first_name);
CREATE INDEX idx_students_email ON acad.students (email);
CREATE INDEX idx_enrollments_student ON acad.enrollments (student_id);
CREATE INDEX idx_enrollments_course ON acad.enrollments (course_id);
CREATE INDEX idx_enrollments_status ON acad.enrollments (status);
CREATE INDEX idx_enrollments_date ON acad.enrollments (enrolled_on);