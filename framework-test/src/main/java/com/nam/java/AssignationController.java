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
import java.util.concurrent.ThreadLocalRandom;

@MyAnnotation(value = "/assignation", method = HttpMethod.CONTROLLER)
public class AssignationController {

    public static class ReservationGroupInfo {
        private final int groupIndex;
        private final List<Reservation> reservations;
        private final LocalDateTime groupStartDate;
        private final LocalDateTime groupEndDate;
        private final int totalPassagers;
        private final String reservationDetails;

        public ReservationGroupInfo(int groupIndex,
                                    List<Reservation> reservations,
                                    LocalDateTime groupStartDate,
                                    LocalDateTime groupEndDate,
                                    int totalPassagers,
                                    String reservationDetails) {
            this.groupIndex = groupIndex;
            this.reservations = reservations;
            this.groupStartDate = groupStartDate;
            this.groupEndDate = groupEndDate;
            this.totalPassagers = totalPassagers;
            this.reservationDetails = reservationDetails;
        }

        public int getGroupIndex() {
            return groupIndex;
        }

        public List<Reservation> getReservations() {
            return reservations;
        }

        public LocalDateTime getGroupStartDate() {
            return groupStartDate;
        }

        public LocalDateTime getGroupEndDate() {
            return groupEndDate;
        }

        public int getTotalPassagers() {
            return totalPassagers;
        }

