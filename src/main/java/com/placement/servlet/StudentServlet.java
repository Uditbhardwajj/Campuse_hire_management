package com.placement.servlet;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.InternshipDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Internship;
import com.placement.model.Job;
import com.placement.model.Student;
import com.placement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/student/*"})
public class StudentServlet extends HttpServlet {

    private StudentDAO studentDAO;
    private JobDAO jobDAO;
    private InternshipDAO internshipDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
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

        Student student = getLoggedInStudent(req);
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Student profile not found. Please log in again.");
            return;
        }

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(student, req, resp);
                break;
            case "/profile":
                showProfile(student, req, resp);
                break;
            case "/jobs":
                showJobs(student, req, resp);
                break;
            case "/internships":
                showInternships(student, req, resp);
                break;
            case "/view-posting":
                showPostingDetails(student, req, resp);
                break;
            case "/applications":
                showApplications(student, req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        Student student = getLoggedInStudent(req);
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Session expired. Please log in again.");
            return;
        }

        if ("/profile".equals(pathInfo)) {
            updateProfile(student, req, resp);
        } else if ("/apply".equals(pathInfo)) {
            handleApply(student, req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }

    private Student getLoggedInStudent(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        User user = (User) session.getAttribute("user");
        if (user == null) return null;
        return studentDAO.getStudentByUserId(user.getId());
    }

    private void showDashboard(Student student, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Application> myApps = applicationDAO.getApplicationsByStudentId(student.getId());
        List<Job> recentJobs = jobDAO.getAllOpenJobs();
        if (recentJobs.size() > 4) {
            recentJobs = recentJobs.subList(0, 4);
        }
        List<Internship> recentInternships = internshipDAO.getAllOpenInternships();
        if (recentInternships.size() > 4) {
            recentInternships = recentInternships.subList(0, 4);
        }

        int totalApplied = myApps.size();
        int shortlistedCount = 0;
        int acceptedCount = 0;
        for (Application a : myApps) {
            if ("SHORTLISTED".equalsIgnoreCase(a.getStatus()) || "INTERVIEW_SCHEDULED".equalsIgnoreCase(a.getStatus())) {
                shortlistedCount++;
            } else if ("ACCEPTED".equalsIgnoreCase(a.getStatus())) {
                acceptedCount++;
            }
        }

        req.setAttribute("student", student);
        req.setAttribute("myApps", myApps);
        req.setAttribute("recentJobs", recentJobs);
        req.setAttribute("recentInternships", recentInternships);
        req.setAttribute("totalApplied", totalApplied);
        req.setAttribute("shortlistedCount", shortlistedCount);
        req.setAttribute("acceptedCount", acceptedCount);

        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }

    private void showProfile(Student student, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("student", student);
        req.getRequestDispatcher("/WEB-INF/views/student/profile.jsp").forward(req, resp);
    }

    private void updateProfile(Student student, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String department = req.getParameter("department");
        String cgpaStr = req.getParameter("cgpa");
        String passingYearStr = req.getParameter("passingYear");
        String phone = req.getParameter("phone");
        String skills = req.getParameter("skills");
        String resumeUrl = req.getParameter("resumeUrl");
        String address = req.getParameter("address");

        if (firstName != null && !firstName.trim().isEmpty()) {
            student.setFirstName(firstName.trim());
        }
        if (lastName != null) {
            student.setLastName(lastName.trim());
        }
        if (department != null && !department.trim().isEmpty()) {
            student.setDepartment(department.trim());
        }
        try {
            if (cgpaStr != null && !cgpaStr.trim().isEmpty()) {
                student.setCgpa(Double.parseDouble(cgpaStr.trim()));
            }
        } catch (NumberFormatException ignored) {}
        try {
            if (passingYearStr != null && !passingYearStr.trim().isEmpty()) {
                student.setPassingYear(Integer.parseInt(passingYearStr.trim()));
            }
        } catch (NumberFormatException ignored) {}
        student.setPhone(phone != null ? phone.trim() : "");
        student.setSkills(skills != null ? skills.trim() : "");
        student.setResumeUrl(resumeUrl != null ? resumeUrl.trim() : "");
        student.setAddress(address != null ? address.trim() : "");

        boolean updated = studentDAO.updateStudent(student);
        if (updated) {
            // Update session attribute
            req.getSession().setAttribute("student", student);
            req.getSession().setAttribute("fullName", student.getFullName());
            req.setAttribute("successMessage", "Profile updated successfully!");
        } else {
            req.setAttribute("errorMessage", "Failed to update profile. Please try again.");
        }
        req.setAttribute("student", student);
        req.getRequestDispatcher("/WEB-INF/views/student/profile.jsp").forward(req, resp);
    }

    private void showJobs(Student student, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");
        String minCgpaParam = req.getParameter("minCgpa");

        Double minCgpa = null;
        if (minCgpaParam != null && !minCgpaParam.trim().isEmpty()) {
            try {
                minCgpa = Double.parseDouble(minCgpaParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Job> jobs;
        if ((keyword != null && !keyword.trim().isEmpty()) || (category != null && !category.trim().isEmpty()) || minCgpa != null) {
            jobs = jobDAO.searchJobs(keyword, category, minCgpa);
        } else {
            jobs = jobDAO.getAllOpenJobs();
        }

        req.setAttribute("student", student);
        req.setAttribute("jobs", jobs);
        req.setAttribute("keyword", keyword);
        req.setAttribute("category", category);
        req.setAttribute("minCgpa", minCgpaParam);
        req.getRequestDispatcher("/WEB-INF/views/student/jobs.jsp").forward(req, resp);
    }

    private void showInternships(Student student, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");
        String minCgpaParam = req.getParameter("minCgpa");

        Double minCgpa = null;
        if (minCgpaParam != null && !minCgpaParam.trim().isEmpty()) {
            try {
                minCgpa = Double.parseDouble(minCgpaParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Internship> internships;
        if ((keyword != null && !keyword.trim().isEmpty()) || (category != null && !category.trim().isEmpty()) || minCgpa != null) {
            internships = internshipDAO.searchInternships(keyword, category, minCgpa);
        } else {
            internships = internshipDAO.getAllOpenInternships();
        }

        req.setAttribute("student", student);
        req.setAttribute("internships", internships);
        req.setAttribute("keyword", keyword);
        req.setAttribute("category", category);
        req.setAttribute("minCgpa", minCgpaParam);
        req.getRequestDispatcher("/WEB-INF/views/student/internships.jsp").forward(req, resp);
    }

    private void showPostingDetails(Student student, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String type = req.getParameter("type"); // JOB or INTERNSHIP
        String idStr = req.getParameter("id");

        if (type == null || idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }

        int postingId;
        try {
            postingId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }

        boolean alreadyApplied = applicationDAO.hasApplied(student.getId(), type.toUpperCase(), postingId);

        if ("JOB".equalsIgnoreCase(type)) {
            Job job = jobDAO.getJobById(postingId);
            if (job == null) {
                resp.sendRedirect(req.getContextPath() + "/student/jobs");
                return;
            }
            req.setAttribute("job", job);
            req.setAttribute("alreadyApplied", alreadyApplied);
            req.setAttribute("isEligible", student.getCgpa() >= job.getMinCgpa());
            req.getRequestDispatcher("/WEB-INF/views/student/view-job.jsp").forward(req, resp);
        } else {
            Internship internship = internshipDAO.getInternshipById(postingId);
            if (internship == null) {
                resp.sendRedirect(req.getContextPath() + "/student/internships");
                return;
            }
            req.setAttribute("internship", internship);
            req.setAttribute("alreadyApplied", alreadyApplied);
            req.setAttribute("isEligible", student.getCgpa() >= internship.getMinCgpa());
            req.getRequestDispatcher("/WEB-INF/views/student/view-internship.jsp").forward(req, resp);
        }
    }

    private void handleApply(Student student, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String postingType = req.getParameter("postingType"); // JOB or INTERNSHIP
        String postingIdStr = req.getParameter("postingId");

        if (postingType == null || postingIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }

        int postingId;
        try {
            postingId = Integer.parseInt(postingIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }

        // Check if student already applied
        if (applicationDAO.hasApplied(student.getId(), postingType.toUpperCase(), postingId)) {
            resp.sendRedirect(req.getContextPath() + "/student/applications?msg=You have already submitted an application for this opportunity.");
            return;
        }

        // Check eligibility (CGPA check)
        double requiredCgpa = 0.0;
        if ("JOB".equalsIgnoreCase(postingType)) {
            Job j = jobDAO.getJobById(postingId);
            if (j != null) requiredCgpa = j.getMinCgpa();
        } else {
            Internship i = internshipDAO.getInternshipById(postingId);
            if (i != null) requiredCgpa = i.getMinCgpa();
        }

        if (student.getCgpa() < requiredCgpa) {
            resp.sendRedirect(req.getContextPath() + "/student/view-posting?type=" + postingType + "&id=" + postingId + "&error=Your CGPA (" + student.getCgpa() + ") does not meet the minimum required CGPA (" + requiredCgpa + ").");
            return;
        }

        Application app = new Application();
        app.setStudentId(student.getId());
        app.setPostingType(postingType.toUpperCase());
        app.setPostingId(postingId);
        app.setStatus("PENDING");
        app.setRemarks("Application submitted successfully. Awaiting company review.");

        boolean applied = applicationDAO.apply(app);
        if (applied) {
            resp.sendRedirect(req.getContextPath() + "/student/applications?msg=Application submitted successfully!");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/view-posting?type=" + postingType + "&id=" + postingId + "&error=Could not submit application. Please try again.");
        }
    }

    private void showApplications(Student student, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Application> myApps = applicationDAO.getApplicationsByStudentId(student.getId());
        req.setAttribute("student", student);
        req.setAttribute("myApps", myApps);
        req.getRequestDispatcher("/WEB-INF/views/student/my-applications.jsp").forward(req, resp);
    }
}
