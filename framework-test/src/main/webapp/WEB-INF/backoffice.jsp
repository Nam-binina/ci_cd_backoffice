<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backoffice</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 650px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .nav { display: flex; flex-direction: column; gap: 12px; margin-top: 25px; }
        .nav a { display: block; padding: 14px 20px; background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 6px; text-decoration: none; color: #333; font-size: 16px; transition: all 0.2s; }
        .nav a:hover { background: #e9ecef; border-color: #adb5bd; transform: translateX(5px); }
        .nav a .icon { margin-right: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📋 Backoffice</h1>
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
        </div>
    </div>
</body>
</html>
