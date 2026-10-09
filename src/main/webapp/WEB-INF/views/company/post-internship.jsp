<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Internship, com.placement.model.Company" %>
<%
    Internship internship = (Internship) request.getAttribute("internship");
    boolean isEdit = (internship != null);
    request.setAttribute("pageTitle", (isEdit ? "Edit Internship" : "Post New Internship") + " - CampusHire");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 820px;">
        <jsp:include page="/includes/alerts.jsp" />

        <div class="card">
            <div class="card-header">
                <div>
                    <h3>🌱 <%= isEdit ? "Edit Internship Posting" : "Create New Internship Opportunity" %></h3>
                    <p style="font-size: 0.88rem; color: var(--text-muted); margin-top: 4px;">Launch student internship drives with stipend and pre-placement offer guidelines</p>
                </div>
            </div>

            <form action="<%= ctx %>/company/<%= isEdit ? "edit-internship" : "post-internship" %>" method="POST">
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= internship.getId() %>">
                <% } %>

                <div class="form-row">
                    <div class="form-group">
                        <label for="title">Internship Designation / Role *</label>
                        <input type="text" id="title" name="title" required value="<%= isEdit ? internship.getTitle() : "" %>" placeholder="e.g. Java Full Stack Intern">
                    </div>
                    <div class="form-group">
                        <label for="roleCategory">Functional Domain *</label>
                        <input type="text" id="roleCategory" name="roleCategory" required value="<%= isEdit ? internship.getRoleCategory() : "Software Development" %>" placeholder="e.g. Software Development, QA, Data">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="stipendPerMonth">Monthly Stipend (in ₹) *</label>
                        <input type="number" id="stipendPerMonth" name="stipendPerMonth" step="1000" min="0" required value="<%= isEdit ? internship.getStipendPerMonth() : "20000" %>" placeholder="e.g. 25000">
                    </div>
                    <div class="form-group">
                        <label for="durationMonths">Duration (in Months) *</label>
                        <select id="durationMonths" name="durationMonths" required>
                            <option value="2" <%= (isEdit && internship.getDurationMonths() == 2) ? "selected" : "" %>>2 Months (Summer Internship)</option>
                            <option value="3" <%= (isEdit && internship.getDurationMonths() == 3) ? "selected" : "" %>>3 Months</option>
                            <option value="6" <%= (!isEdit || internship.getDurationMonths() == 6) ? "selected" : "" %>>6 Months (Semester Internship)</option>
                            <option value="12" <%= (isEdit && internship.getDurationMonths() == 12) ? "selected" : "" %>>12 Months</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="minCgpa">Minimum CGPA Cutoff (0.0 - 10.0) *</label>
                        <input type="number" id="minCgpa" name="minCgpa" step="0.01" min="0" max="10" required value="<%= isEdit ? internship.getMinCgpa() : "6.50" %>">
                    </div>
                    <div class="form-group">
                        <label for="allowedBranches">Eligible Branches / Departments *</label>
                        <input type="text" id="allowedBranches" name="allowedBranches" required value="<%= isEdit ? internship.getAllowedBranches() : "CSE, IT, ECE" %>" placeholder="e.g. CSE, IT, ECE or All Branches">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="location">Location / Work Mode *</label>
                        <input type="text" id="location" name="location" required value="<%= isEdit ? internship.getLocation() : "Pune / Remote" %>" placeholder="e.g. Pune, Bengaluru, Hybrid, Remote">
                    </div>
                    <div class="form-group">
                        <label for="openings">Internship Seats / Openings</label>
                        <input type="number" id="openings" name="openings" min="1" value="<%= isEdit ? internship.getOpenings() : "5" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="deadline">Application Deadline *</label>
                        <input type="date" id="deadline" name="deadline" required value="<%= isEdit ? internship.getDeadline() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="status">Posting Status</label>
                        <select id="status" name="status">
                            <option value="OPEN" <%= (isEdit && "OPEN".equals(internship.getStatus())) ? "selected" : "" %>>OPEN (Accepting Applications)</option>
                            <option value="CLOSED" <%= (isEdit && "CLOSED".equals(internship.getStatus())) ? "selected" : "" %>>CLOSED</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Internship Learning & Project Scope</label>
                    <textarea id="description" name="description" rows="4" placeholder="Overview of projects and mentorship provided..."><%= isEdit ? internship.getDescription() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label for="requirements">Prerequisites & Desired Candidate Skills</label>
                    <textarea id="requirements" name="requirements" rows="4" placeholder="Languages, frameworks and coursework desired..."><%= isEdit ? internship.getRequirements() : "" %></textarea>
                </div>

                <div style="margin-top: 25px;">
                    <button type="submit" class="btn btn-primary" style="padding: 11px 26px; background-color: var(--secondary);">
                        <%= isEdit ? "Save Internship Changes" : "Publish Internship" %> &rarr;
                    </button>
                    <a href="<%= ctx %>/company/manage-postings" class="btn btn-outline" style="margin-left: 10px;">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
