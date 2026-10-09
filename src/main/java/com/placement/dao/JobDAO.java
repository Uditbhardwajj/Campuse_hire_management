package com.placement.dao;

import com.placement.model.Job;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class JobDAO {

    public boolean createJob(Job job) {
        String sql = "INSERT INTO jobs (company_id, title, role_category, job_type, description, requirements, min_cgpa, allowed_branches, package_lpa, location, openings, deadline, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, job.getCompanyId());
            stmt.setString(2, job.getTitle());
            stmt.setString(3, job.getRoleCategory());
            stmt.setString(4, job.getJobType());
            stmt.setString(5, job.getDescription());
            stmt.setString(6, job.getRequirements());
            stmt.setDouble(7, job.getMinCgpa());
            stmt.setString(8, job.getAllowedBranches());
            stmt.setDouble(9, job.getPackageLpa());
            stmt.setString(10, job.getLocation());
            stmt.setInt(11, job.getOpenings());
            stmt.setDate(12, job.getDeadline());
            stmt.setString(13, job.getStatus() != null ? job.getStatus() : "OPEN");

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public Job getJobById(int jobId) {
        String sql = "SELECT j.*, c.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'JOB' AND a.posting_id = j.id) as applicant_count " +
                     "FROM jobs j JOIN companies c ON j.company_id = c.id WHERE j.id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, jobId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToJob(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public List<Job> getAllOpenJobs() {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.*, c.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'JOB' AND a.posting_id = j.id) as applicant_count " +
                     "FROM jobs j JOIN companies c ON j.company_id = c.id " +
                     "WHERE j.status = 'OPEN' AND c.approval_status = 'APPROVED' " +
                     "ORDER BY j.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToJob(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Job> searchJobs(String keyword, String roleCategory, Double maxMinCgpa) {
        List<Job> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT j.*, c.company_name, " +
            "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'JOB' AND a.posting_id = j.id) as applicant_count " +
            "FROM jobs j JOIN companies c ON j.company_id = c.id " +
            "WHERE j.status = 'OPEN' AND c.approval_status = 'APPROVED' "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (j.title LIKE ? OR c.company_name LIKE ? OR j.location LIKE ? OR j.requirements LIKE ?) ");
        }
        if (roleCategory != null && !roleCategory.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleCategory)) {
            sql.append("AND j.role_category = ? ");
        }
        if (maxMinCgpa != null && maxMinCgpa > 0) {
            sql.append("AND j.min_cgpa <= ? ");
        }
        sql.append("ORDER BY j.created_at DESC");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int idx = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim() + "%";
                stmt.setString(idx++, pattern);
                stmt.setString(idx++, pattern);
                stmt.setString(idx++, pattern);
                stmt.setString(idx++, pattern);
            }
            if (roleCategory != null && !roleCategory.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleCategory)) {
                stmt.setString(idx++, roleCategory.trim());
            }
            if (maxMinCgpa != null && maxMinCgpa > 0) {
                stmt.setDouble(idx++, maxMinCgpa);
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToJob(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Job> getJobsByCompanyId(int companyId) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.*, c.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'JOB' AND a.posting_id = j.id) as applicant_count " +
                     "FROM jobs j JOIN companies c ON j.company_id = c.id WHERE j.company_id = ? " +
                     "ORDER BY j.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, companyId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToJob(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Job> getAllJobsForAdmin() {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.*, c.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'JOB' AND a.posting_id = j.id) as applicant_count " +
                     "FROM jobs j JOIN companies c ON j.company_id = c.id " +
                     "ORDER BY j.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToJob(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public boolean updateJob(Job job) {
        String sql = "UPDATE jobs SET title = ?, role_category = ?, job_type = ?, description = ?, requirements = ?, min_cgpa = ?, allowed_branches = ?, package_lpa = ?, location = ?, openings = ?, deadline = ?, status = ? WHERE id = ? AND company_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, job.getTitle());
            stmt.setString(2, job.getRoleCategory());
            stmt.setString(3, job.getJobType());
            stmt.setString(4, job.getDescription());
            stmt.setString(5, job.getRequirements());
            stmt.setDouble(6, job.getMinCgpa());
            stmt.setString(7, job.getAllowedBranches());
            stmt.setDouble(8, job.getPackageLpa());
            stmt.setString(9, job.getLocation());
            stmt.setInt(10, job.getOpenings());
            stmt.setDate(11, job.getDeadline());
            stmt.setString(12, job.getStatus());
            stmt.setInt(13, job.getId());
            stmt.setInt(14, job.getCompanyId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public boolean updateJobStatus(int jobId, String status) {
        String sql = "UPDATE jobs SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, jobId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public boolean deleteJob(int jobId) {
        String sql = "DELETE FROM jobs WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, jobId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public int getJobCount() {
        String sql = "SELECT COUNT(*) FROM jobs";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return 0;
    }

    private Job mapResultSetToJob(ResultSet rs) throws SQLException {
        Job j = new Job();
        j.setId(rs.getInt("id"));
        j.setCompanyId(rs.getInt("company_id"));
        j.setTitle(rs.getString("title"));
        j.setRoleCategory(rs.getString("role_category"));
        j.setJobType(rs.getString("job_type"));
        j.setDescription(rs.getString("description"));
        j.setRequirements(rs.getString("requirements"));
        j.setMinCgpa(rs.getDouble("min_cgpa"));
        j.setAllowedBranches(rs.getString("allowed_branches"));
        j.setPackageLpa(rs.getDouble("package_lpa"));
        j.setLocation(rs.getString("location"));
        j.setOpenings(rs.getInt("openings"));
        j.setDeadline(rs.getDate("deadline"));
        j.setStatus(rs.getString("status"));
        j.setCreatedAt(rs.getTimestamp("created_at"));
        j.setCompanyName(rs.getString("company_name"));
        j.setApplicantCount(rs.getInt("applicant_count"));
        return j;
    }
}
