<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Reservation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assignation automatique</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">Formulaire d'assignation automatique</h1>

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
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
