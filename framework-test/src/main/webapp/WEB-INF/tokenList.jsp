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
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 950px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; font-size: 14px; }
        th { background-color: #667eea; color: white; }
        tr:nth-child(even) { background-color: #f8f9fa; }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .badge-valid { background: #d4edda; color: #155724; }
        .badge-expired { background: #f8d7da; color: #721c24; }
        .uid-cell { font-family: monospace; font-size: 13px; word-break: break-all; }
        .copy-btn { cursor: pointer; background: #e9ecef; border: 1px solid #ced4da; border-radius: 4px; padding: 3px 8px; font-size: 12px; margin-left: 5px; }
        .copy-btn:hover { background: #dee2e6; }
        .delete-btn { color: #dc3545; text-decoration: none; font-size: 13px; }
        .delete-btn:hover { text-decoration: underline; }
        .success { color: #155724; padding: 12px; background: #d4edda; border: 1px solid #c3e6cb; border-radius: 6px; margin-bottom: 15px; }
        .error { color: #721c24; padding: 12px; background: #f8d7da; border: 1px solid #f5c6cb; border-radius: 6px; margin-bottom: 15px; }
        .created-token { background: #fff3cd; border: 1px solid #ffc107; border-radius: 6px; padding: 15px; margin-bottom: 20px; }
        .created-token .uid { font-family: monospace; font-size: 16px; font-weight: bold; color: #856404; word-break: break-all; }
        .created-token .frontoffice-link { display: inline-block; margin-top: 10px; padding: 8px 16px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 6px; font-size: 14px; }
        .created-token .frontoffice-link:hover { opacity: 0.9; }
        .links { margin-top: 25px; text-align: center; }
        .links a { color: #667eea; text-decoration: none; margin: 0 12px; }
        .links a:hover { text-decoration: underline; }
        .empty { text-align: center; color: #888; padding: 30px; font-size: 16px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔑 Gestion des tokens</h1>

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
</body>
</html>
