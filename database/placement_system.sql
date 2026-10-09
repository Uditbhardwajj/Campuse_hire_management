-- ==========================================================
-- College Placement and Internship Management System
-- Database: campus_hire_db
-- Developed with Core Java, Servlets, JSP and MySQL
-- ==========================================================

DROP DATABASE IF EXISTS campus_hire_db;
CREATE DATABASE campus_hire_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE campus_hire_db;

-- 1. Users Table (Core authentication for Admin, Student, and Company)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(64) NOT NULL,
    role ENUM('ADMIN', 'STUDENT', 'COMPANY') NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'PENDING') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Students Table
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    roll_no VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    cgpa DECIMAL(3, 2) NOT NULL DEFAULT 0.00,
    passing_year INT NOT NULL,
    phone VARCHAR(15),
    skills TEXT,
    resume_url VARCHAR(255),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. Companies Table
CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    company_name VARCHAR(100) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    website VARCHAR(150),
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    address TEXT,
    description TEXT,
    approval_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_companies_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Jobs Table
CREATE TABLE jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    title VARCHAR(120) NOT NULL,
    role_category VARCHAR(80) NOT NULL,
    job_type ENUM('FULL_TIME', 'PART_TIME', 'CONTRACT') DEFAULT 'FULL_TIME',
    description TEXT NOT NULL,
    requirements TEXT NOT NULL,
    min_cgpa DECIMAL(3, 2) DEFAULT 0.00,
    allowed_branches VARCHAR(255) DEFAULT 'All Branches',
    package_lpa DECIMAL(5, 2) NOT NULL,
    location VARCHAR(100) NOT NULL,
    openings INT DEFAULT 1,
    deadline DATE NOT NULL,
    status ENUM('OPEN', 'CLOSED') DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_jobs_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Internships Table
CREATE TABLE internships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    title VARCHAR(120) NOT NULL,
    role_category VARCHAR(80) NOT NULL,
    stipend_per_month DECIMAL(10, 2) NOT NULL,
    duration_months INT NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT NOT NULL,
    min_cgpa DECIMAL(3, 2) DEFAULT 0.00,
    allowed_branches VARCHAR(255) DEFAULT 'All Branches',
    location VARCHAR(100) NOT NULL,
    openings INT DEFAULT 1,
    deadline DATE NOT NULL,
    status ENUM('OPEN', 'CLOSED') DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_internships_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Applications Table
CREATE TABLE applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    posting_type ENUM('JOB', 'INTERNSHIP') NOT NULL,
    posting_id INT NOT NULL,
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'SHORTLISTED', 'INTERVIEW_SCHEDULED', 'ACCEPTED', 'REJECTED') DEFAULT 'PENDING',
    remarks VARCHAR(255) DEFAULT 'Application submitted and awaiting review',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT unique_application UNIQUE (student_id, posting_type, posting_id),
    CONSTRAINT fk_app_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ==========================================================
-- SAMPLE DATA INSERTIONS
-- Default Passwords:
-- admin     -> admin123   (SHA-256: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9)
-- students  -> student123 (SHA-256: 703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b)
-- companies -> company123 (SHA-256: 54e48cbd75ad8c2d3237b35a151ca891de8ebd4ec6d2a958a51121e074c1ba51)
-- ==========================================================

