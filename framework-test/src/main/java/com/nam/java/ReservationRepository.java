package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ReservationRepository {

    public List<Reservation> findAll() {
    String sql = "SELECT Id_reservation, date_arriver, nbr_passager, id_client, Id_hotel, IFNULL(id_aeroport, 0) AS id_aeroport FROM reservation ORDER BY Id_reservation DESC";
        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("Id_reservation");
                LocalDateTime dateArriver = rs.getObject("date_arriver", LocalDateTime.class);
                int nbrPassager = rs.getInt("nbr_passager");
                String idClient = rs.getString("id_client");
                int idHotel = rs.getInt("Id_hotel");
                int idAeroport = rs.getInt("id_aeroport");
                reservations.add(new Reservation(id, dateArriver, nbrPassager, idClient, idHotel, idAeroport));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des réservations", e);
        }

        return reservations;
    }

    public void insert(Reservation reservation) {
        insertInternal(reservation, false);
    }

    public int insertAndReturnId(Reservation reservation) {
        return insertInternal(reservation, true);
    }

    public void updatePassengers(int reservationId, int passengers) {
        String sql = "UPDATE reservation SET nbr_passager = ? WHERE Id_reservation = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, passengers);
            ps.setInt(2, reservationId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise a jour des passagers : " + e.getMessage(), e);
        }
    }

    private int insertInternal(Reservation reservation, boolean returnId) {
        String sqlWithAeroport = "INSERT INTO reservation(date_arriver, nbr_passager, id_client, Id_hotel, id_aeroport) VALUES (?,?,?,?,?)";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     sqlWithAeroport,
                     returnId ? Statement.RETURN_GENERATED_KEYS : Statement.NO_GENERATED_KEYS)) {

            ps.setObject(1, reservation.getDateArriver());
            ps.setInt(2, reservation.getNbrPassager());
            ps.setString(3, reservation.getIdClient());
            ps.setInt(4, reservation.getIdHotel());
            ps.setInt(5, reservation.getIdAeroport());

            ps.executeUpdate();
            if (!returnId) {
                return 0;
            }
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
        } catch (SQLException e) {
            if (e.getMessage() == null || !e.getMessage().toLowerCase().contains("id_aeroport")) {
                throw new RuntimeException("Erreur lors de l'insertion de la réservation : " + e.getMessage(), e);
            }
        }

        String sqlFallback = "INSERT INTO reservation(date_arriver, nbr_passager, id_client, Id_hotel) VALUES (?,?,?,?)";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     sqlFallback,
                     returnId ? Statement.RETURN_GENERATED_KEYS : Statement.NO_GENERATED_KEYS)) {

            ps.setObject(1, reservation.getDateArriver());
            ps.setInt(2, reservation.getNbrPassager());
            ps.setString(3, reservation.getIdClient());
            ps.setInt(4, reservation.getIdHotel());

            ps.executeUpdate();
            if (!returnId) {
                return 0;
            }
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion de la réservation : " + e.getMessage(), e);
        }
    }
    public List<Reservation> findNotAssigned() {
    String sql = "SELECT r.Id_reservation, r.date_arriver, r.nbr_passager, r.id_client, r.Id_hotel, IFNULL(r.id_aeroport, 0) AS id_aeroport " +
                "FROM reservation r " +
                "LEFT JOIN assignation a ON a.id_reservation = r.Id_reservation " +
                "WHERE a.id IS NULL " +
                "ORDER BY r.Id_reservation DESC";

        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("Id_reservation");
                LocalDateTime dateArriver = rs.getObject("date_arriver", LocalDateTime.class);
                int nbrPassager = rs.getInt("nbr_passager");
                String idClient = rs.getString("id_client");
                int idHotel = rs.getInt("Id_hotel");
                int idAeroport = rs.getInt("id_aeroport");
                reservations.add(new Reservation(id, dateArriver, nbrPassager, idClient, idHotel, idAeroport));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des réservations non assignées", e);
        }

        return reservations;
    }

    public Reservation findById(int idReservation) {
    String sql = "SELECT Id_reservation, date_arriver, nbr_passager, id_client, Id_hotel, IFNULL(id_aeroport, 0) AS id_aeroport " +
                "FROM reservation WHERE Id_reservation = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idReservation);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                LocalDateTime dateArriver = rs.getObject("date_arriver", LocalDateTime.class);
                return new Reservation(
                        rs.getInt("Id_reservation"),
                        dateArriver,
                        rs.getInt("nbr_passager"),
                        rs.getString("id_client"),
                        rs.getInt("Id_hotel"),
                    rs.getInt("id_aeroport")
                );
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de la réservation", e);
        }
    }

    public List<Reservation> findOverlappingForSelectedDeparture(int selectedReservationId) {
        String sql = "SELECT r2.Id_reservation, r2.date_arriver, r2.nbr_passager, r2.id_client, r2.Id_hotel, IFNULL(r2.id_aeroport, 0) AS id_aeroport " +
                "FROM reservation r1 " +
                "JOIN reservation r2 ON r1.date_arriver BETWEEN r2.date_arriver AND DATE_ADD(r2.date_arriver, INTERVAL IFNULL((SELECT p.temps_attente FROM parametre p ORDER BY p.Id_parametre DESC LIMIT 1), 0) MINUTE) " +
            "AND IFNULL(r1.id_aeroport, -1) = IFNULL(r2.id_aeroport, -1) " +
                "WHERE r1.Id_reservation = ? " +
                "ORDER BY r2.date_arriver ASC, r2.Id_reservation ASC";

        List<Reservation> overlaps = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, selectedReservationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LocalDateTime dateArriver = rs.getObject("date_arriver", LocalDateTime.class);
                    overlaps.add(new Reservation(
                            rs.getInt("Id_reservation"),
                            dateArriver,
                            rs.getInt("nbr_passager"),
                            rs.getString("id_client"),
                            rs.getInt("Id_hotel"),
                            rs.getInt("id_aeroport")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du calcul des réservations chevauchantes", e);
        }

        return overlaps;
    }

    public List<Reservation> findByDate(LocalDate targetDate) {
        String sql = "SELECT Id_reservation, date_arriver, nbr_passager, id_client, Id_hotel, IFNULL(id_aeroport, 0) AS id_aeroport " +
                "FROM reservation " +
                "WHERE DATE(date_arriver) = ? " +
                "ORDER BY date_arriver ASC, Id_reservation ASC";

        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, targetDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LocalDateTime dateArriver = rs.getObject("date_arriver", LocalDateTime.class);
                    reservations.add(new Reservation(
                            rs.getInt("Id_reservation"),
                            dateArriver,
                            rs.getInt("nbr_passager"),
                            rs.getString("id_client"),
                            rs.getInt("Id_hotel"),
                            rs.getInt("id_aeroport")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des réservations par date", e);
        }

        return reservations;
    }
}
