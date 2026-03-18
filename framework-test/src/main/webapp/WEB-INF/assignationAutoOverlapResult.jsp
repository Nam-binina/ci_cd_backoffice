<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Reservation" %>
<%@ page import="com.nam.java.AssignationController.ReservationGroupInfo" %>
<%@ page import="com.nam.java.AssignationController.GroupAssignmentResult" %>
<%@ page import="com.nam.java.AssignationController.VehicleAssignmentPlan" %>
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
                List<ReservationGroupInfo> reservationGroupsInfo = (List<ReservationGroupInfo>) request.getAttribute("reservationGroupsInfo");
                List<GroupAssignmentResult> groupAssignmentResults = (List<GroupAssignmentResult>) request.getAttribute("groupAssignmentResults");
                java.util.Set<Integer> assignedReservationIds = (java.util.Set<Integer>) request.getAttribute("assignedReservationIds");
                java.time.LocalDate dateSelectionnee = (java.time.LocalDate) request.getAttribute("dateSelectionnee");
                Integer taMinutes = (Integer) request.getAttribute("taMinutes");
                Integer totalReservations = (Integer) request.getAttribute("totalReservations");
                Integer totalPassagers = (Integer) request.getAttribute("totalPassagers");
                DateTimeFormatter displayDateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
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
                        <div class="stat-value"><%= totalReservations != null ? totalReservations : 0 %></div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-content">
                        <div class="stat-label">Passagers</div>
                        <div class="stat-value"><%= totalPassagers != null ? totalPassagers : 0 %></div>
                    </div>
                </div>
            </div>
            
            <%-- Affichage des groupes par TA --%>
            <% if (reservationGroupsInfo != null && !reservationGroupsInfo.isEmpty()) { %>
                <div class="groups-section">
                    <h2 class="section-title">Groupes de réservations (TA: <%= taMinutes %> min)</h2>
                    <div class="groups-grid">
                        <% for (ReservationGroupInfo groupInfo : reservationGroupsInfo) { %>
                            <div class="group-card">
                                <div class="group-header">
                                    <h3>Groupe <%= groupInfo.getGroupIndex() %></h3>
                                    <span class="group-badge"><%= groupInfo.getReservations().size() %> réservation(s)</span>
                                </div>
                                <div class="group-content">
                                    <% if (groupInfo.getGroupStartDate() != null) { %>
                                        <div style="margin-bottom: 10px; font-size: 0.95rem;">
                                            <strong>Plage horaire:</strong> 
                                            <%= groupInfo.getGroupStartDate().format(displayDateFormatter) %> → 
                                            <%= groupInfo.getGroupEndDate().format(displayDateFormatter) %>
                                        </div>
                                    <% } %>
                                    <div style="margin-bottom: 10px;">
                                        <strong>Réservations:</strong>
                                        <div style="margin-top: 5px; font-size: 0.9rem; color: var(--muted);">
                                            <%= groupInfo.getReservationDetails() %>
                                        </div>
                                    </div>
                                    <div style="font-size: 0.9rem; color: var(--muted);">
                                        <strong>Total passagers:</strong> 
                                        <span style="color: var(--teal); font-weight: bold;"><%= groupInfo.getTotalPassagers() %></span>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <% if (groupAssignmentResults != null && !groupAssignmentResults.isEmpty()) { %>
                <div class="groups-section">
                    <h2 class="section-title">Assignation des voitures par groupe</h2>
                    <% for (GroupAssignmentResult result : groupAssignmentResults) { %>
                        <% java.util.Set<Integer> carryOverIds = new java.util.HashSet<>(result.getCarriedOverReservationIds() != null ? result.getCarriedOverReservationIds() : java.util.Collections.emptyList()); %>
                        <div class="group-card" style="margin-bottom: 16px;">
                            <div class="group-header">
                                <h3>Groupe <%= result.getGroupIndex() %></h3>
                                <span class="group-badge"><%= result.getReservationIds().size() %> réservation(s)</span>
                            </div>
                            <div class="group-content">
                                <div style="margin-bottom: 10px; color: var(--muted);">
                                    <strong>Date de départ du groupe:</strong>
                                    <%= result.getGroupDeparture() != null ? result.getGroupDeparture().format(displayDateFormatter) : "-" %>
                                </div>
                                <% if (result.getPlans() == null || result.getPlans().isEmpty()) { %>
                                    <div style="color: var(--muted);">Aucune voiture assignée pour ce groupe.</div>
                                <% } else { %>
                                    <% for (VehicleAssignmentPlan plan : result.getPlans()) { %>
                                        <div style="padding: 10px; border: 1px solid var(--border); border-radius: 10px; margin-bottom: 10px;">
                                            <div>
                                                <strong>Voiture:</strong> <%= plan.getVoiture().getImmatriculation() %>
                                                (<%= plan.getVoiture().getNombrePlace() %> places)
                                            </div>
                                            <div>
                                                <strong>Occupé:</strong> <%= plan.getUsedSeats() %>
                                                | <strong>Reste:</strong> <%= plan.getRemainingSeats() %>
                                            </div>
                                            <div>
                                                <strong>Trajet parcouru:</strong>
                                                <%= plan.getTrajetOptimum() != null ? plan.getTrajetOptimum() : "-" %>
                                            </div>
                                            <div>
                                                <strong>Distance totale du trajet:</strong>
                                                <%= plan.getTotalKmTrajet() != null ? String.format(java.util.Locale.US, "%.2f", plan.getTotalKmTrajet()) + " km" : "-" %>
                                            </div>
                                            <div>
                                                <strong>Vitesse moyenne:</strong>
                                                <%= plan.getVitesseMoyenne() != null ? String.format(java.util.Locale.US, "%.2f", plan.getVitesseMoyenne()) + " km/h" : "-" %>
                                            </div>
                                            <div>
                                                <strong>Date de retour aéroport:</strong>
                                                <%= plan.getDateRetourAeroport() != null ? plan.getDateRetourAeroport().format(displayDateFormatter) : "-" %>
                                            </div>
                                            <div>
                                                <strong>Réservations assignées:</strong>
                                                <% for (Reservation reservation : plan.getReservations()) { %>
                                                    <span style="display:block; margin-top:4px; color:var(--muted);">
                                                        ID <%= reservation.getIdReservation() %>
                                                        | Arrivée aéroport: <%= reservation.getDateArriver() != null ? reservation.getDateArriver().format(displayDateFormatter) : "-" %>
                                                        | Passagers: <%= reservation.getNbrPassager() %>
                                                        <% if (carryOverIds.contains(reservation.getIdReservation())) { %>
                                                            | <strong>Reportée du groupe précédent</strong>
                                                        <% } %>
                                                    </span>
                                                <% } %>
                                            </div>
                                            <%
                                                StringBuilder reservationIds = new StringBuilder();
                                                boolean allAssigned = true;
                                                if (plan.getReservations() != null) {
                                                    for (Reservation reservation : plan.getReservations()) {
                                                        if (reservationIds.length() > 0) {
                                                            reservationIds.append(",");
                                                        }
                                                        reservationIds.append(reservation.getIdReservation());
                                                        if (assignedReservationIds == null || !assignedReservationIds.contains(reservation.getIdReservation())) {
                                                            allAssigned = false;
                                                        }
                                                    }
                                                }
                                            %>
                                            <% if (allAssigned) { %>
                                                <span class="nav-link" style="background:var(--muted); color:white; display:inline-block; margin-top:12px;">
                                                    ✅ Déjà assigné
                                                </span>
                                            <% } else { %>
                                                <form action="${pageContext.request.contextPath}/assignation/method/auto/confirm" method="POST" class="assignation-confirm-form" style="margin-top:12px;">
                                                    <input type="hidden" name="reservationIds" value="<%= reservationIds %>">
                                                    <input type="hidden" name="voitureId" value="<%= plan.getVoiture().getId() %>">
                                                    <button type="submit" class="nav-link assignation-confirm-btn" style="background:var(--teal); color:white;">
                                                        ✅ Confirmer assignation
                                                    </button>
                                                </form>
                                            <% } %>
                                        </div>
                                    <% } %>
                                <% } %>

                                <% if (result.getUnassignedReservations() != null && !result.getUnassignedReservations().isEmpty()) { %>
                                    <div style="margin-top: 8px; color: var(--muted);">
                                        <strong>Non assignées:</strong>
                                        <% for (Reservation reservation : result.getUnassignedReservations()) { %>
                                            <span style="display:block; margin-top:4px;">
                                                ID <%= reservation.getIdReservation() %>
                                                | Arrivée aéroport: <%= reservation.getDateArriver() != null ? reservation.getDateArriver().format(displayDateFormatter) : "-" %>
                                                | Passagers: <%= reservation.getNbrPassager() %>
                                                <% if (carryOverIds.contains(reservation.getIdReservation())) { %>
                                                    | <strong>Reportée du groupe précédent</strong>
                                                <% } %>
                                            </span>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
            
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
                            <% for (Reservation reservation : reservationsByDate) { %>
                                <tr>
                                    <td class="id-cell">#<%= reservation.getIdReservation() %></td>
                                    <td class="date-cell"><%= reservation.getDateArriver() != null ? reservation.getDateArriver().format(displayDateFormatter) : "-" %></td>
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

    <script>
        (function () {
            const forms = document.querySelectorAll('.assignation-confirm-form');
            const initialAssignedIds = <%= assignedReservationIds != null ? assignedReservationIds.toString() : "[]" %>;
            const assignedIds = new Set(initialAssignedIds);

            const parseReservationIds = (form) => {
                const input = form.querySelector('input[name="reservationIds"]');
                if (!input || !input.value) {
                    return [];
                }
                return input.value
                    .split(',')
                    .map((value) => Number(value.trim()))
                    .filter((value) => !Number.isNaN(value));
            };

            const updateFormState = (form) => {
                const button = form.querySelector('.assignation-confirm-btn');
                if (!button) {
                    return;
                }
                const reservationIds = parseReservationIds(form);
                const allAssigned = reservationIds.length > 0 && reservationIds.every((id) => assignedIds.has(id));
                if (allAssigned) {
                    button.textContent = '✅ Déjà assigné';
                    button.style.background = 'var(--muted)';
                    button.disabled = true;
                }
            };
            forms.forEach((form) => {
                form.addEventListener('submit', async (event) => {
                    event.preventDefault();

                    const button = form.querySelector('.assignation-confirm-btn');
                    if (!button || button.disabled) {
                        return;
                    }

                    const ok = window.confirm('Confirmer cette assignation ?');
                    if (!ok) {
                        return;
                    }

                    const formData = new FormData(form);
                    button.disabled = true;
                    button.textContent = '⏳ Assignation en cours...';

                    try {
                        const response = await fetch(form.action, {
                            method: 'POST',
                            body: formData
                        });

                        if (!response.ok) {
                            throw new Error('Erreur serveur');
                        }

                        const responseText = await response.text();
                        const match = responseText.match(/Assignations\s*enregistr[eé]es\s*:\s*(\d+)/i);
                        const inserted = match ? Number(match[1]) : 0;
                        const paragraphs = [...responseText.matchAll(/<p[^>]*>([\s\S]*?)<\/p>/gi)];
                        const lastParagraph = paragraphs.length ? paragraphs[paragraphs.length - 1][1] : '';
                        const serverMessage = lastParagraph.replace(/<[^>]+>/g, '').trim();

                        if (!inserted) {
                            throw new Error(serverMessage || 'Aucune assignation enregistrée');
                        }

                        parseReservationIds(form).forEach((id) => assignedIds.add(id));
                        updateFormState(form);
                    } catch (error) {
                        button.disabled = false;
                        button.textContent = '✅ Confirmer assignation';
                        alert(error && error.message ? error.message : "Impossible de confirmer l'assignation pour le moment.");
                    }
                });

                updateFormState(form);
            });
        })();
    </script>
</body>
</html>