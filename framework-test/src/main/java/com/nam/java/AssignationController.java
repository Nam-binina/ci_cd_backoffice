package com.nam.java;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Duration;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@MyAnnotation(value = "/assignation", method = HttpMethod.CONTROLLER)
public class AssignationController {

    public static class VehicleAssignmentPlan {
        private final Voiture voiture;
        private final List<Reservation> reservations;
        private final int usedSeats;
        private final int remainingSeats;
        private final LocalDateTime dateDepart;
        private final String trajetOptimum;
        private final Double totalKmTrajet;
        private final Double vitesseMoyenne;
        private final LocalDateTime dateRetourAeroport;

        public VehicleAssignmentPlan(Voiture voiture,
                                     List<Reservation> reservations,
                                     int usedSeats,
                                     int remainingSeats,
                                     LocalDateTime dateDepart,
                                     String trajetOptimum,
                                     Double totalKmTrajet,
                                     Double vitesseMoyenne,
                                     LocalDateTime dateRetourAeroport) {
            this.voiture = voiture;
            this.reservations = reservations;
            this.usedSeats = usedSeats;
            this.remainingSeats = remainingSeats;
            this.dateDepart = dateDepart;
            this.trajetOptimum = trajetOptimum;
            this.totalKmTrajet = totalKmTrajet;
            this.vitesseMoyenne = vitesseMoyenne;
            this.dateRetourAeroport = dateRetourAeroport;
        }

        public Voiture getVoiture() {
            return voiture;
        }

        public List<Reservation> getReservations() {
            return reservations;
        }

        public int getUsedSeats() {
            return usedSeats;
        }

        public int getRemainingSeats() {
            return remainingSeats;
        }

        public LocalDateTime getDateDepart() {
            return dateDepart;
        }

        public String getTrajetOptimum() {
            return trajetOptimum;
        }

        public Double getTotalKmTrajet() {
            return totalKmTrajet;
        }

        public Double getVitesseMoyenne() {
            return vitesseMoyenne;
        }

        public LocalDateTime getDateRetourAeroport() {
            return dateRetourAeroport;
        }
    }

    public static class GroupAssignmentResult {
        private final int groupIndex;
        private final List<Integer> reservationIds;
        private final List<VehicleAssignmentPlan> plans;
        private final List<Reservation> unassignedReservations;

        public GroupAssignmentResult(int groupIndex,
                                     List<Integer> reservationIds,
                                     List<VehicleAssignmentPlan> plans,
                                     List<Reservation> unassignedReservations) {
            this.groupIndex = groupIndex;
            this.reservationIds = reservationIds;
            this.plans = plans;
            this.unassignedReservations = unassignedReservations;
        }

        public int getGroupIndex() {
            return groupIndex;
        }

        public List<Integer> getReservationIds() {
            return reservationIds;
        }

        public List<VehicleAssignmentPlan> getPlans() {
            return plans;
        }

