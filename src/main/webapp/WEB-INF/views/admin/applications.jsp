<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Application" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "All Applications - TPO Admin");
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">College-Wide Applications Registry</h1>
            <p style="color: var(--text-muted); font-size: 0.92rem;">Audit real-time student participation and hiring decisions across all departments</p>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Student</th>
                            <th>Department</th>
                            <th>CGPA</th>
                            <th>Company</th>
                            <th>Opportunity Title</th>
                            <th>Package / Stipend</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                            <th>Remarks</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (applications == null || applications.isEmpty()) { %>
                            <tr><td colspan="11" style="text-align: center; padding: 35px; color: var(--text-muted);">No student applications recorded.</td></tr>
                        <% } else {
                            int idx = 1;
                            for (Application a : applications) { %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td>
                                    <div style="font-weight: 700;"><%= a.getStudentName() %></div>
                                    <div style="font-size: 0.8rem; color: var(--text-muted);"><%= a.getStudentRollNo() %></div>
                                </td>
                                <td><%= a.getStudentDepartment() %></td>
                                <td><strong><%= a.getStudentCgpa() %></strong></td>
                                <td style="font-weight: 600;">🏢 <%= a.getCompanyName() %></td>
                                <td>
                                    <div><%= a.getPostingTitle() %></div>
                                    <span class="opp-badge <%= "JOB".equalsIgnoreCase(a.getPostingType()) ? "badge-job" : "badge-intern" %>"><%= a.getPostingType() %></span>
                                </td>
                                <td style="font-weight: 600; color: var(--primary);"><%= a.getCompensation() %></td>
                                <td><%= a.getAppliedDate().toString().substring(0, 10) %></td>
                                <td><span class="status-badge status-<%= a.getStatus() %>"><%= a.getStatus().replace("_", " ") %></span></td>
                                <td style="font-size: 0.82rem; color: #475569; max-width: 180px;"><%= a.getRemarks() %></td>
                                <td>
                                    <button class="btn btn-outline btn-sm" onclick="openStatusModal(<%= a.getId() %>, '<%= a.getStatus() %>', '<%= a.getRemarks() != null ? a.getRemarks().replace("'", "\\'") : "" %>')">
                                        Edit Status
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
        <h3 style="margin-bottom: 14px; font-size: 1.2rem;">Admin Override Application Status</h3>
        <form action="<%= ctx %>/admin/update-app-status" method="POST">
            <input type="hidden" name="applicationId" id="modalAppId">

            <div class="form-group">
                <label for="modalStatus">Status</label>
                <select id="modalStatus" name="status" required>
                    <option value="PENDING">PENDING</option>
                    <option value="SHORTLISTED">SHORTLISTED</option>
                    <option value="INTERVIEW_SCHEDULED">INTERVIEW SCHEDULED</option>
                    <option value="ACCEPTED">ACCEPTED (Placed / Offer Issued)</option>
                    <option value="REJECTED">REJECTED</option>
                </select>
            </div>

            <div class="form-group">
                <label for="modalRemarks">TPO / Recruiter Remarks</label>
                <textarea id="modalRemarks" name="remarks" rows="3"></textarea>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 15px;">
                <button type="button" class="btn btn-outline" onclick="closeStatusModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Update Status</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
