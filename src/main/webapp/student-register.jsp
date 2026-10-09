<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Student Registration - CampusHire");
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 760px;">
        <jsp:include page="/includes/alerts.jsp" />

        <div class="card">
            <div class="card-header">
                <div>
                    <h3>🎓 Student Registration</h3>
                    <p style="font-size: 0.88rem; color: var(--text-muted); margin-top: 4px;">Fill in your academic and contact details to create your placement account</p>
                </div>
            </div>

            <form action="<%= request.getContextPath() %>/register" method="POST">
                <input type="hidden" name="role" value="STUDENT">

                <div class="form-row">
                    <div class="form-group">
                        <label for="username">Username *</label>
                        <input type="text" id="username" name="username" required placeholder="e.g. rahul.sharma">
                    </div>
                    <div class="form-group">
                        <label for="email">College Email *</label>
                        <input type="email" id="email" name="email" required placeholder="e.g. rahul@college.edu">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password *</label>
                        <input type="password" id="password" name="password" required placeholder="Min 6 characters">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Re-enter password">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="rollNo">College Roll No / Reg No *</label>
                        <input type="text" id="rollNo" name="rollNo" required placeholder="e.g. 21CS101">
                    </div>
                    <div class="form-group">
                        <label for="department">Department / Branch *</label>
                        <select id="department" name="department" required>
                            <option value="Computer Science and Engineering">Computer Science and Engineering (CSE)</option>
                            <option value="Information Technology">Information Technology (IT)</option>
                            <option value="Electronics and Communication">Electronics and Communication (ECE)</option>
                            <option value="Electrical Engineering">Electrical Engineering (EE)</option>
                            <option value="Mechanical Engineering">Mechanical Engineering (ME)</option>
                            <option value="Civil Engineering">Civil Engineering (CE)</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">First Name *</label>
                        <input type="text" id="firstName" name="firstName" required placeholder="First Name">
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" placeholder="Last Name">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="cgpa">Current Cumulative CGPA (0.00 - 10.00) *</label>
                        <input type="number" id="cgpa" name="cgpa" step="0.01" min="0" max="10" required placeholder="e.g. 8.50">
                    </div>
                    <div class="form-group">
                        <label for="passingYear">Graduation Year *</label>
                        <select id="passingYear" name="passingYear" required>
                            <option value="2025">2025</option>
                            <option value="2026" selected>2026</option>
                            <option value="2027">2027</option>
                            <option value="2028">2028</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Contact Mobile Number</label>
                        <input type="text" id="phone" name="phone" placeholder="e.g. 9876543210">
                    </div>
                    <div class="form-group">
                        <label for="resumeUrl">Resume Link (Google Drive / GitHub / LinkedIn)</label>
                        <input type="url" id="resumeUrl" name="resumeUrl" placeholder="https://drive.google.com/...">
                    </div>
                </div>

                <div class="form-group">
                    <label for="skills">Technical Skills (Comma-separated)</label>
                    <input type="text" id="skills" name="skills" placeholder="e.g. Java, Python, SQL, HTML, Data Structures">
                </div>

                <div class="form-group">
                    <label for="address">Address / Hostel Details</label>
                    <textarea id="address" name="address" rows="2" placeholder="Hostel / Local Address"></textarea>
                </div>

                <div style="display: flex; gap: 12px; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary" style="flex: 1; padding: 12px;">Create Student Account &rarr;</button>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline" style="padding: 12px 20px;">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
