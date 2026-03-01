<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Résultat assignation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        .mode { font-weight: bold; color: #2e7d32; }
        .link { display: inline-block; margin-top: 16px; margin-right: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Traitement de l'assignation</h1>
        <p>Méthode choisie : <span class="mode"><%= request.getAttribute("modeChoisi") %></span></p>
        <p><%= request.getAttribute("message") %></p>

        <a class="link" href="${pageContext.request.contextPath}/assignation/method">← Revenir au choix de méthode</a>
        <a class="link" href="${pageContext.request.contextPath}/assignation/page">Retour page assignation</a>
    </div>
</body>
</html>
