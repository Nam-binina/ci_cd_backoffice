package com.nam.java;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Duration;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.ThreadLocalRandom;

@MyAnnotation(value = "/assignation", method = HttpMethod.CONTROLLER)
public class AssignationController {

    private static class CandidateSelection {
        private final int carIndex;
        private final VehicleAssignmentPlan plan;
        private final List<Reservation> reservations;

        private CandidateSelection(int carIndex, VehicleAssignmentPlan plan, List<Reservation> reservations) {
            this.carIndex = carIndex;
            this.plan = plan;
            this.reservations = reservations;
        }
    }

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
        AssignationRepository assignationRepository = new AssignationRepository();
        Map<Integer, LocalDateTime> carNextAvailable = new HashMap<>();
        Set<Integer> dieselConsommationIds = new VoitureRepository().findDieselConsommationIds();

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
                Reservation headReservation = sortedReservations.get(0);
                TreeMap<Integer, List<CandidateSelection>> candidatesByCapacity = new TreeMap<>();

                for (int index = 0; index < availableCars.size(); index++) {
                    Voiture candidateCar = availableCars.get(index);
                    if (candidateCar.getNombrePlace() < headReservation.getNbrPassager()) {
                        continue;
                    }

                    List<Reservation> candidateReservations = buildReservationsForCar(
                            sortedReservations,
                            headReservation,
                            candidateCar.getNombrePlace()
                    );
                    int usedSeats = countPassengers(candidateReservations);
                    int remainingSeats = candidateCar.getNombrePlace() - usedSeats;

                    VehicleAssignmentPlan candidatePlan = buildVehiclePlan(
                            distanceRepository,
                            candidateCar,
                            candidateReservations,
                            usedSeats,
                            remainingSeats,
                            vitesseMoyenne
                    );

                    if (!isCarAvailableBySchedule(candidateCar.getId(), candidatePlan.getDateDepart(), carNextAvailable)) {
                        continue;
                    }

                    LocalDate debutTrajet = toLocalDate(candidatePlan.getDateDepart());
                    LocalDate finTrajet = toLocalDate(candidatePlan.getDateRetourAeroport());
                    if (finTrajet == null) {
                        finTrajet = debutTrajet;
                    }

                    if (assignationRepository.isCarAvailable(candidateCar.getId(), debutTrajet, finTrajet)) {
                        candidatesByCapacity
                                .computeIfAbsent(candidateCar.getNombrePlace(), key -> new ArrayList<>())
                                .add(new CandidateSelection(index, candidatePlan, candidateReservations));
                    }
                }

                CandidateSelection selected = chooseCandidateByPriority(candidatesByCapacity, dieselConsommationIds);
                VehicleAssignmentPlan selectedPlan = selected != null ? selected.plan : null;
                List<Reservation> selectedReservations = selected != null ? selected.reservations : null;
                int selectedCarIndex = selected != null ? selected.carIndex : -1;

                if (selectedPlan == null || selectedReservations == null || selectedCarIndex < 0) {
                    unassignedReservations.add(headReservation);
                    sortedReservations.remove(0);
                    continue;
                }

                plans.add(selectedPlan);
                if (selectedPlan.getDateRetourAeroport() != null) {
                    carNextAvailable.put(selectedPlan.getVoiture().getId(), selectedPlan.getDateRetourAeroport());
                }
                availableCars.remove(selectedCarIndex);
                sortedReservations.removeAll(selectedReservations);
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

    private CandidateSelection chooseCandidateByPriority(
            TreeMap<Integer, List<CandidateSelection>> candidatesByCapacity,
            Set<Integer> dieselConsommationIds
    ) {
        if (candidatesByCapacity == null || candidatesByCapacity.isEmpty()) {
            return null;
        }

        List<CandidateSelection> minimalCapacityCandidates = candidatesByCapacity.firstEntry().getValue();
        if (minimalCapacityCandidates == null || minimalCapacityCandidates.isEmpty()) {
            return null;
        }

        List<CandidateSelection> dieselCandidates = new ArrayList<>();
        for (CandidateSelection candidate : minimalCapacityCandidates) {
            int idConsommation = candidate.plan.getVoiture().getIdConsommation();
            if (dieselConsommationIds.contains(idConsommation)) {
                dieselCandidates.add(candidate);
            }
        }

        List<CandidateSelection> pool = dieselCandidates.isEmpty() ? minimalCapacityCandidates : dieselCandidates;
        int randomIndex = ThreadLocalRandom.current().nextInt(pool.size());
        return pool.get(randomIndex);
    }

