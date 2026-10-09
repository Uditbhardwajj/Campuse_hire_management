package com.placement.servlet;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.CompanyDAO;
import com.placement.dao.InternshipDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Company;
import com.placement.model.DashboardStats;
import com.placement.model.Internship;
import com.placement.model.Job;
import com.placement.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/*"})
public class AdminServlet extends HttpServlet {

    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;
    private JobDAO jobDAO;
    private InternshipDAO internshipDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
        jobDAO = new JobDAO();
        internshipDAO = new InternshipDAO();
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard";
        }

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(req, resp);
                break;
            case "/students":
                showStudents(req, resp);
                break;
            case "/companies":
                showCompanies(req, resp);
                break;
            case "/postings":
                showPostings(req, resp);
                break;
            case "/applications":
                showApplications(req, resp);
                break;
            case "/reports":
                showReports(req, resp);
                break;
            case "/approve-company":
                handleApproveCompany(req, resp);
                break;
            case "/delete-student":
                handleDeleteStudent(req, resp);
                break;
            case "/delete-company":
                handleDeleteCompany(req, resp);
                break;
            case "/delete-posting":
                handleDeletePosting(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if ("/update-app-status".equals(pathInfo)) {
            int appId = Integer.parseInt(req.getParameter("applicationId"));
            String status = req.getParameter("status");
            String remarks = req.getParameter("remarks");
            applicationDAO.updateStatus(appId, status, remarks);
            resp.sendRedirect(req.getContextPath() + "/admin/applications?msg=Application status updated successfully!");
        } else {
            doGet(req, resp);
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DashboardStats stats = applicationDAO.getStats();
        List<Company> allCompanies = companyDAO.getAllCompanies();
        List<Application> recentApps = applicationDAO.getAllApplications();
        if (recentApps.size() > 6) {
            recentApps = recentApps.subList(0, 6);
        }

        req.setAttribute("stats", stats);
        req.setAttribute("companies", allCompanies);
        req.setAttribute("recentApps", recentApps);
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void showStudents(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String dept = req.getParameter("department");

        List<Student> students;
        if ((keyword != null && !keyword.trim().isEmpty()) || (dept != null && !dept.trim().isEmpty())) {
            students = studentDAO.searchStudents(keyword, dept);
        } else {
            students = studentDAO.getAllStudents();
        }

        req.setAttribute("students", students);
        req.setAttribute("keyword", keyword);
        req.setAttribute("department", dept);
        req.getRequestDispatcher("/WEB-INF/views/admin/students.jsp").forward(req, resp);
    }

    private void showCompanies(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Company> companies = companyDAO.getAllCompanies();
        req.setAttribute("companies", companies);
        req.getRequestDispatcher("/WEB-INF/views/admin/companies.jsp").forward(req, resp);
    }

    private void showPostings(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Job> jobs = jobDAO.getAllJobsForAdmin();
        List<Internship> internships = internshipDAO.getAllInternshipsForAdmin();
        req.setAttribute("jobs", jobs);
        req.setAttribute("internships", internships);
        req.getRequestDispatcher("/WEB-INF/views/admin/postings.jsp").forward(req, resp);
    }

    private void showApplications(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Application> applications = applicationDAO.getAllApplications();
        req.setAttribute("applications", applications);
        req.getRequestDispatcher("/WEB-INF/views/admin/applications.jsp").forward(req, resp);
    }

    private void showReports(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DashboardStats stats = applicationDAO.getStats();
        List<Application> applications = applicationDAO.getAllApplications();
        List<Student> students = studentDAO.getAllStudents();

        req.setAttribute("stats", stats);
        req.setAttribute("applications", applications);
        req.setAttribute("students", students);
        req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);
    }

    private void handleApproveCompany(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int companyId = Integer.parseInt(req.getParameter("id"));
        String status = req.getParameter("status"); // APPROVED or REJECTED

        companyDAO.updateApprovalStatus(companyId, status);
        resp.sendRedirect(req.getContextPath() + "/admin/companies?msg=Company status changed to " + status);
    }

    private void handleDeleteStudent(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int studentId = Integer.parseInt(req.getParameter("id"));
        studentDAO.deleteStudent(studentId);
        resp.sendRedirect(req.getContextPath() + "/admin/students?msg=Student removed successfully.");
    }

    private void handleDeleteCompany(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int companyId = Integer.parseInt(req.getParameter("id"));
        companyDAO.deleteCompany(companyId);
        resp.sendRedirect(req.getContextPath() + "/admin/companies?msg=Company account deleted.");
    }

    private void handleDeletePosting(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String type = req.getParameter("type");
        int id = Integer.parseInt(req.getParameter("id"));
        if ("JOB".equalsIgnoreCase(type)) {
            jobDAO.deleteJob(id);
        } else {
            internshipDAO.deleteInternship(id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/postings?msg=Posting removed successfully.");
    }
}
