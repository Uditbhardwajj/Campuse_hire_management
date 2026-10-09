<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Job, com.placement.model.Internship, com.placement.model.Company" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Manage Postings - CampusHire");
    Company company = (Company) request.getAttribute("company");
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    List<Internship> internships = (List<Internship>) request.getAttribute("internships");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
            <div>
                <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Manage Corporate Postings</h1>
                <p style="color: var(--text-muted); font-size: 0.92rem;">Review and edit all active recruitment drives for <%= company.getCompanyName() %></p>
            </div>
            <div style="display: flex; gap: 10px;">
                <a href="<%= ctx %>/company/post-job" class="btn btn-primary btn-sm">+ Post New Job</a>
                <a href="<%= ctx %>/company/post-internship" class="btn btn-secondary btn-sm">+ Post New Internship</a>
            </div>
        </div>

        <!-- Full-Time Jobs Section -->
        <div class="card" style="margin-bottom: 30px;">
            <div class="card-header">
                <h3>💼 Full-Time Job Postings (<%= jobs != null ? jobs.size() : 0 %>)</h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Job Title</th>
                            <th>Category</th>
                            <th>Package</th>
                            <th>Cutoff</th>
                            <th>Applicants</th>
                            <th>Deadline</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (jobs == null || jobs.isEmpty()) { %>
                            <tr><td colspan="8" style="text-align: center; color: var(--text-muted); padding: 25px;">No jobs created yet. Click "+ Post New Job" to begin.</td></tr>
                        <% } else {
                            for (Job j : jobs) { %>
                            <tr>
                                <td style="font-weight: 700;"><%= j.getTitle() %></td>
                                <td><%= j.getRoleCategory() %></td>
                                <td style="font-weight: 600; color: var(--primary);"><%= j.getPackageLpa() %> LPA</td>
                                <td><%= j.getMinCgpa() %></td>
                                <td>
                                    <a href="<%= ctx %>/company/applicants?type=JOB&id=<%= j.getId() %>" style="color: var(--primary); font-weight: 700;">
                                        👥 <%= j.getApplicantCount() %> Students
                                    </a>
                                </td>
                                <td><%= j.getDeadline() %></td>
                                <td><span class="status-badge status-<%= j.getStatus() %>"><%= j.getStatus() %></span></td>
                                <td>
                                    <div style="display: flex; gap: 6px;">
                                        <a href="<%= ctx %>/company/edit-job?id=<%= j.getId() %>" class="btn btn-outline btn-sm">Edit</a>
                                        <a href="<%= ctx %>/company/delete-posting?type=JOB&id=<%= j.getId() %>" 
                                           class="btn btn-danger btn-sm confirm-delete" 
                                           data-item="Job '<%= j.getTitle() %>'">Delete</a>
                                    </div>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Internships Section -->
        <div class="card">
            <div class="card-header">
                <h3>🌱 Internship Postings (<%= internships != null ? internships.size() : 0 %>)</h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Internship Role</th>
                            <th>Domain</th>
                            <th>Stipend</th>
                            <th>Duration</th>
                            <th>Cutoff</th>
                            <th>Applicants</th>
                            <th>Deadline</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (internships == null || internships.isEmpty()) { %>
                            <tr><td colspan="9" style="text-align: center; color: var(--text-muted); padding: 25px;">No internships posted yet.</td></tr>
                        <% } else {
                            for (Internship in : internships) { %>
                            <tr>
                                <td style="font-weight: 700;"><%= in.getTitle() %></td>
                                <td><%= in.getRoleCategory() %></td>
                                <td style="font-weight: 600; color: var(--secondary);">₹<%= String.format("%,.0f", in.getStipendPerMonth()) %>/mo</td>
                                <td><%= in.getDurationMonths() %> Mo</td>
                                <td><%= in.getMinCgpa() %></td>
                                <td>
                                    <a href="<%= ctx %>/company/applicants?type=INTERNSHIP&id=<%= in.getId() %>" style="color: var(--secondary); font-weight: 700;">
                                        👥 <%= in.getApplicantCount() %> Students
                                    </a>
                                </td>
                                <td><%= in.getDeadline() %></td>
                                <td><span class="status-badge status-<%= in.getStatus() %>"><%= in.getStatus() %></span></td>
                                <td>
                                    <div style="display: flex; gap: 6px;">
                                        <a href="<%= ctx %>/company/edit-internship?id=<%= in.getId() %>" class="btn btn-outline btn-sm">Edit</a>
                                        <a href="<%= ctx %>/company/delete-posting?type=INTERNSHIP&id=<%= in.getId() %>" 
                                           class="btn btn-danger btn-sm confirm-delete" 
                                           data-item="Internship '<%= in.getTitle() %>'">Delete</a>
                                    </div>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
