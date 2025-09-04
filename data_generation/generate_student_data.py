import psycopg2
import random
from faker import Faker
from datetime import date
import time
import sys

def generate_large_dataset():
    fake = Faker()

    # -----------------------------
    # Database connection parameters
    # -----------------------------
    db_params = {
        'dbname': 'student_records',
        'user': "postgres",
        'password':"postgres",  # <-- CHANGE THIS ONCE HERE
        'host': 'localhost',
        'port': '5432'
    }

    try:
        # -----------------------------
        # Connect to PostgreSQL
        # -----------------------------
        conn = psycopg2.connect(**db_params)
        cur = conn.cursor()
        print("✅ Connected to database successfully")

        # -----------------------------
        # Step 1: Check/Create Courses
        # -----------------------------
        cur.execute("SELECT COUNT(*) FROM acad.courses")
        course_count = cur.fetchone()[0]

        if course_count == 0:
            print("📚 Adding sample courses...")
            courses = [
                ('CS101', 'Introduction to Computer Science', 4),
                ('MATH101', 'Calculus I', 4),
                ('ENG101', 'Composition I', 3),
                ('BIO101', 'Biology I', 4),
                ('HIST101', 'World History', 3),
                ('CHEM101', 'Chemistry I', 4),
                ('PHYS101', 'Physics I', 4),
                ('PSY101', 'Introduction to Psychology', 3),
                ('ECON101', 'Principles of Economics', 3),
                ('ART101', 'Art Appreciation', 2),
                ('CS201', 'Data Structures', 4),
                ('MATH202', 'Linear Algebra', 4),
                ('ENG202', 'Advanced Composition', 3),
                ('BIO202', 'Genetics', 4),
                ('HIST202', 'European History', 3)
            ]
            cur.executemany(
                "INSERT INTO acad.courses (course_code, course_name, credits) VALUES (%s, %s, %s)",
                courses
            )
            conn.commit()
            print(f"✅ Added {len(courses)} courses")

        # Get all course IDs
        cur.execute("SELECT course_id FROM acad.courses")
        course_ids = [row[0] for row in cur.fetchall()]
        print(f"✅ Found {len(course_ids)} courses")

        # -----------------------------
        # Step 2: Generate Students
        # -----------------------------
        print("👩‍🎓 Generating 200,000 students...")
        batch_size = 1000
        total_students = 200000

        for i in range(0, total_students, batch_size):
            students_data = [
                (
                    fake.first_name(),
                    fake.last_name(),
                    f"{fake.first_name().lower()}.{fake.last_name().lower()}{i+j}@university.edu",
                    fake.date_of_birth(minimum_age=18, maximum_age=25)
                )
                for j in range(batch_size)
            ]

            cur.executemany(
                "INSERT INTO acad.students (first_name, last_name, email, dob) VALUES (%s, %s, %s, %s)",
                students_data
            )
            conn.commit()

            if (i // batch_size) % 20 == 0:
                print(f"Inserted {i + batch_size} students so far...")

        print("✅ Finished inserting students")

        # -----------------------------
        # Step 3: Generate Enrollments
        # -----------------------------
        print("📝 Generating 1,000,000 enrollments...")
        cur.execute("SELECT student_id FROM acad.students ORDER BY student_id")
        student_ids = [row[0] for row in cur.fetchall()]

        total_enrollments = 1000000
        enrollment_batch_size = 5000

        for i in range(0, total_enrollments, enrollment_batch_size):
            enrollments_data = []
            for j in range(enrollment_batch_size):
                student_id = random.choice(student_ids)
                course_id = random.choice(course_ids)

                year = random.randint(2020, 2024)
                month = random.randint(1, 12)
                day = random.randint(1, 28)
                enrolled_on = date(year, month, day)

                status_random = random.random()
                if status_random < 0.9:
                    status, grade = 'active', None
                elif status_random < 0.95:
                    status, grade = 'completed', random.choice(['A', 'B', 'C', 'D'])
                else:
                    status, grade = 'dropped', None

                enrollments_data.append((student_id, course_id, enrolled_on, status, grade))

            cur.executemany(
                "INSERT INTO acad.enrollments (student_id, course_id, enrolled_on, status, grade) VALUES (%s, %s, %s, %s, %s)",
                enrollments_data
            )
            conn.commit()

            if (i // enrollment_batch_size) % 20 == 0:
                print(f"Inserted {i + enrollment_batch_size} enrollments so far...")

        print("✅ Finished inserting enrollments")

        # -----------------------------
        # Close connection
        # -----------------------------
        cur.close()
        conn.close()
        print("🎉 Data generation completed successfully!")

    except Exception as e:
        print(f"❌ Error: {e}")
        if 'conn' in locals():
            conn.rollback()
            conn.close()

# Run script
if __name__ == "__main__":
    print("🚀 Starting data generation...")
    start_time = time.time()
    generate_large_dataset()
    end_time = time.time()
    print(f"⏱ Total execution time: {end_time - start_time:.2f} seconds")
