<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Session</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px; }
        h1 { color: #333; }
        .message { color: green; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .form-section { margin: 20px 0; padding: 15px; background-color: #f9f9f9; border-radius: 4px; }
        input[type="text"] { padding: 8px; margin: 5px; width: 150px; }
        button { background-color: #4CAF50; color: white; padding: 8px 15px; border: none; cursor: pointer; border-radius: 4px; }
        a { color: #007bff; text-decoration: none; margin-right: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Test Session</h1>
        
        <% if (request.getAttribute("message") != null) { %>
            <p class="message">${message}</p>
        <% } %>
        
        <% if (request.getAttribute("key") != null) { %>
            <p><strong>Clé:</strong> ${key} = <strong>${value}</strong></p>
        <% } %>
        
        <h2>Contenu de la Session</h2>
        <table>
            <tr>
                <th>Clé</th>
                <th>Valeur</th>
            </tr>
            <% 
                Map<String, Object> sessionData = (Map<String, Object>) request.getAttribute("session");
                if (sessionData != null && !sessionData.isEmpty()) {
                    for (Map.Entry<String, Object> entry : sessionData.entrySet()) {
            %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td><%= entry.getValue() %></td>
            </tr>
            <%      }
                } else { %>
            <tr>
                <td colspan="2">Session vide</td>
            </tr>
            <% } %>
        </table>
        
        <div class="form-section">
            <h3>Ajouter à la session</h3>
            <form action="${pageContext.request.contextPath}/TestClass/session/set" method="GET">
                <input type="text" name="key" placeholder="Clé" required>
                <input type="text" name="value" placeholder="Valeur" required>
                <button type="submit">Définir</button>
            </form>
        </div>
        
        <div class="form-section">
            <h3>Lire depuis la session</h3>
            <form action="${pageContext.request.contextPath}/TestClass/session/get" method="GET">
                <input type="text" name="key" placeholder="Clé" required>
                <button type="submit">Lire</button>
            </form>
        </div>
        
        <br>
        <a href="${pageContext.request.contextPath}/TestClass/upload">Test Upload</a> | 
        <a href="${pageContext.request.contextPath}/TestClass/login">Test Login/Rôles</a> |
        <a href="${pageContext.request.contextPath}/TestClass/public">Page Publique</a>
    </div>
</body>
</html>
