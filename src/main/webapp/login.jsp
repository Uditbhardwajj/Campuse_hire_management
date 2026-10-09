<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Login - College Placement Portal");
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <div class="auth-container">
            <jsp:include page="/includes/alerts.jsp" />

            <div class="card">
                <div style="text-align: center; margin-bottom: 20px;">
                    <h2 style="font-size: 1.5rem; font-weight: 700; color: var(--primary);">Welcome Back</h2>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Sign in to access your placement dashboard</p>
                </div>

                <!-- Role Selector Tabs -->
                <div class="auth-tabs">
                    <div class="auth-tab active" data-role="STUDENT">Student</div>
                    <div class="auth-tab" data-role="COMPANY">Company HR</div>
                    <div class="auth-tab" data-role="ADMIN">Admin / TPO</div>
                </div>

                <form action="<%= request.getContextPath() %>/login" method="POST">
                    <input type="hidden" name="role" id="selectedRole" value="STUDENT">

                    <div class="form-group">
                        <label for="usernameOrEmail">Username / Email / Roll No</label>
                        <input type="text" id="usernameOrEmail" name="usernameOrEmail" required 
                               placeholder="Enter Roll Number or Student Email">
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required 
                               placeholder="Enter your account password">
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-top: 10px;">
                        Sign In &rarr;
                    </button>
                </form>

                <div style="text-align: center; margin-top: 20px; font-size: 0.88rem; color: var(--text-muted);">
                    Don't have an account yet? <br>
                    <a href="<%= request.getContextPath() %>/register.jsp" style="color: var(--primary); font-weight: 600;">Register as Student or Company</a>
                </div>

                <!-- Viva Demonstration Helper Credentials -->
                <div style="margin-top: 25px; padding: 14px; background: #f8fafc; border: 1px dashed var(--border); border-radius: var(--radius); font-size: 0.82rem;">
                    <div style="font-weight: 700; color: var(--text-main); margin-bottom: 6px;">💡 Demo Accounts for Viva:</div>
                    <div style="line-height: 1.6; color: #475569;">
                        &bull; <strong>Student:</strong> <code>rahul.sharma</code> / <code>student123</code><br>
                        &bull; <strong>Company:</strong> <code>tcs_recruiter</code> / <code>company123</code><br>
                        &bull; <strong>Admin:</strong> <code>admin</code> / <code>admin123</code>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
