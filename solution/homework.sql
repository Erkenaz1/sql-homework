-- ============================================
-- Студент: Erkenaz
-- Топ: _________________________________
-- ============================================

-- ============================================
-- I БӨЛІМ: DDL — Кестелерді жасау
-- ============================================

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    dean_name VARCHAR(100),
    established_year INTEGER,
    building VARCHAR(100)
);

CREATE TABLE teachers (
    teacher_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    department_id INTEGER
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    admission_year INTEGER,
    gpa NUMERIC(3,2),
    department_id INTEGER
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    credits INTEGER NOT NULL,
    department_id INTEGER
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade NUMERIC(5,2)
);

-- ============================================
-- II БӨЛІМ: ALTER TABLE
-- ============================================

ALTER TABLE teachers
ADD CONSTRAINT fk_teacher_department
FOREIGN KEY (department_id)
REFERENCES departments(department_id);

ALTER TABLE students
ADD CONSTRAINT fk_student_department
FOREIGN KEY (department_id)
REFERENCES departments(department_id);

ALTER TABLE students
ADD CONSTRAINT chk_student_gpa
CHECK (gpa >= 0 AND gpa <= 4.00);

ALTER TABLE courses
ADD CONSTRAINT fk_course_department
FOREIGN KEY (department_id)
REFERENCES departments(department_id);

ALTER TABLE enrollments
ADD CONSTRAINT fk_enrollment_student
FOREIGN KEY (student_id)
REFERENCES students(student_id);

ALTER TABLE enrollments
ADD CONSTRAINT fk_enrollment_course
FOREIGN KEY (course_id)
REFERENCES courses(course_id);

-- ============================================
-- III БӨЛІМ: INSERT деректер
-- ============================================

INSERT INTO departments
    (dept_name, dean_name, established_year, building)
VALUES
    ('Ақпараттық технологиялар', 'А. Ахметов', 2005, 'А корпусы'),
    ('Экономика', 'Б. Сәрсенов', 1998, 'Б корпусы');

INSERT INTO teachers
    (first_name, last_name, email, department_id)
VALUES
    ('Айбек', 'Ахметов', 'a.akhmetov@example.com', 1),
    ('Мадина', 'Сәрсенова', 'm.sarsenova@example.com', 2);

INSERT INTO students
    (first_name, last_name, birth_date, admission_year, gpa, department_id)
VALUES
    ('Еркеназ', 'Студент', '2004-05-15', 2022, 3.75, 1),
    ('Алихан', 'Қасымов', '2005-03-20', 2023, 3.40, 1);

INSERT INTO courses
    (course_name, credits, department_id)
VALUES
    ('Деректер базасы', 5, 1),
    ('Бағдарламалау негіздері', 5, 1),
    ('Экономика негіздері', 4, 2);

INSERT INTO enrollments
    (student_id, course_id, grade)
VALUES
    (1, 1, 95.00),
    (1, 2, 90.00),
    (2, 1, 88.00);
    
    -- GitHub Actions test