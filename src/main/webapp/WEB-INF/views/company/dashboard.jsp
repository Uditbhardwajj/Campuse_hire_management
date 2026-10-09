<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Company, com.placement.model.Job, com.placement.model.Internship, com.placement.model.Application" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Recruiter Dashboard - CampusHire");
    Company company = (Company) request.getAttribute("company");
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    List<Internship> internships = (List<Internship>) request.getAttribute("internships");
    List<Application> applicants = (List<Application>) request.getAttribute("applicants");

    int totalJobs = request.getAttribute("totalJobs") != null ? (Integer) request.getAttribute("totalJobs") : 0;
    int totalInternships = request.getAttribute("totalInternships") != null ? (Integer) request.getAttribute("totalInternships") : 0;
    int totalApplicants = request.getAttribute("totalApplicants") != null ? (Integer) request.getAttribute("totalApplicants") : 0;
    int selectedCount = request.getAttribute("selectedCount") != null ? (Integer) request.getAttribute("selectedCount") : 0;
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <!-- Company Info Header -->
        <div class="card" style="margin-bottom: 24px; border-left: 5px solid var(--secondary);">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
                <div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <h2 style="font-size: 1.5rem; font-weight: 700;"><%= company.getCompanyName() %></h2>
                        <span class="status-badge status-<%= company.getApprovalStatus() %>"><%= company.getApprovalStatus() %></span>
                    </div>
                    <p style="color: var(--text-muted); font-size: 0.92rem; margin-top: 4px;">
                        Industry: <strong><%= company.getIndustry() %></strong> &bull; HR Contact: <strong><%= company.getContactPerson() != null ? company.getContactPerson() : "Campus Team" %></strong>
                    </p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="<%= ctx %>/company/post-job" class="btn btn-primary btn-sm">+ Post Job</a>
                    <a href="<%= ctx %>/company/post-internship" class="btn btn-secondary btn-sm">+ Post Internship</a>
                </div>
            </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="grid-4" style="margin-bottom: 30px;">
            <div class="stat-card">
                <div class="stat-icon blue">💼</div>
                <div class="stat-details">
                    <h4><%= totalJobs %></h4>
                    <p>Active Jobs</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">🌱</div>
                <div class="stat-details">
                    <h4><%= totalInternships %></h4>
                    <p>Internships</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon amber">👥</div>
                <div class="stat-details">
                    <h4><%= totalApplicants %></h4>
                    <p>Total Applicants</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon purple">🏆</div>
                <div class="stat-details">
                    <h4><%= selectedCount %></h4>
                    <p>Hired / Accepted</p>
                </div>
            </div>
        </div>

        <!-- Recent Applicants Table -->
        <div class="card" style="margin-bottom: 30px;">
            <div class="card-header">
                <h3>👥 Recent Student Applicants</h3>
                <a href="<%= ctx %>/company/applicants" class="btn btn-outline btn-sm">Manage All Applicants &rarr;</a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Roll No</th>
                            <th>Department</th>
                            <th>CGPA</th>
                            <th>Applied Opportunity</th>
                            <th>Status</th>
                            <th>Resume</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (applicants == null || applicants.isEmpty()) { %>
                            <tr><td colspan="8" style="text-align: center; color: var(--text-muted);">No student applications received yet.</td></tr>
                        <% } else {
                            int count = 0;
                            for (Application a : applicants) {
                                if (count++ >= 5) break; %>
                            <tr>
                                <td style="font-weight: 700;"><%= a.getStudentName() %></td>
                                <td><%= a.getStudentRollNo() %></td>
                                <td><%= a.getStudentDepartment() %></td>
                                <td><strong><%= a.getStudentCgpa() %></strong></td>
                                <td><%= a.getPostingTitle() %></td>
                                <td><span class="status-badge status-<%= a.getStatus() %>"><%= a.getStatus().replace("_", " ") %></span></td>
                                <td>
                                    <% if (a.getStudentResumeUrl() != null && !a.getStudentResumeUrl().equals("#")) { %>
                                        <a href="<%= a.getStudentResumeUrl() %>" target="_blank" class="btn btn-outline btn-sm">View Resume</a>
                                    <% } else { %>
                                        <span style="color: var(--text-muted); font-size: 0.8rem;">Not Provided</span>
                                    <% } %>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" onclick="openStatusModal(<%= a.getId() %>, '<%= a.getStatus() %>', '<%= a.getRemarks() != null ? a.getRemarks().replace("'", "\\'") : "" %>')">
                                        Update Status
                                    </button>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Current Postings Overview -->
        <div class="card">
            <div class="card-header">
                <h3>📋 Active Postings Overview</h3>
                <a href="<%= ctx %>/company/manage-postings" class="btn btn-outline btn-sm">View & Edit All &rarr;</a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Type</th>
                            <th>Compensation</th>
                            <th>Min CGPA</th>
                            <th>Applicants</th>
                            <th>Deadline</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Job j : jobs) { %>
                            <tr>
                                <td style="font-weight: 600;"><%= j.getTitle() %></td>
                                <td><span class="opp-badge badge-job">JOB</span></td>
                                <td><%= j.getPackageLpa() %> LPA</td>
                                <td><%= j.getMinCgpa() %></td>
                                <td><strong><%= j.getApplicantCount() %></strong></td>
                                <td><%= j.getDeadline() %></td>
                                <td><span class="status-badge status-<%= j.getStatus() %>"><%= j.getStatus() %></span></td>
                            </tr>
                        <% } %>
                        <% for (Internship in : internships) { %>
                            <tr>
                                <td style="font-weight: 600;"><%= in.getTitle() %></td>
                                <td><span class="opp-badge badge-intern">INTERNSHIP</span></td>
                                <td>₹<%= String.format("%,.0f", in.getStipendPerMonth()) %>/mo</td>
                                <td><%= in.getMinCgpa() %></td>
                                <td><strong><%= in.getApplicantCount() %></strong></td>
                                <td><%= in.getDeadline() %></td>
                                <td><span class="status-badge status-<%= in.getStatus() %>"><%= in.getStatus() %></span></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Status Update Modal -->
<div id="statusModal" class="modal">
    <div class="modal-content">
        <h3 style="margin-bottom: 14px; font-size: 1.2rem;">Update Application Status</h3>
        <form action="<%= ctx %>/company/update-status" method="POST">
            <input type="hidden" name="applicationId" id="modalAppId">
            <input type="hidden" name="redirect" value="<%= ctx %>/company/dashboard">

            <div class="form-group">
                <label for="modalStatus">Recruitment Stage / Status</label>
                <select id="modalStatus" name="status" required>
                    <option value="PENDING">PENDING (Under Initial Review)</option>
                    <option value="SHORTLISTED">SHORTLISTED (Selected for Next Stage)</option>
                    <option value="INTERVIEW_SCHEDULED">INTERVIEW SCHEDULED</option>
                    <option value="ACCEPTED">ACCEPTED (Final Job/Internship Offer)</option>
                    <option value="REJECTED">REJECTED</option>
                </select>
            </div>

            <div class="form-group">
                <label for="modalRemarks">Remarks / Interview Schedule Details</label>
                <textarea id="modalRemarks" name="remarks" rows="3" placeholder="e.g. Cleared technical round. Final HR scheduled for Monday..."></textarea>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 15px;">
                <button type="button" class="btn btn-outline" onclick="closeStatusModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Status</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
