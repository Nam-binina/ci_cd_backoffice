<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 550px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; background-color: #4CAF50; color: white; padding: 12px; border: none; cursor: pointer; border-radius: 4px; font-size: 16px; }
        button:hover { background-color: #45a049; }
        .links { margin-top: 20px; text-align: center; }
        a { color: #007bff; text-decoration: none; margin: 0 10px; }
        .info-box { background-color: #e7f3ff; border: 1px solid #b3d7ff; padding: 15px; border-radius: 4px; margin-bottom: 20px; }
        .info-box h3 { margin-top: 0; color: #0066cc; }
        .user-table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 14px; }
        .user-table th, .user-table td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        .user-table th { background-color: #f0f7ff; }
        .role-admin { color: #dc3545; font-weight: bold; }
        .role-manager { color: #fd7e14; font-weight: bold; }
        .role-user { color: #007bff; font-weight: bold; }
        .role-guest { color: #6c757d; font-weight: bold; }
        .error { color: red; padding: 10px; background: #ffe0e0; border-radius: 4px; margin-bottom: 15px; }
        .message { color: green; padding: 10px; background: #e0ffe0; border-radius: 4px; margin-bottom: 15px; }
        .quick-login { margin-top: 15px; }
        .quick-btn { display: inline-block; padding: 6px 12px; margin: 3px; border-radius: 4px; text-decoration: none; font-size: 12px; cursor: pointer; border: none; }
        .quick-btn.admin { background: #dc3545; color: white; }
        .quick-btn.manager { background: #fd7e14; color: white; }
        .quick-btn.user { background: #007bff; color: white; }
        .quick-btn.guest { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔑 Connexion</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">${error}</div>
        <% } %>
        
        <% if (request.getAttribute("message") != null) { %>
            <div class="message">${message}</div>
        <% } %>
        
        <div class="info-box">
            <h3>👥 Utilisateurs de test:</h3>
            <table class="user-table">
                <tr>
                    <th>Username</th>
                    <th>Password</th>
                    <th>Rôle</th>
                </tr>
                <tr>
                    <td>admin</td>
                    <td>admin123</td>
                    <td class="role-admin">ADMIN</td>
                </tr>
                <tr>
                    <td>manager</td>
                    <td>manager123</td>
                    <td class="role-manager">MANAGER</td>
                </tr>
                <tr>
                    <td>user</td>
                    <td>user123</td>
                    <td class="role-user">USER</td>
                </tr>
                <tr>
                    <td>john</td>
                    <td>john123</td>
                    <td class="role-user">USER</td>
                </tr>
                <tr>
                    <td>alice</td>
                    <td>alice123</td>
                    <td class="role-user">USER</td>
                </tr>
                <tr>
                    <td>guest</td>
                    <td>guest123</td>
                    <td class="role-guest">GUEST</td>
                </tr>
            </table>
            
            <div class="quick-login">
                <strong>Connexion rapide:</strong><br>
                <button type="button" class="quick-btn admin" onclick="quickLogin('admin', 'admin123')">Admin</button>
                <button type="button" class="quick-btn manager" onclick="quickLogin('manager', 'manager123')">Manager</button>
                <button type="button" class="quick-btn user" onclick="quickLogin('user', 'user123')">User</button>
                <button type="button" class="quick-btn guest" onclick="quickLogin('guest', 'guest123')">Guest</button>
            </div>
        </div>
        
        <form id="loginForm" action="${pageContext.request.contextPath}/auth/login" method="POST">
            <div class="form-group">
                <label for="username">Nom d'utilisateur:</label>
                <input type="text" id="username" name="username" placeholder="Entrez votre nom" value="${username}" required>
            </div>
            <div class="form-group">
                <label for="password">Mot de passe:</label>
                <input type="password" id="password" name="password" placeholder="Entrez le mot de passe">
            </div>
            <button type="submit">Se connecter</button>
        </form>
        
        <div class="links" style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/test-auth.html">🏠 Page de test principale</a>
        </div>
    </div>
    
    <script>
        function quickLogin(username, password) {
            document.getElementById('username').value = username;
            document.getElementById('password').value = password;
            document.getElementById('loginForm').submit();
        }
    </script>
</body>
</html>