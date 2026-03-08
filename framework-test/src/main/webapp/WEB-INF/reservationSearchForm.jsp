<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche de réservation</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
<div class="container">
    <h1 class="page-title">🔍 Recherche de réservation</h1>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/reservation/search/result" method="POST">
        <div class="form-group">
            <label for="searchDate">Date d'arrivée</label>
            <input type="date" id="searchDate" name="searchDate" value="${searchDate}" required>
        </div>
        <button type="submit">Chercher</button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/backoffice">⬅ Retour backoffice</a>
    </div>
</div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
