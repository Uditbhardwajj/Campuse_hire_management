# CampusHire - College Placement and Internship Management System

A complete, professional web application developed strictly using **Core Java, Servlets, JDBC, JSP, MySQL, and Apache Tomcat**. Designed specifically to meet and exceed 3rd-year B.Tech computer science curriculum standards while remaining 100% understandable and explainable in a project demonstration and viva.

---

## 🎯 1. What the Project Does

**CampusHire** is an automated campus recruitment portal for colleges and universities. It replaces traditional manual placement processes (spreadsheets, paper resumes, chaotic notice boards) with a centralized, role-based platform that connects:
1. **Students**: Create profiles, check eligibility against company criteria (CGPA cutoff & department), browse job and internship opportunities, apply with a single click, and track application stages in real-time.
2. **Corporate Recruiters / Companies**: Register organization details, publish recruitment drives (jobs & internships), review applicant resumes and academics, and update hiring stages (`PENDING`, `SHORTLISTED`, `INTERVIEW_SCHEDULED`, `ACCEPTED`, `REJECTED`).
3. **Training & Placement Office (TPO / Admin)**: Supervise the entire campus hiring lifecycle, verify and approve corporate registrations, moderate postings, audit applications, and generate department-wise placement reports.

---

## 🔄 2. How the Complete System Works (Architecture)

The system follows a classic, clean **Model-View-Controller (MVC)** architectural design:

```
+-------------------------------------------------------------+
|                     Client Browser                          |
|         (HTML5, CSS3, JavaScript, Responsive UI)           |
+-------------------------------------------------------------+
                              |
                     HTTP GET / POST
                              v
+-------------------------------------------------------------+
|                 Servlet Container (Tomcat 10)               |
|                                                             |
|   1. AuthFilter (Intercepts protected role URLs)            |
|   2. Controller Servlets (Login, Register, Student, etc.)   |
|   3. HttpSession Management (User session & roles)          |
+-------------------------------------------------------------+
                              |
               Invokes Business & Data Access Logic
                              v
+-------------------------------------------------------------+
|              Data Access Layer (DAO Pattern)                |
|    (UserDAO, StudentDAO, CompanyDAO, JobDAO, AppDAO)        |
+-------------------------------------------------------------+
                              |
                 Standard JDBC API Calls
               (Connection, PreparedStatement)
                              v
+-------------------------------------------------------------+
|               MySQL Relational Database                     |
|                   (campus_hire_db)                          |
+-------------------------------------------------------------+
```

---

## 💻 3. Required Software

- **Java Development Kit (JDK)**: JDK 17, 21, or 25.
- **Web Server**: Apache Tomcat 10.1.x (Jakarta EE 10 compliant).
- **Database**: MySQL Server 8.0+.
- **Database Driver**: MySQL Connector/J (`mysql-connector-j-8.x.x.jar`).
- **Web Browser**: Chrome, Edge, Firefox, or Safari.

---

## 📁 4. Project Folder Structure

```
campushire/
│
├── pom.xml                                   # Standard Maven configuration
├── build.bat                                 # Windows 1-click build and deploy
├── build.ps1                                 # PowerShell build automation script
├── start-tomcat.bat                          # Helper to launch Apache Tomcat
├── stop-tomcat.bat                           # Helper to stop Apache Tomcat
│
├── database/
│   └── placement_system.sql                  # Database schema & sample dataset
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/placement/
│       │       ├── model/                    # Java POJO Model Classes
│       │       │   ├── User.java
│       │       │   ├── Student.java
│       │       │   ├── Company.java
│       │       │   ├── Job.java
│       │       │   ├── Internship.java
│       │       │   ├── Application.java
│       │       │   └── DashboardStats.java
│       │       ├── dao/                      # Data Access Objects (JDBC)
│       │       │   ├── UserDAO.java
│       │       │   ├── StudentDAO.java
│       │       │   ├── CompanyDAO.java
│       │       │   ├── JobDAO.java
│       │       │   ├── InternshipDAO.java
│       │       │   └── ApplicationDAO.java
│       │       ├── util/                     # Connection & Security Utilities
│       │       │   ├── DBConnection.java
│       │       │   └── PasswordUtil.java
│       │       ├── filter/                   # Authentication & RBAC Filter
│       │       │   └── AuthFilter.java
│       │       └── servlet/                  # HTTP Request Controllers
│       │           ├── LoginServlet.java
│       │           ├── LogoutServlet.java
│       │           ├── RegisterServlet.java
│       │           ├── StudentServlet.java
│       │           ├── CompanyServlet.java
│       │           └── AdminServlet.java
│       │
│       ├── resources/
│       │   └── db.properties                 # MySQL configuration file
│       │
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml                   # Web application deployment descriptor
│           │   ├── lib/                      # mysql-connector-j.jar
│           │   └── views/                    # Protected JSP Pages
│           │       ├── student/
│           │       │   ├── dashboard.jsp
│           │       │   ├── profile.jsp
│           │       │   ├── jobs.jsp
│           │       │   ├── internships.jsp
│           │       │   ├── view-job.jsp
│           │       │   ├── view-internship.jsp
│           │       │   └── my-applications.jsp
│           │       ├── company/
│           │       │   ├── dashboard.jsp
│           │       │   ├── profile.jsp
│           │       │   ├── post-job.jsp
│           │       │   ├── post-internship.jsp
│           │       │   ├── manage-postings.jsp
│           │       │   └── applicants.jsp
│           │       └── admin/
│           │           ├── dashboard.jsp
│           │           ├── students.jsp
│           │           ├── companies.jsp
│           │           ├── postings.jsp
│           │           ├── applications.jsp
│           │           └── reports.jsp
│           │
│           ├── css/
│           │   └── style.css                 # Clean, responsive CSS styling
│           ├── js/
│           │   └── main.js                   # UI script (tabs, modal dialogs)
│           ├── includes/                     # Reusable JSP header/footer components
│           │   ├── header.jsp
│           │   ├── navbar.jsp
│           │   ├── alerts.jsp
│           │   └── footer.jsp
│           ├── index.jsp                     # Public Portal Landing Page
│           ├── login.jsp                     # Multi-role Login Page
│           ├── register.jsp                  # Role Selection Page
│           ├── student-register.jsp          # Student Signup Form
│           └── company-register.jsp          # Recruiter Signup Form
```

