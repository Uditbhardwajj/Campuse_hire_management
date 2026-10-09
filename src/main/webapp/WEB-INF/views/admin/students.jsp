<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Student" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Manage Students - TPO Admin");
    List<Student> students = (List<Student>) request.getAttribute("students");
    String keyword = (String) request.getAttribute("keyword");
    String department = (String) request.getAttribute("department");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <jsp:include page="/includes/alerts.jsp" />

        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 1.6rem; font-weight: 700; color: var(--primary);">Student Enrollment Directory</h1>
            <p style="color: var(--text-muted); font-size: 0.92rem;">Search, view and manage all student profiles across engineering departments</p>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar">
            <form action="<%= ctx %>/admin/students" method="GET" class="filter-form">
                <input type="text" name="keyword" class="filter-input" placeholder="Search by name, roll no, or skills..." 
                       value="<%= keyword != null ? keyword : "" %>">

                <select name="department" class="filter-select">
                    <option value="">All Departments</option>
                    <option value="Computer Science and Engineering" <%= "Computer Science and Engineering".equals(department) ? "selected" : "" %>>CSE</option>
                    <option value="Information Technology" <%= "Information Technology".equals(department) ? "selected" : "" %>>IT</option>
                    <option value="Electronics and Communication" <%= "Electronics and Communication".equals(department) ? "selected" : "" %>>ECE</option>
                    <option value="Mechanical Engineering" <%= "Mechanical Engineering".equals(department) ? "selected" : "" %>>ME</option>
                    <option value="Civil Engineering" <%= "Civil Engineering".equals(department) ? "selected" : "" %>>CE</option>
                </select>

                <button type="submit" class="btn btn-primary" style="padding: 10px 18px;">Filter Students</button>
                <a href="<%= ctx %>/admin/students" class="btn btn-outline" style="padding: 10px 14px;">Reset</a>
            </form>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Roll Number</th>
                            <th>Student Name</th>
                            <th>Department</th>
                            <th>CGPA</th>
                            <th>Grad Year</th>
                            <th>Email & Phone</th>
                            <th>Skills</th>
                            <th>Resume</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (students == null || students.isEmpty()) { %>
                            <tr><td colspan="10" style="text-align: center; padding: 35px; color: var(--text-muted);">No student records found.</td></tr>
                        <% } else {
                            int idx = 1;
                            for (Student s : students) { %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td style="font-weight: 700;"><%= s.getRollNo() %></td>
                                <td><%= s.getFullName() %></td>
                                <td><%= s.getDepartment() %></td>
                                <td><strong style="color: var(--primary);"><%= s.getCgpa() %></strong></td>
                                <td><%= s.getPassingYear() %></td>
                                <td style="font-size: 0.82rem;">
                                    <div>✉️ <%= s.getEmail() %></div>
                                    <div>📞 <%= s.getPhone() != null ? s.getPhone() : "N/A" %></div>
                                </td>
                                <td style="font-size: 0.82rem; max-width: 180px;"><%= s.getSkills() != null ? s.getSkills() : "N/A" %></td>
                                <td>
                                    <% if (s.getResumeUrl() != null && !s.getResumeUrl().trim().isEmpty() && !s.getResumeUrl().equals("#")) { %>
                                        <a href="<%= s.getResumeUrl() %>" target="_blank" class="btn btn-outline btn-sm">🔗 View</a>
                                    <% } else { %>
                                        <span style="color: var(--text-muted); font-size: 0.8rem;">None</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="<%= ctx %>/admin/delete-student?id=<%= s.getId() %>" 
                                       class="btn btn-danger btn-sm confirm-delete" 
                                       data-item="Student '<%= s.getFullName() %>'">Delete</a>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
