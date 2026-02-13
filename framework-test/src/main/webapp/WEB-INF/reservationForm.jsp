<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.model.Hotel" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insertion réservation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 650px; margin: 0 auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="number"], input[type="datetime-local"], select {
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
        <h1>🧾 Insertion d'une réservation</h1>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error">${error}</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/reservation/insert" method="POST">
            <div class="form-group">
                <label for="dateArriver">Date d'arrivée</label>
                <input type="datetime-local" id="dateArriver" name="dateArriver" value="${dateArriver}" required>
            </div>

            <div class="form-group">
                <label for="nbrPassager">Nombre de passagers</label>
                <input type="number" id="nbrPassager" name="nbrPassager" min="1" value="${nbrPassager}" required>
            </div>

            <div class="form-group">
                <label for="idClient">Identifiant client</label>
                <input type="text" id="idClient" name="idClient" placeholder="ex: CLT-001" value="${idClient}" required>
            </div>

            <div class="form-group">
                <label for="idHotel">Hôtel</label>
                <%
                    List<Hotel> hotels = (List<Hotel>) request.getAttribute("hotels");
                    if (hotels != null && !hotels.isEmpty()) {
                %>
                    <select id="idHotel" name="idHotel" required>
                        <option value="">-- Sélectionner un hôtel --</option>
                        <% for (Hotel h : hotels) { %>
                            <option value="<%= h.getIdHotel() %>"><%= h.getNom() %> (#<%= h.getIdHotel() %>)</option>
                        <% } %>
                    </select>
                <%
                    } else {
                %>
                    <input type="number" id="idHotel" name="idHotel" min="1" placeholder="ID de l'hôtel" value="${idHotel}" required>
                <%
                    }
                %>
            </div>

            <button type="submit">Enregistrer</button>
        </form>

        <div class="links">
            <a href="${pageContext.request.contextPath}/backoffice">⬅ Retour backoffice</a>
        </div>
    </div>
</body>
</html>
