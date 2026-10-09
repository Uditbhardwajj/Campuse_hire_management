package com.placement.servlet;

import com.placement.dao.CompanyDAO;
import com.placement.dao.StudentDAO;
import com.placement.dao.UserDAO;
import com.placement.model.Company;
import com.placement.model.Student;
import com.placement.model.User;
import com.placement.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;
    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        if ("company".equalsIgnoreCase(type)) {
            req.getRequestDispatcher("/company-register.jsp").forward(req, resp);
        } else if ("student".equalsIgnoreCase(type)) {
            req.getRequestDispatcher("/student-register.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = req.getParameter("role");

        if ("STUDENT".equalsIgnoreCase(role)) {
            handleStudentRegistration(req, resp);
        } else if ("COMPANY".equalsIgnoreCase(role)) {
            handleCompanyRegistration(req, resp);
        } else {
            req.setAttribute("errorMessage", "Invalid registration type.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }

    private void handleStudentRegistration(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String rollNo = req.getParameter("rollNo");
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String department = req.getParameter("department");
        String cgpaStr = req.getParameter("cgpa");
        String passingYearStr = req.getParameter("passingYear");
        String phone = req.getParameter("phone");
        String skills = req.getParameter("skills");
        String resumeUrl = req.getParameter("resumeUrl");
        String address = req.getParameter("address");

        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            rollNo == null || rollNo.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty()) {
            req.setAttribute("errorMessage", "All required fields must be filled.");
            req.getRequestDispatcher("/student-register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Password and Confirm Password do not match.");
            req.getRequestDispatcher("/student-register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.usernameExists(username.trim())) {
            req.setAttribute("errorMessage", "Username is already taken. Please choose another.");
            req.getRequestDispatcher("/student-register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.emailExists(email.trim())) {
            req.setAttribute("errorMessage", "Email is already registered. Please login instead.");
            req.getRequestDispatcher("/student-register.jsp").forward(req, resp);
            return;
        }

        double cgpa = 0.0;
        try {
            if (cgpaStr != null && !cgpaStr.trim().isEmpty()) {
                cgpa = Double.parseDouble(cgpaStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        int passingYear = 2026;
        try {
            if (passingYearStr != null && !passingYearStr.trim().isEmpty()) {
                passingYear = Integer.parseInt(passingYearStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        // Create user record
        User user = new User();
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPasswordHash(PasswordUtil.hashPassword(password.trim()));
        user.setRole("STUDENT");
        user.setStatus("ACTIVE");

        int userId = userDAO.createUser(user);
        if (userId <= 0) {
            req.setAttribute("errorMessage", "Failed to create user account. Please try again.");
            req.getRequestDispatcher("/student-register.jsp").forward(req, resp);
            return;
        }

        // Create student profile
        Student student = new Student();
        student.setUserId(userId);
        student.setRollNo(rollNo.trim().toUpperCase());
        student.setFirstName(firstName.trim());
        student.setLastName(lastName != null ? lastName.trim() : "");
        student.setDepartment(department != null ? department.trim() : "Computer Science");
        student.setCgpa(cgpa);
        student.setPassingYear(passingYear);
        student.setPhone(phone != null ? phone.trim() : "");
        student.setSkills(skills != null ? skills.trim() : "");
        student.setResumeUrl(resumeUrl != null ? resumeUrl.trim() : "");
        student.setAddress(address != null ? address.trim() : "");

        boolean success = studentDAO.createStudent(student);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=Student account registered successfully! You can now log in.");
        } else {
            req.setAttribute("errorMessage", "Failed to save student profile. Please contact the administrator.");
            req.getRequestDispatcher("/student-register.jsp").forward(req, resp);
        }
    }

    private void handleCompanyRegistration(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String companyName = req.getParameter("companyName");
        String industry = req.getParameter("industry");
        String website = req.getParameter("website");
        String contactPerson = req.getParameter("contactPerson");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String description = req.getParameter("description");

        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            companyName == null || companyName.trim().isEmpty() ||
            industry == null || industry.trim().isEmpty()) {
            req.setAttribute("errorMessage", "All mandatory company details must be provided.");
            req.getRequestDispatcher("/company-register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Passwords do not match.");
            req.getRequestDispatcher("/company-register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.usernameExists(username.trim())) {
            req.setAttribute("errorMessage", "Username already exists. Please pick another one.");
            req.getRequestDispatcher("/company-register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.emailExists(email.trim())) {
            req.setAttribute("errorMessage", "Company email is already registered.");
            req.getRequestDispatcher("/company-register.jsp").forward(req, resp);
            return;
        }

        // Create user
        User user = new User();
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPasswordHash(PasswordUtil.hashPassword(password.trim()));
        user.setRole("COMPANY");
        user.setStatus("ACTIVE");

        int userId = userDAO.createUser(user);
        if (userId <= 0) {
            req.setAttribute("errorMessage", "Could not create company account.");
            req.getRequestDispatcher("/company-register.jsp").forward(req, resp);
            return;
        }

        // Create company profile with PENDING status
        Company company = new Company();
        company.setUserId(userId);
        company.setCompanyName(companyName.trim());
        company.setIndustry(industry.trim());
        company.setWebsite(website != null ? website.trim() : "");
        company.setContactPerson(contactPerson != null ? contactPerson.trim() : "");
        company.setPhone(phone != null ? phone.trim() : "");
        company.setAddress(address != null ? address.trim() : "");
        company.setDescription(description != null ? description.trim() : "");
        company.setApprovalStatus("PENDING");

        boolean success = companyDAO.createCompany(company);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=Company registration submitted successfully! It will be reviewed by the TPO / Admin before you can sign in.");
        } else {
            req.setAttribute("errorMessage", "Could not complete company profile creation.");
            req.getRequestDispatcher("/company-register.jsp").forward(req, resp);
        }
    }
}
