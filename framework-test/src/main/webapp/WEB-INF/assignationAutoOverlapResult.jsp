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
    <title>Réservations par date - Gestionnaire de transport</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        <%@ include file="/assets/theme.css" %>
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    
    <main class="page-main">
        <section class="content-card reservations-container">
            
            <%-- Récupération des attributs --%>
            <%
                List<Reservation> reservationsByDate = (List<Reservation>) request.getAttribute("reservationsByDate");
                List<List<Reservation>> reservationGroups = (List<List<Reservation>>) request.getAttribute("reservationGroups");
                List<GroupAssignmentResult> groupAssignmentResults = (List<GroupAssignmentResult>) request.getAttribute("groupAssignmentResults");
                Integer taMinutes = (Integer) request.getAttribute("taMinutes");
                java.time.LocalDate dateSelectionnee = (java.time.LocalDate) request.getAttribute("dateSelectionnee");
                DateTimeFormatter displayDateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                java.util.Map<Integer, Reservation> reservationById = new java.util.HashMap<>();
                
                // Calcul des statistiques
                int totalReservations = reservationsByDate != null ? reservationsByDate.size() : 0;
                int totalPassagers = 0;
                int totalVoituresUtilisees = 0;
                
                if (reservationsByDate != null) {
                    for (Reservation r : reservationsByDate) {
                        totalPassagers += r.getNbrPassager();
                        reservationById.put(r.getIdReservation(), r);
                    }
                }
                
                if (groupAssignmentResults != null) {
                    for (GroupAssignmentResult result : groupAssignmentResults) {
                        if (result.getPlans() != null) {
                            totalVoituresUtilisees += result.getPlans().size();
                        }
                    }
                }
            %>
            
            <%-- En-tête avec informations --%>
            <div class="reservations-header">
                <h1>Réservations par date</h1>
                <div class="reservations-meta">
                    <% if (dateSelectionnee != null) { %>
                        <span class="meta-item"><strong>📅 Date</strong> <%= dateSelectionnee %></span>
                    <% } %>
                    <% if (taMinutes != null) { %>
                        <span class="meta-item"><strong>⏱️ TA</strong> <%= taMinutes %> min</span>
                    <% } %>
                </div>
            </div>
            
            <%-- Statistiques rapides --%>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📋</div>
                    <div class="stat-content">
                        <div class="stat-label">Réservations</div>
                        <div class="stat-value"><%= totalReservations %></div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-content">
                        <div class="stat-label">Passagers</div>
                        <div class="stat-value"><%= totalPassagers %></div>
                    </div>
                </div>
                
                <% if (reservationGroups != null) { %>
                <div class="stat-card">
                    <div class="stat-icon">📦</div>
                    <div class="stat-content">
                        <div class="stat-label">Groupes formés</div>
                        <div class="stat-value"><%= reservationGroups.size() %></div>
                    </div>
                </div>
                <% } %>
                
                <% if (totalVoituresUtilisees > 0) { %>
                <div class="stat-card">
                    <div class="stat-icon">🚗</div>
                    <div class="stat-content">
                        <div class="stat-label">Voitures utilisées</div>
                        <div class="stat-value"><%= totalVoituresUtilisees %></div>
                    </div>
                </div>
                <% } %>
            </div>
            
            <%-- Affichage des groupes par TA --%>
            <% if (reservationGroups != null && !reservationGroups.isEmpty()) { %>
                <div class="groups-section">
                    <h2 class="section-title">Groupes par intervalle de temps (TA)</h2>
                    <div class="groups-grid">
                        <% for (int groupIndex = 0; groupIndex < reservationGroups.size(); groupIndex++) {
                            List<Reservation> group = reservationGroups.get(groupIndex);
                            StringBuilder ids = new StringBuilder();
                            int totalGroupPassagers = 0;
                            for (Reservation reservation : group) {
                                if (ids.length() > 0) ids.append(", ");
                                String reservationDate = (reservation.getDateArriver() != null)
                                        ? reservation.getDateArriver().format(displayDateFormatter)
                                        : "-";
                                ids.append("ID ")
                                        .append(reservation.getIdReservation())
                                        .append(" | Client ")
                                        .append(reservation.getIdClient())
                                        .append(" | Départ ")
                                        .append(reservationDate);
                                totalGroupPassagers += reservation.getNbrPassager();
                            }
                        %>
                            <div class="group-card">
                                <div class="group-header">
                                    <h3>Groupe <%= (groupIndex + 1) %></h3>
                                    <span class="group-badge"><%= group.size() %> réservation(s)</span>
                                </div>
                                <div class="group-content">
                                    <div class="reservation-ids">
                                        <strong>Réservations</strong>
                                        <%= ids %>
                                    </div>
                                    <div style="font-size:0.9rem; color:var(--muted);">
                                        Total passagers: <strong style="color:var(--teal);"><%= totalGroupPassagers %></strong>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>
            
            <%-- Affichage des assignations par groupe --%>
            <% if (groupAssignmentResults != null && !groupAssignmentResults.isEmpty()) { %>
                <div class="groups-section">
                    <h2 class="section-title">Assignation des véhicules par groupe</h2>
                    
                    <% for (GroupAssignmentResult result : groupAssignmentResults) {
                        StringBuilder groupReservationsInfo = new StringBuilder();
                        if (result.getReservationIds() != null) {
                            for (Integer reservationId : result.getReservationIds()) {
                                Reservation reservation = reservationById.get(reservationId);
                                if (groupReservationsInfo.length() > 0) {
                                    groupReservationsInfo.append(" • ");
                                }
                                if (reservation != null) {
                                    String reservationDate = (reservation.getDateArriver() != null)
                                            ? reservation.getDateArriver().format(displayDateFormatter)
                                            : "-";
                                    groupReservationsInfo.append("ID ")
                                            .append(reservation.getIdReservation())
                                            .append(" | Client ")
                                            .append(reservation.getIdClient())
                                            .append(" | Départ ")
                                            .append(reservationDate);
                                } else {
                                    groupReservationsInfo.append("ID ").append(reservationId);
                                }
                            }
                        }
                    %>
                        <div class="group-card" style="margin-bottom:20px;">
                            <div class="group-header" style="background: linear-gradient(135deg, var(--teal) 0%, var(--teal-lt) 100%);">
                                <h3>Groupe <%= result.getGroupIndex() %></h3>
                                <span class="group-badge"><%= groupReservationsInfo %></span>
                            </div>
                            
                            <div class="group-content">
                                <% if (result.getPlans() == null || result.getPlans().isEmpty()) { %>
                                    <div class="empty-state" style="padding:30px;">
                                        <div class="empty-state-icon">🚗</div>
                                        <h3>Aucune voiture affectée</h3>
                                        <p>Impossible d'assigner des véhicules pour ce groupe</p>
                                    </div>
                                <% } else { %>
                                    <div class="plans-list">
                                        <% for (VehicleAssignmentPlan plan : result.getPlans()) { %>
                                            <div class="plan-item">
                                                <div class="plan-header">
                                                    <div class="vehicle-info">
                                                        <div class="vehicle-icon">🚙</div>
                                                        <div class="vehicle-details">
                                                            Voiture <strong><%= plan.getVoiture().getImmatriculation() %></strong>
                                                            <small><%= plan.getVoiture().getNombrePlace() %> places</small>
                                                        </div>
                                                    </div>
                                                    <div class="seats-info">
                                                        Occupé: <%= plan.getUsedSeats() %> | Reste: <%= plan.getRemainingSeats() %>
                                                    </div>
                                                </div>
                                                
                                                <div class="plan-details">
                                                    <% if (plan.getDateDepart() != null) { %>
                                                        <div class="detail-item">
                                                            <span class="detail-label">Départ</span>
                                                            <span class="detail-value"><%= plan.getDateDepart().format(displayDateFormatter) %></span>
                                                        </div>
                                                    <% } %>
                                                    
                                                    <% if (plan.getTrajetOptimum() != null) { %>
                                                        <div class="detail-item">
                                                            <span class="detail-label">Trajet optimum</span>
                                                            <span class="detail-value highlight"><%= plan.getTrajetOptimum() %></span>
                                                        </div>
                                                    <% } %>
                                                    
                                                    <% if (plan.getTotalKmTrajet() != null) { %>
                                                        <div class="detail-item">
                                                            <span class="detail-label">Distance</span>
                                                            <span class="detail-value"><%= String.format(java.util.Locale.US, "%.2f", plan.getTotalKmTrajet()) %> km</span>
                                                        </div>
                                                    <% } %>
                                                    
                                                    <% if (plan.getVitesseMoyenne() != null) { %>
                                                        <div class="detail-item">
                                                            <span class="detail-label">Vitesse moyenne</span>
                                                            <span class="detail-value"><%= String.format(java.util.Locale.US, "%.2f", plan.getVitesseMoyenne()) %> km/h</span>
                                                        </div>
                                                    <% } %>
                                                    
                                                    <% if (plan.getDateRetourAeroport() != null) { %>
                                                        <div class="detail-item">
                                                            <span class="detail-label">Retour aéroport</span>
                                                            <span class="detail-value"><%= plan.getDateRetourAeroport().format(displayDateFormatter) %></span>
                                                        </div>
                                                    <% } %>
                                                </div>
                                                
                                                <div class="reservations-list">
                                                    <h4>Réservations assignées</h4>
                                                    <div class="reservation-tags">
                                                        <% for (Reservation reservation : plan.getReservations()) {
                                                            String reservationDate = (reservation.getDateArriver() != null)
                                                                    ? reservation.getDateArriver().format(displayDateFormatter)
                                                                    : "-";
                                                        %>
                                                            <span class="reservation-tag">
                                                                ID <%= reservation.getIdReservation() %> |
                                                                Client <%= reservation.getIdClient() %> |
                                                                Départ <%= reservationDate %>
                                                                <span class="passenger-count"><%= reservation.getNbrPassager() %></span>
                                                            </span>
                                                        <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } %>
                                
                                <% if (result.getUnassignedReservations() != null && !result.getUnassignedReservations().isEmpty()) { %>
                                    <div class="unassigned-section">
                                        <div class="unassigned-title">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            Réservations non assignées
                                        </div>
                                        <div class="unassigned-tags">
                                            <% for (Reservation reservation : result.getUnassignedReservations()) {
                                                String reservationDate = (reservation.getDateArriver() != null)
                                                        ? reservation.getDateArriver().format(displayDateFormatter)
                                                        : "-";
                                            %>
                                                <span class="unassigned-tag">
                                                    ID <%= reservation.getIdReservation() %> |
                                                    Client <%= reservation.getIdClient() %> |
                                                    Départ <%= reservationDate %>
                                                    (<%= reservation.getNbrPassager() %> passagers)
                                                </span>
                                            <% } %>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
            
            <%-- Tableau des réservations --%>
            <% if (reservationsByDate == null || reservationsByDate.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>Aucune réservation trouvée</h3>
                    <p>Il n'y a pas de réservations pour la date sélectionnée.</p>
                    <a href="${pageContext.request.contextPath}/assignation/method/auto" class="nav-link primary">
                        <i class="fas fa-arrow-left"></i> Retour au formulaire
                    </a>
                </div>
            <% } else { %>
                <div class="table-container">
                    <h2>
                        <i class="fas fa-list" style="margin-right:10px;"></i>
                        Détail des réservations
                    </h2>
                    <table class="reservations-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date d'arrivée</th>
                                <th>Passagers</th>
                                <th>Client</th>
                                <th>Hôtel</th>
                                <th>Aéroport</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Reservation reservation : reservationsByDate) { 
                                String reservationDate = (reservation.getDateArriver() != null)
                                        ? reservation.getDateArriver().format(displayDateFormatter)
                                        : "-";
                            %>
                                <tr>
                                    <td class="id-cell">#<%= reservation.getIdReservation() %></td>
                                    <td class="date-cell"><%= reservationDate %></td>
                                    <td class="passenger-cell">
                                        <span class="passenger-badge">
                                            <%= reservation.getNbrPassager() %>
                                        </span>
                                    </td>
                                    <td><%= reservation.getIdClient() %></td>
                                    <td><%= reservation.getIdHotel() %></td>
                                    <td><%= reservation.getIdAeroport() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
            
            <%-- Barre d'actions --%>
            <div class="actions-bar">
                <div class="navigation-links">
                    <a href="${pageContext.request.contextPath}/assignation/method/auto" class="nav-link">
                        <i class="fas fa-arrow-left"></i> Formulaire auto
                    </a>
                    <a href="${pageContext.request.contextPath}/assignation/method" class="nav-link">
                        <i class="fas fa-chevron-left"></i> Choix méthode
                    </a>
                </div>
                
                <% if (reservationsByDate != null && !reservationsByDate.isEmpty()) { %>
                    <button onclick="window.print()" class="nav-link" style="background:var(--teal); color:white;">
                        <i class="fas fa-print"></i> Imprimer
                    </button>
                <% } %>
            </div>
            
        </section>
    </main>
    
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>