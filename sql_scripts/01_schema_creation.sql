-- Create schema
CREATE SCHEMA IF NOT EXISTS acad AUTHORIZATION postgres;

-- Students table
CREATE TABLE acad.students (
  student_id    BIGSERIAL PRIMARY KEY,
  first_name    TEXT NOT NULL,
  last_name     TEXT NOT NULL,
  email         TEXT UNIQUE NOT NULL,
  dob           DATE NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT now(),
  updated_at    TIMESTAMPTZ DEFAULT now()
);

-- Courses table
CREATE TABLE acad.courses (
  course_id   BIGSERIAL PRIMARY KEY,
  course_code TEXT NOT NULL UNIQUE,
  course_name TEXT NOT NULL,
  credits     SMALLINT NOT NULL CHECK (credits BETWEEN 1 AND 5),
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Enrollments table - partitioned by year
CREATE TABLE acad.enrollments (
  enrollment_id BIGSERIAL,
  student_id    BIGINT NOT NULL,
  course_id     BIGINT NOT NULL,
  enrolled_on   DATE NOT NULL DEFAULT CURRENT_DATE,
  status        TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'dropped', 'completed')),
  grade         TEXT CHECK (grade IN ('A', 'B', 'C', 'D', 'F', 'I')),
  created_at    TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (enrollment_id, enrolled_on)
) PARTITION BY RANGE (enrolled_on);

-- Create partitions for enrollments (2020-2025)
CREATE TABLE acad.enrollments_2020 PARTITION OF acad.enrollments
  FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');
CREATE TABLE acad.enrollments_2021 PARTITION OF acad.enrollments
  FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');
CREATE TABLE acad.enrollments_2022 PARTITION OF acad.enrollments
  FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');
CREATE TABLE acad.enrollments_2023 PARTITION OF acad.enrollments
  FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE acad.enrollments_2024 PARTITION OF acad.enrollments
  FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
CREATE TABLE acad.enrollments_2025 PARTITION OF acad.enrollments
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');