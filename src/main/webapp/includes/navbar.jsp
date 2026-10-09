<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = currentUser != null ? currentUser.getRole() : null;
    String displayName = (String) session.getAttribute("fullName");
    if (displayName == null && currentUser != null) {
        displayName = currentUser.getUsername();
    }
    String ctx = request.getContextPath();
%>
<header>
    <div class="container">
        <nav class="navbar">
            <a href="<%= ctx %>/" class="brand">
                <span class="brand-badge">CAMPUS</span>
                <span>Placement Portal</span>
            </a>

            <ul class="nav-links">
                <% if (currentUser == null) { %>
                    <li><a href="<%= ctx %>/">Home</a></li>
                    <li><a href="<%= ctx %>/login.jsp">Login</a></li>
                    <li><a href="<%= ctx %>/register.jsp" class="btn btn-primary btn-sm">Register</a></li>
                <% } else if ("STUDENT".equalsIgnoreCase(userRole)) { %>
                    <li><a href="<%= ctx %>/student/dashboard">Dashboard</a></li>
                    <li><a href="<%= ctx %>/student/jobs">Jobs</a></li>
                    <li><a href="<%= ctx %>/student/internships">Internships</a></li>
                    <li><a href="<%= ctx %>/student/applications">My Applications</a></li>
                    <li><a href="<%= ctx %>/student/profile">My Profile</a></li>
                <% } else if ("COMPANY".equalsIgnoreCase(userRole)) { %>
                    <li><a href="<%= ctx %>/company/dashboard">Dashboard</a></li>
                    <li><a href="<%= ctx %>/company/manage-postings">Postings</a></li>
                    <li><a href="<%= ctx %>/company/applicants">Applicants</a></li>
                    <li><a href="<%= ctx %>/company/post-job">+ Post Job</a></li>
                    <li><a href="<%= ctx %>/company/post-internship">+ Post Internship</a></li>
                    <li><a href="<%= ctx %>/company/profile">Company Profile</a></li>
                <% } else if ("ADMIN".equalsIgnoreCase(userRole)) { %>
                    <li><a href="<%= ctx %>/admin/dashboard">Dashboard</a></li>
                    <li><a href="<%= ctx %>/admin/students">Students</a></li>
                    <li><a href="<%= ctx %>/admin/companies">Companies</a></li>
                    <li><a href="<%= ctx %>/admin/postings">Postings</a></li>
                    <li><a href="<%= ctx %>/admin/applications">Applications</a></li>
                    <li><a href="<%= ctx %>/admin/reports">Reports</a></li>
                <% } %>
            </ul>

            <% if (currentUser != null) { %>
                <div class="nav-user">
                    <span class="role-pill role-<%= userRole %>"><%= userRole %></span>
                    <span style="font-size: 0.9rem; font-weight: 600;"><%= displayName %></span>
                    <a href="<%= ctx %>/logout" class="btn btn-secondary btn-sm">Logout</a>
                </div>
            <% } %>
        </nav>
    </div>
</header>
