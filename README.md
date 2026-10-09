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

## 🔑 7. Demo Accounts for Project Demonstration & Viva

| Role | Username | Password | Notes |
|---|---|---|---|
| **Admin (TPO)** | `admin` | `admin123` | Full administrative control, company approvals, reports |
| **Student** | `rahul.sharma` | `student123` | CSE student (CGPA: 8.65), pre-seeded applications |
| **Student** | `priya.verma` | `student123` | CSE student (CGPA: 9.15), placed candidate |
| **Company** | `tcs_recruiter` | `company123` | Approved recruiter (Tata Consultancy Services) |
| **Company** | `infosys_recruiter` | `company123` | Approved recruiter (Infosys) |
| **Company** | `techm_recruiter` | `company123` | Pending recruiter (Tech Mahindra - test Admin approval) |

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

## 🌐 9. How to Deploy Online and Get a Public URL

To share your working project with evaluators, professors, or team members online:

### Option A: Free Public Tunnel (Fastest & Easiest for Demos - 2 minutes)
Keep your local Tomcat server running and expose it via **ngrok** or **localtunnel**:
1. Download [ngrok](https://ngrok.com/) or run in terminal:
   ```cmd
   npx localtunnel --port 8080
   ```
2. Localtunnel immediately generates a public HTTPS URL like:
   `https://campus-hire-portal.loca.lt/placement/`
3. Anyone with this link can open your live web application directly in their browser!

### Option B: Cloud Hosting (Render / Railway / AWS EC2)
1. **Database**: Use a free cloud MySQL instance on **Aiven**, **Railway**, or **Clever Cloud**.
2. **Web Server**: Deploy a standard Docker container running Tomcat 10:
   ```dockerfile
   FROM tomcat:10.1-jdk17
   COPY target/placement.war /usr/local/tomcat/webapps/ROOT.war
   EXPOSE 8080
   CMD ["catalina.sh", "run"]
   ```
3. Update `db.properties` with the cloud database URL.
4. Push to GitHub and deploy to Render or Railway to get an address like `https://campushire.onrender.com`.

---

## 🎓 10. Frequently Asked Viva Questions & Answers

### Q1: Why did you use Servlets and JSP instead of Spring Boot?
**Answer**: "Spring Boot abstracts away the fundamental mechanisms of web request handling, inversion of control, and session lifecycle. Building the system using Core Java Servlets, JSP, and JDBC demonstrates a direct understanding of how HTTP requests map to Servlets, how the Servlet lifecycle operates (`init`, `service`, `destroy`), how `HttpSession` cookies work under the hood, and how raw SQL statements are safely executed via JDBC `PreparedStatement`."

### Q2: What is MVC architecture and how is it implemented in your project?
**Answer**:
- **Model**: Java POJO classes (`User`, `Student`, `Job`, etc.) representing real-world business entities.
- **View**: JSP pages located inside `WEB-INF/views/` that render the user interface using HTML, CSS, and dynamic Java expressions.
- **Controller**: Java Servlets (`LoginServlet`, `StudentServlet`, `CompanyServlet`, `AdminServlet`) that intercept HTTP requests, validate input, call the appropriate DAO methods, attach results to the request scope, and forward the request to the view.

### Q3: Why are JSPs placed in `WEB-INF/views/`?
**Answer**: "Files inside the `WEB-INF` folder are protected by the Servlet specification from direct URL access. A client cannot type `/placement/WEB-INF/views/student/dashboard.jsp` to bypass business logic and access control. Only the Controller Servlets can forward requests to these pages using `request.getRequestDispatcher().forward(request, response)`."

### Q4: How do you prevent SQL Injection?
**Answer**: "By exclusively using `PreparedStatement` with parameterized placeholders (`?`) instead of string concatenation. The JDBC driver pre-compiles the SQL command and treats user input strictly as literal parameter data, ensuring malicious SQL input can never alter query execution structure."

### Q5: How does session management work without Spring Security?
**Answer**: "When a user logs in successfully, `req.getSession(true)` creates an `HttpSession` managed by Apache Tomcat. Tomcat assigns a unique session identifier stored in the client's browser as a `JSESSIONID` cookie. The `AuthFilter` intercepts subsequent requests, retrieves the session using `req.getSession(false)`, inspects the logged-in `User` and `role` attributes, and either permits access or redirects unauthorized users to `login.jsp`."
