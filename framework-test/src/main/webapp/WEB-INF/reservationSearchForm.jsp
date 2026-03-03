<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche de réservation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 480px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #333; }
        .form-group { margin: 20px 0; }
        label { display: block; margin-bottom: 8px; font-weight: bold; }
        input[type="date"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        button { width: 100%; padding: 12px; background-color: #4CAF50; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background-color: #43a047; }
        .links { text-align: center; margin-top: 15px; }
        a { color: #007bff; text-decoration: none; }
        .error { color: #b71c1c; background: #fdecea; padding: 10px; border-radius: 4px; }
    </style>
</head>
<body>
<div class="container">
    <h1>🔍 Recherche de réservation</h1>

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
</body>
</html>