-- Admin User
INSERT INTO users (id, username, email, password_hash, role, status) VALUES
(1, 'admin', 'admin@college.edu', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN', 'ACTIVE');

-- Company Users
INSERT INTO users (id, username, email, password_hash, role, status) VALUES
(2, 'tcs_recruiter', 'hr@tcs-careers.com', '54e48cbd75ad8c2d3237b35a151ca891de8ebd4ec6d2a958a51121e074c1ba51', 'COMPANY', 'ACTIVE'),
(3, 'infosys_recruiter', 'campus@infosys.com', '54e48cbd75ad8c2d3237b35a151ca891de8ebd4ec6d2a958a51121e074c1ba51', 'COMPANY', 'ACTIVE'),
(4, 'techm_recruiter', 'careers@techmahindra.com', '54e48cbd75ad8c2d3237b35a151ca891de8ebd4ec6d2a958a51121e074c1ba51', 'COMPANY', 'ACTIVE');

-- Student Users
INSERT INTO users (id, username, email, password_hash, role, status) VALUES
(5, 'rahul.sharma', 'rahul.sharma@college.edu', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'STUDENT', 'ACTIVE'),
(6, 'priya.verma', 'priya.verma@college.edu', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'STUDENT', 'ACTIVE'),
(7, 'aman.gupta', 'aman.gupta@college.edu', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'STUDENT', 'ACTIVE'),
(8, 'sneha.patel', 'sneha.patel@college.edu', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'STUDENT', 'ACTIVE');

-- Company Profiles
INSERT INTO companies (id, user_id, company_name, industry, website, contact_person, phone, address, description, approval_status) VALUES
(1, 2, 'Tata Consultancy Services', 'IT & Software Services', 'https://www.tcs.com', 'Vikram Malhotra', '9876543210', 'TCS Olympus, Hiranandani, Mumbai', 'Leading global IT services, consulting, and business solutions organization.', 'APPROVED'),
(2, 3, 'Infosys Technologies', 'Information Technology', 'https://www.infosys.com', 'Anita Desai', '9823456781', 'Electronics City, Hosur Road, Bengaluru', 'Global leader in next-generation digital services and consulting.', 'APPROVED'),
(3, 4, 'Tech Mahindra', 'Telecom & Digital Solutions', 'https://www.techmahindra.com', 'Suresh Menon', '9811223344', 'Infocity, Sector 34, Gurugram', 'Digital transformation, consulting and business re-engineering services provider.', 'PENDING');

-- Student Profiles
INSERT INTO students (id, user_id, roll_no, first_name, last_name, department, cgpa, passing_year, phone, skills, resume_url, address) VALUES
(1, 5, '21CS101', 'Rahul', 'Sharma', 'Computer Science and Engineering', 8.65, 2026, '9988776655', 'Java, Spring Boot, MySQL, JavaScript, Git', 'https://drive.google.com/file/d/sample-resume-rahul', 'Hostel 3, Room 204, Campus'),
(2, 6, '21CS102', 'Priya', 'Verma', 'Computer Science and Engineering', 9.15, 2026, '9877001122', 'Core Java, Python, Machine Learning, SQL, React', 'https://drive.google.com/file/d/sample-resume-priya', 'B-12, Green Park Extension, City'),
(3, 7, '21IT105', 'Aman', 'Gupta', 'Information Technology', 7.80, 2026, '9765432109', 'Java, HTML/CSS, Servlets, Oracle, Linux', 'https://drive.google.com/file/d/sample-resume-aman', 'Hostel 1, Room 112, Campus'),
(4, 8, '21EC110', 'Sneha', 'Patel', 'Electronics and Communication', 8.25, 2026, '9822334455', 'Embedded C, Java, IoT, Verilog, SQL', 'https://drive.google.com/file/d/sample-resume-sneha', 'C-404, Sunrise Apartments, City');

-- Job Postings
INSERT INTO jobs (id, company_id, title, role_category, job_type, description, requirements, min_cgpa, allowed_branches, package_lpa, location, openings, deadline, status) VALUES
(1, 1, 'Associate Software Engineer', 'Software Engineering', 'FULL_TIME',
 'Looking for passionate software engineers to develop robust enterprise solutions in Core Java and cloud platforms.',
 'Strong fundamentals in OOP, Core Java, Data Structures, Algorithms and RDBMS. Good problem solving and communication skills.',
 7.00, 'CSE, IT, ECE', 7.20, 'Bengaluru / Pune', 15, '2026-11-30', 'OPEN'),

(2, 1, 'Digital System Engineer', 'Systems & Cloud', 'FULL_TIME',
 'High-growth role for engineering graduates focusing on enterprise application development, DevOps, and microservices.',
 'B.Tech with minimum 7.5 CGPA. Knowledge of Java, Web technologies, and SQL required.',
 7.50, 'CSE, IT', 9.00, 'Hyderabad', 8, '2026-12-15', 'OPEN'),

(3, 2, 'Systems Engineer - Java Development', 'Software Development', 'FULL_TIME',
 'Design, develop, and maintain high-performance web applications and backend batch processing systems.',
 'Proficiency in Core Java, JDBC, Servlets/JSP or modern Java web frameworks. Understanding of relational databases.',
 6.50, 'All Branches', 6.50, 'Mysuru / Bengaluru', 20, '2026-11-20', 'OPEN'),

(4, 2, 'Specialist Programmer', 'Product Development', 'FULL_TIME',
 'Elite coding role focusing on algorithm optimization, complex architecture, and next-generation software products.',
 'Outstanding algorithmic skills, competitive programming background, deep knowledge of Java or C++.',
 8.00, 'CSE, IT', 13.50, 'Bengaluru', 5, '2026-10-31', 'OPEN');

-- Internship Postings
INSERT INTO internships (id, company_id, title, role_category, stipend_per_month, duration_months, description, requirements, min_cgpa, allowed_branches, location, openings, deadline, status) VALUES
(1, 1, 'Java Full Stack Intern', 'Software Development', 25000.00, 6,
 'Six-month intensive internship on real-world client projects using Java, Web APIs, and relational databases. PPO opportunity based on performance.',
 'Basic understanding of Core Java, HTML, CSS, JavaScript, and SQL. Currently in 6th or 7th semester.',
 7.00, 'CSE, IT, ECE', 'Pune', 10, '2026-11-15', 'OPEN'),

(2, 2, 'Data Analytics & Web Intern', 'Data & Web', 22000.00, 6,
 'Work with our enterprise delivery unit on data pipelines, dashboard reporting, and web interfaces.',
 'Strong analytical skills, familiarity with SQL queries, Excel, and Java programming.',
 7.20, 'All Branches', 'Bengaluru (Hybrid)', 6, '2026-11-25', 'OPEN'),

(3, 1, 'Cloud Support Intern', 'Infrastructure & Cloud', 20000.00, 4,
 'Assist cloud architects in monitoring infrastructure, scripting automated jobs, and system administration.',
 'Basics of Linux, Networking, Java, and Shell scripting.',
 6.50, 'CSE, IT, ECE', 'Mumbai', 4, '2026-12-05', 'OPEN');

-- Sample Applications
INSERT INTO applications (id, student_id, posting_type, posting_id, applied_date, status, remarks) VALUES
(1, 1, 'JOB', 1, '2026-10-01 10:15:00', 'SHORTLISTED', 'Resume shortlisted. Technical round scheduled soon.'),
(2, 1, 'JOB', 3, '2026-10-02 11:30:00', 'PENDING', 'Application received and under review.'),
(3, 2, 'JOB', 2, '2026-10-01 14:00:00', 'ACCEPTED', 'Congratulations! Selected for Digital System Engineer role.'),
(4, 2, 'JOB', 4, '2026-10-03 09:45:00', 'INTERVIEW_SCHEDULED', 'Online technical assessment cleared. Interview on 12th Oct.'),
(5, 3, 'JOB', 1, '2026-10-02 16:20:00', 'REJECTED', 'Did not meet the technical cutoff in initial screening.'),
(6, 1, 'INTERNSHIP', 1, '2026-10-04 12:00:00', 'INTERVIEW_SCHEDULED', 'Interview scheduled for 15th October via Teams.'),
(7, 4, 'INTERNSHIP', 2, '2026-10-05 15:10:00', 'PENDING', 'Application under review by HR team.');
