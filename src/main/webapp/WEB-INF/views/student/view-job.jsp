<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Job, com.placement.model.Student" %>
<%
    request.setAttribute("pageTitle", "Job Details - CampusHire");
    Job job = (Job) request.getAttribute("job");
    Student student = (Student) session.getAttribute("student");
    boolean alreadyApplied = (Boolean) request.getAttribute("alreadyApplied");
    boolean isEligible = (Boolean) request.getAttribute("isEligible");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 860px;">
        <jsp:include page="/includes/alerts.jsp" />

        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; border-bottom: 1px solid var(--border); padding-bottom: 16px;">
                <div>
                    <span class="opp-badge badge-job">FULL-TIME JOB &bull; <%= job.getRoleCategory() %></span>
                    <h1 style="font-size: 1.7rem; font-weight: 800; color: var(--text-main); margin-top: 8px;"><%= job.getTitle() %></h1>
                    <div style="font-size: 1.05rem; color: var(--text-muted); margin-top: 4px;">🏢 <strong><%= job.getCompanyName() %></strong></div>
                </div>
                <div style="text-align: right;">
                    <div style="font-size: 1.6rem; font-weight: 800; color: var(--primary);"><%= job.getPackageLpa() %> LPA</div>
                    <div style="font-size: 0.85rem; color: var(--text-muted);">Annual CTC</div>
                </div>
            </div>

            <!-- Job Highlights Grid -->
            <div class="grid-3" style="margin-bottom: 24px; background: #f8fafc; padding: 16px; border-radius: var(--radius);">
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Location</div>
                    <div style="font-weight: 700;">📍 <%= job.getLocation() %></div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Min CGPA Cutoff</div>
                    <div style="font-weight: 700; color: <%= isEligible ? "var(--success)" : "var(--danger)" %>;">
                        🎓 <%= job.getMinCgpa() %> (Yours: <%= student.getCgpa() %>)
                    </div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Deadline to Apply</div>
                    <div style="font-weight: 700;">📅 <%= job.getDeadline() %></div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Allowed Branches</div>
                    <div style="font-weight: 600;"><%= job.getAllowedBranches() %></div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Total Vacancies</div>
                    <div style="font-weight: 600;"><%= job.getOpenings() %> Positions</div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Total Applicants</div>
                    <div style="font-weight: 600;">👥 <%= job.getApplicantCount() %> Students Applied</div>
                </div>
            </div>

            <!-- Job Description -->
            <div style="margin-bottom: 24px;">
                <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 10px;">Role Description</h3>
                <p style="font-size: 0.95rem; line-height: 1.6; color: #334155; white-space: pre-line;"><%= job.getDescription() %></p>
            </div>

            <!-- Requirements -->
            <div style="margin-bottom: 30px;">
                <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 10px;">Candidate Requirements & Skills</h3>
                <p style="font-size: 0.95rem; line-height: 1.6; color: #334155; white-space: pre-line;"><%= job.getRequirements() %></p>
            </div>

            <!-- Application Section -->
            <div style="padding-top: 20px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
                <div>
                    <a href="<%= ctx %>/student/jobs" class="btn btn-outline">&larr; Back to Jobs List</a>
                </div>

                <div>
                    <% if (alreadyApplied) { %>
                        <button class="btn btn-secondary" disabled style="cursor: not-allowed; padding: 12px 24px;">
                            ✓ Already Applied
                        </button>
                    <% } else if (!isEligible) { %>
                        <div style="display: inline-flex; align-items: center; gap: 10px;">
                            <span style="font-size: 0.88rem; color: var(--danger); font-weight: 600;">⚠️ Ineligible: CGPA (<%= student.getCgpa() %>) &lt; Required (<%= job.getMinCgpa() %>)</span>
                            <button class="btn btn-secondary" disabled style="cursor: not-allowed; padding: 12px 20px;">Cannot Apply</button>
                        </div>
                    <% } else { %>
                        <form action="<%= ctx %>/student/apply" method="POST" style="display: inline;">
                            <input type="hidden" name="postingType" value="JOB">
                            <input type="hidden" name="postingId" value="<%= job.getId() %>">
                            <button type="submit" class="btn btn-primary" style="padding: 12px 28px; font-size: 1rem;">
                                Submit Application &rarr;
                            </button>
                        </form>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
