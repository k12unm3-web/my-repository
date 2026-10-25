CREATE TABLE departments (
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE users (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    login_id      VARCHAR(50)  NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    display_name  VARCHAR(100) NOT NULL,
    email         VARCHAR(255),
    role          VARCHAR(20)  NOT NULL CHECK (role IN ('STUDENT', 'STAFF', 'ADMIN')),
    department_id BIGINT REFERENCES departments (id),
    grade         SMALLINT CHECK (grade BETWEEN 1 AND 6),
    enabled       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT chk_student_affiliation
        CHECK (role <> 'STUDENT' OR (department_id IS NOT NULL AND grade IS NOT NULL))
);

CREATE INDEX idx_users_department_grade ON users (department_id, grade);