-- ============================================
-- Тесты DDL для SQL Homework
-- ============================================

-- ============================================
-- 1. Проверка существования таблиц
-- ============================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'departments'
    ) THEN
        RAISE EXCEPTION 'ТЕСТ СӘТСІЗ: departments кестесі жоқ';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'teachers'
    ) THEN
        RAISE EXCEPTION 'ТЕСТ СӘТСІЗ: teachers кестесі жоқ';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'students'
    ) THEN
        RAISE EXCEPTION 'ТЕСТ СӘТСІЗ: students кестесі жоқ';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'courses'
    ) THEN
        RAISE EXCEPTION 'ТЕСТ СӘТСІЗ: courses кестесі жоқ';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_name = 'enrollments'
    ) THEN
        RAISE EXCEPTION 'ТЕСТ СӘТСІЗ: enrollments кестесі жоқ';
    END IF;

    RAISE NOTICE 'OK: Барлық қажетті кестелер бар';
END $$;


-- ============================================
-- 2. assert функциясы
-- ============================================

CREATE OR REPLACE FUNCTION assert(
    condition BOOLEAN,
    message TEXT
)
RETURNS VOID AS $$
BEGIN
    IF NOT condition THEN
        RAISE EXCEPTION 'ТЕСТ СӘТСІЗ: %', message;
    END IF;

    RAISE NOTICE 'OK: %', message;
END;
$$ LANGUAGE plpgsql;


-- ============================================
-- 3. students кестесіндегі бағандарды тексеру
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'students'
          AND column_name = 'gpa'
    ),
    'students.gpa бағаны бар'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'students'
          AND column_name = 'department_id'
    ),
    'students.department_id бағаны бар'
);


-- ============================================
-- 4. enrollments.grade бағанын тексеру
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'enrollments'
          AND column_name = 'grade'
    ),
    'enrollments.grade бағаны бар'
);


-- ============================================
-- 5. PRIMARY KEY тексеру
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
          AND table_name = 'departments'
          AND constraint_type = 'PRIMARY KEY'
    ),
    'departments PRIMARY KEY бар'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
          AND table_name = 'students'
          AND constraint_type = 'PRIMARY KEY'
    ),
    'students PRIMARY KEY бар'
);


-- ============================================
-- 6. FOREIGN KEY тексеру
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
          AND table_name = 'students'
          AND constraint_type = 'FOREIGN KEY'
    ),
    'students FOREIGN KEY бар'
);

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
          AND table_name = 'enrollments'
          AND constraint_type = 'FOREIGN KEY'
    ),
    'enrollments FOREIGN KEY бар'
);


-- ============================================
-- 7. UNIQUE тексеру
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE table_schema = 'public'
          AND table_name = 'teachers'
          AND constraint_type = 'UNIQUE'
    ),
    'teachers UNIQUE constraint бар'
);


-- ============================================
-- 8. CHECK constraint тексеру
-- ============================================

SELECT assert(
    EXISTS (
        SELECT 1
        FROM information_schema.table_constraints tc
        JOIN information_schema.constraint_column_usage ccu
          ON tc.constraint_name = ccu.constraint_name
        WHERE tc.table_schema = 'public'
          AND tc.table_name = 'students'
          AND tc.constraint_type = 'CHECK'
          AND ccu.column_name = 'gpa'
    ),
    'students.gpa CHECK constraint бар'
);


-- ============================================
-- 9. Тесттік department қосу
-- ============================================

INSERT INTO departments
    (dept_name, dean_name, established_year, building)
VALUES
    ('Тест факультеті', 'Тест Декан', 2000, 'А корпусы');


-- ============================================
-- 10. GPA CHECK constraint тесті
-- ============================================

DO $$
BEGIN

    BEGIN

        INSERT INTO students
            (
                first_name,
                last_name,
                birth_date,
                admission_year,
                gpa,
                department_id
            )
        SELECT
            'Тест',
            'Студент',
            '2000-01-01',
            2023,
            9.99,
            department_id
        FROM departments
        LIMIT 1;

        RAISE EXCEPTION
            'ТЕСТ СӘТСІЗ: GPA CHECK constraint 9.99 мәнін қабылдады';

    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE
                'OK: GPA CHECK constraint 9.99 мәнін дұрыс қабылдамады';
    END;

END $$;


-- ============================================
-- Барлық тесттер аяқталды
-- ============================================

DO $$
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE 'БАРЛЫҚ SQL ТЕСТТЕР СӘТТІ ӨТТІ!';
    RAISE NOTICE '============================================';
END $$;