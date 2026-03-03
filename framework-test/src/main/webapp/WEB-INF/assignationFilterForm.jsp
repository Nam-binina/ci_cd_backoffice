<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Filtrer les assignations</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 550px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; }
        .form-group { margin: 15px 0; }
        label { display: block; font-weight: bold; margin-bottom: 6px; }
        input[type="date"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        button { width: 100%; background-color: #4CAF50; color: white; padding: 12px; border: none; cursor: pointer; border-radius: 4px; font-size: 16px; }
        button:hover { background-color: #45a049; }
        .error { color: red; margin-bottom: 10px; }
        .links { margin-top: 20px; text-align: center; }
        .links a { margin: 0 8px; text-decoration: none; color: #007bff; }
    </style>
</head>
<body>
<div class="container">
    <h1>📅 Filtrer les assignations</h1>

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
</body>
</html>
