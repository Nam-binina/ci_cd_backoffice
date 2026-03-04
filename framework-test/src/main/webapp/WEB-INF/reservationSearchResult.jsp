<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultat recherche réservation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 520px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #333; }
        .info { margin: 20px 0; font-size: 18px; text-align: center; }
        .info span { font-weight: bold; color: #2e7d32; }
        .error { color: #b71c1c; background: #fdecea; padding: 10px; border-radius: 4px; text-align: center; }
        .actions { display: flex; justify-content: space-between; margin-top: 25px; }
        a { text-decoration: none; color: #fff; background: #4CAF50; padding: 10px 18px; border-radius: 4px; }
        a.secondary { background: #607d8b; }
    </style>
</head>
<body>
<div class="container">
    <h1>📅 Résultat de la recherche</h1>

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
</body>
</html>
