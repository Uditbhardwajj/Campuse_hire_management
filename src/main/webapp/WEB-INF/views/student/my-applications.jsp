<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Application, com.placement.model.Student" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "My Applications - CampusHire");
    Student student = (Student) request.getAttribute("student");
    List<Application> myApps = (List<Application>) request.getAttribute("myApps");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
            <div>
                <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">My Applications Tracker</h1>
                <p style="color: var(--text-muted); font-size: 0.92rem;">Monitor your recruitment stages, interview invitations and recruiter remarks</p>
            </div>
            <div>
                <a href="<%= ctx %>/student/jobs" class="btn btn-primary btn-sm">+ Apply to More Drives</a>
            </div>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Opportunity Title</th>
                            <th>Type</th>
                            <th>Company</th>
                            <th>Package / Stipend</th>
                            <th>Location</th>
                            <th>Applied Date</th>
                            <th>Current Status</th>
                            <th>Remarks from Recruiter</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (myApps == null || myApps.isEmpty()) { %>
                            <tr>
                                <td colspan="9" style="text-align: center; padding: 35px; color: var(--text-muted);">
                                    You have not submitted any applications yet. <br>
                                    <a href="<%= ctx %>/student/jobs" style="color: var(--primary); font-weight: 600; margin-top: 8px; display: inline-block;">Browse Job Openings &rarr;</a>
                                </td>
                            </tr>
                        <% } else {
                            int idx = 1;
                            for (Application a : myApps) { %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td style="font-weight: 700;">
                                    <a href="<%= ctx %>/student/view-posting?type=<%= a.getPostingType() %>&id=<%= a.getPostingId() %>" style="color: var(--text-main); text-decoration: none;">
                                        <%= a.getPostingTitle() %> &rarr;
                                    </a>
                                </td>
                                <td>
                                    <span class="opp-badge <%= "JOB".equalsIgnoreCase(a.getPostingType()) ? "badge-job" : "badge-intern" %>">
                                        <%= a.getPostingType() %>
                                    </span>
                                </td>
                                <td>🏢 <%= a.getCompanyName() %></td>
                                <td style="font-weight: 600; color: var(--primary);"><%= a.getCompensation() %></td>
                                <td><%= a.getLocation() %></td>
                                <td><%= a.getAppliedDate().toString().substring(0, 16) %></td>
                                <td>
                                    <span class="status-badge status-<%= a.getStatus() %>">
                                        <%= a.getStatus().replace("_", " ") %>
                                    </span>
                                </td>
                                <td style="font-size: 0.88rem; color: #475569; max-width: 250px;">
                                    <%= a.getRemarks() != null ? a.getRemarks() : "Under evaluation" %>
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
