package com.placement.dao;

import com.placement.model.Internship;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class InternshipDAO {

    public boolean createInternship(Internship internship) {
        String sql = "INSERT INTO internships (company_id, title, role_category, stipend_per_month, duration_months, description, requirements, min_cgpa, allowed_branches, location, openings, deadline, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, internship.getCompanyId());
            stmt.setString(2, internship.getTitle());
            stmt.setString(3, internship.getRoleCategory());
            stmt.setDouble(4, internship.getStipendPerMonth());
            stmt.setInt(5, internship.getDurationMonths());
            stmt.setString(6, internship.getDescription());
            stmt.setString(7, internship.getRequirements());
            stmt.setDouble(8, internship.getMinCgpa());
            stmt.setString(9, internship.getAllowedBranches());
            stmt.setString(10, internship.getLocation());
            stmt.setInt(11, internship.getOpenings());
            stmt.setDate(12, internship.getDeadline());
            stmt.setString(13, internship.getStatus() != null ? internship.getStatus() : "OPEN");

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public Internship getInternshipById(int internshipId) {
        String sql = "SELECT i.*, c.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) as applicant_count " +
                     "FROM internships i JOIN companies c ON i.company_id = c.id WHERE i.id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, internshipId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToInternship(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public List<Internship> getAllOpenInternships() {
        List<Internship> list = new ArrayList<>();
        String sql = "SELECT i.*, c.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) as applicant_count " +
                     "FROM internships i JOIN companies c ON i.company_id = c.id " +
                     "WHERE i.status = 'OPEN' AND c.approval_status = 'APPROVED' " +
                     "ORDER BY i.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToInternship(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Internship> searchInternships(String keyword, String roleCategory, Double maxMinCgpa) {
        List<Internship> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, c.company_name, " +
            "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) as applicant_count " +
            "FROM internships i JOIN companies c ON i.company_id = c.id " +
            "WHERE i.status = 'OPEN' AND c.approval_status = 'APPROVED' "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (i.title LIKE ? OR c.company_name LIKE ? OR i.location LIKE ? OR i.requirements LIKE ?) ");
        }
        if (roleCategory != null && !roleCategory.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleCategory)) {
            sql.append("AND i.role_category = ? ");
        }
        if (maxMinCgpa != null && maxMinCgpa > 0) {
            sql.append("AND i.min_cgpa <= ? ");
        }
        sql.append("ORDER BY i.created_at DESC");

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
                list.add(mapResultSetToInternship(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Internship> getInternshipsByCompanyId(int companyId) {
        List<Internship> list = new ArrayList<>();
        String sql = "SELECT i.*, c.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) as applicant_count " +
                     "FROM internships i JOIN companies c ON i.company_id = c.id WHERE i.company_id = ? " +
                     "ORDER BY i.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, companyId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToInternship(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Internship> getAllInternshipsForAdmin() {
        List<Internship> list = new ArrayList<>();
        String sql = "SELECT i.*, c.company_name, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.posting_type = 'INTERNSHIP' AND a.posting_id = i.id) as applicant_count " +
                     "FROM internships i JOIN companies c ON i.company_id = c.id " +
                     "ORDER BY i.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToInternship(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public boolean updateInternship(Internship internship) {
        String sql = "UPDATE internships SET title = ?, role_category = ?, stipend_per_month = ?, duration_months = ?, description = ?, requirements = ?, min_cgpa = ?, allowed_branches = ?, location = ?, openings = ?, deadline = ?, status = ? WHERE id = ? AND company_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, internship.getTitle());
            stmt.setString(2, internship.getRoleCategory());
            stmt.setDouble(3, internship.getStipendPerMonth());
            stmt.setInt(4, internship.getDurationMonths());
            stmt.setString(5, internship.getDescription());
            stmt.setString(6, internship.getRequirements());
            stmt.setDouble(7, internship.getMinCgpa());
            stmt.setString(8, internship.getAllowedBranches());
            stmt.setString(9, internship.getLocation());
            stmt.setInt(10, internship.getOpenings());
            stmt.setDate(11, internship.getDeadline());
            stmt.setString(12, internship.getStatus());
            stmt.setInt(13, internship.getId());
            stmt.setInt(14, internship.getCompanyId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public boolean updateInternshipStatus(int internshipId, String status) {
        String sql = "UPDATE internships SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, internshipId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public boolean deleteInternship(int internshipId) {
        String sql = "DELETE FROM internships WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, internshipId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public int getInternshipCount() {
        String sql = "SELECT COUNT(*) FROM internships";
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

    private Internship mapResultSetToInternship(ResultSet rs) throws SQLException {
        Internship i = new Internship();
        i.setId(rs.getInt("id"));
        i.setCompanyId(rs.getInt("company_id"));
        i.setTitle(rs.getString("title"));
        i.setRoleCategory(rs.getString("role_category"));
        i.setStipendPerMonth(rs.getDouble("stipend_per_month"));
        i.setDurationMonths(rs.getInt("duration_months"));
        i.setDescription(rs.getString("description"));
        i.setRequirements(rs.getString("requirements"));
        i.setMinCgpa(rs.getDouble("min_cgpa"));
        i.setAllowedBranches(rs.getString("allowed_branches"));
        i.setLocation(rs.getString("location"));
        i.setOpenings(rs.getInt("openings"));
        i.setDeadline(rs.getDate("deadline"));
        i.setStatus(rs.getString("status"));
        i.setCreatedAt(rs.getTimestamp("created_at"));
        i.setCompanyName(rs.getString("company_name"));
        i.setApplicantCount(rs.getInt("applicant_count"));
        return i;
    }
}
