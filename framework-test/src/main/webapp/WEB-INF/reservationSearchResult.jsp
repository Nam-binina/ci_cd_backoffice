<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultat recherche réservation</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
<div class="container">
    <h1 class="page-title">📅 Résultat de la recherche</h1>

    <%
        String error = (String) request.getAttribute("error");
        String searchDate = (String) request.getAttribute("searchDate");
        if (error != null) {
    %>
        <div class="error"><%= error %></div>
    <% } else if (searchDate != null) { %>
        <div class="info">Date sélectionnée : <span><%= searchDate %></span></div>
    <% } else { %>
        <div class="info">Aucune date fournie.</div>
    <% } %>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/reservation/search/form">Nouvelle recherche</a>
        <a class="secondary" href="${pageContext.request.contextPath}/reservation/list">Voir les réservations</a>
    </div>
</div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
