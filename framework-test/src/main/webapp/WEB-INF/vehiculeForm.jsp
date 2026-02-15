<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.model.Carburant" %>
<%@ page import="com.nam.java.model.Vehicule" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulaire véhicule</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 650px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="number"], select {
            width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;
        }
        button { width: 100%; background-color: #4CAF50; color: white; padding: 12px; border: none; cursor: pointer; border-radius: 4px; font-size: 16px; }
        button:hover { background-color: #45a049; }
        .links { margin-top: 20px; text-align: center; }
        a { color: #007bff; text-decoration: none; margin: 0 10px; }
        .error { color: red; padding: 10px; background: #ffe0e0; border-radius: 4px; margin-bottom: 15px; }
    </style>
</head>
<body>
<div class="container">
    <h1>🚗 Formulaire véhicule</h1>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>

    <%
        Vehicule vehicule = (Vehicule) request.getAttribute("vehicule");
        boolean editing = vehicule != null && vehicule.getIdVehicule() > 0;
        List<Carburant> carburants = (List<Carburant>) request.getAttribute("carburants");
    %>

    <form action="${pageContext.request.contextPath}/vehicule/<%= editing ? "update" : "insert" %>" method="POST">
        <% if (editing) { %>
            <input type="hidden" name="idVehicule" value="<%= vehicule.getIdVehicule() %>">
        <% } %>

        <div class="form-group">
            <label for="capacite">Capacité</label>
            <input type="number" id="capacite" name="capacite" min="1" value="<%= editing ? vehicule.getCapacite() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="idCarburant">Carburant</label>
            <select id="idCarburant" name="idCarburant" required>
                <option value="">-- Sélectionner un carburant --</option>
                <% if (carburants != null) { %>
                    <% for (Carburant carburant : carburants) { %>
                        <option value="<%= carburant.getIdCarburant() %>"
                                <%= editing && carburant.getIdCarburant() == vehicule.getIdCarburant() ? "selected" : "" %>>
                            <%= carburant.getNom() %>
                        </option>
                    <% } %>
                <% } %>
            </select>
        </div>

        <button type="submit"><%= editing ? "Mettre à jour" : "Enregistrer" %></button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/vehicule/list">📋 Liste des véhicules</a>
        <a href="${pageContext.request.contextPath}/backoffice">⬅ Retour backoffice</a>
    </div>
</div>
</body>
</html>
