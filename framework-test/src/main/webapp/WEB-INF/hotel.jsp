<%@ page import="com.nam.java.Hotel" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel</title>
</head>
<body>
<%
    String error = (String) request.getAttribute("error");
    Hotel hotel = (Hotel) request.getAttribute("hotel");
    if (error != null && !error.isEmpty()) {
%>
    <p>Erreur : <%= error %></p>
<%
    } else if (hotel == null) {
%>
    <p>Aucun hôtel trouvé.</p>
<%
    } else {
%>
    <h2>Hôtel</h2>
    <p><strong>ID :</strong> <%= hotel.getIdHotel() %></p>
    <p><strong>Nom :</strong> <%= hotel.getNom() %></p>
<%
    }
%>
</body>
</html>
