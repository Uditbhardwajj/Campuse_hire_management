<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Application, com.placement.model.Company" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Candidate Applicants - CampusHire");
    Company company = (Company) request.getAttribute("company");
    List<Application> applicants = (List<Application>) request.getAttribute("applicants");
    String selectedType = (String) request.getAttribute("selectedType");
    String selectedId = (String) request.getAttribute("selectedId");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
            <div>
                <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Candidate Applications Review</h1>
                <p style="color: var(--text-muted); font-size: 0.92rem;">
                    Evaluating student profiles, academic scores, and managing recruitment stages for <%= company.getCompanyName() %>
                </p>
            </div>
            <% if (selectedType != null) { %>
                <div>
                    <a href="<%= ctx %>/company/applicants" class="btn btn-outline btn-sm">&larr; Show All Postings' Applicants</a>
                </div>
            <% } %>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Student Details</th>
                            <th>Department</th>
                            <th>CGPA</th>
                            <th>Applied Opportunity</th>
                            <th>Skills</th>
                            <th>Resume</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (applicants == null || applicants.isEmpty()) { %>
                            <tr><td colspan="9" style="text-align: center; padding: 35px; color: var(--text-muted);">No candidate applications received for this drive yet.</td></tr>
                        <% } else {
                            int idx = 1;
                            for (Application a : applicants) { %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td>
                                    <div style="font-weight: 700;"><%= a.getStudentName() %></div>
                                    <div style="font-size: 0.8rem; color: var(--text-muted);">Roll: <%= a.getStudentRollNo() %></div>
                                    <div style="font-size: 0.8rem; color: var(--text-muted);">✉️ <%= a.getStudentEmail() %></div>
                                </td>
                                <td><%= a.getStudentDepartment() %></td>
                                <td>
                                    <span style="font-weight: 700; font-size: 1.05rem; color: var(--primary);"><%= a.getStudentCgpa() %></span>
                                </td>
                                <td>
                                    <div style="font-weight: 600;"><%= a.getPostingTitle() %></div>
                                    <span class="opp-badge <%= "JOB".equalsIgnoreCase(a.getPostingType()) ? "badge-job" : "badge-intern" %>"><%= a.getPostingType() %></span>
                                </td>
                                <td style="font-size: 0.82rem; color: #334155; max-width: 180px;">
                                    <%= a.getStudentSkills() != null ? a.getStudentSkills() : "N/A" %>
                                </td>
                                <td>
                                    <% if (a.getStudentResumeUrl() != null && !a.getStudentResumeUrl().equals("#")) { %>
                                        <a href="<%= a.getStudentResumeUrl() %>" target="_blank" class="btn btn-outline btn-sm">🔗 Resume</a>
                                    <% } else { %>
                                        <span style="color: var(--text-muted); font-size: 0.78rem;">Not uploaded</span>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="status-badge status-<%= a.getStatus() %>"><%= a.getStatus().replace("_", " ") %></span>
                                    <% if (a.getRemarks() != null && !a.getRemarks().trim().isEmpty()) { %>
                                        <div style="font-size: 0.78rem; color: var(--text-muted); margin-top: 4px; max-width: 150px;">
                                            <%= a.getRemarks() %>
                                        </div>
                                    <% } %>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" onclick="openStatusModal(<%= a.getId() %>, '<%= a.getStatus() %>', '<%= a.getRemarks() != null ? a.getRemarks().replace("'", "\\'") : "" %>')">
                                        Update
                                    </button>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Status Update Modal -->
<div id="statusModal" class="modal">
    <div class="modal-content">
        <h3 style="margin-bottom: 14px; font-size: 1.2rem;">Evaluate & Update Application</h3>
        <form action="<%= ctx %>/company/update-status" method="POST">
            <input type="hidden" name="applicationId" id="modalAppId">
            <input type="hidden" name="redirect" value="<%= ctx %>/company/applicants<%= selectedType != null ? "?type=" + selectedType + "&id=" + selectedId : "" %>">

            <div class="form-group">
                <label for="modalStatus">Recruitment Decision / Round</label>
                <select id="modalStatus" name="status" required>
                    <option value="PENDING">PENDING (Application Under Review)</option>
                    <option value="SHORTLISTED">SHORTLISTED (Resume Selected for Next Round)</option>
                    <option value="INTERVIEW_SCHEDULED">INTERVIEW SCHEDULED</option>
                    <option value="ACCEPTED">ACCEPTED (Candidate Selected / Offered)</option>
                    <option value="REJECTED">REJECTED (Candidate Not Selected)</option>
                </select>
            </div>

            <div class="form-group">
                <label for="modalRemarks">Feedback / Round Instructions</label>
                <textarea id="modalRemarks" name="remarks" rows="3" placeholder="e.g. Cleared round 1 online assessment. Virtual interview on Microsoft Teams..."></textarea>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 15px;">
                <button type="button" class="btn btn-outline" onclick="closeStatusModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
