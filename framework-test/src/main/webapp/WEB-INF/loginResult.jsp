<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Résultat Login</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 500px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .success { color: green; font-size: 18px; text-align: center; padding: 20px; background-color: #d4edda; border-radius: 4px; }
        .info { margin: 20px 0; padding: 15px; background-color: #f8f9fa; border-radius: 4px; }
        .links { margin-top: 20px; text-align: center; }
        a { color: #007bff; text-decoration: none; margin: 0 10px; }
        .btn { display: inline-block; padding: 10px 20px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; margin: 5px; }
        .btn:hover { background-color: #45a049; }
        .btn-danger { background-color: #dc3545; }
        .btn-danger:hover { background-color: #c82333; }
        .role-badge { display: inline-block; padding: 5px 15px; background-color: #28a745; color: white; border-radius: 20px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>✅ Connexion Réussie</h1>
        
        <p class="success">${message}</p>
        
        <div class="info">
            <p><strong>Utilisateur:</strong> ${user}</p>
            <p><strong>Rôle:</strong> <span class="role-badge">${role}</span></p>
        </div>
        
        <div class="links">
            <h3>Tester les pages protégées:</h3>
            <a href="${pageContext.request.contextPath}/auth/public" class="btn">Page Publique</a>
            <a href="${pageContext.request.contextPath}/auth/user-only" class="btn">Page USER</a>
            <a href="${pageContext.request.contextPath}/auth/manager-only" class="btn">Page MANAGER</a>
            <a href="${pageContext.request.contextPath}/auth/admin-only" class="btn">Page ADMIN</a>
        </div>
        
        <div class="links" style="margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/auth/login">← Retour au Login</a> |
            <a href="${pageContext.request.contextPath}/auth/session-info">📊 Info Session</a> |
            <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger">Déconnexion</a>
        </div>
        
        <div class="links" style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/test-auth.html">🏠 Page de test principale</a>
        </div>
    </div>
</body>
</html>