        public List<Reservation> getUnassignedReservations() {
            return unassignedReservations;
        }
    }

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
    public ModelView saveAutomaticPlaceholder(@MyParam("date") String date) {
        ModelView mv = new ModelView();

        if (date == null || date.trim().isEmpty()) {
            mv.addItem("modeChoisi", "Automatique");
            mv.addItem("message", "Aucune date sélectionnée.");
            mv.setJspName("assignationMethodResult");
            return mv;
        }

        try {
            LocalDate selectedDate = LocalDate.parse(date.trim());
            ReservationRepository reservationRepository = new ReservationRepository();

            List<Reservation> reservationsByDate = reservationRepository.findByDate(selectedDate);
            if (reservationsByDate == null || reservationsByDate.isEmpty()) {
                mv.addItem("modeChoisi", "Automatique");
                mv.addItem("message", "Aucune réservation trouvée pour la date " + date + ".");
                mv.setJspName("assignationMethodResult");
                return mv;
            }

            Parametre currentParametre = new ParametreRepository().getCurrent();
            int taMinutes = 15;
            if (currentParametre != null && currentParametre.getTempsAttente() > 0) {
                taMinutes = currentParametre.getTempsAttente();
            }

            java.util.List<java.util.List<Reservation>> reservationGroups = new java.util.ArrayList<>();
            java.util.List<Reservation> currentGroup = new java.util.ArrayList<>();
            LocalDateTime groupStartDate = null;

            for (Reservation reservation : reservationsByDate) {
                LocalDateTime currentDate = reservation.getDateArriver();

                if (currentGroup.isEmpty()) {
                    currentGroup.add(reservation);
                    groupStartDate = currentDate;
                    continue;
                }

                if (groupStartDate != null && currentDate != null
                        && Duration.between(groupStartDate, currentDate).toMinutes() <= taMinutes) {
                    currentGroup.add(reservation);
                } else {
                    reservationGroups.add(currentGroup);
                    currentGroup = new java.util.ArrayList<>();
                    currentGroup.add(reservation);
                    groupStartDate = currentDate;
                }
            }

            if (!currentGroup.isEmpty()) {
                reservationGroups.add(currentGroup);
            }

            List<Voiture> allCars = new VoitureRepository().findAllOrderBySeatsAsc();
            double vitesseMoyenne = (currentParametre != null) ? currentParametre.getVitesseMoyenne() : 0.0;
            List<GroupAssignmentResult> groupAssignmentResults = buildAssignmentsByGroup(reservationGroups, allCars, vitesseMoyenne);

            mv.addItem("reservationsByDate", reservationsByDate);
            mv.addItem("reservationGroups", reservationGroups);
            mv.addItem("groupAssignmentResults", groupAssignmentResults);
            mv.addItem("taMinutes", taMinutes);
            mv.addItem("dateSelectionnee", selectedDate);
            mv.setJspName("assignationAutoOverlapResult");
        } catch (DateTimeParseException e) {
            mv.addItem("modeChoisi", "Automatique");
            mv.addItem("message", "Date invalide : " + date + ". Format attendu : yyyy-MM-dd.");
            mv.setJspName("assignationMethodResult");
        }

        return mv;
    }

    private List<GroupAssignmentResult> buildAssignmentsByGroup(List<List<Reservation>> reservationGroups, List<Voiture> cars, double vitesseMoyenne) {
        List<GroupAssignmentResult> results = new ArrayList<>();
        DistanceRepository distanceRepository = new DistanceRepository();

        for (int groupIndex = 0; groupIndex < reservationGroups.size(); groupIndex++) {
            List<Reservation> group = reservationGroups.get(groupIndex);

            List<Integer> reservationIds = new ArrayList<>();
            for (Reservation reservation : group) {
                reservationIds.add(reservation.getIdReservation());
            }

            List<Reservation> sortedReservations = new ArrayList<>(group);
            sortedReservations.sort(Comparator
                    .comparingInt(Reservation::getNbrPassager)
                    .reversed()
                    .thenComparingInt(Reservation::getIdReservation));

            List<Voiture> availableCars = new ArrayList<>(cars);
            List<VehicleAssignmentPlan> plans = new ArrayList<>();
            List<Reservation> unassignedReservations = new ArrayList<>();

            while (!sortedReservations.isEmpty()) {
                Reservation headReservation = sortedReservations.remove(0);
                int carIndex = findFirstCarIndexWithEnoughSeats(availableCars, headReservation.getNbrPassager());

                if (carIndex < 0) {
                    unassignedReservations.add(headReservation);
                    continue;
                }

                Voiture selectedCar = availableCars.remove(carIndex);
                int carCapacity = selectedCar.getNombrePlace();

                List<Reservation> assignedReservations = new ArrayList<>();
                assignedReservations.add(headReservation);
                int usedSeats = headReservation.getNbrPassager();

                int reservationIndex = 0;
                while (reservationIndex < sortedReservations.size()) {
                    Reservation candidate = sortedReservations.get(reservationIndex);
                    if (usedSeats + candidate.getNbrPassager() <= carCapacity) {
                        assignedReservations.add(candidate);
                        usedSeats += candidate.getNbrPassager();
                        sortedReservations.remove(reservationIndex);
                    } else {
                        reservationIndex++;
                    }
                }

                plans.add(buildVehiclePlan(
                    distanceRepository,
                    selectedCar,
                    assignedReservations,
                    usedSeats,
                    carCapacity - usedSeats,
                    vitesseMoyenne
                ));
            }

            results.add(new GroupAssignmentResult(
                    groupIndex + 1,
                    reservationIds,
                    plans,
                    unassignedReservations
            ));
        }

        return results;
    }

