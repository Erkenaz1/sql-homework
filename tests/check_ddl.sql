-- ============================================
-- SQL HOMEWORK AUTOMATIC CHECKER
-- ============================================

-- Вспомогательная функция проверки
CREATE OR REPLACE FUNCTION assert(
    condition BOOLEAN,
    message TEXT
)
RETURNS VOID AS $$
BEGIN
    IF NOT condition THEN
        RAISE EXCEPTION 'TEST FAILED: %', message;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- 1. Проверка существования таблиц
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'departments'
    ),
    'Таблица departments не существует'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'teachers'
    ),
    'Таблица teachers не существует'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'students'
    ),
    'Таблица students не существует'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'courses'
    ),
    'Таблица courses не существует'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'enrollments'
    ),
    'Таблица enrollments не существует'
);


-- ============================================
-- 2. Проверка обязательных столбцов
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'students'
        AND column_name = 'gpa'
    ),
    'В students отсутствует столбец gpa'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'students'
        AND column_name = 'department_id'
    ),
    'В students отсутствует столбец department_id'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = 'enrollments'
        AND column_name = 'grade'
    ),
    'В enrollments отсутствует столбец grade'
);


-- ============================================
-- 3. Проверка Primary Key
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
        AND table_name = 'departments'
        AND constraint_type = 'PRIMARY KEY'
    ),
    'В departments отсутствует PRIMARY KEY'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
        AND table_name = 'students'
        AND constraint_type = 'PRIMARY KEY'
    ),
    'В students отсутствует PRIMARY KEY'
);


-- ============================================
-- 4. Проверка Foreign Key
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
        AND table_name = 'students'
        AND constraint_type = 'FOREIGN KEY'
    ),
    'В students отсутствует FOREIGN KEY'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
        AND table_name = 'enrollments'
        AND constraint_type = 'FOREIGN KEY'
    ),
    'В enrollments отсутствует FOREIGN KEY'
);


-- ============================================
-- 5. Проверка UNIQUE constraint
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
        AND table_name = 'teachers'
        AND constraint_type = 'UNIQUE'
    ),
    'В teachers отсутствует UNIQUE constraint'
);


-- ============================================
-- 6. Проверка CHECK constraint для GPA
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.check_constraints cc
        JOIN information_schema.table_constraints tc
          ON cc.constraint_name = tc.constraint_name
        WHERE tc.table_schema = 'public'
        AND tc.table_name = 'students'
        AND tc.constraint_type = 'CHECK'
    ),
    'В students отсутствует CHECK constraint для GPA'
);


-- ============================================
-- 7. Проверка INSERT в departments
-- ============================================

INSERT INTO departments
    (dept_name, dean_name, established_year, building)
VALUES
    ('Тест факультеті', 'Тест Декан', 2000, 'А корпусы');


-- ============================================
-- 8. Проверка CHECK constraint
-- GPA = 9.99 должен быть запрещён
-- ============================================

DO $$
BEGIN
    BEGIN
        INSERT INTO students
            (full_name, gpa, department_id)
        VALUES
            ('Invalid Student', 9.99, 1);

        RAISE EXCEPTION
            'TEST FAILED: GPA CHECK constraint не работает';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'OK: GPA CHECK constraint работает';
    END;
END $$;


-- ============================================
-- Результат
-- ============================================

SELECT 'ALL TESTS PASSED SUCCESSFULLY!' AS result;
