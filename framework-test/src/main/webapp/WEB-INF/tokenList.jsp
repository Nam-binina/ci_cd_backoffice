<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des tokens</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">🔑 Gestion des tokens</h1>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success">${success}</div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error">${error}</div>
        <% } %>

        <% if (request.getAttribute("createdUid") != null) { %>
            <div class="created-token">
                <strong>✅ Nouveau token généré :</strong><br>
                <div class="uid">${createdUid}</div>
                <br>
                <button class="copy-btn" onclick="copyToken('${createdUid}')">📋 Copier le token</button>
            </div>
        <% } %>

        <%
            List<Map<String, Object>> tokens = (List<Map<String, Object>>) request.getAttribute("tokens");
            if (tokens == null || tokens.isEmpty()) {
        %>
            <div class="empty">
                Aucun token créé.<br>
                <a href="${pageContext.request.contextPath}/token/form">Créer un premier token</a>
            </div>
        <%
            } else {
        %>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Token (UID)</th>
                    <th>Créé le</th>
                    <th>Expire le</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> t : tokens) {
                    boolean valid = (boolean) t.get("valid");
                %>
                <tr>
                    <td><%= t.get("id") %></td>
                    <td class="uid-cell">
                        <%= t.get("uid") %>
                        <button class="copy-btn" onclick="copyToken('<%= t.get("uid") %>')">📋</button>
                    </td>
                    <td><%= t.get("created_at") %></td>
                    <td><%= t.get("expires_at") %></td>
                    <td>
                        <% if (valid) { %>
                            <span class="badge badge-valid">✅ Valide</span>
                        <% } else { %>
                            <span class="badge badge-expired">❌ Expiré</span>
                        <% } %>
                    </td>
                    <td>
                        <a class="delete-btn" href="${pageContext.request.contextPath}/token/delete?id=<%= t.get("id") %>"
                           onclick="return confirm('Supprimer ce token ?');">🗑 Supprimer</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>

        <div class="links">
            <a href="${pageContext.request.contextPath}/token/form">🆕 Créer un token</a>
            <a href="${pageContext.request.contextPath}/backoffice">⬅ Retour backoffice</a>
        </div>
    </div>

    <script>
        function copyToken(uid) {
            navigator.clipboard.writeText(uid).then(function() {
                alert('Token copié : ' + uid);
            }, function() {
                prompt('Copier ce token :', uid);
            });
        }
    </script>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