    private VehicleAssignmentPlan buildVehiclePlan(
            DistanceRepository distanceRepository,
            Voiture selectedCar,
            List<Reservation> assignedReservations,
            int usedSeats,
            int remainingSeats,
            double vitesseMoyenne
    ) {
        LocalDateTime dateDepart = findLatestArrival(assignedReservations);
        double effectiveSpeed = vitesseMoyenne > 0 ? vitesseMoyenne : 0.0;

        if (assignedReservations == null || assignedReservations.isEmpty()) {
            return new VehicleAssignmentPlan(
                    selectedCar,
                    assignedReservations,
                    usedSeats,
                    remainingSeats,
                    dateDepart,
                    "Trajet indisponible",
                    null,
                    effectiveSpeed,
                    null
            );
        }

        int idAeroport = assignedReservations.get(0).getIdAeroport();
        List<Integer> hotels = extractUniqueHotels(assignedReservations);

        DistanceRepository.OptimalPathResult optimalPath = distanceRepository.findOptimalShortestPath(idAeroport, hotels);
        if (optimalPath.hasError() || optimalPath.getTotalDistanceKm() == null) {
            String message = optimalPath.hasError() ? optimalPath.getErrorMessage() : "Distance indisponible";
            return new VehicleAssignmentPlan(
                    selectedCar,
                    assignedReservations,
                    usedSeats,
                    remainingSeats,
                    dateDepart,
                    "Trajet indisponible: " + message,
                    null,
                    effectiveSpeed,
                    null
            );
        }

        List<Integer> hotelOrder = optimalPath.getHotelOrder();
        StringBuilder trajet = new StringBuilder();
        trajet.append("Aeroport ").append(idAeroport);
        for (Integer hotelId : hotelOrder) {
            trajet.append(" -> Hotel ").append(hotelId);
        }
        trajet.append(" -> Aeroport ").append(idAeroport);

        double totalKm = optimalPath.getTotalDistanceKm() * 2.0;
        LocalDateTime dateRetour = null;
        if (dateDepart != null && effectiveSpeed > 0.0) {
            long minutes = Math.round((totalKm / effectiveSpeed) * 60.0);
            dateRetour = dateDepart.plusMinutes(minutes);
        }

        return new VehicleAssignmentPlan(
                selectedCar,
                assignedReservations,
                usedSeats,
                remainingSeats,
                dateDepart,
                trajet.toString(),
                totalKm,
                effectiveSpeed,
                dateRetour
        );
    }

    private LocalDateTime findLatestArrival(List<Reservation> reservations) {
        LocalDateTime latest = null;
        for (Reservation reservation : reservations) {
            LocalDateTime date = reservation.getDateArriver();
            if (date != null && (latest == null || date.isAfter(latest))) {
                latest = date;
            }
        }
        return latest;
    }

    private List<Integer> extractUniqueHotels(List<Reservation> reservations) {
        Set<Integer> hotelSet = new LinkedHashSet<>();
        for (Reservation reservation : reservations) {
            hotelSet.add(reservation.getIdHotel());
        }
        return new ArrayList<>(hotelSet);
    }

    private int findFirstCarIndexWithEnoughSeats(List<Voiture> cars, int requiredSeats) {
        for (int index = 0; index < cars.size(); index++) {
            if (cars.get(index).getNombrePlace() >= requiredSeats) {
                return index;
            }
        }
        return -1;
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
