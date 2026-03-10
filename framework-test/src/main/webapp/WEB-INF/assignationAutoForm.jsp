<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assignation automatique</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 700px; margin: 0 auto; }
        .field { margin-top: 16px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; }
        input[list] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; }
        .btn { margin-top: 14px; padding: 10px 16px; border: none; border-radius: 6px; background: #4CAF50; color: white; cursor: pointer; }
        .btn:hover { background: #45a049; }
        .error { color: #c62828; margin-top: 10px; }
        .hint { color: #666; font-size: 14px; margin-top: 6px; }
        .link { display: inline-block; margin-top: 18px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Formulaire d'assignation automatique</h1>

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
</body>
</html>
