<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Company Registration - CampusHire");
%>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="max-width: 760px;">
        <jsp:include page="/includes/alerts.jsp" />

        <div class="card">
            <div class="card-header">
                <div>
                    <h3>🏢 Recruiter / Corporate Registration</h3>
                    <p style="font-size: 0.88rem; color: var(--text-muted); margin-top: 4px;">Register your organization to hire university talent. Note: Accounts require Placement Cell approval.</p>
                </div>
            </div>

            <form action="<%= request.getContextPath() %>/register" method="POST">
                <input type="hidden" name="role" value="COMPANY">

                <div class="form-row">
                    <div class="form-group">
                        <label for="username">Username / HR User ID *</label>
                        <input type="text" id="username" name="username" required placeholder="e.g. tcs_recruiter">
                    </div>
                    <div class="form-group">
                        <label for="email">Corporate Official Email *</label>
                        <input type="email" id="email" name="email" required placeholder="e.g. campus@company.com">
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
                        <label for="companyName">Company / Organization Name *</label>
                        <input type="text" id="companyName" name="companyName" required placeholder="e.g. Tata Consultancy Services">
                    </div>
                    <div class="form-group">
                        <label for="industry">Industry Sector *</label>
                        <select id="industry" name="industry" required>
                            <option value="IT & Software Services">IT & Software Services</option>
                            <option value="Financial Services & FinTech">Financial Services & FinTech</option>
                            <option value="Telecommunications & Networks">Telecommunications & Networks</option>
                            <option value="Consulting & Analytics">Consulting & Analytics</option>
                            <option value="Core Engineering & Manufacturing">Core Engineering & Manufacturing</option>
                            <option value="E-Commerce & Internet">E-Commerce & Internet</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="website">Company Website URL</label>
                        <input type="url" id="website" name="website" placeholder="https://www.company.com">
                    </div>
                    <div class="form-group">
                        <label for="contactPerson">HR / Contact Person Name</label>
                        <input type="text" id="contactPerson" name="contactPerson" placeholder="e.g. Vikram Malhotra (Lead Campus HR)">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Corporate Contact Number</label>
                        <input type="text" id="phone" name="phone" placeholder="e.g. 080-12345678">
                    </div>
                    <div class="form-group">
                        <label for="address">Corporate Office Location</label>
                        <input type="text" id="address" name="address" placeholder="e.g. Electronic City, Bengaluru">
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Company Brief Overview</label>
                    <textarea id="description" name="description" rows="3" placeholder="Brief summary of your organization and campus hiring vision..."></textarea>
                </div>

                <div style="display: flex; gap: 12px; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary" style="flex: 1; padding: 12px; background-color: var(--secondary);">
                        Submit Company Registration &rarr;
                    </button>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline" style="padding: 12px 20px;">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
