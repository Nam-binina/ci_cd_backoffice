<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Filtrer les assignations</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
<div class="container">
    <h1 class="page-title">📅 Filtrer les assignations</h1>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/assignation/filter/result" method="POST">
        <div class="form-group">
            <label for="date">Date d'arrivée</label>
            <input type="date" id="date" name="date" required>
        </div>
        <button type="submit">Afficher</button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/assignation/page">⬅ Retour assignations</a>
        <a href="${pageContext.request.contextPath}/backoffice">🏠 Backoffice</a>
    </div>
</div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
