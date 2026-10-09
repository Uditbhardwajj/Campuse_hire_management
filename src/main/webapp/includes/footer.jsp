<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer>
    <div class="container">
        <div class="footer-content">
            <div>
                <div class="footer-brand">CampusHire - Training & Placement Cell</div>
                <p style="margin-top: 6px; font-size: 0.85rem;">Empowering Students and Connecting Top Industry Recruiters</p>
            </div>
            <div>
                <p>Developed with <strong>Core Java, Servlets, JDBC, JSP & MySQL</strong></p>
                <p style="font-size: 0.8rem; margin-top: 4px; color: #64748b;">Academic Project | 3rd Year B.Tech Computer Science & Engineering</p>
            </div>
        </div>
        <div style="text-align: center; font-size: 0.8rem; color: #64748b;">
            &copy; <%= java.time.Year.now().getValue() %> College Placement & Internship Management System. All rights reserved.
        </div>
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
