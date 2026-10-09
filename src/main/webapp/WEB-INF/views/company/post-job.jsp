<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Job, com.placement.model.Company" %>
<%
    Job job = (Job) request.getAttribute("job");
    boolean isEdit = (job != null);
    request.setAttribute("pageTitle", (isEdit ? "Edit Job" : "Post New Job") + " - CampusHire");
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
                    <h3>💼 <%= isEdit ? "Edit Job Posting" : "Create New Job Opportunity" %></h3>
                    <p style="font-size: 0.88rem; color: var(--text-muted); margin-top: 4px;">Define recruitment criteria, compensation, and candidate expectations</p>
                </div>
            </div>

            <form action="<%= ctx %>/company/<%= isEdit ? "edit-job" : "post-job" %>" method="POST">
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= job.getId() %>">
                <% } %>

                <div class="form-row">
                    <div class="form-group">
                        <label for="title">Job Designation / Role Title *</label>
                        <input type="text" id="title" name="title" required value="<%= isEdit ? job.getTitle() : "" %>" placeholder="e.g. Associate Software Engineer">
                    </div>
                    <div class="form-group">
                        <label for="roleCategory">Job Functional Category *</label>
                        <input type="text" id="roleCategory" name="roleCategory" required value="<%= isEdit ? job.getRoleCategory() : "Software Engineering" %>" placeholder="e.g. Software Engineering, Cloud, QA">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="jobType">Employment Type *</label>
                        <select id="jobType" name="jobType" required>
                            <option value="FULL_TIME" <%= (isEdit && "FULL_TIME".equals(job.getJobType())) ? "selected" : "" %>>Full Time (Regular)</option>
                            <option value="CONTRACT" <%= (isEdit && "CONTRACT".equals(job.getJobType())) ? "selected" : "" %>>Contractual</option>
                            <option value="PART_TIME" <%= (isEdit && "PART_TIME".equals(job.getJobType())) ? "selected" : "" %>>Part Time</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="packageLpa">Annual Package CTC (in LPA) *</label>
                        <input type="number" id="packageLpa" name="packageLpa" step="0.1" required value="<%= isEdit ? job.getPackageLpa() : "6.5" %>" placeholder="e.g. 7.5">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="minCgpa">Minimum CGPA Cutoff (0.0 - 10.0) *</label>
                        <input type="number" id="minCgpa" name="minCgpa" step="0.01" min="0" max="10" required value="<%= isEdit ? job.getMinCgpa() : "6.50" %>">
                    </div>
                    <div class="form-group">
                        <label for="allowedBranches">Eligible Branches / Departments *</label>
                        <input type="text" id="allowedBranches" name="allowedBranches" required value="<%= isEdit ? job.getAllowedBranches() : "CSE, IT, ECE" %>" placeholder="e.g. CSE, IT, ECE or All Branches">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="location">Job Location *</label>
                        <input type="text" id="location" name="location" required value="<%= isEdit ? job.getLocation() : "Bengaluru / Pune" %>" placeholder="e.g. Bengaluru, Pune, Hyderabad, Remote">
                    </div>
                    <div class="form-group">
                        <label for="openings">Number of Openings</label>
                        <input type="number" id="openings" name="openings" min="1" value="<%= isEdit ? job.getOpenings() : "5" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="deadline">Application Deadline *</label>
                        <input type="date" id="deadline" name="deadline" required value="<%= isEdit ? job.getDeadline() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="status">Posting Status</label>
                        <select id="status" name="status">
                            <option value="OPEN" <%= (isEdit && "OPEN".equals(job.getStatus())) ? "selected" : "" %>>OPEN (Accepting Applications)</option>
                            <option value="CLOSED" <%= (isEdit && "CLOSED".equals(job.getStatus())) ? "selected" : "" %>>CLOSED</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Detailed Job Description</label>
                    <textarea id="description" name="description" rows="4" placeholder="Responsibilities and project scope..."><%= isEdit ? job.getDescription() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label for="requirements">Technical Requirements & Preferred Qualifications</label>
                    <textarea id="requirements" name="requirements" rows="4" placeholder="Skills, programming languages, coursework required..."><%= isEdit ? job.getRequirements() : "" %></textarea>
                </div>

                <div style="margin-top: 25px;">
                    <button type="submit" class="btn btn-primary" style="padding: 11px 26px;">
                        <%= isEdit ? "Save Job Changes" : "Publish Job Posting" %> &rarr;
                    </button>
                    <a href="<%= ctx %>/company/manage-postings" class="btn btn-outline" style="margin-left: 10px;">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
