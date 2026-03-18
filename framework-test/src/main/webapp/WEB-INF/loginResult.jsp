<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Résultat Login</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">✅ Connexion Réussie</h1>
        
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
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
