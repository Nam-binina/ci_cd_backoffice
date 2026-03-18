<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.AssignationDetail" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignations par date</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
<h1 class="page-title">Assignations du ${date}</h1>

<%
    List<AssignationDetail> details = (List<AssignationDetail>) request.getAttribute("details");
    if (details == null || details.isEmpty()) {
%>
    <p>Aucune assignation trouvée pour cette date.</p>
<%
    } else {
%>
    <table>
        <tr>
            <th>ID Assignation</th>
            <th>Réservation</th>
            <th>Date arrivée</th>
            <th>Passagers</th>
            <th>Voiture</th>
            <th>Immatriculation</th>
            <th>Places</th>
        </tr>
        <% for (AssignationDetail detail : details) { %>
        <tr>
            <td><%= detail.getId() %></td>
            <td><%= detail.getReservation().getIdReservation() %></td>
            <td><%= detail.getReservation().getDateArriver() %></td>
            <td><%= detail.getReservation().getNbrPassager() %></td>
            <td><%= detail.getVoiture().getId() %></td>
            <td><%= detail.getVoiture().getImmatriculation() %></td>
            <td><%= detail.getVoiture().getNombrePlace() %></td>
        </tr>
        <% } %>
    </table>
<%
    }
%>

<div class="links">
    <a href="${pageContext.request.contextPath}/assignation/filter">🔎 Nouvelle recherche</a>
    <a href="${pageContext.request.contextPath}/assignation/page">⬅ Retour assignations</a>
</div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
