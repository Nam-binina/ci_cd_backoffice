<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Assignation" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des assignations</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <h1 class="page-title">Liste des assignations</h1>

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
                <th>Début trajet</th>
                <th>Fin trajet</th>
                <th>Distance totale (km)</th>
            </tr>
            <% for (Assignation a : assignations) { %>
            <tr>
                <td><%= a.getId() %></td>
                <td><%= a.getIdReservation() %></td>
                <td><%= a.getIdVoiture() %></td>
                <td><%= a.getDebutTrajet() %></td>
                <td><%= a.getFinTrajet() %></td>
                <td>
                    <%= a.getDistanceTotale() != null
                            ? String.format(java.util.Locale.US, "%.2f", a.getDistanceTotale())
                            : "-" %>
                </td>
            </tr>
            <% } %>
        </table>
    <%
        }
    %>

    <a class="link" href="${pageContext.request.contextPath}/assignation/page">← Retour page assignation</a>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
