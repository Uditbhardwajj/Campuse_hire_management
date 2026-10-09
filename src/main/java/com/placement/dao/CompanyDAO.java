package com.placement.dao;

import com.placement.model.Company;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {

    public boolean createCompany(Company company) {
        String sql = "INSERT INTO companies (user_id, company_name, industry, website, contact_person, phone, address, description, approval_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, company.getUserId());
            stmt.setString(2, company.getCompanyName());
            stmt.setString(3, company.getIndustry());
            stmt.setString(4, company.getWebsite());
            stmt.setString(5, company.getContactPerson());
            stmt.setString(6, company.getPhone());
            stmt.setString(7, company.getAddress());
            stmt.setString(8, company.getDescription());
            stmt.setString(9, company.getApprovalStatus() != null ? company.getApprovalStatus() : "PENDING");

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public Company getCompanyByUserId(int userId) {
        String sql = "SELECT c.*, u.email, u.username FROM companies c JOIN users u ON c.user_id = u.id WHERE c.user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCompany(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public Company getCompanyById(int companyId) {
        String sql = "SELECT c.*, u.email, u.username FROM companies c JOIN users u ON c.user_id = u.id WHERE c.id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, companyId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCompany(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public List<Company> getAllCompanies() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT c.*, u.email, u.username FROM companies c JOIN users u ON c.user_id = u.id ORDER BY c.id DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToCompany(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Company> getApprovedCompanies() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT c.*, u.email, u.username FROM companies c JOIN users u ON c.user_id = u.id WHERE c.approval_status = 'APPROVED' ORDER BY c.company_name ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToCompany(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public boolean updateCompany(Company company) {
        String sql = "UPDATE companies SET company_name = ?, industry = ?, website = ?, contact_person = ?, phone = ?, address = ?, description = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, company.getCompanyName());
            stmt.setString(2, company.getIndustry());
            stmt.setString(3, company.getWebsite());
            stmt.setString(4, company.getContactPerson());
            stmt.setString(5, company.getPhone());
            stmt.setString(6, company.getAddress());
            stmt.setString(7, company.getDescription());
            stmt.setInt(8, company.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public boolean updateApprovalStatus(int companyId, String status) {
        String sql = "UPDATE companies SET approval_status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, companyId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public boolean deleteCompany(int companyId) {
        String findUserSql = "SELECT user_id FROM companies WHERE id = ?";
        String deleteUserSql = "DELETE FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt1 = null;
        PreparedStatement stmt2 = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt1 = conn.prepareStatement(findUserSql);
            stmt1.setInt(1, companyId);
            rs = stmt1.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                stmt2 = conn.prepareStatement(deleteUserSql);
                stmt2.setInt(1, userId);
                return stmt2.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(null, stmt1, rs);
            DBConnection.close(conn, stmt2);
        }
        return false;
    }

    public int getCompanyCount() {
        String sql = "SELECT COUNT(*) FROM companies";
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

    public int getPendingCompanyCount() {
        String sql = "SELECT COUNT(*) FROM companies WHERE approval_status = 'PENDING'";
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

    private Company mapResultSetToCompany(ResultSet rs) throws SQLException {
        Company c = new Company();
        c.setId(rs.getInt("id"));
        c.setUserId(rs.getInt("user_id"));
        c.setCompanyName(rs.getString("company_name"));
        c.setIndustry(rs.getString("industry"));
        c.setWebsite(rs.getString("website"));
        c.setContactPerson(rs.getString("contact_person"));
        c.setPhone(rs.getString("phone"));
        c.setAddress(rs.getString("address"));
        c.setDescription(rs.getString("description"));
        c.setApprovalStatus(rs.getString("approval_status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setEmail(rs.getString("email"));
        c.setUsername(rs.getString("username"));
        return c;
    }
}
