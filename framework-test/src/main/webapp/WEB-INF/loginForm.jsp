<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">🔑 Connexion</h1>
        
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
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>