<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.nam.java.Reservation" %>
<%@ page import="com.nam.java.Voiture" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chevauchement automatique</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 900px; margin: 0 auto; }
        .selected { background: #f1f8e9; border: 1px solid #c5e1a5; padding: 12px; border-radius: 6px; margin-bottom: 18px; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .link { display: inline-block; margin-top: 16px; margin-right: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Réservations qui chevauchent la date choisie</h1>

        <%
            Reservation selected = (Reservation) request.getAttribute("selectedReservation");
            List<Reservation> overlaps = (List<Reservation>) request.getAttribute("overlaps");
            Map<Integer, Boolean> assignmentStatus = (Map<Integer, Boolean>) request.getAttribute("assignmentStatus");
            Integer totalPassagers = (Integer) request.getAttribute("totalPassagers");
            LocalDateTime dateDepartReel = (LocalDateTime) request.getAttribute("dateDepartReel");
            List<Integer> hotelsItineraire = (List<Integer>) request.getAttribute("hotelsItineraire");
            Double distanceAller = (Double) request.getAttribute("distanceAller");
            Double distanceTotale = (Double) request.getAttribute("distanceTotale");
            LocalDateTime dateArriveeFinTrajet = (LocalDateTime) request.getAttribute("dateArriveeFinTrajet");
            LocalDateTime dateRetourAeroport = (LocalDateTime) request.getAttribute("dateRetourAeroport");
            String trajetMessage = (String) request.getAttribute("trajetMessage");
            List<Voiture> voituresProposees = (List<Voiture>) request.getAttribute("voituresProposees");
            Voiture voitureSelectionnee = (Voiture) request.getAttribute("voitureSelectionnee");
            DateTimeFormatter displayDateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

            StringBuilder reservationIdsBuilder = new StringBuilder();
            if (selected != null) {
                reservationIdsBuilder.append(selected.getIdReservation());
            }
            if (overlaps != null) {
                for (Reservation reservation : overlaps) {
                    if (selected != null && reservation.getIdReservation() == selected.getIdReservation()) {
                        continue;
                    }
                    if (reservationIdsBuilder.length() > 0) {
                        reservationIdsBuilder.append(",");
                    }
                    reservationIdsBuilder.append(reservation.getIdReservation());
                }
            }
            String reservationIds = reservationIdsBuilder.toString();
        %>

        <% if (selected != null) { %>
            <%
                String selectedDate = (selected.getDateArriver() != null)
                        ? selected.getDateArriver().format(displayDateFormatter)
                        : "-";
            %>
            <div class="selected">
                <strong>Réservation choisie :</strong>
                ID <%= selected.getIdReservation() %> |
                Date <%= selectedDate %> |
                Passagers <%= selected.getNbrPassager() %> |
                Client <%= selected.getIdClient() %> |
                Hôtel <%= selected.getIdHotel() %> |
                Aéroport <%= selected.getIdAeroport() %> |
                TA <%= selected.getTa() %> min |
                Statut <%= (assignmentStatus != null && Boolean.TRUE.equals(assignmentStatus.get(selected.getIdReservation()))) ? "Déjà assignée" : "Non assignée" %>
            </div>
            <p>Filtre appliqué : même aéroport que la réservation choisie (id_aeroport = <strong><%= selected.getIdAeroport() %></strong>).</p>
        <% } %>

        <% if (overlaps == null || overlaps.isEmpty()) { %>
            <p>Aucune réservation chevauchante trouvée.</p>
        <% } else { %>
            <p>
                Date de départ réel (plus grande date de la liste chevauchante) :
                <strong><%= dateDepartReel != null ? dateDepartReel.format(displayDateFormatter) : "-" %></strong>
            </p>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Date d'arrivée</th>
                    <th>Passagers</th>
                    <th>Client</th>
                    <th>Hôtel</th>
                    <th>Aéroport</th>
                    <th>TA (min)</th>
                    <th>Assignation</th>
                </tr>
                <% for (Reservation reservation : overlaps) { %>
                    <%
                        String overlapDate = (reservation.getDateArriver() != null)
                                ? reservation.getDateArriver().format(displayDateFormatter)
                                : "-";
                        boolean isAssigned = assignmentStatus != null
                                && Boolean.TRUE.equals(assignmentStatus.get(reservation.getIdReservation()));
                    %>
                    <tr>
                        <td><%= reservation.getIdReservation() %></td>
                        <td><%= overlapDate %></td>
                        <td><%= reservation.getNbrPassager() %></td>
                        <td><%= reservation.getIdClient() %></td>
                        <td><%= reservation.getIdHotel() %></td>
                        <td><%= reservation.getIdAeroport() %></td>
                        <td><%= reservation.getTa() %></td>
                        <td><%= isAssigned ? "Déjà assignée" : "Non assignée" %></td>
                    </tr>
                <% } %>
            </table>
        <% } %>

        <h2>Trajet estimé</h2>
        <% if (trajetMessage != null && !trajetMessage.trim().isEmpty()) { %>
            <p><%= trajetMessage %></p>
        <% } else { %>
            <p>
                Itinéraire hôtels (ordre non optimisé) :
                <strong><%= hotelsItineraire != null ? hotelsItineraire : java.util.Collections.emptyList() %></strong>
            </p>
            <p>
                Distance aller : <strong><%= distanceAller != null ? String.format(java.util.Locale.US, "%.2f", distanceAller) : "0.00" %> km</strong>
                | Distance totale (aller-retour) :
                <strong><%= distanceTotale != null ? String.format(java.util.Locale.US, "%.2f", distanceTotale) : "0.00" %> km</strong>
            </p>
            <p>
                Date de départ réel :
                <strong><%= dateDepartReel != null ? dateDepartReel.format(displayDateFormatter) : "-" %></strong>
                | Date d'arrivée fin trajet (aller) :
                <strong><%= dateArriveeFinTrajet != null ? dateArriveeFinTrajet.format(displayDateFormatter) : "-" %></strong>
            </p>
            <p>
                Date/heure de retour vers l'aéroport :
                <strong><%= dateRetourAeroport != null ? dateRetourAeroport.format(displayDateFormatter) : "-" %></strong>
            </p>
        <% } %>

        <h2>Voitures proposées</h2>
        <% if (totalPassagers != null) { %>
            <p>Total passagers de la liste chevauchante : <strong><%= totalPassagers %></strong></p>
            <p>Voitures avec nombre de places suffisant et le plus proche du total :</p>
        <% } %>

        <% if (voituresProposees == null || voituresProposees.isEmpty()) { %>
            <p>Aucune voiture ne possède un nombre de places supérieur ou égal à <%= totalPassagers != null ? totalPassagers : 0 %>.</p>
        <% } else { %>
            <% if (voitureSelectionnee != null) { %>
                <p>
                    <strong>Voiture retenue (règle: proche, Diesel prioritaire, sinon random):</strong>
                    ID <%= voitureSelectionnee.getId() %> |
                    Immatriculation <%= voitureSelectionnee.getImmatriculation() %> |
                    Places <%= voitureSelectionnee.getNombrePlace() %> |
                    ID Consommation <%= voitureSelectionnee.getIdConsommation() %>
                </p>
            <% } %>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Immatriculation</th>
                    <th>Nombre de places</th>
                    <th>ID Consommation</th>
                    <th>Vitesse moyenne</th>
                </tr>
                <% for (Voiture voiture : voituresProposees) { %>
                    <tr>
                        <td><%= voiture.getId() %></td>
                        <td><%= voiture.getImmatriculation() %></td>
                        <td><%= voiture.getNombrePlace() %></td>
                        <td><%= voiture.getIdConsommation() %></td>
                        <td><%= voiture.getVitesseMoyenne() %></td>
                    </tr>
                <% } %>
            </table>
        <% } %>

        <% if (voitureSelectionnee != null && reservationIds != null && !reservationIds.trim().isEmpty()) { %>
            <form action="${pageContext.request.contextPath}/assignation/method/auto/confirm" method="post">
                <input type="hidden" name="reservationIds" value="<%= reservationIds %>">
                <input type="hidden" name="voitureId" value="<%= voitureSelectionnee.getId() %>">
                <button type="submit">✅ Confirmer l'assignation</button>
            </form>
        <% } %>

        <a class="link" href="${pageContext.request.contextPath}/assignation/method/auto">← Retour formulaire automatique</a>
        <a class="link" href="${pageContext.request.contextPath}/assignation/method">Retour choix de méthode</a>
    </div>
</body>
</html>
