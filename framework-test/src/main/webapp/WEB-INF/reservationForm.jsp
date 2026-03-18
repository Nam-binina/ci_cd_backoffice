<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Hotel" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insertion réservation</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">🧾 Insertion d'une réservation</h1>

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
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
