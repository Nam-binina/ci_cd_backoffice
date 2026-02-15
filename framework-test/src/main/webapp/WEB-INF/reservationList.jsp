<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.model.Reservation" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des réservations</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Liste des réservations</h1>

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
            <tr>
                <td><%= r.getIdReservation() %></td>
                <td><%= r.getDateArriver() %></td>
                <td><%= r.getNbrPassager() %></td>
                <td><%= r.getIdClient() %></td>
                <td><%= r.getIdHotel() %></td>
            </tr>
            <% } %>
        </table>
    <%
        }
    %>
</body>
</html>
