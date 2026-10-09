<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Company" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Manage Companies - TPO Admin");
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Corporate Partners & Recruiters</h1>
            <p style="color: var(--text-muted); font-size: 0.92rem;">Verify, approve or deactivate hiring organizations participating in campus placements</p>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Company Name</th>
                            <th>Industry</th>
                            <th>Website</th>
                            <th>Contact Person</th>
                            <th>Email & Phone</th>
                            <th>Approval Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (companies == null || companies.isEmpty()) { %>
                            <tr><td colspan="8" style="text-align: center; padding: 35px; color: var(--text-muted);">No companies registered yet.</td></tr>
                        <% } else {
                            int idx = 1;
                            for (Company c : companies) { %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td style="font-weight: 700;"><%= c.getCompanyName() %></td>
                                <td><%= c.getIndustry() %></td>
                                <td>
                                    <% if (c.getWebsite() != null && !c.getWebsite().trim().isEmpty()) { %>
                                        <a href="<%= c.getWebsite() %>" target="_blank" style="color: var(--primary); text-decoration: none;">Visit Site &rarr;</a>
                                    <% } else { %>
                                        <span style="color: var(--text-muted);">N/A</span>
                                    <% } %>
                                </td>
                                <td><%= c.getContactPerson() != null ? c.getContactPerson() : "HR" %></td>
                                <td style="font-size: 0.82rem;">
                                    <div>✉️ <%= c.getEmail() %></div>
                                    <div>📞 <%= c.getPhone() != null ? c.getPhone() : "N/A" %></div>
                                </td>
                                <td>
                                    <span class="status-badge status-<%= c.getApprovalStatus() %>">
                                        <%= c.getApprovalStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 6px; align-items: center;">
                                        <% if (!"APPROVED".equalsIgnoreCase(c.getApprovalStatus())) { %>
                                            <a href="<%= ctx %>/admin/approve-company?id=<%= c.getId() %>&status=APPROVED" class="btn btn-success btn-sm">Approve</a>
                                        <% } %>
                                        <% if (!"REJECTED".equalsIgnoreCase(c.getApprovalStatus())) { %>
                                            <a href="<%= ctx %>/admin/approve-company?id=<%= c.getId() %>&status=REJECTED" class="btn btn-outline btn-sm">Reject</a>
                                        <% } %>
                                        <a href="<%= ctx %>/admin/delete-company?id=<%= c.getId() %>" 
                                           class="btn btn-danger btn-sm confirm-delete" 
                                           data-item="Company '<%= c.getCompanyName() %>'">Delete</a>
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
