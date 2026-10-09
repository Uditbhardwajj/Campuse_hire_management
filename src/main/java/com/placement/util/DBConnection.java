package com.placement.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Database Connection Utility using standard JDBC.
 * Manages database connection pool / single connections to MySQL.
 */
public class DBConnection {

    private static String url = "jdbc:mysql://localhost:3306/campus_hire_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String user = "root";
    private static String password = "root";

    static {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Try loading configurations from db.properties if present on classpath
            try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (input != null) {
                    Properties prop = new Properties();
                    prop.load(input);
                    if (prop.getProperty("db.url") != null) {
                        url = prop.getProperty("db.url").trim();
                    }
                    if (prop.getProperty("db.user") != null) {
                        user = prop.getProperty("db.user").trim();
                    }
                    if (prop.getProperty("db.password") != null) {
                        password = prop.getProperty("db.password").trim();
                    }
                }
            } catch (Exception e) {
                System.out.println("[DBConnection] db.properties not found, using default credentials: " + e.getMessage());
            }

            // 2. Override with Cloud Environment Variables if present (Render/Railway/AWS)
            String envUrl = System.getenv("DB_URL");
            if (envUrl == null) envUrl = System.getenv("DATABASE_URL");
            String envUser = System.getenv("DB_USER");
            String envPass = System.getenv("DB_PASSWORD");

            if (envUrl != null && !envUrl.trim().isEmpty()) {
                url = envUrl.trim();
            }
            if (envUser != null && !envUser.trim().isEmpty()) {
                user = envUser.trim();
            }
            if (envPass != null) {
                password = envPass.trim();
            }
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] MySQL JDBC Driver not found! Ensure mysql-connector-j.jar is in WEB-INF/lib.");
            e.printStackTrace();
        }
    }

    /**
     * Get a new JDBC connection to MySQL database.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Safely close JDBC resources.
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException ignored) {}
        }
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException ignored) {}
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ignored) {}
        }
    }

    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
}
