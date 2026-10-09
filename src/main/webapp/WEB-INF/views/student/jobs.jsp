<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Job, com.placement.model.Student" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Explore Jobs - CampusHire");
    Student student = (Student) request.getAttribute("student");
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    String keyword = (String) request.getAttribute("keyword");
    String category = (String) request.getAttribute("category");
    String minCgpa = (String) request.getAttribute("minCgpa");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Full-Time Placement Opportunities</h1>
            <p style="color: var(--text-muted); font-size: 0.92rem;">Explore verified campus recruitment drives and apply according to your eligibility</p>
        </div>

        <!-- Filter & Search Bar -->
        <div class="filter-bar">
            <form action="<%= ctx %>/student/jobs" method="GET" class="filter-form">
                <input type="text" name="keyword" class="filter-input" placeholder="Search by job title, company, or skills..." 
                       value="<%= keyword != null ? keyword : "" %>">

                <select name="category" class="filter-select">
                    <option value="">All Categories</option>
                    <option value="Software Engineering" <%= "Software Engineering".equals(category) ? "selected" : "" %>>Software Engineering</option>
                    <option value="Software Development" <%= "Software Development".equals(category) ? "selected" : "" %>>Software Development</option>
                    <option value="Systems & Cloud" <%= "Systems & Cloud".equals(category) ? "selected" : "" %>>Systems & Cloud</option>
                    <option value="Product Development" <%= "Product Development".equals(category) ? "selected" : "" %>>Product Development</option>
                    <option value="Data & Analytics" <%= "Data & Analytics".equals(category) ? "selected" : "" %>>Data & Analytics</option>
                </select>

                <select name="minCgpa" class="filter-select">
                    <option value="">Any CGPA Cutoff</option>
                    <option value="6.0" <%= "6.0".equals(minCgpa) ? "selected" : "" %>>CGPA Cutoff &le; 6.0</option>
                    <option value="7.0" <%= "7.0".equals(minCgpa) ? "selected" : "" %>>CGPA Cutoff &le; 7.0</option>
                    <option value="7.5" <%= "7.5".equals(minCgpa) ? "selected" : "" %>>CGPA Cutoff &le; 7.5</option>
                    <option value="8.0" <%= "8.0".equals(minCgpa) ? "selected" : "" %>>CGPA Cutoff &le; 8.0</option>
                </select>

                <button type="submit" class="btn btn-primary" style="padding: 10px 18px;">Search</button>
                <a href="<%= ctx %>/student/jobs" class="btn btn-outline" style="padding: 10px 14px;">Reset</a>
            </form>
        </div>

        <!-- Jobs Listing Grid -->
        <% if (jobs == null || jobs.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 40px; color: var(--text-muted);">
                <h3>No job postings matched your search criteria.</h3>
                <p style="margin-top: 8px;">Try clearing filters or search with different keywords.</p>
            </div>
        <% } else { %>
            <div class="grid-3">
                <% for (Job j : jobs) { 
                    boolean meetsCgpa = student.getCgpa() >= j.getMinCgpa();
                %>
                    <div class="opp-card">
                        <div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                <span class="opp-badge badge-job"><%= j.getRoleCategory() %></span>
                                <span style="font-size: 0.8rem; color: var(--text-muted);">👥 <%= j.getApplicantCount() %> applied</span>
                            </div>
                            <h3 class="opp-title"><%= j.getTitle() %></h3>
                            <div class="opp-company">🏢 <%= j.getCompanyName() %></div>

                            <div class="opp-meta">
                                <span>📍 <%= j.getLocation() %></span>
                                <span>💼 <%= j.getJobType() %></span>
                                <span>🎯 <%= j.getOpenings() %> Openings</span>
                                <span>📅 Apply: <%= j.getDeadline() %></span>
                            </div>

                            <div style="margin: 10px 0; font-size: 0.85rem; padding: 6px 10px; border-radius: 6px; background: <%= meetsCgpa ? "#f0fdf4" : "#fef2f2" %>; color: <%= meetsCgpa ? "var(--success)" : "var(--danger)" %>;">
                                🎓 <strong>Min CGPA: <%= j.getMinCgpa() %></strong> 
                                (<%= meetsCgpa ? "You are Eligible" : "Your CGPA: " + student.getCgpa() %>)
                            </div>

                            <p style="font-size: 0.86rem; color: #475569; line-height: 1.4; margin-bottom: 12px;">
                                <%= j.getDescription().length() > 110 ? j.getDescription().substring(0, 110) + "..." : j.getDescription() %>
                            </p>
                        </div>

                        <div class="opp-footer">
                            <span style="font-weight: 800; color: var(--primary); font-size: 1.1rem;"><%= j.getPackageLpa() %> LPA</span>
                            <a href="<%= ctx %>/student/view-posting?type=JOB&id=<%= j.getId() %>" class="btn btn-primary btn-sm">
                                View Details &rarr;
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
