<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.nam.java.model.Vehicule" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des véhicules</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .actions a { margin-right: 10px; text-decoration: none; }
        .top-links { margin-bottom: 20px; }
    </style>
</head>
<body>
<h1>Liste des véhicules</h1>

<% if (request.getAttribute("error") != null) { %>
    <p style="color: red;">${error}</p>
<% } %>

<div class="top-links">
    <a href="${pageContext.request.contextPath}/vehicule/form">➕ Nouveau véhicule</a>
    <a href="${pageContext.request.contextPath}/backoffice">⬅ Retour backoffice</a>
</div>

<%
    List<Vehicule> vehicules = (List<Vehicule>) request.getAttribute("vehicules");
    Map<Integer, String> carburantMap = (Map<Integer, String>) request.getAttribute("carburantMap");
    if (vehicules == null || vehicules.isEmpty()) {
%>
    <p>Aucun véhicule trouvé.</p>
<%
    } else {
%>
    <table>
        <tr>
            <th>ID</th>
            <th>Capacité</th>
            <th>Carburant</th>
            <th>Actions</th>
        </tr>
        <% for (Vehicule v : vehicules) { %>
        <tr>
            <td><%= v.getIdVehicule() %></td>
            <td><%= v.getCapacite() %></td>
            <td><%= carburantMap != null ? carburantMap.get(v.getIdCarburant()) : v.getIdCarburant() %></td>
            <td class="actions">
                <a href="${pageContext.request.contextPath}/vehicule/edit?id=<%= v.getIdVehicule() %>">✏️ Modifier</a>
                <a href="${pageContext.request.contextPath}/vehicule/delete?id=<%= v.getIdVehicule() %>">🗑️ Supprimer</a>
            </td>
        </tr>
        <% } %>
    </table>
<%
    }
%>
</body>
</html>
