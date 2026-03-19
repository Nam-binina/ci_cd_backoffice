<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assignation automatique</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
<%@ include file="/assets/theme.css" %>

/* Correctif lisibilité input date */
.content-card input[type="date"] {
    color: #1a1612 !important;
    -webkit-text-fill-color: #1a1612 !important;
    background: #ffffff !important;
    color-scheme: light;
}

.content-card input[type="date"]::-webkit-datetime-edit,
.content-card input[type="date"]::-webkit-datetime-edit-text,
.content-card input[type="date"]::-webkit-datetime-edit-month-field,
.content-card input[type="date"]::-webkit-datetime-edit-day-field,
.content-card input[type="date"]::-webkit-datetime-edit-year-field {
    color: #1a1612 !important;
    -webkit-text-fill-color: #1a1612 !important;
}

.content-card input[type="date"]::-webkit-date-and-time-value {
    color: #1a1612 !important;
    -webkit-text-fill-color: #1a1612 !important;
}

.content-card input[type="date"]::-webkit-calendar-picker-indicator {
    opacity: 0.9;
    cursor: pointer;
}
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
