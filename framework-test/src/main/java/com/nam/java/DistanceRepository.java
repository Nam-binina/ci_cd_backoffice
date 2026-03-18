package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Repository d'accès aux distances utilisées par la logique d'assignation.
 *
 * <p>Utilisation typique :</p>
 * <pre>
 *     DistanceRepository repository = new DistanceRepository();
 *     Double kmAeroport = repository.findAeroportHotelDistance(idHotel, idAeroport);
 *     Double kmEntreHotels = repository.findHotelHotelDistance(hotelA, hotelB);
 * </pre>
 *
 * <p>Les méthodes retournent {@code null} si aucune distance n'est trouvée.</p>
 */
public class DistanceRepository {

    public static class OptimalPathResult {
        private final List<Integer> hotelOrder;
        private final Double totalDistanceKm;
        private final String errorMessage;

        public OptimalPathResult(List<Integer> hotelOrder, Double totalDistanceKm, String errorMessage) {
            this.hotelOrder = hotelOrder;
            this.totalDistanceKm = totalDistanceKm;
            this.errorMessage = errorMessage;
        }

        public List<Integer> getHotelOrder() {
            return hotelOrder;
        }

        public Double getTotalDistanceKm() {
            return totalDistanceKm;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public boolean hasError() {
            return errorMessage != null && !errorMessage.trim().isEmpty();
        }
    }

    /**
     * Récupère la distance (en km) entre un hôtel et un aéroport.
     *
     * @param idHotel identifiant de l'hôtel
     * @param idAeroport identifiant de l'aéroport
     * @return la distance en km, ou {@code null} si aucune ligne ne correspond
     * @throws RuntimeException si une erreur SQL survient
     */
    public Double findAeroportHotelDistance(int idHotel, int idAeroport) {
        String sql = "SELECT km FROM hotel_aeroport_distance WHERE id_hotel = ? AND id_aeroport = ? LIMIT 1";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idHotel);
            ps.setInt(2, idAeroport);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return rs.getDouble("km");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de la distance hôtel-aéroport", e);
        }
    }

    /**
     * Récupère la distance (en km) entre deux hôtels.
     *
     * <p>La recherche est symétrique : (A -> B) ou (B -> A).</p>
     *
     * @param fromHotelId identifiant du premier hôtel
     * @param toHotelId identifiant du second hôtel
     * @return la distance en km, ou {@code null} si aucune ligne ne correspond
     * @throws RuntimeException si une erreur SQL survient
     */
    public Double findHotelHotelDistance(int fromHotelId, int toHotelId) {
        String sql = "SELECT km FROM hotel_hotel_distance " +
                "WHERE (from_hotel_id = ? AND to_hotel_id = ?) " +
                "   OR (from_hotel_id = ? AND to_hotel_id = ?) " +
                "LIMIT 1";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, fromHotelId);
            ps.setInt(2, toHotelId);
            ps.setInt(3, toHotelId);
            ps.setInt(4, fromHotelId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return rs.getDouble("km");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de la distance hôtel-hôtel", e);
        }
    }

    /**
     * Calcule le plus court chemin (distance minimale) depuis un avion/aéroport
     * vers une liste d'hôtels à visiter une seule fois chacun.
     *
     * @param idAvion identifiant avion (correspond à l'ID aéroport utilisé par les distances)
     * @param hotelIds liste des hôtels à visiter
     * @return résultat contenant l'ordre optimal des hôtels et la distance totale
     */
    public OptimalPathResult findOptimalShortestPath(int idAvion, List<Integer> hotelIds) {
        if (hotelIds == null || hotelIds.isEmpty()) {
            return new OptimalPathResult(new ArrayList<>(), 0.0, null);
        }

        Set<Integer> uniqueHotels = new LinkedHashSet<>(hotelIds);
        List<Integer> hotelsToVisit = new ArrayList<>(uniqueHotels);

        Map<String, Double> airportHotelCache = new HashMap<>();
        Map<String, Double> hotelHotelCache = new HashMap<>();

        List<Integer> currentPath = new ArrayList<>();
        boolean[] used = new boolean[hotelsToVisit.size()];

        double[] bestDistance = new double[] { Double.POSITIVE_INFINITY };
        @SuppressWarnings("unchecked")
        List<Integer>[] bestPath = new List[] { null };

        searchOptimalPath(
                idAvion,
                hotelsToVisit,
                used,
                currentPath,
                0.0,
                bestDistance,
                bestPath,
                airportHotelCache,
                hotelHotelCache
        );

        if (bestPath[0] == null) {
            return new OptimalPathResult(
                    new ArrayList<>(),
                    null,
                    "Aucun chemin valide trouvé (distance manquante entre certains points)."
            );
        }

        return new OptimalPathResult(bestPath[0], bestDistance[0], null);
    }

    private void searchOptimalPath(
            int idAvion,
            List<Integer> hotelsToVisit,
            boolean[] used,
            List<Integer> currentPath,
            double currentDistance,
            double[] bestDistance,
            List<Integer>[] bestPath,
            Map<String, Double> airportHotelCache,
            Map<String, Double> hotelHotelCache
    ) {
        if (currentPath.size() == hotelsToVisit.size()) {
            int lastHotelId = currentPath.get(currentPath.size() - 1);
            Double backToAirportDistance = getAirportHotelDistanceCached(idAvion, lastHotelId, airportHotelCache);
            if (backToAirportDistance == null) {
                return;
            }

            double totalDistanceWithReturn = currentDistance + backToAirportDistance;
            if (totalDistanceWithReturn < bestDistance[0]) {
                bestDistance[0] = totalDistanceWithReturn;
                bestPath[0] = new ArrayList<>(currentPath);
            }
            return;
        }

        for (int i = 0; i < hotelsToVisit.size(); i++) {
            if (used[i]) {
                continue;
            }

            int nextHotelId = hotelsToVisit.get(i);
            Double stepDistance;

            if (currentPath.isEmpty()) {
                stepDistance = getAirportHotelDistanceCached(idAvion, nextHotelId, airportHotelCache);
            } else {
                int currentHotelId = currentPath.get(currentPath.size() - 1);
                stepDistance = getHotelHotelDistanceCached(currentHotelId, nextHotelId, hotelHotelCache);
            }

            if (stepDistance == null) {
                continue;
            }

            double newDistance = currentDistance + stepDistance;
            if (newDistance >= bestDistance[0]) {
                continue;
            }

            used[i] = true;
            currentPath.add(nextHotelId);

            searchOptimalPath(
                    idAvion,
                    hotelsToVisit,
                    used,
                    currentPath,
                    newDistance,
                    bestDistance,
                    bestPath,
                    airportHotelCache,
                    hotelHotelCache
            );

            currentPath.remove(currentPath.size() - 1);
            used[i] = false;
        }
    }

    private Double getAirportHotelDistanceCached(int idAeroport, int idHotel, Map<String, Double> cache) {
        String key = idAeroport + "->" + idHotel;
        if (cache.containsKey(key)) {
            return cache.get(key);
        }
        Double km = findAeroportHotelDistance(idHotel, idAeroport);
        cache.put(key, km);
        return km;
    }

    private Double getHotelHotelDistanceCached(int fromHotelId, int toHotelId, Map<String, Double> cache) {
        int minId = Math.min(fromHotelId, toHotelId);
        int maxId = Math.max(fromHotelId, toHotelId);
        String key = minId + "<->" + maxId;
        if (cache.containsKey(key)) {
            return cache.get(key);
        }
        Double km = findHotelHotelDistance(fromHotelId, toHotelId);
        cache.put(key, km);
        return km;
    }
}
