package com.placement.servlet;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.CompanyDAO;
import com.placement.dao.InternshipDAO;
import com.placement.dao.JobDAO;
import com.placement.model.Application;
import com.placement.model.Company;
import com.placement.model.Internship;
import com.placement.model.Job;
import com.placement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/company/*"})
public class CompanyServlet extends HttpServlet {

    private CompanyDAO companyDAO;
    private JobDAO jobDAO;
    private InternshipDAO internshipDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
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

        Company company = getLoggedInCompany(req);
        if (company == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Company profile not found. Please log in again.");
            return;
        }

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(company, req, resp);
                break;
            case "/profile":
                showProfile(company, req, resp);
                break;
            case "/post-job":
                req.setAttribute("company", company);
                req.getRequestDispatcher("/WEB-INF/views/company/post-job.jsp").forward(req, resp);
                break;
            case "/post-internship":
                req.setAttribute("company", company);
                req.getRequestDispatcher("/WEB-INF/views/company/post-internship.jsp").forward(req, resp);
                break;
            case "/manage-postings":
                showManagePostings(company, req, resp);
                break;
            case "/edit-job":
                showEditJob(company, req, resp);
                break;
            case "/edit-internship":
                showEditInternship(company, req, resp);
                break;
            case "/delete-posting":
                deletePosting(company, req, resp);
                break;
            case "/applicants":
                showApplicants(company, req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/company/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        Company company = getLoggedInCompany(req);
        if (company == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Session expired. Please log in again.");
            return;
        }

        if ("/profile".equals(pathInfo)) {
            updateProfile(company, req, resp);
        } else if ("/post-job".equals(pathInfo)) {
            handlePostJob(company, req, resp);
        } else if ("/post-internship".equals(pathInfo)) {
            handlePostInternship(company, req, resp);
        } else if ("/edit-job".equals(pathInfo)) {
            handleUpdateJob(company, req, resp);
        } else if ("/edit-internship".equals(pathInfo)) {
            handleUpdateInternship(company, req, resp);
        } else if ("/update-status".equals(pathInfo)) {
            handleUpdateStatus(company, req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/company/dashboard");
        }
    }

    private Company getLoggedInCompany(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        User user = (User) session.getAttribute("user");
        if (user == null) return null;
        return companyDAO.getCompanyByUserId(user.getId());
    }

    private void showDashboard(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Job> jobs = jobDAO.getJobsByCompanyId(company.getId());
        List<Internship> internships = internshipDAO.getInternshipsByCompanyId(company.getId());
        List<Application> applicants = applicationDAO.getApplicationsByCompanyId(company.getId());

        int totalJobs = jobs.size();
        int totalInternships = internships.size();
        int totalApplicants = applicants.size();

        int shortlistedCount = 0;
        int selectedCount = 0;
        for (Application a : applicants) {
            if ("SHORTLISTED".equalsIgnoreCase(a.getStatus()) || "INTERVIEW_SCHEDULED".equalsIgnoreCase(a.getStatus())) {
                shortlistedCount++;
            } else if ("ACCEPTED".equalsIgnoreCase(a.getStatus())) {
                selectedCount++;
            }
        }

        req.setAttribute("company", company);
        req.setAttribute("jobs", jobs);
        req.setAttribute("internships", internships);
        req.setAttribute("applicants", applicants);
        req.setAttribute("totalJobs", totalJobs);
        req.setAttribute("totalInternships", totalInternships);
        req.setAttribute("totalApplicants", totalApplicants);
        req.setAttribute("shortlistedCount", shortlistedCount);
        req.setAttribute("selectedCount", selectedCount);

        req.getRequestDispatcher("/WEB-INF/views/company/dashboard.jsp").forward(req, resp);
    }

    private void showProfile(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("company", company);
        req.getRequestDispatcher("/WEB-INF/views/company/profile.jsp").forward(req, resp);
    }

    private void updateProfile(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String companyName = req.getParameter("companyName");
        String industry = req.getParameter("industry");
        String website = req.getParameter("website");
        String contactPerson = req.getParameter("contactPerson");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String description = req.getParameter("description");

        if (companyName != null && !companyName.trim().isEmpty()) {
            company.setCompanyName(companyName.trim());
        }
        if (industry != null && !industry.trim().isEmpty()) {
            company.setIndustry(industry.trim());
        }
        company.setWebsite(website != null ? website.trim() : "");
        company.setContactPerson(contactPerson != null ? contactPerson.trim() : "");
        company.setPhone(phone != null ? phone.trim() : "");
        company.setAddress(address != null ? address.trim() : "");
        company.setDescription(description != null ? description.trim() : "");

        boolean ok = companyDAO.updateCompany(company);
        if (ok) {
            req.getSession().setAttribute("company", company);
            req.getSession().setAttribute("fullName", company.getCompanyName());
            req.setAttribute("successMessage", "Company profile updated successfully!");
        } else {
            req.setAttribute("errorMessage", "Failed to update profile.");
        }

        req.setAttribute("company", company);
        req.getRequestDispatcher("/WEB-INF/views/company/profile.jsp").forward(req, resp);
    }

    private void showManagePostings(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Job> jobs = jobDAO.getJobsByCompanyId(company.getId());
        List<Internship> internships = internshipDAO.getInternshipsByCompanyId(company.getId());

        req.setAttribute("company", company);
        req.setAttribute("jobs", jobs);
        req.setAttribute("internships", internships);
        req.getRequestDispatcher("/WEB-INF/views/company/manage-postings.jsp").forward(req, resp);
    }

    private void handlePostJob(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String title = req.getParameter("title");
        String roleCategory = req.getParameter("roleCategory");
        String jobType = req.getParameter("jobType");
        String description = req.getParameter("description");
        String requirements = req.getParameter("requirements");
        String minCgpaStr = req.getParameter("minCgpa");
        String allowedBranches = req.getParameter("allowedBranches");
        String packageLpaStr = req.getParameter("packageLpa");
        String location = req.getParameter("location");
        String openingsStr = req.getParameter("openings");
        String deadlineStr = req.getParameter("deadline");

        if (title == null || title.trim().isEmpty() || packageLpaStr == null || deadlineStr == null) {
            req.setAttribute("errorMessage", "Required fields are missing.");
            req.getRequestDispatcher("/WEB-INF/views/company/post-job.jsp").forward(req, resp);
            return;
        }

        Job job = new Job();
        job.setCompanyId(company.getId());
        job.setTitle(title.trim());
        job.setRoleCategory(roleCategory != null ? roleCategory.trim() : "Software");
        job.setJobType(jobType != null ? jobType.trim() : "FULL_TIME");
        job.setDescription(description != null ? description.trim() : "");
        job.setRequirements(requirements != null ? requirements.trim() : "");
        try {
            job.setMinCgpa(Double.parseDouble(minCgpaStr.trim()));
        } catch (Exception e) {
            job.setMinCgpa(6.0);
        }
        job.setAllowedBranches(allowedBranches != null ? allowedBranches.trim() : "All Branches");
        try {
            job.setPackageLpa(Double.parseDouble(packageLpaStr.trim()));
        } catch (Exception e) {
            job.setPackageLpa(5.0);
        }
        job.setLocation(location != null ? location.trim() : "Campus / Pan India");
        try {
            job.setOpenings(Integer.parseInt(openingsStr.trim()));
        } catch (Exception e) {
            job.setOpenings(1);
        }
        job.setDeadline(Date.valueOf(deadlineStr.trim()));
        job.setStatus("OPEN");

        boolean created = jobDAO.createJob(job);
        if (created) {
            resp.sendRedirect(req.getContextPath() + "/company/manage-postings?msg=Job posting created successfully!");
        } else {
            req.setAttribute("errorMessage", "Could not publish job posting.");
            req.getRequestDispatcher("/WEB-INF/views/company/post-job.jsp").forward(req, resp);
        }
    }

    private void handlePostInternship(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String title = req.getParameter("title");
        String roleCategory = req.getParameter("roleCategory");
        String stipendStr = req.getParameter("stipendPerMonth");
        String durationStr = req.getParameter("durationMonths");
        String description = req.getParameter("description");
        String requirements = req.getParameter("requirements");
        String minCgpaStr = req.getParameter("minCgpa");
        String allowedBranches = req.getParameter("allowedBranches");
        String location = req.getParameter("location");
        String openingsStr = req.getParameter("openings");
        String deadlineStr = req.getParameter("deadline");

        if (title == null || title.trim().isEmpty() || stipendStr == null || deadlineStr == null) {
            req.setAttribute("errorMessage", "Please complete all mandatory fields.");
            req.getRequestDispatcher("/WEB-INF/views/company/post-internship.jsp").forward(req, resp);
            return;
        }

        Internship internship = new Internship();
        internship.setCompanyId(company.getId());
        internship.setTitle(title.trim());
        internship.setRoleCategory(roleCategory != null ? roleCategory.trim() : "Engineering");
        try {
            internship.setStipendPerMonth(Double.parseDouble(stipendStr.trim()));
        } catch (Exception e) {
            internship.setStipendPerMonth(15000.0);
        }
        try {
            internship.setDurationMonths(Integer.parseInt(durationStr.trim()));
        } catch (Exception e) {
            internship.setDurationMonths(6);
        }
        internship.setDescription(description != null ? description.trim() : "");
        internship.setRequirements(requirements != null ? requirements.trim() : "");
        try {
            internship.setMinCgpa(Double.parseDouble(minCgpaStr.trim()));
        } catch (Exception e) {
            internship.setMinCgpa(6.0);
        }
        internship.setAllowedBranches(allowedBranches != null ? allowedBranches.trim() : "All Branches");
        internship.setLocation(location != null ? location.trim() : "Hybrid / Remote");
        try {
            internship.setOpenings(Integer.parseInt(openingsStr.trim()));
        } catch (Exception e) {
            internship.setOpenings(1);
        }
        internship.setDeadline(Date.valueOf(deadlineStr.trim()));
        internship.setStatus("OPEN");

        boolean created = internshipDAO.createInternship(internship);
        if (created) {
            resp.sendRedirect(req.getContextPath() + "/company/manage-postings?msg=Internship posting created successfully!");
        } else {
            req.setAttribute("errorMessage", "Could not publish internship posting.");
            req.getRequestDispatcher("/WEB-INF/views/company/post-internship.jsp").forward(req, resp);
        }
    }

    private void showEditJob(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        int id = Integer.parseInt(idStr);
        Job job = jobDAO.getJobById(id);
        if (job == null || job.getCompanyId() != company.getId()) {
            resp.sendRedirect(req.getContextPath() + "/company/manage-postings");
            return;
        }
        req.setAttribute("job", job);
        req.setAttribute("company", company);
        req.getRequestDispatcher("/WEB-INF/views/company/post-job.jsp").forward(req, resp);
    }

    private void handleUpdateJob(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Job job = jobDAO.getJobById(id);
        if (job == null || job.getCompanyId() != company.getId()) {
            resp.sendRedirect(req.getContextPath() + "/company/manage-postings");
            return;
        }

        job.setTitle(req.getParameter("title"));
        job.setRoleCategory(req.getParameter("roleCategory"));
        job.setJobType(req.getParameter("jobType"));
        job.setDescription(req.getParameter("description"));
        job.setRequirements(req.getParameter("requirements"));
        job.setMinCgpa(Double.parseDouble(req.getParameter("minCgpa")));
        job.setAllowedBranches(req.getParameter("allowedBranches"));
        job.setPackageLpa(Double.parseDouble(req.getParameter("packageLpa")));
        job.setLocation(req.getParameter("location"));
        job.setOpenings(Integer.parseInt(req.getParameter("openings")));
        job.setDeadline(Date.valueOf(req.getParameter("deadline")));
        job.setStatus(req.getParameter("status"));

        jobDAO.updateJob(job);
        resp.sendRedirect(req.getContextPath() + "/company/manage-postings?msg=Job updated successfully!");
    }

    private void showEditInternship(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        int id = Integer.parseInt(idStr);
        Internship internship = internshipDAO.getInternshipById(id);
        if (internship == null || internship.getCompanyId() != company.getId()) {
            resp.sendRedirect(req.getContextPath() + "/company/manage-postings");
            return;
        }
        req.setAttribute("internship", internship);
        req.setAttribute("company", company);
        req.getRequestDispatcher("/WEB-INF/views/company/post-internship.jsp").forward(req, resp);
    }

    private void handleUpdateInternship(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Internship internship = internshipDAO.getInternshipById(id);
        if (internship == null || internship.getCompanyId() != company.getId()) {
            resp.sendRedirect(req.getContextPath() + "/company/manage-postings");
            return;
        }

        internship.setTitle(req.getParameter("title"));
        internship.setRoleCategory(req.getParameter("roleCategory"));
        internship.setStipendPerMonth(Double.parseDouble(req.getParameter("stipendPerMonth")));
        internship.setDurationMonths(Integer.parseInt(req.getParameter("durationMonths")));
        internship.setDescription(req.getParameter("description"));
        internship.setRequirements(req.getParameter("requirements"));
        internship.setMinCgpa(Double.parseDouble(req.getParameter("minCgpa")));
        internship.setAllowedBranches(req.getParameter("allowedBranches"));
        internship.setLocation(req.getParameter("location"));
        internship.setOpenings(Integer.parseInt(req.getParameter("openings")));
        internship.setDeadline(Date.valueOf(req.getParameter("deadline")));
        internship.setStatus(req.getParameter("status"));

        internshipDAO.updateInternship(internship);
        resp.sendRedirect(req.getContextPath() + "/company/manage-postings?msg=Internship updated successfully!");
    }

    private void deletePosting(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String type = req.getParameter("type");
        int id = Integer.parseInt(req.getParameter("id"));

        if ("JOB".equalsIgnoreCase(type)) {
            Job j = jobDAO.getJobById(id);
            if (j != null && j.getCompanyId() == company.getId()) {
                jobDAO.deleteJob(id);
            }
        } else if ("INTERNSHIP".equalsIgnoreCase(type)) {
            Internship in = internshipDAO.getInternshipById(id);
            if (in != null && in.getCompanyId() == company.getId()) {
                internshipDAO.deleteInternship(id);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/company/manage-postings?msg=Posting deleted successfully!");
    }

    private void showApplicants(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String postingType = req.getParameter("type");
        String postingIdStr = req.getParameter("id");

        List<Application> applicants;
        if (postingType != null && postingIdStr != null) {
            int postingId = Integer.parseInt(postingIdStr);
            applicants = applicationDAO.getApplicationsForPosting(postingType.toUpperCase(), postingId);
        } else {
            applicants = applicationDAO.getApplicationsByCompanyId(company.getId());
        }

        req.setAttribute("company", company);
        req.setAttribute("applicants", applicants);
        req.setAttribute("selectedType", postingType);
        req.setAttribute("selectedId", postingIdStr);
        req.getRequestDispatcher("/WEB-INF/views/company/applicants.jsp").forward(req, resp);
    }

    private void handleUpdateStatus(Company company, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int applicationId = Integer.parseInt(req.getParameter("applicationId"));
        String newStatus = req.getParameter("status");
        String remarks = req.getParameter("remarks");

        // Update application
        applicationDAO.updateStatus(applicationId, newStatus, remarks);

        String redirect = req.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty()) {
            resp.sendRedirect(redirect);
        } else {
            resp.sendRedirect(req.getContextPath() + "/company/applicants?msg=Applicant status updated successfully!");
        }
    }
}
