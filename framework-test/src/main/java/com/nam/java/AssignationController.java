package com.nam.java;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@MyAnnotation(value = "/assignation", method = HttpMethod.CONTROLLER)
public class AssignationController {

    @MyAnnotation(value = "/page", method = HttpMethod.GET)
    public ModelView page() {
        ModelView mv = new ModelView();
        mv.setJspName("assignationPage");
        return mv;
    }

    @MyAnnotation(value = "/method", method = HttpMethod.GET)
    public ModelView methodPage() {
        ModelView mv = new ModelView();
        mv.setJspName("assignationMethod");
        return mv;
    }

    @MyAnnotation(value = "/method/auto", method = HttpMethod.GET)
    public ModelView automaticForm() {
        ModelView mv = new ModelView();
        try {
            List<Reservation> reservations = new ReservationRepository().findNotAssigned();
            mv.addItem("reservations", reservations);
        } catch (Exception e) {
            mv.addItem("error", e.getMessage());
        }
        mv.setJspName("assignationAutoForm");
        return mv;
    }

    @MyAnnotation(value = "/method/auto/save", method = HttpMethod.POST)
    public ModelView saveAutomaticPlaceholder(@MyParam("idReservation") String idReservation) {
        ModelView mv = new ModelView();

        if (idReservation == null || idReservation.trim().isEmpty()) {
            mv.addItem("modeChoisi", "Automatique");
            mv.addItem("message", "Aucune réservation sélectionnée.");
            mv.setJspName("assignationMethodResult");
            return mv;
        }

        try {
            int selectedReservationId = Integer.parseInt(idReservation.trim());
            ReservationRepository reservationRepository = new ReservationRepository();

            Reservation selectedReservation = reservationRepository.findById(selectedReservationId);
            if (selectedReservation == null) {
                mv.addItem("modeChoisi", "Automatique");
                mv.addItem("message", "Réservation introuvable pour l'ID " + idReservation + ".");
                mv.setJspName("assignationMethodResult");
                return mv;
            }

            List<Reservation> overlaps = reservationRepository.findOverlappingForSelectedDeparture(selectedReservationId);
            java.util.Set<Integer> assignedReservationIds = new AssignationRepository().findAssignedReservationIds();
            java.util.Map<Integer, Boolean> assignmentStatus = new java.util.HashMap<>();
            int totalPassagers = 0;
            LocalDateTime dateDepartReel = null;
                java.util.List<Integer> hotelsItineraire = new java.util.ArrayList<>();
                java.util.Set<Integer> hotelsAlreadyAdded = new java.util.HashSet<>();

            assignmentStatus.put(selectedReservation.getIdReservation(),
                    assignedReservationIds.contains(selectedReservation.getIdReservation()));

            for (Reservation reservation : overlaps) {
                assignmentStatus.put(reservation.getIdReservation(),
                        assignedReservationIds.contains(reservation.getIdReservation()));
                totalPassagers += reservation.getNbrPassager();

                LocalDateTime currentDate = reservation.getDateArriver();
                if (currentDate != null && (dateDepartReel == null || currentDate.isAfter(dateDepartReel))) {
                    dateDepartReel = currentDate;
                }

                if (hotelsAlreadyAdded.add(reservation.getIdHotel())) {
                    hotelsItineraire.add(reservation.getIdHotel());
                }
            }

            List<Voiture> voituresProposees = new VoitureRepository().findClosestByRequiredSeats(totalPassagers);
            Voiture voitureSelectionnee = new VoitureRepository().findBestByRequiredSeats(totalPassagers);

            Double distanceAller = null;
            Double distanceTotale = null;
            LocalDateTime dateArriveeFinTrajet = null;
            LocalDateTime dateRetourAeroport = null;
            String trajetMessage = null;

            if (!hotelsItineraire.isEmpty()) {
                DistanceRepository distanceRepository = new DistanceRepository();
                double trajetAller = 0.0;
                int idAeroportDepart = selectedReservation.getIdAeroport();

                int firstHotelId = hotelsItineraire.get(0);
                Double aeroportToFirst = distanceRepository.findAeroportHotelDistance(firstHotelId, idAeroportDepart);

                if (aeroportToFirst == null) {
                    trajetMessage = "Distance introuvable entre l'aéroport " + idAeroportDepart + " et l'hôtel " + firstHotelId + ".";
                } else {
                    trajetAller += aeroportToFirst;

                    for (int index = 0; index < hotelsItineraire.size() - 1; index++) {
                        int fromHotelId = hotelsItineraire.get(index);
                        int toHotelId = hotelsItineraire.get(index + 1);
                        Double betweenHotels = distanceRepository.findHotelHotelDistance(fromHotelId, toHotelId);

                        if (betweenHotels == null) {
                            trajetMessage = "Distance introuvable entre les hôtels " + fromHotelId + " et " + toHotelId + ".";
                            break;
                        }

                        trajetAller += betweenHotels;
                    }
                }

                if (trajetMessage == null) {
                    distanceAller = trajetAller;
                    distanceTotale = trajetAller * 2.0;

                    if (dateDepartReel != null && voitureSelectionnee != null && voitureSelectionnee.getVitesseMoyenne() > 0) {
                        long minutesAller = Math.round((distanceAller / voitureSelectionnee.getVitesseMoyenne()) * 60.0);
                        dateArriveeFinTrajet = dateDepartReel.plusMinutes(minutesAller);
                        dateRetourAeroport = dateArriveeFinTrajet.plusMinutes(minutesAller);
                    }
                }
            } else {
                trajetMessage = "Aucun hôtel dans la liste chevauchante.";
            }

            mv.addItem("selectedReservation", selectedReservation);
            mv.addItem("overlaps", overlaps);
            mv.addItem("assignmentStatus", assignmentStatus);
            mv.addItem("totalPassagers", totalPassagers);
            mv.addItem("dateDepartReel", dateDepartReel);
            mv.addItem("hotelsItineraire", hotelsItineraire);
            mv.addItem("distanceAller", distanceAller);
            mv.addItem("distanceTotale", distanceTotale);
            mv.addItem("dateArriveeFinTrajet", dateArriveeFinTrajet);
            mv.addItem("dateRetourAeroport", dateRetourAeroport);
            mv.addItem("trajetMessage", trajetMessage);
            mv.addItem("voituresProposees", voituresProposees);
            mv.addItem("voitureSelectionnee", voitureSelectionnee);
            mv.setJspName("assignationAutoOverlapResult");
        } catch (NumberFormatException e) {
            mv.addItem("modeChoisi", "Automatique");
            mv.addItem("message", "ID réservation invalide : " + idReservation + ".");
            mv.setJspName("assignationMethodResult");
        }

        return mv;
    }

