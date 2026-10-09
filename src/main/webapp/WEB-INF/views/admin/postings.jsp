<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Job, com.placement.model.Internship" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Manage Postings - TPO Admin");
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    List<Internship> internships = (List<Internship>) request.getAttribute("internships");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Campus Postings Oversight</h1>
            <p style="color: var(--text-muted); font-size: 0.92rem;">Audit and manage all active job and internship drives published by partner companies</p>
        </div>

        <!-- All Jobs -->
        <div class="card" style="margin-bottom: 30px;">
            <div class="card-header">
                <h3>💼 Full-Time Job Drives (<%= jobs != null ? jobs.size() : 0 %>)</h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Company</th>
                            <th>Role Title</th>
                            <th>Category</th>
                            <th>CTC</th>
                            <th>Cutoff</th>
                            <th>Applicants</th>
                            <th>Deadline</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (jobs == null || jobs.isEmpty()) { %>
                            <tr><td colspan="10" style="text-align: center; color: var(--text-muted);">No job drives active.</td></tr>
                        <% } else {
                            int idx = 1;
                            for (Job j : jobs) { %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td style="font-weight: 700;">🏢 <%= j.getCompanyName() %></td>
                                <td><%= j.getTitle() %></td>
                                <td><%= j.getRoleCategory() %></td>
                                <td style="font-weight: 600; color: var(--primary);"><%= j.getPackageLpa() %> LPA</td>
                                <td><%= j.getMinCgpa() %></td>
                                <td><strong><%= j.getApplicantCount() %></strong></td>
                                <td><%= j.getDeadline() %></td>
                                <td><span class="status-badge status-<%= j.getStatus() %>"><%= j.getStatus() %></span></td>
                                <td>
                                    <a href="<%= ctx %>/admin/delete-posting?type=JOB&id=<%= j.getId() %>" 
                                       class="btn btn-danger btn-sm confirm-delete" 
                                       data-item="Job '<%= j.getTitle() %>'">Delete</a>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- All Internships -->
        <div class="card">
            <div class="card-header">
                <h3>🌱 Internship Drives (<%= internships != null ? internships.size() : 0 %>)</h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Company</th>
                            <th>Role Title</th>
                            <th>Domain</th>
                            <th>Stipend</th>
                            <th>Duration</th>
                            <th>Cutoff</th>
                            <th>Applicants</th>
                            <th>Deadline</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (internships == null || internships.isEmpty()) { %>
                            <tr><td colspan="11" style="text-align: center; color: var(--text-muted);">No internships active.</td></tr>
                        <% } else {
                            int idx = 1;
                            for (Internship in : internships) { %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td style="font-weight: 700;">🏢 <%= in.getCompanyName() %></td>
                                <td><%= in.getTitle() %></td>
                                <td><%= in.getRoleCategory() %></td>
                                <td style="font-weight: 600; color: var(--secondary);">₹<%= String.format("%,.0f", in.getStipendPerMonth()) %>/mo</td>
                                <td><%= in.getDurationMonths() %> Mo</td>
                                <td><%= in.getMinCgpa() %></td>
                                <td><strong><%= in.getApplicantCount() %></strong></td>
                                <td><%= in.getDeadline() %></td>
                                <td><span class="status-badge status-<%= in.getStatus() %>"><%= in.getStatus() %></span></td>
                                <td>
                                    <a href="<%= ctx %>/admin/delete-posting?type=INTERNSHIP&id=<%= in.getId() %>" 
                                       class="btn btn-danger btn-sm confirm-delete" 
                                       data-item="Internship '<%= in.getTitle() %>'">Delete</a>
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
