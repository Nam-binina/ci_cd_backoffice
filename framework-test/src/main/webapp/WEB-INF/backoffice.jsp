<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backoffice</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">📋 Backoffice</h1>
        <div class="nav">
            <a href="${pageContext.request.contextPath}/reservation/list">
                <span class="icon">📅</span> Liste des réservations
            </a>
            <a href="${pageContext.request.contextPath}/reservation/form">
                <span class="icon">➕</span> Nouvelle réservation
            </a>
            <a href="${pageContext.request.contextPath}/token/list">
                <span class="icon">🔑</span> Gestion des tokens
            </a>
            <a href="${pageContext.request.contextPath}/token/form">
                <span class="icon">🆕</span> Créer un token
            </a>
            <a href="${pageContext.request.contextPath}/assignation/page">
                <span class="icon">🚗</span> Liste des assignations
            </a>
        </div>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
