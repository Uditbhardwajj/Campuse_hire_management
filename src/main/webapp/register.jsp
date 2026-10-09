<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Register - College Placement Portal");
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="font-size: 1.8rem; font-weight: 700; color: var(--primary);">Join Campus Placement Portal</h1>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Select your account type to proceed with registration</p>
        </div>

        <div class="grid-2" style="max-width: 800px; margin: 0 auto;">
            <!-- Student Registration Card -->
            <div class="card" style="text-align: center; padding: 35px 25px;">
                <div style="font-size: 3rem; margin-bottom: 15px;">🎓</div>
                <h2 style="font-size: 1.3rem; font-weight: 700; margin-bottom: 10px;">I am a Student</h2>
                <p style="font-size: 0.9rem; color: var(--text-muted); line-height: 1.5; margin-bottom: 25px;">
                    Register with your college roll number, enter your branch and CGPA, explore top company drives and track your recruitment rounds.
                </p>
                <a href="<%= request.getContextPath() %>/student-register.jsp" class="btn btn-primary" style="width: 100%;">
                    Register as Student &rarr;
                </a>
            </div>

            <!-- Company Registration Card -->
            <div class="card" style="text-align: center; padding: 35px 25px;">
                <div style="font-size: 3rem; margin-bottom: 15px;">🏢</div>
                <h2 style="font-size: 1.3rem; font-weight: 700; margin-bottom: 10px;">I am a Recruiter / Company</h2>
                <p style="font-size: 0.9rem; color: var(--text-muted); line-height: 1.5; margin-bottom: 25px;">
                    Register your organization, post job and internship vacancies, set eligibility criteria, and evaluate college applicants.
                </p>
                <a href="<%= request.getContextPath() %>/company-register.jsp" class="btn btn-primary" style="width: 100%; background-color: var(--secondary);">
                    Register as Company &rarr;
                </a>
            </div>
        </div>

        <div style="text-align: center; margin-top: 30px; font-size: 0.9rem;">
            Already have an account? <a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--primary); font-weight: 600;">Sign in here</a>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
