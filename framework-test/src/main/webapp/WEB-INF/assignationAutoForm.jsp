<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Reservation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assignation automatique</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 700px; margin: 0 auto; }
        .field { margin-top: 16px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; }
        input[list] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; }
        .btn { margin-top: 14px; padding: 10px 16px; border: none; border-radius: 6px; background: #4CAF50; color: white; cursor: pointer; }
        .btn:hover { background: #45a049; }
        .error { color: #c62828; margin-top: 10px; }
        .hint { color: #666; font-size: 14px; margin-top: 6px; }
        .link { display: inline-block; margin-top: 18px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Formulaire d'assignation automatique</h1>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null && !error.trim().isEmpty()) {
        %>
            <p class="error"><%= error %></p>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/assignation/method/auto/save" method="post">
            <div class="field">
                <label for="idReservation">Réservation non encore assignée</label>
                <input id="idReservation" name="idReservation" list="reservationOptions" placeholder="Choisir une réservation" required />
                <datalist id="reservationOptions">
                    <%
                        DateTimeFormatter displayDateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                        List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
                        if (reservations != null) {
                            for (Reservation r : reservations) {
                                String displayDate = (r.getDateArriver() != null)
                                        ? r.getDateArriver().format(displayDateFormatter)
                                        : "-";
                    %>
                        <option value="<%= r.getIdReservation() %>">ID <%= r.getIdReservation() %> | Client <%= r.getIdClient() %> | Date <%= displayDate %> | Hôtel <%= r.getIdHotel() %></option>
                    <%
                            }
                        }
                    %>
                </datalist>
                <p class="hint">La liste contient uniquement les réservations qui n'existent pas encore dans la table assignation.</p>
            </div>
            <button type="submit" class="btn">Enregistrer (placeholder)</button>
        </form>

        <a class="link" href="${pageContext.request.contextPath}/assignation/method">← Retour au choix de méthode</a>
    </div>
</body>
</html>
