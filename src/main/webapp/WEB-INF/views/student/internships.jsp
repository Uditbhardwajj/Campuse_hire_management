<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Internship, com.placement.model.Student" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Explore Internships - CampusHire");
    Student student = (Student) request.getAttribute("student");
    List<Internship> internships = (List<Internship>) request.getAttribute("internships");
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
            <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Student Internship Drives</h1>
            <p style="color: var(--text-muted); font-size: 0.92rem;">Gain industrial exposure with paid internships and Pre-Placement Offer (PPO) opportunities</p>
        </div>

        <!-- Filter & Search Bar -->
        <div class="filter-bar">
            <form action="<%= ctx %>/student/internships" method="GET" class="filter-form">
                <input type="text" name="keyword" class="filter-input" placeholder="Search internships by title, company, or skills..." 
                       value="<%= keyword != null ? keyword : "" %>">

                <select name="category" class="filter-select">
                    <option value="">All Categories</option>
                    <option value="Software Development" <%= "Software Development".equals(category) ? "selected" : "" %>>Software Development</option>
                    <option value="Data & Web" <%= "Data & Web".equals(category) ? "selected" : "" %>>Data & Web</option>
                    <option value="Infrastructure & Cloud" <%= "Infrastructure & Cloud".equals(category) ? "selected" : "" %>>Infrastructure & Cloud</option>
                    <option value="Engineering" <%= "Engineering".equals(category) ? "selected" : "" %>>Engineering</option>
                </select>

                <select name="minCgpa" class="filter-select">
                    <option value="">Any CGPA Cutoff</option>
                    <option value="6.0" <%= "6.0".equals(minCgpa) ? "selected" : "" %>>CGPA Cutoff &le; 6.0</option>
                    <option value="7.0" <%= "7.0".equals(minCgpa) ? "selected" : "" %>>CGPA Cutoff &le; 7.0</option>
                    <option value="7.5" <%= "7.5".equals(minCgpa) ? "selected" : "" %>>CGPA Cutoff &le; 7.5</option>
                </select>

                <button type="submit" class="btn btn-primary" style="padding: 10px 18px;">Search</button>
                <a href="<%= ctx %>/student/internships" class="btn btn-outline" style="padding: 10px 14px;">Reset</a>
            </form>
        </div>

        <!-- Internship Listings Grid -->
        <% if (internships == null || internships.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 40px; color: var(--text-muted);">
                <h3>No internship postings matched your search criteria.</h3>
                <p style="margin-top: 8px;">Try clearing filters or search with different keywords.</p>
            </div>
        <% } else { %>
            <div class="grid-3">
                <% for (Internship in : internships) { 
                    boolean meetsCgpa = student.getCgpa() >= in.getMinCgpa();
                %>
                    <div class="opp-card">
                        <div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                <span class="opp-badge badge-intern"><%= in.getDurationMonths() %> Months Internship</span>
                                <span style="font-size: 0.8rem; color: var(--text-muted);">👥 <%= in.getApplicantCount() %> applied</span>
                            </div>
                            <h3 class="opp-title"><%= in.getTitle() %></h3>
                            <div class="opp-company">🏢 <%= in.getCompanyName() %></div>

                            <div class="opp-meta">
                                <span>📍 <%= in.getLocation() %></span>
                                <span>🏷️ <%= in.getRoleCategory() %></span>
                                <span>🎯 <%= in.getOpenings() %> Openings</span>
                                <span>📅 Apply: <%= in.getDeadline() %></span>
                            </div>

                            <div style="margin: 10px 0; font-size: 0.85rem; padding: 6px 10px; border-radius: 6px; background: <%= meetsCgpa ? "#f0fdf4" : "#fef2f2" %>; color: <%= meetsCgpa ? "var(--success)" : "var(--danger)" %>;">
                                🎓 <strong>Min CGPA: <%= in.getMinCgpa() %></strong> 
                                (<%= meetsCgpa ? "You are Eligible" : "Your CGPA: " + student.getCgpa() %>)
                            </div>

                            <p style="font-size: 0.86rem; color: #475569; line-height: 1.4; margin-bottom: 12px;">
                                <%= in.getDescription().length() > 110 ? in.getDescription().substring(0, 110) + "..." : in.getDescription() %>
                            </p>
                        </div>

                        <div class="opp-footer">
                            <span style="font-weight: 800; color: var(--secondary); font-size: 1.05rem;">
                                ₹<%= String.format("%,.0f", in.getStipendPerMonth()) %>/mo
                            </span>
                            <a href="<%= ctx %>/student/view-posting?type=INTERNSHIP&id=<%= in.getId() %>" class="btn btn-primary btn-sm">
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
