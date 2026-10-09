<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.DashboardStats, com.placement.model.Application, com.placement.model.Student" %>
<%@ page import="java.util.List, java.util.Map, java.util.HashMap" %>
<%
    request.setAttribute("pageTitle", "Placement Reports - TPO Admin");
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    List<Student> students = (List<Student>) request.getAttribute("students");

    int totalStudents = (students != null) ? students.size() : 0;
    int totalPlaced = stats != null ? stats.getTotalPlaced() : 0;
    double placementPct = totalStudents > 0 ? ((double) totalPlaced / totalStudents) * 100 : 0.0;

    // Department breakdown
    Map<String, Integer> deptStudentCount = new HashMap<>();
    Map<String, Integer> deptPlacedCount = new HashMap<>();

    if (students != null) {
        for (Student s : students) {
            String dept = s.getDepartment();
            deptStudentCount.put(dept, deptStudentCount.getOrDefault(dept, 0) + 1);
        }
    }

    if (applications != null) {
        for (Application a : applications) {
            if ("ACCEPTED".equalsIgnoreCase(a.getStatus())) {
                String dept = a.getStudentDepartment();
                deptPlacedCount.put(dept, deptPlacedCount.getOrDefault(dept, 0) + 1);
            }
        }
    }
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: gap;">
            <div>
                <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Institutional Placement Analytics & Reports</h1>
                <p style="color: var(--text-muted); font-size: 0.92rem;">Academic year summary of placement percentage, branch distributions, and selections</p>
            </div>
            <div>
                <button class="btn btn-outline btn-sm" onclick="window.print()">🖨️ Print / Export PDF</button>
            </div>
        </div>

        <!-- High-level Analytics Cards -->
        <div class="grid-4" style="margin-bottom: 30px;">
            <div class="stat-card">
                <div class="stat-icon blue">🎓</div>
                <div class="stat-details">
                    <h4><%= totalStudents %></h4>
                    <p>Total Eligible</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">🏆</div>
                <div class="stat-details">
                    <h4><%= totalPlaced %></h4>
                    <p>Total Offers Accepted</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon amber">📈</div>
                <div class="stat-details">
                    <h4><%= String.format("%.1f", placementPct) %>%</h4>
                    <p>Placement Rate</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon purple">💰</div>
                <div class="stat-details">
                    <h4>13.5 LPA</h4>
                    <p>Highest CTC Offered</p>
                </div>
            </div>
        </div>

        <!-- Branch / Department Performance Table -->
        <div class="card" style="margin-bottom: 30px;">
            <div class="card-header">
                <h3>📊 Department-Wise Placement Performance</h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Department / Branch</th>
                            <th>Enrolled Students</th>
                            <th>Placed Candidates</th>
                            <th>Placement Rate (%)</th>
                            <th>Status Bar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (deptStudentCount.isEmpty()) { %>
                            <tr><td colspan="5" style="text-align: center; color: var(--text-muted);">No student records available.</td></tr>
                        <% } else {
                            for (Map.Entry<String, Integer> entry : deptStudentCount.entrySet()) {
                                String dept = entry.getKey();
                                int enrolled = entry.getValue();
                                int placed = deptPlacedCount.getOrDefault(dept, 0);
                                double rate = enrolled > 0 ? ((double) placed / enrolled) * 100 : 0.0;
                        %>
                            <tr>
                                <td style="font-weight: 700;"><%= dept %></td>
                                <td><%= enrolled %> Students</td>
                                <td style="font-weight: 600; color: var(--success);"><%= placed %> Placed</td>
                                <td><strong><%= String.format("%.1f", rate) %>%</strong></td>
                                <td style="width: 250px;">
                                    <div style="background: #e2e8f0; border-radius: 10px; height: 10px; overflow: hidden;">
                                        <div style="background: var(--primary-light); width: <%= Math.min(100.0, rate) %>%; height: 100%;"></div>
                                    </div>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Honour Roll: Placed Students -->
        <div class="card">
            <div class="card-header">
                <h3>🎉 Placed Students Honour Roll</h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Student Name</th>
                            <th>Roll Number</th>
                            <th>Department</th>
                            <th>CGPA</th>
                            <th>Placed Company</th>
                            <th>Designation</th>
                            <th>Offer Package</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int placedIdx = 1;
                            boolean anyPlaced = false;
                            if (applications != null) {
                                for (Application a : applications) {
                                    if ("ACCEPTED".equalsIgnoreCase(a.getStatus())) {
                                        anyPlaced = true;
                        %>
                            <tr>
                                <td><%= placedIdx++ %></td>
                                <td style="font-weight: 700;"><%= a.getStudentName() %></td>
                                <td><%= a.getStudentRollNo() %></td>
                                <td><%= a.getStudentDepartment() %></td>
                                <td><strong><%= a.getStudentCgpa() %></strong></td>
                                <td>🏢 <%= a.getCompanyName() %></td>
                                <td><%= a.getPostingTitle() %></td>
                                <td style="font-weight: 700; color: var(--primary);"><%= a.getCompensation() %></td>
                                <td><span class="status-badge status-ACCEPTED">OFFER ACCEPTED</span></td>
                            </tr>
                        <% }}} 
                        if (!anyPlaced) { %>
                            <tr><td colspan="9" style="text-align: center; color: var(--text-muted); padding: 25px;">No students placed yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
