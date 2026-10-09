<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.DashboardStats, com.placement.model.Company, com.placement.model.Application" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "TPO Admin Dashboard - CampusHire");
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    List<Application> recentApps = (List<Application>) request.getAttribute("recentApps");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
            <div>
                <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Training & Placement Office (TPO) Administration</h1>
                <p style="color: var(--text-muted); font-size: 0.92rem;">Centralized control panel for campus recruitment, corporate verifications, and placement records</p>
            </div>
            <div>
                <a href="<%= ctx %>/admin/reports" class="btn btn-primary btn-sm">📊 View Placement Reports</a>
            </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="grid-4" style="margin-bottom: 30px;">
            <div class="stat-card">
                <div class="stat-icon blue">🎓</div>
                <div class="stat-details">
                    <h4><%= stats.getTotalStudents() %></h4>
                    <p>Total Students</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon purple">🏢</div>
                <div class="stat-details">
                    <h4><%= stats.getTotalCompanies() %></h4>
                    <p>Total Companies</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon amber">⏳</div>
                <div class="stat-details">
                    <h4><%= stats.getPendingCompanies() %></h4>
                    <p>Pending Approvals</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">🏆</div>
                <div class="stat-details">
                    <h4><%= stats.getTotalPlaced() %></h4>
                    <p>Students Placed</p>
                </div>
            </div>
        </div>

        <!-- Pending Company Approvals -->
        <% 
            boolean hasPending = false;
            if (companies != null) {
                for (Company c : companies) {
                    if ("PENDING".equalsIgnoreCase(c.getApprovalStatus())) {
                        hasPending = true;
                        break;
                    }
                }
            }
        %>
        <% if (hasPending) { %>
            <div class="card" style="margin-bottom: 30px; border-left: 5px solid var(--warning);">
                <div class="card-header">
                    <div>
                        <h3 style="color: var(--warning);">⏳ Recruiter Registrations Awaiting TPO Approval</h3>
                        <p style="font-size: 0.85rem; color: var(--text-muted); margin-top: 4px;">Approve legitimate companies to enable them to post drives on campus</p>
                    </div>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Company Name</th>
                                <th>Industry</th>
                                <th>Contact Person</th>
                                <th>Official Email</th>
                                <th>Phone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Company c : companies) {
                                if ("PENDING".equalsIgnoreCase(c.getApprovalStatus())) { %>
                                <tr>
                                    <td style="font-weight: 700;"><%= c.getCompanyName() %></td>
                                    <td><%= c.getIndustry() %></td>
                                    <td><%= c.getContactPerson() %></td>
                                    <td><%= c.getEmail() %></td>
                                    <td><%= c.getPhone() %></td>
                                    <td>
                                        <a href="<%= ctx %>/admin/approve-company?id=<%= c.getId() %>&status=APPROVED" class="btn btn-success btn-sm">✓ Approve</a>
                                        <a href="<%= ctx %>/admin/approve-company?id=<%= c.getId() %>&status=REJECTED" class="btn btn-danger btn-sm" style="margin-left: 6px;">✕ Reject</a>
                                    </td>
                                </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

        <!-- Recent Campus Applications -->
        <div class="card">
            <div class="card-header">
                <h3>📋 Recent Campus Recruitment Activity</h3>
                <a href="<%= ctx %>/admin/applications" class="btn btn-outline btn-sm">View All Applications &rarr;</a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Roll No</th>
                            <th>Department</th>
                            <th>CGPA</th>
                            <th>Company</th>
                            <th>Opportunity</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentApps == null || recentApps.isEmpty()) { %>
                            <tr><td colspan="8" style="text-align: center; color: var(--text-muted); padding: 25px;">No applications submitted yet.</td></tr>
                        <% } else {
                            for (Application a : recentApps) { %>
                            <tr>
                                <td style="font-weight: 700;"><%= a.getStudentName() %></td>
                                <td><%= a.getStudentRollNo() %></td>
                                <td><%= a.getStudentDepartment() %></td>
                                <td><strong><%= a.getStudentCgpa() %></strong></td>
                                <td>🏢 <%= a.getCompanyName() %></td>
                                <td><%= a.getPostingTitle() %></td>
                                <td><%= a.getAppliedDate().toString().substring(0, 10) %></td>
                                <td><span class="status-badge status-<%= a.getStatus() %>"><%= a.getStatus().replace("_", " ") %></span></td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
