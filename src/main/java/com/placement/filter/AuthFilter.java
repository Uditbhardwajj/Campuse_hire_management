package com.placement.filter;

import com.placement.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication and Role-based Access Control Filter.
 * Protects Student, Company, and Admin endpoints without external frameworks like Spring Security.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialization
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Allow public static resources and public pages
        if (path.startsWith("/css") || path.startsWith("/js") || path.startsWith("/images")
                || path.equals("/") || path.equals("/index.jsp")
                || path.equals("/login.jsp") || path.equals("/login")
                || path.equals("/register.jsp") || path.equals("/register")
                || path.equals("/student-register.jsp") || path.equals("/company-register.jsp")
                || path.equals("/logout")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Protected Student area
        if (path.startsWith("/student/") || path.equals("/student")) {
            if (user == null) {
                response.sendRedirect(contextPath + "/login.jsp?error=Please log in as a student to access this page");
                return;
            }
            if (!"STUDENT".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(contextPath + "/login.jsp?error=Access denied: Student access required");
                return;
            }
        }

        // Protected Company area
        if (path.startsWith("/company/") || path.equals("/company")) {
            if (user == null) {
                response.sendRedirect(contextPath + "/login.jsp?error=Please log in as a company recruiter to access this page");
                return;
            }
            if (!"COMPANY".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(contextPath + "/login.jsp?error=Access denied: Recruiter access required");
                return;
            }
        }

        // Protected Admin area
        if (path.startsWith("/admin/") || path.equals("/admin")) {
            if (user == null) {
                response.sendRedirect(contextPath + "/login.jsp?error=Please log in as admin to access this page");
                return;
            }
            if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(contextPath + "/login.jsp?error=Access denied: Admin access required");
                return;
            }
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // Filter cleanup
    }
}
