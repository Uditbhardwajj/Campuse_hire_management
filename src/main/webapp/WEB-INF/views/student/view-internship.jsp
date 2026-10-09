<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Internship, com.placement.model.Student" %>
<%
    request.setAttribute("pageTitle", "Internship Details - CampusHire");
    Internship internship = (Internship) request.getAttribute("internship");
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
                    <span class="opp-badge badge-intern">INTERNSHIP &bull; <%= internship.getDurationMonths() %> Months</span>
                    <h1 style="font-size: 1.7rem; font-weight: 800; color: var(--text-main); margin-top: 8px;"><%= internship.getTitle() %></h1>
                    <div style="font-size: 1.05rem; color: var(--text-muted); margin-top: 4px;">🏢 <strong><%= internship.getCompanyName() %></strong></div>
                </div>
                <div style="text-align: right;">
                    <div style="font-size: 1.6rem; font-weight: 800; color: var(--secondary);">₹<%= String.format("%,.0f", internship.getStipendPerMonth()) %>/mo</div>
                    <div style="font-size: 0.85rem; color: var(--text-muted);">Monthly Stipend</div>
                </div>
            </div>

            <!-- Internship Highlights Grid -->
            <div class="grid-3" style="margin-bottom: 24px; background: #f8fafc; padding: 16px; border-radius: var(--radius);">
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Location</div>
                    <div style="font-weight: 700;">📍 <%= internship.getLocation() %></div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Min CGPA Cutoff</div>
                    <div style="font-weight: 700; color: <%= isEligible ? "var(--success)" : "var(--danger)" %>;">
                        🎓 <%= internship.getMinCgpa() %> (Yours: <%= student.getCgpa() %>)
                    </div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Deadline to Apply</div>
                    <div style="font-weight: 700;">📅 <%= internship.getDeadline() %></div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Allowed Branches</div>
                    <div style="font-weight: 600;"><%= internship.getAllowedBranches() %></div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Duration</div>
                    <div style="font-weight: 600;">⏱️ <%= internship.getDurationMonths() %> Months</div>
                </div>
                <div>
                    <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase;">Total Applicants</div>
                    <div style="font-weight: 600;">👥 <%= internship.getApplicantCount() %> Students Applied</div>
                </div>
            </div>

            <!-- Description -->
            <div style="margin-bottom: 24px;">
                <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 10px;">Internship Overview</h3>
                <p style="font-size: 0.95rem; line-height: 1.6; color: #334155; white-space: pre-line;"><%= internship.getDescription() %></p>
            </div>

            <!-- Requirements -->
            <div style="margin-bottom: 30px;">
                <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 10px;">Eligibility & Skills Desired</h3>
                <p style="font-size: 0.95rem; line-height: 1.6; color: #334155; white-space: pre-line;"><%= internship.getRequirements() %></p>
            </div>

            <!-- Application Section -->
            <div style="padding-top: 20px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
                <div>
                    <a href="<%= ctx %>/student/internships" class="btn btn-outline">&larr; Back to Internships</a>
                </div>

                <div>
                    <% if (alreadyApplied) { %>
                        <button class="btn btn-secondary" disabled style="cursor: not-allowed; padding: 12px 24px;">
                            ✓ Already Applied
                        </button>
                    <% } else if (!isEligible) { %>
                        <div style="display: inline-flex; align-items: center; gap: 10px;">
                            <span style="font-size: 0.88rem; color: var(--danger); font-weight: 600;">⚠️ Ineligible: CGPA (<%= student.getCgpa() %>) &lt; Required (<%= internship.getMinCgpa() %>)</span>
                            <button class="btn btn-secondary" disabled style="cursor: not-allowed; padding: 12px 20px;">Cannot Apply</button>
                        </div>
                    <% } else { %>
                        <form action="<%= ctx %>/student/apply" method="POST" style="display: inline;">
                            <input type="hidden" name="postingType" value="INTERNSHIP">
                            <input type="hidden" name="postingId" value="<%= internship.getId() %>">
                            <button type="submit" class="btn btn-primary" style="padding: 12px 28px; font-size: 1rem; background-color: var(--secondary);">
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
