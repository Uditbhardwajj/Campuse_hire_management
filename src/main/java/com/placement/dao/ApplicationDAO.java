package com.placement.dao;

import com.placement.model.Application;
import com.placement.model.DashboardStats;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean hasApplied(int studentId, String postingType, int postingId) {
        String sql = "SELECT id FROM applications WHERE student_id = ? AND posting_type = ? AND posting_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            stmt.setString(2, postingType);
            stmt.setInt(3, postingId);
            rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
    }

    public boolean apply(Application app) {
        if (hasApplied(app.getStudentId(), app.getPostingType(), app.getPostingId())) {
            return false; // Already applied
        }

        String sql = "INSERT INTO applications (student_id, posting_type, posting_id, status, remarks) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, app.getStudentId());
            stmt.setString(2, app.getPostingType());
            stmt.setInt(3, app.getPostingId());
            stmt.setString(4, app.getStatus() != null ? app.getStatus() : "PENDING");
            stmt.setString(5, app.getRemarks() != null ? app.getRemarks() : "Application submitted and under review");

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public List<Application> getApplicationsByStudentId(int studentId) {
        List<Application> list = new ArrayList<>();
        String sql = 
            "SELECT a.*, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN j.title " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN i.title " +
            "END as posting_title, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN c1.company_name " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN c2.company_name " +
            "END as company_name, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN c1.id " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN c2.id " +
            "END as company_id, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN CONCAT(j.package_lpa, ' LPA') " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN CONCAT('₹', FORMAT(i.stipend_per_month, 0), '/mo') " +
            "END as compensation, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN j.location " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN i.location " +
            "END as location " +
            "FROM applications a " +
            "LEFT JOIN jobs j ON (a.posting_type = 'JOB' AND a.posting_id = j.id) " +
            "LEFT JOIN companies c1 ON j.company_id = c1.id " +
            "LEFT JOIN internships i ON (a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) " +
            "LEFT JOIN companies c2 ON i.company_id = c2.id " +
            "WHERE a.student_id = ? " +
            "ORDER BY a.applied_date DESC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Application a = new Application();
                a.setId(rs.getInt("id"));
                a.setStudentId(rs.getInt("student_id"));
                a.setPostingType(rs.getString("posting_type"));
                a.setPostingId(rs.getInt("posting_id"));
                a.setAppliedDate(rs.getTimestamp("applied_date"));
                a.setStatus(rs.getString("status"));
                a.setRemarks(rs.getString("remarks"));
                a.setUpdatedAt(rs.getTimestamp("updated_at"));
                a.setPostingTitle(rs.getString("posting_title"));
                a.setCompanyName(rs.getString("company_name"));
                a.setCompanyId(rs.getInt("company_id"));
                a.setCompensation(rs.getString("compensation"));
                a.setLocation(rs.getString("location"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Application> getApplicationsByCompanyId(int companyId) {
        List<Application> list = new ArrayList<>();
        String sql = 
            "SELECT a.*, s.first_name, s.last_name, s.roll_no, s.department, s.cgpa, s.resume_url, s.skills, s.phone, u.email as student_email, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN j.title " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN i.title " +
            "END as posting_title, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN CONCAT(j.package_lpa, ' LPA') " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN CONCAT('₹', FORMAT(i.stipend_per_month, 0), '/mo') " +
            "END as compensation " +
            "FROM applications a " +
            "JOIN students s ON a.student_id = s.id " +
            "JOIN users u ON s.user_id = u.id " +
            "LEFT JOIN jobs j ON (a.posting_type = 'JOB' AND a.posting_id = j.id) " +
            "LEFT JOIN internships i ON (a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) " +
            "WHERE (a.posting_type = 'JOB' AND j.company_id = ?) " +
            "   OR (a.posting_type = 'INTERNSHIP' AND i.company_id = ?) " +
            "ORDER BY a.applied_date DESC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, companyId);
            stmt.setInt(2, companyId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToApplication(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Application> getApplicationsForPosting(String postingType, int postingId) {
        List<Application> list = new ArrayList<>();
        String sql = 
            "SELECT a.*, s.first_name, s.last_name, s.roll_no, s.department, s.cgpa, s.resume_url, s.skills, s.phone, u.email as student_email, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN j.title " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN i.title " +
            "END as posting_title, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN CONCAT(j.package_lpa, ' LPA') " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN CONCAT('₹', FORMAT(i.stipend_per_month, 0), '/mo') " +
            "END as compensation " +
            "FROM applications a " +
            "JOIN students s ON a.student_id = s.id " +
            "JOIN users u ON s.user_id = u.id " +
            "LEFT JOIN jobs j ON (a.posting_type = 'JOB' AND a.posting_id = j.id) " +
            "LEFT JOIN internships i ON (a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) " +
            "WHERE a.posting_type = ? AND a.posting_id = ? " +
            "ORDER BY a.applied_date DESC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, postingType);
            stmt.setInt(2, postingId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToApplication(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Application> getAllApplications() {
        List<Application> list = new ArrayList<>();
        String sql = 
            "SELECT a.*, s.first_name, s.last_name, s.roll_no, s.department, s.cgpa, s.resume_url, s.skills, s.phone, u.email as student_email, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN j.title " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN i.title " +
            "END as posting_title, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN c1.company_name " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN c2.company_name " +
            "END as company_name, " +
            "CASE " +
            "  WHEN a.posting_type = 'JOB' THEN CONCAT(j.package_lpa, ' LPA') " +
            "  WHEN a.posting_type = 'INTERNSHIP' THEN CONCAT('₹', FORMAT(i.stipend_per_month, 0), '/mo') " +
            "END as compensation " +
            "FROM applications a " +
            "JOIN students s ON a.student_id = s.id " +
            "JOIN users u ON s.user_id = u.id " +
            "LEFT JOIN jobs j ON (a.posting_type = 'JOB' AND a.posting_id = j.id) " +
            "LEFT JOIN companies c1 ON j.company_id = c1.id " +
            "LEFT JOIN internships i ON (a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) " +
            "LEFT JOIN companies c2 ON i.company_id = c2.id " +
            "ORDER BY a.applied_date DESC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Application a = mapResultSetToApplication(rs);
                a.setCompanyName(rs.getString("company_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public Application getApplicationById(int applicationId) {
        String sql = "SELECT a.*, s.first_name, s.last_name, s.roll_no, s.department, s.cgpa, s.resume_url, s.skills, s.phone, u.email as student_email, " +
                     "CASE " +
                     "  WHEN a.posting_type = 'JOB' THEN j.title " +
                     "  WHEN a.posting_type = 'INTERNSHIP' THEN i.title " +
                     "END as posting_title, " +
                     "CASE " +
                     "  WHEN a.posting_type = 'JOB' THEN c1.company_name " +
                     "  WHEN a.posting_type = 'INTERNSHIP' THEN c2.company_name " +
                     "END as company_name " +
                     "FROM applications a " +
                     "JOIN students s ON a.student_id = s.id " +
                     "JOIN users u ON s.user_id = u.id " +
                     "LEFT JOIN jobs j ON (a.posting_type = 'JOB' AND a.posting_id = j.id) " +
                     "LEFT JOIN companies c1 ON j.company_id = c1.id " +
                     "LEFT JOIN internships i ON (a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) " +
                     "LEFT JOIN companies c2 ON i.company_id = c2.id " +
                     "WHERE a.id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, applicationId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Application a = mapResultSetToApplication(rs);
                a.setCompanyName(rs.getString("company_name"));
                return a;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public boolean updateStatus(int applicationId, String status, String remarks) {
        String sql = "UPDATE applications SET status = ?, remarks = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setString(2, remarks);
            stmt.setInt(3, applicationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public DashboardStats getStats() {
        DashboardStats stats = new DashboardStats();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();

            // Total students
            rs = stmt.executeQuery("SELECT COUNT(*) FROM students");
            if (rs.next()) stats.setTotalStudents(rs.getInt(1));
            rs.close();

            // Total companies
            rs = stmt.executeQuery("SELECT COUNT(*) FROM companies");
            if (rs.next()) stats.setTotalCompanies(rs.getInt(1));
            rs.close();

            // Pending companies
            rs = stmt.executeQuery("SELECT COUNT(*) FROM companies WHERE approval_status = 'PENDING'");
            if (rs.next()) stats.setPendingCompanies(rs.getInt(1));
            rs.close();

            // Total jobs
            rs = stmt.executeQuery("SELECT COUNT(*) FROM jobs");
            if (rs.next()) stats.setTotalJobs(rs.getInt(1));
            rs.close();

            // Total internships
            rs = stmt.executeQuery("SELECT COUNT(*) FROM internships");
            if (rs.next()) stats.setTotalInternships(rs.getInt(1));
            rs.close();

            // Total applications
            rs = stmt.executeQuery("SELECT COUNT(*) FROM applications");
            if (rs.next()) stats.setTotalApplications(rs.getInt(1));
            rs.close();

            // Placed students (distinct students with ACCEPTED job or internship)
            rs = stmt.executeQuery("SELECT COUNT(DISTINCT student_id) FROM applications WHERE status = 'ACCEPTED'");
            if (rs.next()) stats.setTotalPlaced(rs.getInt(1));
            rs.close();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return stats;
    }

    private Application mapResultSetToApplication(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId(rs.getInt("id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setPostingType(rs.getString("posting_type"));
        a.setPostingId(rs.getInt("posting_id"));
        a.setAppliedDate(rs.getTimestamp("applied_date"));
        a.setStatus(rs.getString("status"));
        a.setRemarks(rs.getString("remarks"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));

        a.setStudentName(rs.getString("first_name") + " " + rs.getString("last_name"));
        a.setStudentRollNo(rs.getString("roll_no"));
        a.setStudentDepartment(rs.getString("department"));
        a.setStudentCgpa(rs.getDouble("cgpa"));
        a.setStudentEmail(rs.getString("student_email"));
        a.setStudentPhone(rs.getString("phone"));
        a.setStudentResumeUrl(rs.getString("resume_url"));
        a.setStudentSkills(rs.getString("skills"));

        a.setPostingTitle(rs.getString("posting_title"));
        try {
            a.setCompensation(rs.getString("compensation"));
        } catch (Exception ignored) {}

        return a;
    }
}
