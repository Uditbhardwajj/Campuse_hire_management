<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Student, com.placement.model.Job, com.placement.model.Internship, com.placement.model.Application" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Student Dashboard - CampusHire");
    Student student = (Student) request.getAttribute("student");
    List<Application> myApps = (List<Application>) request.getAttribute("myApps");
    List<Job> recentJobs = (List<Job>) request.getAttribute("recentJobs");
    List<Internship> recentInternships = (List<Internship>) request.getAttribute("recentInternships");

    int totalApplied = request.getAttribute("totalApplied") != null ? (Integer) request.getAttribute("totalApplied") : 0;
    int shortlistedCount = request.getAttribute("shortlistedCount") != null ? (Integer) request.getAttribute("shortlistedCount") : 0;
    int acceptedCount = request.getAttribute("acceptedCount") != null ? (Integer) request.getAttribute("acceptedCount") : 0;
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <!-- Student Profile Banner -->
        <div class="card" style="margin-bottom: 24px; background: linear-gradient(to right, #ffffff, #f0fdf4); border-left: 5px solid var(--primary);">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: gap;">
                <div>
                    <h2 style="font-size: 1.5rem; font-weight: 700; color: var(--primary);">Hello, <%= student.getFullName() %>! 👋</h2>
                    <p style="color: var(--text-muted); font-size: 0.92rem; margin-top: 4px;">
                        Roll No: <strong><%= student.getRollNo() %></strong> &bull; Department: <strong><%= student.getDepartment() %></strong> &bull; CGPA: <strong><%= student.getCgpa() %></strong>
                    </p>
                </div>
                <div>
                    <a href="<%= ctx %>/student/profile" class="btn btn-outline btn-sm">Edit Profile</a>
                </div>
            </div>
        </div>

        <!-- Metric Cards -->
        <div class="grid-3" style="margin-bottom: 30px;">
            <div class="stat-card">
                <div class="stat-icon blue">📝</div>
                <div class="stat-details">
                    <h4><%= totalApplied %></h4>
                    <p>Total Applied</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon amber">🎯</div>
                <div class="stat-details">
                    <h4><%= shortlistedCount %></h4>
                    <p>In Review / Shortlisted</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">🎉</div>
                <div class="stat-details">
                    <h4><%= acceptedCount %></h4>
                    <p>Offers Accepted</p>
                </div>
            </div>
        </div>

        <!-- Latest Job Postings -->
        <div class="card" style="margin-bottom: 30px;">
            <div class="card-header">
                <h3>💼 Open Job Opportunities</h3>
                <a href="<%= ctx %>/student/jobs" class="btn btn-outline btn-sm">Browse All Jobs &rarr;</a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Job Title</th>
                            <th>Company</th>
                            <th>Package</th>
                            <th>Location</th>
                            <th>Min CGPA</th>
                            <th>Deadline</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentJobs == null || recentJobs.isEmpty()) { %>
                            <tr><td colspan="7" style="text-align: center; color: var(--text-muted);">No open job drives currently available.</td></tr>
                        <% } else {
                            for (Job j : recentJobs) { %>
                            <tr>
                                <td style="font-weight: 600;"><%= j.getTitle() %></td>
                                <td><%= j.getCompanyName() %></td>
                                <td style="color: var(--primary); font-weight: 700;"><%= j.getPackageLpa() %> LPA</td>
                                <td><%= j.getLocation() %></td>
                                <td>
                                    <span style="color: <%= student.getCgpa() >= j.getMinCgpa() ? "var(--success)" : "var(--danger)" %>; font-weight: 600;">
                                        <%= j.getMinCgpa() %>
                                    </span>
                                </td>
                                <td><%= j.getDeadline() %></td>
                                <td>
                                    <a href="<%= ctx %>/student/view-posting?type=JOB&id=<%= j.getId() %>" class="btn btn-primary btn-sm">View & Apply</a>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Latest Internships -->
        <div class="card" style="margin-bottom: 30px;">
            <div class="card-header">
                <h3>🌱 Active Internship Drives</h3>
                <a href="<%= ctx %>/student/internships" class="btn btn-outline btn-sm">Browse All Internships &rarr;</a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Internship Role</th>
                            <th>Company</th>
                            <th>Stipend</th>
                            <th>Duration</th>
                            <th>Min CGPA</th>
                            <th>Deadline</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentInternships == null || recentInternships.isEmpty()) { %>
                            <tr><td colspan="7" style="text-align: center; color: var(--text-muted);">No active internship drives currently available.</td></tr>
                        <% } else {
                            for (Internship in : recentInternships) { %>
                            <tr>
                                <td style="font-weight: 600;"><%= in.getTitle() %></td>
                                <td><%= in.getCompanyName() %></td>
                                <td style="color: var(--secondary); font-weight: 700;">₹<%= String.format("%,.0f", in.getStipendPerMonth()) %>/mo</td>
                                <td><%= in.getDurationMonths() %> Months</td>
                                <td>
                                    <span style="color: <%= student.getCgpa() >= in.getMinCgpa() ? "var(--success)" : "var(--danger)" %>; font-weight: 600;">
                                        <%= in.getMinCgpa() %>
                                    </span>
                                </td>
                                <td><%= in.getDeadline() %></td>
                                <td>
                                    <a href="<%= ctx %>/student/view-posting?type=INTERNSHIP&id=<%= in.getId() %>" class="btn btn-primary btn-sm">View & Apply</a>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Recent Application Status -->
        <div class="card">
            <div class="card-header">
                <h3>📋 Recent Applications Track</h3>
                <a href="<%= ctx %>/student/applications" class="btn btn-outline btn-sm">View Full History &rarr;</a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Opportunity</th>
                            <th>Type</th>
                            <th>Company</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                            <th>Company Remarks</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (myApps == null || myApps.isEmpty()) { %>
                            <tr><td colspan="6" style="text-align: center; color: var(--text-muted);">You haven't applied to any drives yet. Check open jobs above!</td></tr>
                        <% } else {
                            int count = 0;
                            for (Application a : myApps) {
                                if (count++ >= 5) break; %>
                            <tr>
                                <td style="font-weight: 600;"><%= a.getPostingTitle() %></td>
                                <td><span class="opp-badge <%= "JOB".equalsIgnoreCase(a.getPostingType()) ? "badge-job" : "badge-intern" %>"><%= a.getPostingType() %></span></td>
                                <td><%= a.getCompanyName() %></td>
                                <td><%= a.getAppliedDate().toString().substring(0, 10) %></td>
                                <td><span class="status-badge status-<%= a.getStatus() %>"><%= a.getStatus().replace("_", " ") %></span></td>
                                <td style="font-size: 0.88rem; color: #475569;"><%= a.getRemarks() %></td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
