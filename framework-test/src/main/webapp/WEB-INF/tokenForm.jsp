<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer un token</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 550px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .form-group { margin: 20px 0; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        select, input[type="number"] {
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 15px;
        }
        .hint { font-size: 13px; color: #888; margin-top: 5px; }
        button { width: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 14px; border: none; cursor: pointer; border-radius: 6px; font-size: 16px; font-weight: 600; margin-top: 10px; }
        button:hover { opacity: 0.9; }
        .links { margin-top: 25px; text-align: center; }
        .links a { color: #667eea; text-decoration: none; margin: 0 10px; }
        .links a:hover { text-decoration: underline; }
        .info-box { background: #f0f4ff; border: 1px solid #d0d9ff; border-radius: 6px; padding: 15px; margin-bottom: 20px; font-size: 14px; color: #555; line-height: 1.6; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔑 Créer un token d'accès</h1>

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
</body>
</html>
