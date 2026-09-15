-- ============================================
-- SQL HOMEWORK
-- ============================================

-- I БӨЛІМ: DDL — Кестелерді жасау

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    dean_name VARCHAR(100),
    established_year INTEGER,
    building VARCHAR(100)
);

CREATE TABLE teachers (
    teacher_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    department_id INTEGER,
    CONSTRAINT fk_teacher_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    gpa NUMERIC(3,2),
    department_id INTEGER,
    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT chk_student_gpa
        CHECK (gpa >= 0 AND gpa <= 4.00)
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    credits INTEGER NOT NULL,
    department_id INTEGER,
    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade NUMERIC(5,2),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id),
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

-- II БӨЛІМ: ALTER TABLE

ALTER TABLE students
ADD COLUMN IF NOT EXISTS enrollment_year INTEGER;

-- III БӨЛІМ: INSERT деректер

INSERT INTO departments
    (dept_name, dean_name, established_year, building)
VALUES
    ('Ақпараттық технологиялар', 'Айдос Қасымов', 2000, 'А корпусы');

INSERT INTO teachers
    (full_name, email, department_id)
VALUES
    ('Ерлан Ахметов', 'erlan@example.com', 1);

INSERT INTO students
    (full_name, email, gpa, department_id, enrollment_year)
VALUES
    ('Арман Сәрсенов', 'arman@example.com', 3.50, 1, 2026);

INSERT INTO courses
    (course_name, credits, department_id)
VALUES
    ('Database Systems', 5, 1);

INSERT INTO enrollments
    (student_id, course_id, grade)
VALUES
    (1, 1, 95.00);
