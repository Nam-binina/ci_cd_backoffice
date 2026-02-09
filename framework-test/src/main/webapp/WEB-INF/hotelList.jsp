<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Hotel" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des hôtels</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Liste des hôtels</h1>

    <%
        List<Hotel> hotels = (List<Hotel>) request.getAttribute("hotels");
        if (hotels == null || hotels.isEmpty()) {
    %>
        <p>Aucun hôtel trouvé.</p>
    <%
        } else {
    %>
        <table>
            <tr>
                <th>ID</th>
                <th>Nom</th>
            </tr>
            <% for (Hotel h : hotels) { %>
            <tr>
                <td><%= h.getIdHotel() %></td>
                <td><%= h.getNom() %></td>
            </tr>
            <% } %>
        </table>
    <%
        }
    %>
</body>
</html>
