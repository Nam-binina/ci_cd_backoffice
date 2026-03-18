<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer un token</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">🔑 Créer un token d'accès</h1>

        <div class="info-box">
            Un token permet d'autoriser l'accès au <strong>frontoffice</strong>.
            Il sera ajouté à l'URL sous la forme <code>?token=xxxx-xxxx-xxxx</code>.
            Le token expirera automatiquement après la durée choisie.
        </div>

        <form action="${pageContext.request.contextPath}/token/create" method="POST">
            <div class="form-group">
                <label for="durationHours">Durée de validité</label>
                <select id="durationHours" name="durationHours">
                    <option value="1">1 heure</option>
                    <option value="6">6 heures</option>
                    <option value="12">12 heures</option>
                    <option value="24" selected>24 heures (1 jour)</option>
                    <option value="48">48 heures (2 jours)</option>
                    <option value="168">168 heures (7 jours)</option>
                    <option value="720">720 heures (30 jours)</option>
                </select>
                <p class="hint">Le token sera automatiquement invalidé après cette durée.</p>
            </div>

            <button type="submit">Générer le token</button>
        </form>

        <div class="links">
            <a href="${pageContext.request.contextPath}/token/list">📋 Liste des tokens</a>
            <a href="${pageContext.request.contextPath}/backoffice">⬅ Retour backoffice</a>
        </div>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