---

## 🗄️ 5. Database Schema & Relationships

The database `campus_hire_db` contains 6 relational tables with foreign keys and cascade rules:

1. **`users`**: Base credentials for all roles (`id`, `username`, `email`, `password_hash`, `role` [ADMIN/STUDENT/COMPANY], `status`, `created_at`).
2. **`students`**: Academic profile (`id`, `user_id` -> `users.id`, `roll_no`, `first_name`, `last_name`, `department`, `cgpa`, `passing_year`, `skills`, `resume_url`, `phone`, `address`).
3. **`companies`**: Recruiter profile (`id`, `user_id` -> `users.id`, `company_name`, `industry`, `website`, `contact_person`, `phone`, `address`, `approval_status` [PENDING/APPROVED/REJECTED]).
4. **`jobs`**: Full-time postings (`id`, `company_id` -> `companies.id`, `title`, `role_category`, `job_type`, `description`, `requirements`, `min_cgpa`, `allowed_branches`, `package_lpa`, `location`, `openings`, `deadline`, `status`).
5. **`internships`**: Internship postings (`id`, `company_id` -> `companies.id`, `title`, `role_category`, `stipend_per_month`, `duration_months`, `description`, `requirements`, `min_cgpa`, `allowed_branches`, `location`, `openings`, `deadline`, `status`).
6. **`applications`**: Application records (`id`, `student_id` -> `students.id`, `posting_type` [JOB/INTERNSHIP], `posting_id`, `applied_date`, `status` [PENDING/SHORTLISTED/INTERVIEW_SCHEDULED/ACCEPTED/REJECTED], `remarks`, `updated_at`).
   - Includes unique constraint: `UNIQUE (student_id, posting_type, posting_id)` preventing duplicate applications.

---

## 🔐 6. Authentication & Password Security

- **No Frameworks**: Uses purely `java.security.MessageDigest` and `jakarta.servlet.http.HttpSession`.
- **SHA-256 Hashing**: Passwords entered by users are transformed into 64-character hexadecimal SHA-256 hashes via `PasswordUtil.hashPassword()`. Plaintext passwords are never stored in the database.
- **Role-Based Access Control (`AuthFilter`)**:
  - Intercepts all requests.
  - Ensures unauthenticated visitors cannot access `/student/*`, `/company/*`, or `/admin/*`.
  - Verifies that logged-in users only access their assigned role's area (e.g. a Student cannot access `/admin/*` or `/company/*`).
- **Session Attributes**:
  - `user`: Authenticated User object.
  - `role`: Role string (`STUDENT`, `COMPANY`, `ADMIN`).
  - `fullName`: Display name for navbar.
  - `studentId` or `companyId`: Entity ID for fast relational queries.

---



## 🚀 8. How to Run the Project Locally

### Step 1: Initialize Database
Open MySQL Command Line or MySQL Workbench:
```sql
SOURCE C:/Users/VIRENDRA SINGH/Downloads/campushire/database/placement_system.sql;
```

### Step 2: Configure Database Credentials
Open `src/main/resources/db.properties` and verify your MySQL credentials:
```properties
db.url=jdbc:mysql://localhost:3306/campus_hire_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.user=root
db.password=YourMySQLPassword
```

### Step 3: Build & Deploy
Run `build.bat` (or in PowerShell run `.\build.ps1`):
```powershell
.\build.ps1
```
This automatically:
- Compiles all 22 Java source files using `javac`.
- Copies `db.properties` into `WEB-INF/classes`.
- Bundles the `.war` archive (`target/placement.war`).
- Copies `placement.war` directly into your Tomcat `webapps/` folder.

### Step 4: Start Apache Tomcat
Double-click `start-tomcat.bat` (or execute `catalina.bat run` in Tomcat's `bin` folder).

### Step 5: Open in Browser
Visit:
```
http://localhost:8080/placement/
```

---

