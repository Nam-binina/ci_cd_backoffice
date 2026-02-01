<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Page Protégée</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 500px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .message { font-size: 18px; text-align: center; padding: 20px; background-color: #d4edda; border-radius: 4px; color: #155724; }
        .info { margin: 20px 0; padding: 15px; background-color: #f8f9fa; border-radius: 4px; text-align: center; }
        .links { margin-top: 20px; text-align: center; }
        a { color: #007bff; text-decoration: none; margin: 0 10px; }
        .btn { display: inline-block; padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; margin: 5px; }
        .btn:hover { background-color: #0056b3; }
        .role-badge { display: inline-block; padding: 5px 15px; background-color: #28a745; color: white; border-radius: 20px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔒 Page Protégée</h1>
        
        <p class="message">${message}</p>
        
        <div class="info">
            <p><strong>Utilisateur:</strong> ${user}</p>
            <p><strong>Rôle:</strong> 
                <span class="role-badge">${role}</span>
            </p>
        </div>
        
        <div class="links">
            <h3>Navigation:</h3>
            <a href="${pageContext.request.contextPath}/auth/public" class="btn">Page Publique</a>
            <a href="${pageContext.request.contextPath}/auth/user-only" class="btn">Page USER</a>
            <a href="${pageContext.request.contextPath}/auth/manager-only" class="btn">Page MANAGER</a>
            <a href="${pageContext.request.contextPath}/auth/admin-only" class="btn">Page ADMIN</a>
        </div>
        
        <div class="links" style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/auth/login">← Login</a> |
            <a href="${pageContext.request.contextPath}/auth/session-info">📊 Session</a> |
            <a href="${pageContext.request.contextPath}/auth/logout">🚪 Déconnexion</a>
        </div>
        
        <div class="links" style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/test-auth.html">🏠 Page de test principale</a>
        </div>
    </div>
</body>
</html>