    @MyAnnotation(value = "/method/auto/confirm", method = HttpMethod.POST)
    public ModelView confirmAutomatic(
            @MyParam("reservationIds") String reservationIds,
            @MyParam("voitureId") int voitureId
    ) {
        ModelView mv = new ModelView();
        mv.addItem("modeChoisi", "Automatique");

        if (reservationIds == null || reservationIds.trim().isEmpty()) {
            mv.addItem("message", "Aucune réservation à assigner.");
            mv.setJspName("assignationMethodResult");
            return mv;
        }

        if (voitureId <= 0) {
            mv.addItem("message", "Voiture invalidée ou manquante.");
            mv.setJspName("assignationMethodResult");
            return mv;
        }

        String[] tokens = reservationIds.split(",");
        java.util.Set<Integer> assignedReservationIds = new AssignationRepository().findAssignedReservationIds();
        AssignationRepository assignationRepository = new AssignationRepository();
        int inserted = 0;
        int skipped = 0;

        for (String token : tokens) {
            if (token == null || token.trim().isEmpty()) {
                continue;
            }
            try {
                int idReservation = Integer.parseInt(token.trim());
                if (assignedReservationIds.contains(idReservation)) {
                    skipped++;
                    continue;
                }
                assignationRepository.insert(new Assignation(0, idReservation, voitureId));
                inserted++;
            } catch (NumberFormatException e) {
                skipped++;
            }
        }

        mv.addItem("message", "Assignations enregistrées : " + inserted + ", ignorées : " + skipped + ".");
        mv.setJspName("assignationMethodResult");
        return mv;
    }

    @MyAnnotation(value = "/method/manual", method = HttpMethod.GET)
    public ModelView manualForm() {
        ModelView mv = new ModelView();
        mv.setJspName("assignationManualForm");
        return mv;
    }

    @MyAnnotation(value = "/list", method = HttpMethod.GET)
    public ModelView list() {
        ModelView mv = new ModelView();
        try {
            List<Assignation> assignations = new AssignationRepository().findAll();
            mv.addItem("assignations", assignations);
        } catch (Exception e) {
            mv.addItem("error", e.getMessage());
        }
        mv.setJspName("assignationList");
        return mv;
    }

    @MyAnnotation(value = "/filter", method = HttpMethod.GET)
    public ModelView filterForm() {
        ModelView mv = new ModelView();
        mv.setJspName("assignationFilterForm");
        return mv;
    }

    @MyAnnotation(value = "/filter/result", method = HttpMethod.POST)
    public ModelView filterResult(@MyParam("date") String date) {
        ModelView mv = new ModelView();

        if (date == null || date.trim().isEmpty()) {
            mv.addItem("error", "Veuillez choisir une date.");
            mv.setJspName("assignationFilterForm");
            return mv;
        }

        try {
            LocalDate targetDate = LocalDate.parse(date.trim());
            List<AssignationDetail> details = new AssignationRepository().findAssignedByDate(targetDate);
            mv.addItem("date", date.trim());
            mv.addItem("details", details);
            mv.setJspName("assignationFilterResult");
            return mv;
        } catch (DateTimeParseException e) {
            mv.addItem("error", "Format de date invalide.");
            mv.setJspName("assignationFilterForm");
            return mv;
        } catch (Exception e) {
            mv.addItem("error", e.getMessage());
            mv.setJspName("assignationFilterForm");
            return mv;
        }
    }
}