    private boolean isCarAvailableBySchedule(int voitureId, LocalDateTime dateDepart, Map<Integer, LocalDateTime> carNextAvailable) {
        if (dateDepart == null) {
            return true;
        }
        LocalDateTime nextAvailable = carNextAvailable.get(voitureId);
        return nextAvailable == null || !dateDepart.isBefore(nextAvailable);
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

        double totalKm = optimalPath.getTotalDistanceKm();
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

    private List<Reservation> buildReservationsForCar(
            List<Reservation> sortedReservations,
            Reservation headReservation,
            int carCapacity
    ) {
        List<Reservation> assignedReservations = new ArrayList<>();
        assignedReservations.add(headReservation);
        int usedSeats = headReservation.getNbrPassager();

        for (int index = 1; index < sortedReservations.size(); index++) {
            Reservation candidate = sortedReservations.get(index);
            if (usedSeats + candidate.getNbrPassager() <= carCapacity) {
                assignedReservations.add(candidate);
                usedSeats += candidate.getNbrPassager();
            }
        }

        return assignedReservations;
    }

    private int countPassengers(List<Reservation> reservations) {
        int total = 0;
        for (Reservation reservation : reservations) {
            total += reservation.getNbrPassager();
        }
        return total;
    }

    private LocalDate toLocalDate(LocalDateTime dateTime) {
        return dateTime != null ? dateTime.toLocalDate() : null;
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
        AssignationRepository assignationRepository = new AssignationRepository();
        java.util.Set<Integer> assignedReservationIds = assignationRepository.findAssignedReservationIds();
        ReservationRepository reservationRepository = new ReservationRepository();
        List<Reservation> reservationsToAssign = new ArrayList<>();
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
                Reservation reservation = reservationRepository.findById(idReservation);
                if (reservation == null) {
                    skipped++;
                    continue;
                }
                reservationsToAssign.add(reservation);
            } catch (NumberFormatException e) {
                skipped++;
            }
        }

        if (reservationsToAssign.isEmpty()) {
            mv.addItem("message", "Aucune reservation valide a assigner.");
            mv.setJspName("assignationMethodResult");
            return mv;
        }

        Voiture selectedCar = new VoitureRepository().findById(voitureId);
        if (selectedCar == null) {
            mv.addItem("message", "Voiture introuvable.");
            mv.setJspName("assignationMethodResult");
            return mv;
        }

        int usedSeats = countPassengers(reservationsToAssign);
        int remainingSeats = selectedCar.getNombrePlace() - usedSeats;
        Parametre currentParametre = new ParametreRepository().getCurrent();
        double vitesseMoyenne = (currentParametre != null) ? currentParametre.getVitesseMoyenne() : 0.0;
        VehicleAssignmentPlan plan = buildVehiclePlan(
                new DistanceRepository(),
                selectedCar,
                reservationsToAssign,
                usedSeats,
                remainingSeats,
                vitesseMoyenne
        );

        LocalDate debutTrajet = toLocalDate(plan.getDateDepart());
        LocalDate finTrajet = toLocalDate(plan.getDateRetourAeroport());
        if (finTrajet == null) {
            finTrajet = debutTrajet;
        }

        if (!assignationRepository.isCarAvailable(voitureId, debutTrajet, finTrajet)) {
            mv.addItem("message", "Voiture indisponible sur la periode demandee.");
            mv.setJspName("assignationMethodResult");
            return mv;
        }

        for (Reservation reservation : reservationsToAssign) {
            assignationRepository.insert(new Assignation(0,
                    reservation.getIdReservation(),
                    voitureId,
                    debutTrajet,
                    finTrajet));
            inserted++;
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
