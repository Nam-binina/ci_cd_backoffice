<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Reservation" %>
<%@ page import="com.nam.java.AssignationController.GroupAssignmentResult" %>
<%@ page import="com.nam.java.AssignationController.VehicleAssignmentPlan" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Réservations par date</title>
    
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 900px; margin: 0 auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .link { display: inline-block; margin-top: 16px; margin-right: 12px; }
    </style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">Liste des réservations par date</h1>

        <%
            List<Reservation> reservationsByDate = (List<Reservation>) request.getAttribute("reservationsByDate");
            List<List<Reservation>> reservationGroups = (List<List<Reservation>>) request.getAttribute("reservationGroups");
            List<GroupAssignmentResult> groupAssignmentResults = (List<GroupAssignmentResult>) request.getAttribute("groupAssignmentResults");
            Integer taMinutes = (Integer) request.getAttribute("taMinutes");
            java.time.LocalDate dateSelectionnee = (java.time.LocalDate) request.getAttribute("dateSelectionnee");
            DateTimeFormatter displayDateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        %>

        <% if (dateSelectionnee != null) { %>
            <p>Date sélectionnée : <strong><%= dateSelectionnee %></strong></p>
        <% } %>

        <% if (taMinutes != null) { %>
            <p>TA utilisé pour le regroupement : <strong><%= taMinutes %> min</strong></p>
        <% } %>

        <% if (reservationGroups != null && !reservationGroups.isEmpty()) { %>
            <h2>Groupes par TA</h2>
            <ul>
                <% for (int groupIndex = 0; groupIndex < reservationGroups.size(); groupIndex++) {
                    List<Reservation> group = reservationGroups.get(groupIndex);
                    StringBuilder ids = new StringBuilder();
                    for (Reservation reservation : group) {
                        if (ids.length() > 0) {
                            ids.append(", ");
                        }
                        ids.append(reservation.getIdReservation());
                    }
                %>
                    <li>Groupe <%= (groupIndex + 1) %> : IDs <strong><%= ids %></strong></li>
                <% } %>
            </ul>
        <% } %>

        <% if (groupAssignmentResults != null && !groupAssignmentResults.isEmpty()) { %>
            <h2>Voitures par groupe</h2>
            <% for (GroupAssignmentResult result : groupAssignmentResults) { %>
                <h3>Groupe <%= result.getGroupIndex() %> (IDs: <%= result.getReservationIds() %>)</h3>

                <% if (result.getPlans() == null || result.getPlans().isEmpty()) { %>
                    <p>Aucune voiture affectée.</p>
                <% } else { %>
                    <ul>
                        <% for (VehicleAssignmentPlan plan : result.getPlans()) {
                            StringBuilder reservationsText = new StringBuilder();
                            for (Reservation reservation : plan.getReservations()) {
                                if (reservationsText.length() > 0) {
                                    reservationsText.append(" | ");
                                }
                                reservationsText.append("ID ")
                                        .append(reservation.getIdReservation())
                                        .append(" (")
                                        .append(reservation.getNbrPassager())
                                        .append(" passagers)");
                            }
                        %>
                            <li>
                                Voiture ID <strong><%= plan.getVoiture().getId() %></strong>
                                (<%= plan.getVoiture().getNombrePlace() %> places)
                                → <%= reservationsText %>
                                | Occupé: <%= plan.getUsedSeats() %>
                                | Reste: <%= plan.getRemainingSeats() %>
                                <br/>
                                Date départ: <strong><%= plan.getDateDepart() != null ? plan.getDateDepart().format(displayDateFormatter) : "-" %></strong>
                                | Trajet optimum: <strong><%= plan.getTrajetOptimum() != null ? plan.getTrajetOptimum() : "-" %></strong>
                                | Total km: <strong><%= plan.getTotalKmTrajet() != null ? String.format(java.util.Locale.US, "%.2f", plan.getTotalKmTrajet()) : "-" %></strong>
                                | Vitesse moyenne: <strong><%= plan.getVitesseMoyenne() != null ? String.format(java.util.Locale.US, "%.2f", plan.getVitesseMoyenne()) : "-" %></strong>
                                | Retour aéroport: <strong><%= plan.getDateRetourAeroport() != null ? plan.getDateRetourAeroport().format(displayDateFormatter) : "-" %></strong>
                            </li>
                        <% } %>
                    </ul>
                <% } %>

                <% if (result.getUnassignedReservations() != null && !result.getUnassignedReservations().isEmpty()) { %>
                    <p>
                        Non affectées:
                        <%
                            StringBuilder missingText = new StringBuilder();
                            for (Reservation reservation : result.getUnassignedReservations()) {
                                if (missingText.length() > 0) {
                                    missingText.append(", ");
                                }
                                missingText.append("ID ")
                                        .append(reservation.getIdReservation())
                                        .append(" (")
                                        .append(reservation.getNbrPassager())
                                        .append(" passagers)");
                            }
                        %>
                        <strong><%= missingText %></strong>
                    </p>
                <% } %>
            <% } %>
        <% } %>

        <% if (reservationsByDate == null || reservationsByDate.isEmpty()) { %>
            <p>Aucune réservation trouvée pour cette date.</p>
        <% } else { %>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Date d'arrivée</th>
                    <th>Passagers</th>
                    <th>Client</th>
                    <th>Hôtel</th>
                    <th>Aéroport</th>
                </tr>
                <% for (Reservation reservation : reservationsByDate) { %>
                    <%
                        String reservationDate = (reservation.getDateArriver() != null)
                                ? reservation.getDateArriver().format(displayDateFormatter)
                                : "-";
                    %>
                    <tr>
                        <td><%= reservation.getIdReservation() %></td>
                        <td><%= reservationDate %></td>
                        <td><%= reservation.getNbrPassager() %></td>
                        <td><%= reservation.getIdClient() %></td>
                        <td><%= reservation.getIdHotel() %></td>
                        <td><%= reservation.getIdAeroport() %></td>
                    </tr>
                <% } %>
            </table>
        <% } %>

        <a class="link" href="${pageContext.request.contextPath}/assignation/method/auto">← Retour formulaire automatique</a>
        <a class="link" href="${pageContext.request.contextPath}/assignation/method">Retour choix de méthode</a>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
