

## 📚 Project Documentation

| Document | Description | Link |
|---|---|---|
| 📄 SRS Document | Software Requirements Specification | [View SRS](./CampusHire_SRS.pdf) |
| 📊 Project Presentation | Project PPT | [View PPT](./CampusHire_Presentation.pptx) |
| 📝 Research Paper | IEEE Research Paper | [View Paper](./CampusHire_IEEE_Paper.pdf) |
| 📘 Project Report | Complete project report | [View Report](./CampusHire%20Report.pdf) |




## 👥 Team Members and Responsibilities


| Team Member | GitHub Profile | Responsibility | Contribution Notes |
|---|---|---|---|
| Rahul Tailor | [GitHub](https://github.com/rahultailorofficial01) | Frontend Development: HTML, CSS, JavaScript | UI development and page design |
| Yash Kumar | [GitHub](https://github.com/yashkumar-25) | Project Documentation | SRS, research paper, PPT, and project report |
| Vaibhav Charan | [GitHub](https://github.com/vaibhavcharan5555-collab) | Java Backend Development: Servlet/JSP | Backend logic and request handling |
| Virendra Singh Chundawat | [GitHub](https://github.com/virendrasinghchundawat984) | Database Design and Connectivity: MySQL/JDBC | Database schema and connectivity |
| Udit Bhardwaj | [Github](https://github.com/Uditbhardwajj) | Testing, GitHub Management, and Integration | Testing, version control, repository management, and code integration |





# CampusHire - College Placement and Internship Management System

CampusHire is a Java-based web application designed to bring students, recruiters, and a college's Training and Placement Office (TPO) together in one portal. It supports job and internship postings, student applications, and role-based access for students, companies, and administrators.

## Features

### Student
- Register and manage an academic profile.
- Browse job and internship opportunities.
- Review eligibility requirements such as CGPA and department.
- Apply for opportunities and check application status.

### Company / Recruiter
- Register and maintain company details.
- Post jobs and internships.
- Review applicants and update application statuses.

### TPO / Administrator
- Access administrative pages for managing students, companies, postings, and applications.
- Review company registrations and recruitment activity.
- View placement-related reports, where supported by the application.

> The available features depend on the current implementation. Check the application itself before describing any feature as complete.

## Technologies Used

| Technology | Purpose |
|---|---|
| Java | Application logic |
| Servlets and JSP | Request handling and dynamic web pages |
| JDBC | Connecting Java code to the database |
| MySQL | Relational database |
| HTML, CSS and JavaScript | User interface |
| Apache Tomcat | Servlet container and web server |
| Maven | Project and dependency configuration |
| Git and GitHub | Version control and source hosting |

## System Architecture

The application is organized around an MVC-style structure, with Servlets handling requests, JSP pages rendering views, DAO classes managing database access, and MySQL storing application data.

```text
Browser (HTML, CSS, JavaScript)
              |
          HTTP request
              v
      Servlets / Filters
       (controllers)
              |
       Model and DAO classes
              |
            JDBC
              |
          MySQL DB
```

- **View:** JSP pages and frontend assets.
- **Controller:** Servlets process user requests.
- **Data access:** DAO classes perform database operations using JDBC.
- **Authentication:** Sessions and `AuthFilter` are used for login state and role-based access.

## Project Structure

```text
campushire/
├── pom.xml
├── build.bat
├── build.ps1
├── start-tomcat.bat
├── stop-tomcat.bat
├── database/
│   └── placement_system.sql
└── src/
    └── main/
        ├── java/com/placement/
        │   ├── model/       # Application model classes
        │   ├── dao/         # JDBC data-access classes
        │   ├── util/        # Database and utility classes
        │   ├── filter/      # Authentication/role filter
        │   └── servlet/     # Request controllers
        ├── resources/
        │   └── db.properties
        └── webapp/
            ├── WEB-INF/
            │   └── views/   # Role-specific JSP pages
            ├── css/
            ├── js/
            ├── includes/
            ├── index.jsp
            ├── login.jsp
            └── register.jsp
```

Some files and directories may change as the project develops.

## Database Overview

The database is named `campus_hire_db`. The current project documentation identifies these main tables:

- **`users`** — account details, role, status, and password hash.
- **`students`** — student academic and contact information.
- **`companies`** — recruiter and company information.
- **`jobs`** — job postings and eligibility details.
- **`internships`** — internship postings and eligibility details.
- **`applications`** — student applications and their statuses.

The schema and sample data are provided in `database/placement_system.sql`. Review that SQL file for the exact columns, constraints, and relationships used by the current version.

## Authentication and Security Notes

- The application uses Servlet sessions to maintain login state.
- `AuthFilter` is intended to restrict access to role-specific areas.
- The current password utility is documented as using SHA-256 hashing.

**Security note:** Plain SHA-256 is not recommended for production password storage because it is fast and does not provide password-specific salting by itself. For a production deployment, use a password-hashing algorithm designed for passwords, such as Argon2id, bcrypt, or PBKDF2. Do not publish real credentials, database passwords, or private configuration files.

## Requirements

- A compatible JDK (use the version supported by the project configuration).
- Apache Tomcat 10.1.x, if the application uses the Jakarta Servlet APIs.
- MySQL Server 8.0 or a compatible version.
- MySQL Connector/J.
- A modern web browser.
- Maven, if using the Maven build configuration.

## Run Locally

### 1. Set up the database

1. Start MySQL.
2. Open MySQL Workbench or the MySQL command-line client.
3. Execute the SQL script at `database/placement_system.sql`.

For the MySQL command-line client, use the path to the script on **your own computer**. For example:

```sql
SOURCE /path/to/campushire/database/placement_system.sql;
```

Replace the example path with the actual location of your project. The path should not be copied literally.

### 2. Configure database access

Open `src/main/resources/db.properties` and set the connection details for your local MySQL installation. For example:

```properties
db.url=jdbc:mysql://localhost:3306/campus_hire_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.user=root
db.password=YOUR_LOCAL_MYSQL_PASSWORD
```

Use your own local credentials. Do not commit a file containing a real password to a public repository.

### 3. Build and deploy

Use the build method supported by your project. The repository includes `build.bat` and `build.ps1`; check those scripts and `pom.xml` for the exact build and deployment steps. If using the PowerShell script, run it from the project directory:

```powershell
.\build.ps1
```

### 4. Start Tomcat and open the application

Start Tomcat using your configured installation or the provided `start-tomcat.bat` helper. Then open the context path configured for the deployed application. If the WAR is deployed as `placement.war`, the URL is typically:

```text
http://localhost:8080/placement/
```

If this URL does not work, check the WAR filename, Tomcat port, deployment logs, and context path.

## Screenshots

Add screenshots of the actual application here when available. Useful examples include the login page, student dashboard, job listings, recruiter pages, and admin dashboard.

## Future Enhancements

Possible future improvements include:

- Use a dedicated password-hashing algorithm such as bcrypt, Argon2id, or PBKDF2.
- Add email notifications for application status changes.
- Improve resume upload and management.
- Add advanced job and internship search filters.
- Improve placement analytics and reporting.
- Deploy the application to a secure public hosting environment.

Only list an item as a completed feature once it has been implemented and tested.

## Project Progress Report

The 12-week project report should be maintained as a separate document so the README remains focused on explaining the software. Add a link here after creating and committing a file such as `PROJECT_REPORT.md`.
