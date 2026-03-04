<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Assignation" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des assignations</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .error { color: #c62828; }
        .link { margin-top: 16px; display: inline-block; }
    </style>
</head>
<body>
    <h1>Liste des assignations</h1>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null && !error.trim().isEmpty()) {
    %>
        <p class="error"><%= error %></p>
    <%
        }
    %>

    <%
        List<Assignation> assignations = (List<Assignation>) request.getAttribute("assignations");
        if (assignations == null || assignations.isEmpty()) {
    %>
        <p>Aucune assignation trouvée.</p>
    <%
        } else {
    %>
        <table>
            <tr>
                <th>ID</th>
                <th>ID Réservation</th>
                <th>ID Voiture</th>
            </tr>
            <% for (Assignation a : assignations) { %>
            <tr>
                <td><%= a.getId() %></td>
                <td><%= a.getIdReservation() %></td>
                <td><%= a.getIdVoiture() %></td>
            </tr>
            <% } %>
        </table>
    <%
        }
    %>

    <a class="link" href="${pageContext.request.contextPath}/assignation/page">← Retour page assignation</a>
</body>
</html>
