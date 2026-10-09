<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Student" %>
<%
    request.setAttribute("pageTitle", "My Profile - CampusHire");
    Student student = (Student) request.getAttribute("student");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 800px;">
        <jsp:include page="/includes/alerts.jsp" />

        <div class="card">
            <div class="card-header">
                <div>
                    <h3>👤 My Academic & Student Profile</h3>
                    <p style="font-size: 0.88rem; color: var(--text-muted); margin-top: 4px;">Keep your CGPA, technical skills and resume link up-to-date for recruiters</p>
                </div>
            </div>

            <form action="<%= ctx %>/student/profile" method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label>Roll Number (Fixed)</label>
                        <input type="text" value="<%= student.getRollNo() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                    </div>
                    <div class="form-group">
                        <label>Registered Email</label>
                        <input type="text" value="<%= student.getEmail() != null ? student.getEmail() : "" %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">First Name *</label>
                        <input type="text" id="firstName" name="firstName" value="<%= student.getFirstName() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" value="<%= student.getLastName() != null ? student.getLastName() : "" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="department">Department / Branch *</label>
                        <select id="department" name="department" required>
                            <option value="Computer Science and Engineering" <%= "Computer Science and Engineering".equals(student.getDepartment()) ? "selected" : "" %>>Computer Science and Engineering (CSE)</option>
                            <option value="Information Technology" <%= "Information Technology".equals(student.getDepartment()) ? "selected" : "" %>>Information Technology (IT)</option>
                            <option value="Electronics and Communication" <%= "Electronics and Communication".equals(student.getDepartment()) ? "selected" : "" %>>Electronics and Communication (ECE)</option>
                            <option value="Electrical Engineering" <%= "Electrical Engineering".equals(student.getDepartment()) ? "selected" : "" %>>Electrical Engineering (EE)</option>
                            <option value="Mechanical Engineering" <%= "Mechanical Engineering".equals(student.getDepartment()) ? "selected" : "" %>>Mechanical Engineering (ME)</option>
                            <option value="Civil Engineering" <%= "Civil Engineering".equals(student.getDepartment()) ? "selected" : "" %>>Civil Engineering (CE)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="cgpa">Current CGPA (0.00 - 10.00) *</label>
                        <input type="number" id="cgpa" name="cgpa" step="0.01" min="0" max="10" value="<%= student.getCgpa() %>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="passingYear">Passing / Graduation Year *</label>
                        <select id="passingYear" name="passingYear" required>
                            <option value="2025" <%= student.getPassingYear() == 2025 ? "selected" : "" %>>2025</option>
                            <option value="2026" <%= student.getPassingYear() == 2026 ? "selected" : "" %>>2026</option>
                            <option value="2027" <%= student.getPassingYear() == 2027 ? "selected" : "" %>>2027</option>
                            <option value="2028" <%= student.getPassingYear() == 2028 ? "selected" : "" %>>2028</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="phone">Contact Mobile Number</label>
                        <input type="text" id="phone" name="phone" value="<%= student.getPhone() != null ? student.getPhone() : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="resumeUrl">Resume Link (Google Drive / GitHub / Cloud Hosted URL)</label>
                    <input type="url" id="resumeUrl" name="resumeUrl" value="<%= student.getResumeUrl() != null ? student.getResumeUrl() : "" %>" placeholder="https://drive.google.com/file/d/...">
                    <% if (student.getResumeUrl() != null && !student.getResumeUrl().trim().isEmpty()) { %>
                        <div style="margin-top: 6px; font-size: 0.85rem;">
                            <a href="<%= student.getResumeUrl() %>" target="_blank" style="color: var(--primary); font-weight: 600;">🔗 Test Current Resume Link</a>
                        </div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label for="skills">Technical & Soft Skills</label>
                    <input type="text" id="skills" name="skills" value="<%= student.getSkills() != null ? student.getSkills() : "" %>" placeholder="e.g. Java, Spring Boot, MySQL, React, AWS, Communication">
                </div>

                <div class="form-group">
                    <label for="address">Address / Accommodation</label>
                    <textarea id="address" name="address" rows="2"><%= student.getAddress() != null ? student.getAddress() : "" %></textarea>
                </div>

                <div style="margin-top: 25px;">
                    <button type="submit" class="btn btn-primary" style="padding: 11px 24px;">Save Profile Changes</button>
                    <a href="<%= ctx %>/student/dashboard" class="btn btn-outline" style="margin-left: 10px;">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
