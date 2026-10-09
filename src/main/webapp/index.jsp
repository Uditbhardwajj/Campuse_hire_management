<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.dao.JobDAO, com.placement.dao.InternshipDAO, com.placement.dao.ApplicationDAO" %>
<%@ page import="com.placement.model.Job, com.placement.model.Internship, com.placement.model.DashboardStats" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Home - College Placement & Internship Portal");
    JobDAO jobDAO = new JobDAO();
    InternshipDAO internshipDAO = new InternshipDAO();
    ApplicationDAO appDAO = new ApplicationDAO();

    DashboardStats stats = appDAO.getStats();
    List<Job> featuredJobs = jobDAO.getAllOpenJobs();
    if (featuredJobs.size() > 3) featuredJobs = featuredJobs.subList(0, 3);

    List<Internship> featuredInternships = internshipDAO.getAllOpenInternships();
    if (featuredInternships.size() > 3) featuredInternships = featuredInternships.subList(0, 3);
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<section class="hero">
    <div class="container">
        <h1>College Placement & Internship Management System</h1>
        <p>A centralized campus recruitment platform connecting students, corporate recruiters, and the training & placement department for seamless job and internship drives.</p>
        <div class="hero-actions">
            <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-hero-white">Login to Portal</a>
            <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-hero-trans">Register Account</a>
        </div>
    </div>
</section>

<div class="container" style="margin-top: -30px; position: relative; z-index: 10;">
    <div class="grid-4">
        <div class="stat-card">
            <div class="stat-icon blue">🎓</div>
            <div class="stat-details">
                <h4><%= stats.getTotalStudents() %></h4>
                <p>Enrolled Students</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon purple">🏢</div>
            <div class="stat-details">
                <h4><%= stats.getTotalCompanies() %></h4>
                <p>Partner Companies</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">💼</div>
            <div class="stat-details">
                <h4><%= stats.getTotalJobs() + stats.getTotalInternships() %></h4>
                <p>Open Opportunities</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">🏆</div>
            <div class="stat-details">
                <h4><%= stats.getTotalPlaced() %></h4>
                <p>Students Placed</p>
            </div>
        </div>
    </div>
</div>

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <!-- Featured Job Openings -->
        <div style="margin-top: 30px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <div>
                    <h2 style="font-size: 1.5rem; font-weight: 700;">Latest Placement Drives</h2>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Full-time graduate engineer opportunities</p>
                </div>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline btn-sm">View All Jobs &rarr;</a>
            </div>

            <div class="grid-3">
                <% for (Job j : featuredJobs) { %>
                    <div class="opp-card">
                        <div>
                            <span class="opp-badge badge-job">JOB &bull; <%= j.getJobType() %></span>
                            <h3 class="opp-title"><%= j.getTitle() %></h3>
                            <div class="opp-company">🏢 <%= j.getCompanyName() %></div>
                            <div class="opp-meta">
                                <span>📍 <%= j.getLocation() %></span>
                                <span>🎓 Min CGPA: <%= j.getMinCgpa() %></span>
                                <span>📅 Apply by: <%= j.getDeadline() %></span>
                            </div>
                            <p style="font-size: 0.88rem; color: #475569; margin-bottom: 15px; line-height: 1.4;">
                                <%= j.getDescription().length() > 100 ? j.getDescription().substring(0, 100) + "..." : j.getDescription() %>
                            </p>
                        </div>
                        <div class="opp-footer">
                            <span style="font-weight: 700; color: var(--primary); font-size: 1.05rem;"><%= j.getPackageLpa() %> LPA</span>
                            <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary btn-sm">Apply Now</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Featured Internship Openings -->
        <div style="margin-top: 45px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <div>
                    <h2 style="font-size: 1.5rem; font-weight: 700;">Featured Internships</h2>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Pre-placement internships with stipend</p>
                </div>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline btn-sm">View All Internships &rarr;</a>
            </div>

            <div class="grid-3">
                <% for (Internship in : featuredInternships) { %>
                    <div class="opp-card">
                        <div>
                            <span class="opp-badge badge-intern">INTERNSHIP &bull; <%= in.getDurationMonths() %> Months</span>
                            <h3 class="opp-title"><%= in.getTitle() %></h3>
                            <div class="opp-company">🏢 <%= in.getCompanyName() %></div>
                            <div class="opp-meta">
                                <span>📍 <%= in.getLocation() %></span>
                                <span>🎓 Min CGPA: <%= in.getMinCgpa() %></span>
                                <span>📅 Apply by: <%= in.getDeadline() %></span>
                            </div>
                            <p style="font-size: 0.88rem; color: #475569; margin-bottom: 15px; line-height: 1.4;">
                                <%= in.getDescription().length() > 100 ? in.getDescription().substring(0, 100) + "..." : in.getDescription() %>
                            </p>
                        </div>
                        <div class="opp-footer">
                            <span style="font-weight: 700; color: var(--secondary); font-size: 1.05rem;">₹<%= String.format("%,.0f", in.getStipendPerMonth()) %>/mo</span>
                            <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary btn-sm">Apply Now</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- System Architecture Features -->
        <div style="margin-top: 50px; background: white; padding: 30px; border-radius: var(--radius); border: 1px solid var(--border);">
            <h2 style="font-size: 1.4rem; font-weight: 700; text-align: center; margin-bottom: 25px;">Why CampusHire?</h2>
            <div class="grid-3">
                <div>
                    <h3 style="font-size: 1.1rem; color: var(--primary); margin-bottom: 8px;">🎓 For Students</h3>
                    <p style="font-size: 0.9rem; color: var(--text-muted); line-height: 1.5;">
                        Complete profile management, eligibility checks based on CGPA criteria, real-time application tracking, and direct company recruitment drives.
                    </p>
                </div>
                <div>
                    <h3 style="font-size: 1.1rem; color: var(--primary); margin-bottom: 8px;">🏢 For Companies</h3>
                    <p style="font-size: 0.9rem; color: var(--text-muted); line-height: 1.5;">
                        Create customized job and internship listings, view shortlisted applicants, review student resumes, and update hiring rounds seamlessly.
                    </p>
                </div>
                <div>
                    <h3 style="font-size: 1.1rem; color: var(--primary); margin-bottom: 8px;">🛡️ For Placement Cell (TPO)</h3>
                    <p style="font-size: 0.9rem; color: var(--text-muted); line-height: 1.5;">
                        Supervise company approvals, monitor student registrations, track college-wide placement statistics, and generate placement reports.
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
