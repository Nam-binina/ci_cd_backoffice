<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Session</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">Test Session</h1>
        
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
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
