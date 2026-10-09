package com.placement.servlet;

import com.placement.dao.CompanyDAO;
import com.placement.dao.StudentDAO;
import com.placement.dao.UserDAO;
import com.placement.model.Company;
import com.placement.model.Student;
import com.placement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

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
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectUserByRole(user.getRole(), req, resp);
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usernameOrEmail = req.getParameter("usernameOrEmail");
        String password = req.getParameter("password");
        String expectedRole = req.getParameter("role");

        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please provide both username/email and password.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(usernameOrEmail.trim(), password.trim());

        if (user == null) {
            req.setAttribute("errorMessage", "Invalid credentials. Please verify your username and password.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Validate role if specified by user login tab
        if (expectedRole != null && !expectedRole.trim().isEmpty() && !expectedRole.equalsIgnoreCase(user.getRole())) {
            req.setAttribute("errorMessage", "Account found, but role mismatch: you attempted to log in as " + expectedRole + ".");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Check if company account is pending approval
        if ("COMPANY".equalsIgnoreCase(user.getRole())) {
            Company company = companyDAO.getCompanyByUserId(user.getId());
            if (company != null && "PENDING".equalsIgnoreCase(company.getApprovalStatus())) {
                req.setAttribute("errorMessage", "Your company registration is pending approval by the Placement Cell.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            } else if (company != null && "REJECTED".equalsIgnoreCase(company.getApprovalStatus())) {
                req.setAttribute("errorMessage", "Your company registration was not approved. Please contact the administrator.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }
        }

        // Create Session
        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());

        if ("STUDENT".equalsIgnoreCase(user.getRole())) {
            Student student = studentDAO.getStudentByUserId(user.getId());
            if (student != null) {
                session.setAttribute("student", student);
                session.setAttribute("studentId", student.getId());
                session.setAttribute("fullName", student.getFullName());
            } else {
                session.setAttribute("fullName", user.getUsername());
            }
        } else if ("COMPANY".equalsIgnoreCase(user.getRole())) {
            Company company = companyDAO.getCompanyByUserId(user.getId());
            if (company != null) {
                session.setAttribute("company", company);
                session.setAttribute("companyId", company.getId());
                session.setAttribute("fullName", company.getCompanyName());
            } else {
                session.setAttribute("fullName", user.getUsername());
            }
        } else if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("fullName", "Placement Officer (Admin)");
        }

        redirectUserByRole(user.getRole(), req, resp);
    }

    private void redirectUserByRole(String role, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ctx = req.getContextPath();
        if ("STUDENT".equalsIgnoreCase(role)) {
            resp.sendRedirect(ctx + "/student/dashboard");
        } else if ("COMPANY".equalsIgnoreCase(role)) {
            resp.sendRedirect(ctx + "/company/dashboard");
        } else if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(ctx + "/admin/dashboard");
        } else {
            resp.sendRedirect(ctx + "/index.jsp");
        }
    }
}