        public String getReservationDetails() {
            return reservationDetails;
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
        private final List<Integer> carriedOverReservationIds;
        private final List<VehicleAssignmentPlan> plans;
        private final List<Reservation> unassignedReservations;
        private final LocalDateTime groupDeparture;

        public GroupAssignmentResult(int groupIndex,
                                     List<Integer> reservationIds,
                                     List<Integer> carriedOverReservationIds,
                                     List<VehicleAssignmentPlan> plans,
                                     List<Reservation> unassignedReservations,
                                     LocalDateTime groupDeparture) {
            this.groupIndex = groupIndex;
            this.reservationIds = reservationIds;
            this.carriedOverReservationIds = carriedOverReservationIds;
            this.plans = plans;
            this.unassignedReservations = unassignedReservations;
            this.groupDeparture = groupDeparture;
        }

        public int getGroupIndex() {
            return groupIndex;
        }

        public List<Integer> getReservationIds() {
            return reservationIds;
        }

        public List<Integer> getCarriedOverReservationIds() {
            return carriedOverReservationIds;
        }

        public List<VehicleAssignmentPlan> getPlans() {
            return plans;
        }

        public List<Reservation> getUnassignedReservations() {
            return unassignedReservations;
        }

        public LocalDateTime getGroupDeparture() {
            return groupDeparture;
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

            // Étape 1: Sélectionner toutes les réservations pour la date choisie
            List<Reservation> reservationsByDate = reservationRepository.findByDate(selectedDate);
            if (reservationsByDate == null || reservationsByDate.isEmpty()) {
                mv.addItem("modeChoisi", "Automatique");
                mv.addItem("message", "Aucune réservation trouvée pour la date " + date + ".");
                mv.setJspName("assignationMethodResult");
                return mv;
            }

            // Récupérer le TA depuis les paramètres
            Parametre currentParametre = new ParametreRepository().getCurrent();
            int taMinutes = 15;
            if (currentParametre != null && currentParametre.getTempsAttente() > 0) {
                taMinutes = currentParametre.getTempsAttente();
            }

            // Étape 2: Grouper les réservations par rapport au TA
            // Trier d'abord par date d'arrivée
            reservationsByDate.sort(Comparator.comparing(r -> r.getDateArriver() != null ? r.getDateArriver() : LocalDateTime.MIN));

            // Étape 2: Grouper les réservations par rapport au TA avec calculs pré-effectués
            java.util.List<ReservationGroupInfo> reservationGroupsInfo = new java.util.ArrayList<>();
            java.util.List<java.util.List<Reservation>> reservationGroups = new java.util.ArrayList<>();
            java.util.List<Reservation> currentGroup = new java.util.ArrayList<>();
            LocalDateTime groupStartDate = null;

            for (Reservation reservation : reservationsByDate) {
                LocalDateTime currentDate = reservation.getDateArriver();

                if (currentGroup.isEmpty()) {
                    // Début d'un nouveau groupe
                    currentGroup.add(reservation);
                    groupStartDate = currentDate;
                    continue;
                }

                // Vérifier si la réservation appartient au groupe courant
                if (groupStartDate != null && currentDate != null
                        && Duration.between(groupStartDate, currentDate).toMinutes() <= taMinutes) {
                    currentGroup.add(reservation);
                } else {
                    // Créer les infos du groupe et l'ajouter
                    reservationGroups.add(new java.util.ArrayList<>(currentGroup));
                    ReservationGroupInfo groupInfo = buildGroupInfo(reservationGroupsInfo.size() + 1, 
                                                                     currentGroup, 
                                                                     groupStartDate, 
                                                                     taMinutes);
                    reservationGroupsInfo.add(groupInfo);
                    
                    currentGroup = new java.util.ArrayList<>();
                    currentGroup.add(reservation);
                    groupStartDate = currentDate;
                }
            }

            // Ajouter le dernier groupe
            if (!currentGroup.isEmpty()) {
                reservationGroups.add(new java.util.ArrayList<>(currentGroup));
                ReservationGroupInfo groupInfo = buildGroupInfo(reservationGroupsInfo.size() + 1, 
                                                                 currentGroup, 
                                                                 groupStartDate, 
                                                                 taMinutes);
                reservationGroupsInfo.add(groupInfo);
            }

            List<Voiture> allCars = new VoitureRepository().findAllOrderBySeatsAsc();
            double vitesseMoyenne = (currentParametre != null) ? currentParametre.getVitesseMoyenne() : 0.0;
            Map<Integer, Integer> tripCounts = loadTripCountsForCars(allCars, selectedDate);
            List<GroupAssignmentResult> groupAssignmentResults = buildAssignmentsByGroup(reservationGroups, allCars, vitesseMoyenne, taMinutes, tripCounts);

            int totalPassagers = 0;
            for (Reservation reservation : reservationsByDate) {
                totalPassagers += reservation.getNbrPassager();
            }

            // Envoyer les données à la vue
            mv.addItem("reservationsByDate", reservationsByDate);
            mv.addItem("reservationGroupsInfo", reservationGroupsInfo);
            mv.addItem("groupAssignmentResults", groupAssignmentResults);
            mv.addItem("assignedReservationIds", new AssignationRepository().findAssignedReservationIds());
            mv.addItem("carTripCounts", tripCounts);
            mv.addItem("totalReservations", reservationsByDate.size());
            mv.addItem("totalPassagers", totalPassagers);
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

    private ReservationGroupInfo buildGroupInfo(int groupIndex, List<Reservation> group, LocalDateTime groupStartDate, int taMinutes) {
        // Calculer la date de fin du groupe
        LocalDateTime groupEndDate = groupStartDate != null ? groupStartDate.plusMinutes(taMinutes) : null;
        
        // Calculer le total des passagers
        int totalPassagers = 0;
        for (Reservation reservation : group) {
            totalPassagers += reservation.getNbrPassager();
        }
        
        // Construire les détails des réservations
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        StringBuilder reservationDetails = new StringBuilder();
        for (Reservation reservation : group) {
            if (reservationDetails.length() > 0) {
                reservationDetails.append(", ");
            }
            String reservationDate = (reservation.getDateArriver() != null)
                    ? reservation.getDateArriver().format(formatter)
                    : "-";
            reservationDetails.append("ID ")
                    .append(reservation.getIdReservation())
                    .append(" (").append(reservationDate).append(")");
        }
        
        return new ReservationGroupInfo(groupIndex, group, groupStartDate, groupEndDate, totalPassagers, reservationDetails.toString());
    }

    private List<GroupAssignmentResult> buildAssignmentsByGroup(List<List<Reservation>> reservationGroups, List<Voiture> cars, double vitesseMoyenne, int taMinutes, Map<Integer, Integer> tripCounts) {
        List<GroupAssignmentResult> results = new ArrayList<>();
        DistanceRepository distanceRepository = new DistanceRepository();
        Set<Integer> dieselConsommationIds = new VoitureRepository().findDieselConsommationIds();
        Map<Integer, LocalDateTime> carNextAvailable = new HashMap<>();
        List<Reservation> carryOverReservations = new ArrayList<>();

        for (int groupIndex = 0; groupIndex < reservationGroups.size(); groupIndex++) {
            List<Reservation> group = reservationGroups.get(groupIndex);
            LocalDateTime groupStart = group != null && !group.isEmpty() ? group.get(0).getDateArriver() : null;
            LocalDateTime groupEnd = groupStart != null ? groupStart.plusMinutes(taMinutes) : null;
            List<Integer> carriedOverReservationIds = new ArrayList<>();
            for (Reservation reservation : carryOverReservations) {
                if (reservation != null) {
                    carriedOverReservationIds.add(reservation.getIdReservation());
                }
            }

            List<Reservation> processingReservations = new ArrayList<>();
            Set<Integer> seenReservationIds = new LinkedHashSet<>();

            for (Reservation reservation : carryOverReservations) {
                if (reservation != null && seenReservationIds.add(reservation.getIdReservation())) {
                    processingReservations.add(reservation);
                }
            }
            if (group != null) {
                for (Reservation reservation : group) {
                    if (reservation != null && seenReservationIds.add(reservation.getIdReservation())) {
                        processingReservations.add(reservation);
                    }
                }
            }

            List<Integer> reservationIds = new ArrayList<>();
            for (Reservation reservation : processingReservations) {
                reservationIds.add(reservation.getIdReservation());
            }

            Comparator<Reservation> reservationComparator = Comparator
                .comparingInt(Reservation::getNbrPassager)
                .reversed()
                .thenComparingInt(Reservation::getIdReservation);
            List<Reservation> sortedReservations = new ArrayList<>(processingReservations);
            sortedReservations.sort(reservationComparator);
            List<Reservation> priorityReservations = new ArrayList<>();

            List<Voiture> availableCars = new ArrayList<>(cars);
            availableCars.sort(Comparator
                    .comparingInt(Voiture::getNombrePlace)
                    .reversed()
                    .thenComparingInt(Voiture::getId));
            List<Voiture> candidateCarsForGroup = new ArrayList<>();
            for (Voiture car : availableCars) {
                LocalDateTime availability = getCarAvailabilityTime(car, groupStart);
                LocalDateTime readyAt = carNextAvailable.get(car.getId());
                if (readyAt == null || (availability != null && availability.isAfter(readyAt))) {
                    readyAt = availability;
                    if (readyAt != null) {
                        carNextAvailable.put(car.getId(), readyAt);
                    }
                }
                if (isCarCandidateForGroup(readyAt, groupEnd)) {
                    candidateCarsForGroup.add(car);
                }
            }
            availableCars = candidateCarsForGroup;

            List<VehicleAssignmentPlan> plans = new ArrayList<>();
            List<Reservation> unassignedReservations = new ArrayList<>();
            List<LocalDateTime> selectedCarReadyTimes = new ArrayList<>();

            while (!priorityReservations.isEmpty() || !sortedReservations.isEmpty()) {
                boolean headIsPriority = !priorityReservations.isEmpty();
                Reservation headReservation = headIsPriority
                    ? priorityReservations.get(0)
                    : sortedReservations.get(0);
                int maxCapacity = getMaxCapacity(availableCars);
                int requiredSeats = headReservation.getNbrPassager();
                if (maxCapacity > 0 && requiredSeats > maxCapacity) {
                    requiredSeats = maxCapacity;
                }
                int selectedCarIndex = chooseCarIndexByPriority(
                        availableCars,
                        requiredSeats,
                        dieselConsommationIds,
                        tripCounts
                );

                if (selectedCarIndex < 0) {
                    unassignedReservations.add(headReservation);
                    if (headIsPriority) {
                        priorityReservations.remove(0);
                    } else {
                        sortedReservations.remove(0);
                    }
                    continue;
                }

                Voiture selectedCar = availableCars.get(selectedCarIndex);
                List<Reservation> selectedReservations = new ArrayList<>();
                if (headReservation.getNbrPassager() > selectedCar.getNombrePlace()) {
                    Reservation assignedPart = cloneReservationWithPassengers(headReservation, selectedCar.getNombrePlace());
                    Reservation remainingPart = cloneReservationWithPassengers(
                        headReservation,
                        headReservation.getNbrPassager() - selectedCar.getNombrePlace()
                    );
                    selectedReservations.add(assignedPart);
                    if (headIsPriority) {
                        priorityReservations.remove(0);
                    } else {
                        sortedReservations.remove(0);
                    }
                    priorityReservations.add(0, remainingPart);
                } else if (headIsPriority) {
                    priorityReservations.remove(0);
                    selectedReservations = buildReservationsForCarFromPriority(
                        priorityReservations,
                        sortedReservations,
                        headReservation,
                        selectedCar.getNombrePlace()
                    );
                } else {
                    sortedReservations.remove(0);
                    selectedReservations = buildReservationsForCarWithSplit(
                        sortedReservations,
                        priorityReservations,
                        headReservation,
                        selectedCar.getNombrePlace()
                    );
                }
                int usedSeats = countPassengers(selectedReservations);
                int remainingSeats = selectedCar.getNombrePlace() - usedSeats;

                VehicleAssignmentPlan selectedPlan = buildVehiclePlan(
                        distanceRepository,
                        selectedCar,
                        selectedReservations,
                        usedSeats,
                        remainingSeats,
                        vitesseMoyenne
                );

                plans.add(selectedPlan);
                if (selectedCar != null) {
                    int currentTrips = tripCounts != null ? tripCounts.getOrDefault(selectedCar.getId(), 0) : 0;
                    if (tripCounts != null) {
                        tripCounts.put(selectedCar.getId(), currentTrips + 1);
                    }
                }
                selectedCarReadyTimes.add(carNextAvailable.get(selectedCar.getId()));
                availableCars.remove(selectedCarIndex);
            }

            LocalDateTime groupDeparture = findGroupDepartureFromPlans(plans, selectedCarReadyTimes);
            plans = applyGroupDepartureToPlans(plans, groupDeparture);

            for (VehicleAssignmentPlan plan : plans) {
                if (plan.getDateRetourAeroport() != null) {
                    carNextAvailable.put(plan.getVoiture().getId(), plan.getDateRetourAeroport());
                } else if (groupDeparture != null) {
                    carNextAvailable.put(plan.getVoiture().getId(), groupDeparture);
                }
            }

            carryOverReservations = new ArrayList<>(unassignedReservations);

            results.add(new GroupAssignmentResult(
                    groupIndex + 1,
                    reservationIds,
                    carriedOverReservationIds,
                    plans,
                    unassignedReservations,
                    groupDeparture
            ));
        }

        return results;
    }

    private boolean isCarCandidateForGroup(LocalDateTime readyAt, LocalDateTime groupEnd) {
        if (readyAt == null || groupEnd == null) {
            return true;
        }
        return !readyAt.isAfter(groupEnd);
    }

    private LocalDateTime getCarAvailabilityTime(Voiture car, LocalDateTime groupStart) {
        if (car == null || groupStart == null) {
            return null;
        }
        java.time.LocalTime heureDisponibilite = car.getHeureDisponibilite();
        if (heureDisponibilite == null) {
            return null;
        }
        return java.time.LocalDateTime.of(groupStart.toLocalDate(), heureDisponibilite);
    }

    private int chooseCarIndexByPriority(
            List<Voiture> availableCars,
            int requiredSeats,
            Set<Integer> dieselConsommationIds,
            Map<Integer, Integer> tripCounts
    ) {
        if (availableCars == null || availableCars.isEmpty()) {
            return -1;
        }
        int minimalCapacity = Integer.MAX_VALUE;
        List<Integer> minimalCapacityIndexes = new ArrayList<>();
        for (int index = 0; index < availableCars.size(); index++) {
            Voiture car = availableCars.get(index);
            if (car.getNombrePlace() < requiredSeats) {
                continue;
            }

            if (car.getNombrePlace() < minimalCapacity) {
                minimalCapacity = car.getNombrePlace();
                minimalCapacityIndexes.clear();
                minimalCapacityIndexes.add(index);
            } else if (car.getNombrePlace() == minimalCapacity) {
                minimalCapacityIndexes.add(index);
            }
        }

        if (minimalCapacityIndexes.isEmpty()) {
            return -1;
        }

        int minTrips = Integer.MAX_VALUE;
        List<Integer> minTripIndexes = new ArrayList<>();
        for (int index : minimalCapacityIndexes) {
            Voiture car = availableCars.get(index);
            int trips = tripCounts != null ? tripCounts.getOrDefault(car.getId(), 0) : 0;
            if (trips < minTrips) {
                minTrips = trips;
                minTripIndexes.clear();
                minTripIndexes.add(index);
            } else if (trips == minTrips) {
                minTripIndexes.add(index);
            }
        }

        if (minTripIndexes.isEmpty()) {
            return -1;
        }

        List<Integer> dieselIndexes = new ArrayList<>();
        for (Integer candidateIndex : minTripIndexes) {
            Voiture candidate = availableCars.get(candidateIndex);
            if (dieselConsommationIds.contains(candidate.getIdConsommation())) {
                dieselIndexes.add(candidateIndex);
            }
        }

        List<Integer> pool = dieselIndexes.isEmpty() ? minTripIndexes : dieselIndexes;
        int randomIndex = ThreadLocalRandom.current().nextInt(pool.size());
        return pool.get(randomIndex);
    }

    private Map<Integer, Integer> loadTripCounts(List<Voiture> cars) {
        List<Integer> carIds = new ArrayList<>();
        if (cars != null) {
            for (Voiture car : cars) {
                if (car != null) {
                    carIds.add(car.getId());
                }
            }
        }
        return new AssignationRepository().countTripsByCarIds(carIds);
    }

    private Map<Integer, Integer> loadTripCountsForCars(List<Voiture> cars, LocalDate date) {
        List<Integer> carIds = new ArrayList<>();
        if (cars != null) {
            for (Voiture car : cars) {
                if (car != null) {
                    carIds.add(car.getId());
                }
            }
        }
        AssignationRepository repository = new AssignationRepository();
        return date != null
                ? repository.countTripsByCarIdsForDate(carIds, date)
                : repository.countTripsByCarIds(carIds);
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

    private LocalDateTime findGroupDepartureFromPlans(List<VehicleAssignmentPlan> plans, List<LocalDateTime> selectedCarReadyTimes) {
        LocalDateTime latestAssignedArrival = null;
        if (plans == null) {
            return null;
        }

        for (VehicleAssignmentPlan plan : plans) {
            if (plan == null || plan.getReservations() == null) {
                continue;
            }
            LocalDateTime latestPlanArrival = findLatestArrival(plan.getReservations());
            if (latestPlanArrival != null && (latestAssignedArrival == null || latestPlanArrival.isAfter(latestAssignedArrival))) {
                latestAssignedArrival = latestPlanArrival;
            }
        }

        LocalDateTime latestSelectedCarReady = null;
        if (selectedCarReadyTimes != null) {
            for (LocalDateTime readyAt : selectedCarReadyTimes) {
                if (readyAt != null && (latestSelectedCarReady == null || readyAt.isAfter(latestSelectedCarReady))) {
                    latestSelectedCarReady = readyAt;
                }
            }
        }

        if (latestAssignedArrival == null) {
            return latestSelectedCarReady;
        }
        if (latestSelectedCarReady == null) {
            return latestAssignedArrival;
        }
        return latestAssignedArrival.isAfter(latestSelectedCarReady) ? latestAssignedArrival : latestSelectedCarReady;
    }

    private List<VehicleAssignmentPlan> applyGroupDepartureToPlans(List<VehicleAssignmentPlan> plans, LocalDateTime groupDeparture) {
        List<VehicleAssignmentPlan> normalizedPlans = new ArrayList<>();
        if (plans == null) {
            return normalizedPlans;
        }

        for (VehicleAssignmentPlan plan : plans) {
            if (plan == null) {
                continue;
            }

            LocalDateTime dateRetour = null;
            if (groupDeparture != null && plan.getTotalKmTrajet() != null && plan.getVitesseMoyenne() != null && plan.getVitesseMoyenne() > 0.0) {
                long minutes = Math.round((plan.getTotalKmTrajet() / plan.getVitesseMoyenne()) * 60.0);
                dateRetour = groupDeparture.plusMinutes(minutes);
            }

            normalizedPlans.add(new VehicleAssignmentPlan(
                    plan.getVoiture(),
                    plan.getReservations(),
                    plan.getUsedSeats(),
                    plan.getRemainingSeats(),
                    groupDeparture,
                    plan.getTrajetOptimum(),
                    plan.getTotalKmTrajet(),
                    plan.getVitesseMoyenne(),
                    dateRetour
            ));
        }

        return normalizedPlans;
    }

    private List<Reservation> buildReservationsForCarWithSplit(
            List<Reservation> sortedReservations,
            List<Reservation> priorityReservations,
            Reservation headReservation,
            int carCapacity
    ) {
        List<Reservation> assignedReservations = new ArrayList<>();
        assignedReservations.add(headReservation);
        int usedSeats = headReservation.getNbrPassager();

        usedSeats = fillCarFromList(
            assignedReservations,
            sortedReservations,
            headReservation,
            carCapacity,
            priorityReservations,
            true,
            usedSeats
        );

        return assignedReservations;
    }

    private List<Reservation> buildReservationsForCarFromPriority(
            List<Reservation> priorityReservations,
            List<Reservation> sortedReservations,
            Reservation headReservation,
            int carCapacity
    ) {
        List<Reservation> assignedReservations = new ArrayList<>();
        assignedReservations.add(headReservation);
        int usedSeats = headReservation.getNbrPassager();

        usedSeats = fillCarFromList(
            assignedReservations,
            priorityReservations,
            headReservation,
            carCapacity,
            priorityReservations,
            false,
            usedSeats
        );

        usedSeats = fillCarFromList(
            assignedReservations,
            sortedReservations,
            headReservation,
            carCapacity,
            priorityReservations,
            true,
            usedSeats
        );

        return assignedReservations;
    }

    private int fillCarFromList(
            List<Reservation> assignedReservations,
            List<Reservation> sourceReservations,
            Reservation headReservation,
            int carCapacity,
            List<Reservation> priorityReservations,
            boolean remainderToPriority,
            int usedSeats
    ) {
        if (sourceReservations == null) {
            return usedSeats;
        }

        while (usedSeats < carCapacity && !sourceReservations.isEmpty()) {
            int remainingSeats = carCapacity - usedSeats;
            int bestIndex = -1;
            int bestDiff = Integer.MAX_VALUE;
            int bestPassengers = -1;

            for (int i = 0; i < sourceReservations.size(); i++) {
                Reservation candidate = sourceReservations.get(i);
                if (candidate == headReservation) {
                    continue;
                }
                int passengers = candidate.getNbrPassager();
                int diff = Math.abs(remainingSeats - passengers);
                if (diff < bestDiff || (diff == bestDiff && passengers > bestPassengers)) {
                    bestDiff = diff;
                    bestPassengers = passengers;
                    bestIndex = i;
                }
            }

            if (bestIndex < 0 || remainingSeats <= 0) {
                break;
            }

            Reservation candidate = sourceReservations.get(bestIndex);
            if (candidate.getNbrPassager() <= remainingSeats) {
                assignedReservations.add(candidate);
                usedSeats += candidate.getNbrPassager();
                sourceReservations.remove(bestIndex);
                continue;
            }

            Reservation assignedPart = cloneReservationWithPassengers(candidate, remainingSeats);
            Reservation remainingPart = cloneReservationWithPassengers(
                candidate,
                candidate.getNbrPassager() - remainingSeats
            );
            assignedReservations.add(assignedPart);
            sourceReservations.remove(bestIndex);
            if (remainderToPriority && priorityReservations != null) {
                priorityReservations.add(0, remainingPart);
            } else {
                sourceReservations.add(bestIndex, remainingPart);
            }
            usedSeats = carCapacity;
            break;
        }

        return usedSeats;
    }

    private int countPassengers(List<Reservation> reservations) {
        int total = 0;
        for (Reservation reservation : reservations) {
            total += reservation.getNbrPassager();
        }
        return total;
    }

    private Reservation cloneReservationWithPassengers(Reservation source, int passengers) {
        if (source == null) {
            return null;
        }
        return new Reservation(
                source.getIdReservation(),
                source.getDateArriver(),
                passengers,
                source.getIdClient(),
                source.getIdHotel(),
                source.getIdAeroport()
        );
    }

    private int getMaxCapacity(List<Voiture> cars) {
        int max = 0;
        if (cars == null) {
            return max;
        }
        for (Voiture car : cars) {
            if (car != null && car.getNombrePlace() > max) {
                max = car.getNombrePlace();
            }
        }
        return max;
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
                String trimmed = token.trim();
                int assignedCount = -1;
                String idToken = trimmed;
                if (trimmed.contains(":")) {
                    String[] parts = trimmed.split(":");
                    if (parts.length >= 2) {
                        idToken = parts[0];
                        assignedCount = Integer.parseInt(parts[1]);
                    }
                }
                int idReservation = Integer.parseInt(idToken.trim());
                if (assignedReservationIds.contains(idReservation)) {
                    skipped++;
                    continue;
                }
                Reservation reservation = reservationRepository.findById(idReservation);
                if (reservation == null) {
                    skipped++;
                    continue;
                }
                if (assignedCount <= 0) {
                    assignedCount = reservation.getNbrPassager();
                }
                if (assignedCount > reservation.getNbrPassager()) {
                    skipped++;
                    continue;
                }
                if (assignedCount < reservation.getNbrPassager()) {
                    int remaining = reservation.getNbrPassager() - assignedCount;
                    reservationRepository.updatePassengers(idReservation, remaining);
                    Reservation assignedReservation = new Reservation(
                            0,
                            reservation.getDateArriver(),
                            assignedCount,
                            reservation.getIdClient(),
                            reservation.getIdHotel(),
                            reservation.getIdAeroport()
                    );
                    int newId = reservationRepository.insertAndReturnId(assignedReservation);
                    if (newId <= 0) {
                        skipped++;
                        continue;
                    }
                    assignedReservation.setIdReservation(newId);
                    reservationsToAssign.add(assignedReservation);
                } else {
                    reservationsToAssign.add(reservation);
                }
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

    Double distanceTotale = plan.getTotalKmTrajet();

    for (Reservation reservation : reservationsToAssign) {
        assignationRepository.insert(new Assignation(0,
            reservation.getIdReservation(),
            voitureId,
            debutTrajet,
            finTrajet,
            distanceTotale));
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
