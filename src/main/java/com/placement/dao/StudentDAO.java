package com.placement.dao;

import com.placement.model.Student;
import com.placement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public boolean createStudent(Student student) {
        String sql = "INSERT INTO students (user_id, roll_no, first_name, last_name, department, cgpa, passing_year, phone, skills, resume_url, address) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, student.getUserId());
            stmt.setString(2, student.getRollNo());
            stmt.setString(3, student.getFirstName());
            stmt.setString(4, student.getLastName());
            stmt.setString(5, student.getDepartment());
            stmt.setDouble(6, student.getCgpa());
            stmt.setInt(7, student.getPassingYear());
            stmt.setString(8, student.getPhone());
            stmt.setString(9, student.getSkills());
            stmt.setString(10, student.getResumeUrl());
            stmt.setString(11, student.getAddress());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public Student getStudentByUserId(int userId) {
        String sql = "SELECT s.*, u.email, u.username FROM students s JOIN users u ON s.user_id = u.id WHERE s.user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToStudent(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public Student getStudentById(int studentId) {
        String sql = "SELECT s.*, u.email, u.username FROM students s JOIN users u ON s.user_id = u.id WHERE s.id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToStudent(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return null;
    }

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.*, u.email, u.username FROM students s JOIN users u ON s.user_id = u.id ORDER BY s.id DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToStudent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public List<Student> searchStudents(String keyword, String department) {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT s.*, u.email, u.username FROM students s JOIN users u ON s.user_id = u.id WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (s.first_name LIKE ? OR s.last_name LIKE ? OR s.roll_no LIKE ? OR s.skills LIKE ?) ");
        }
        if (department != null && !department.trim().isEmpty() && !"ALL".equalsIgnoreCase(department)) {
            sql.append("AND s.department = ? ");
        }
        sql.append("ORDER BY s.cgpa DESC");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern);
            }
            if (department != null && !department.trim().isEmpty() && !"ALL".equalsIgnoreCase(department)) {
                stmt.setString(paramIndex++, department.trim());
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToStudent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return list;
    }

    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET first_name = ?, last_name = ?, department = ?, cgpa = ?, passing_year = ?, phone = ?, skills = ?, resume_url = ?, address = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, student.getFirstName());
            stmt.setString(2, student.getLastName());
            stmt.setString(3, student.getDepartment());
            stmt.setDouble(4, student.getCgpa());
            stmt.setInt(5, student.getPassingYear());
            stmt.setString(6, student.getPhone());
            stmt.setString(7, student.getSkills());
            stmt.setString(8, student.getResumeUrl());
            stmt.setString(9, student.getAddress());
            stmt.setInt(10, student.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(conn, stmt);
        }
    }

    public boolean deleteStudent(int studentId) {
        // Find user_id first to delete cascading user
        String findUserSql = "SELECT user_id FROM students WHERE id = ?";
        String deleteUserSql = "DELETE FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt1 = null;
        PreparedStatement stmt2 = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt1 = conn.prepareStatement(findUserSql);
            stmt1.setInt(1, studentId);
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

    public int getStudentCount() {
        String sql = "SELECT COUNT(*) FROM students";
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

    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setUserId(rs.getInt("user_id"));
        s.setRollNo(rs.getString("roll_no"));
        s.setFirstName(rs.getString("first_name"));
        s.setLastName(rs.getString("last_name"));
        s.setDepartment(rs.getString("department"));
        s.setCgpa(rs.getDouble("cgpa"));
        s.setPassingYear(rs.getInt("passing_year"));
        s.setPhone(rs.getString("phone"));
        s.setSkills(rs.getString("skills"));
        s.setResumeUrl(rs.getString("resume_url"));
        s.setAddress(rs.getString("address"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setEmail(rs.getString("email"));
        s.setUsername(rs.getString("username"));
        return s;
    }
}
