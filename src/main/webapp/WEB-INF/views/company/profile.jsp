<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.placement.model.Company" %>
<%
    request.setAttribute("pageTitle", "Company Profile - CampusHire");
    Company company = (Company) request.getAttribute("company");
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
                    <h3>🏢 Corporate Profile Details</h3>
                    <p style="font-size: 0.88rem; color: var(--text-muted); margin-top: 4px;">Update your organization details, website, and point-of-contact for student visibility</p>
                </div>
                <div>
                    <span class="status-badge status-<%= company.getApprovalStatus() %>"><%= company.getApprovalStatus() %></span>
                </div>
            </div>

            <form action="<%= ctx %>/company/profile" method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label for="companyName">Company Name *</label>
                        <input type="text" id="companyName" name="companyName" value="<%= company.getCompanyName() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="industry">Industry Sector *</label>
                        <select id="industry" name="industry" required>
                            <option value="IT & Software Services" <%= "IT & Software Services".equals(company.getIndustry()) ? "selected" : "" %>>IT & Software Services</option>
                            <option value="Financial Services & FinTech" <%= "Financial Services & FinTech".equals(company.getIndustry()) ? "selected" : "" %>>Financial Services & FinTech</option>
                            <option value="Telecommunications & Networks" <%= "Telecommunications & Networks".equals(company.getIndustry()) ? "selected" : "" %>>Telecommunications & Networks</option>
                            <option value="Consulting & Analytics" <%= "Consulting & Analytics".equals(company.getIndustry()) ? "selected" : "" %>>Consulting & Analytics</option>
                            <option value="Core Engineering & Manufacturing" <%= "Core Engineering & Manufacturing".equals(company.getIndustry()) ? "selected" : "" %>>Core Engineering & Manufacturing</option>
                            <option value="E-Commerce & Internet" <%= "E-Commerce & Internet".equals(company.getIndustry()) ? "selected" : "" %>>E-Commerce & Internet</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="website">Official Website URL</label>
                        <input type="url" id="website" name="website" value="<%= company.getWebsite() != null ? company.getWebsite() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="contactPerson">HR / Contact Person</label>
                        <input type="text" id="contactPerson" name="contactPerson" value="<%= company.getContactPerson() != null ? company.getContactPerson() : "" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Contact Phone</label>
                        <input type="text" id="phone" name="phone" value="<%= company.getPhone() != null ? company.getPhone() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="address">Corporate Address</label>
                        <input type="text" id="address" name="address" value="<%= company.getAddress() != null ? company.getAddress() : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Company Overview</label>
                    <textarea id="description" name="description" rows="3"><%= company.getDescription() != null ? company.getDescription() : "" %></textarea>
                </div>

                <div style="margin-top: 25px;">
                    <button type="submit" class="btn btn-primary" style="padding: 11px 24px;">Update Company Profile</button>
                    <a href="<%= ctx %>/company/dashboard" class="btn btn-outline" style="margin-left: 10px;">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
