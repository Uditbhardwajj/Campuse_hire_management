<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String err = (String) request.getAttribute("errorMessage");
    if (err == null) err = request.getParameter("error");

    String succ = (String) request.getAttribute("successMessage");
    if (succ == null) succ = request.getParameter("msg");
%>
<% if (err != null && !err.trim().isEmpty()) { %>
    <div class="alert alert-danger">
        <strong>Error:</strong> <%= err %>
    </div>
<% } %>
<% if (succ != null && !succ.trim().isEmpty()) { %>
    <div class="alert alert-success">
        <strong>Success:</strong> <%= succ %>
    </div>
<% } %>
