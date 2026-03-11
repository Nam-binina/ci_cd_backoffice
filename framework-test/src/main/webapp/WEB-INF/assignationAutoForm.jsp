<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assignation automatique</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">Formulaire d'assignation automatique</h1>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null && !error.trim().isEmpty()) {
        %>
            <p class="error"><%= error %></p>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/assignation/method/auto/save" method="post">
            <div class="field">
                <label for="date">Date d'arrivée (sans heure)</label>
                <input id="date" name="date" type="date" required />
                <p class="hint">Le système va charger toutes les réservations de cette date (peu importe l'heure).</p>
            </div>
            <button type="submit" class="btn">Enregistrer (placeholder)</button>
        </form>

        <a class="link" href="${pageContext.request.contextPath}/assignation/method">← Retour au choix de méthode</a>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
