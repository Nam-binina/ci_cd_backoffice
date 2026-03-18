<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Reservation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des réservations</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <h1 class="page-title">Liste des réservations</h1>

    <%
        DateTimeFormatter displayDateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    %>

    <%
        List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
        if (reservations == null || reservations.isEmpty()) {
    %>
        <p>Aucune réservation trouvée.</p>
    <%
        } else {
    %>
        <table>
            <tr>
                <th>ID</th>
                <th>Date d'arrivée</th>
                <th>Passagers</th>
                <th>Client</th>
                <th>Hotel</th>
            </tr>
            <% for (Reservation r : reservations) { %>
            <%
                String displayDate = (r.getDateArriver() != null)
                        ? r.getDateArriver().format(displayDateFormatter)
                        : "-";
            %>
            <tr>
                <td><%= r.getIdReservation() %></td>
                <td><%= displayDate %></td>
                <td><%= r.getNbrPassager() %></td>
                <td><%= r.getIdClient() %></td>
                <td><%= r.getIdHotel() %></td>
            </tr>
            <% } %>
        </table>
    <%
        }
    %>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
