package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AssignationRepository {

    public void insert(Assignation assignation) {
        String sql = "INSERT INTO assignation (id_reservation, id_voiture) VALUES (?, ?)";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assignation.getIdReservation());
            ps.setInt(2, assignation.getIdVoiture());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion de l'assignation : " + e.getMessage(), e);
        }
    }

    public List<Assignation> findAll() {
        String sql = "SELECT id, id_reservation, id_voiture FROM assignation ORDER BY id DESC";
        List<Assignation> assignations = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                int idReservation = rs.getInt("id_reservation");
                int idVoiture = rs.getInt("id_voiture");
                assignations.add(new Assignation(id, idReservation, idVoiture));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des assignations", e);
        }

        return assignations;
    }

    public java.util.Set<Integer> findAssignedReservationIds() {
        String sql = "SELECT DISTINCT id_reservation FROM assignation";
        java.util.Set<Integer> assignedReservationIds = new java.util.HashSet<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                assignedReservationIds.add(rs.getInt("id_reservation"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des réservations déjà assignées", e);
        }

        return assignedReservationIds;
    }

    public List<AssignationDetail> findAssignedByDate(LocalDate date) {
    String sql = "SELECT a.id AS assignation_id, " +
        "r.Id_reservation, r.date_arriver, r.nbr_passager, r.id_client, r.Id_hotel, " +
        "IFNULL(r.id_aeroport, 0) AS id_aeroport, " +
        "IFNULL((SELECT p.temps_attente FROM parametre p ORDER BY p.Id_parametre DESC LIMIT 1), 0) AS TA, " +
        "v.id AS voiture_id, v.immatriculation, v.nombre_place, v.id_consommation, " +
        "IFNULL((SELECT p.vitesse_moyenne FROM parametre p ORDER BY p.Id_parametre DESC LIMIT 1), 0) AS vitesse_moyenne " +
        "FROM assignation a " +
        "JOIN reservation r ON r.Id_reservation = a.id_reservation " +
        "JOIN voiture v ON v.id = a.id_voiture " +
        "WHERE DATE(r.date_arriver) = ? " +
        "ORDER BY r.date_arriver ASC, r.Id_reservation ASC";

        List<AssignationDetail> details = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(date));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LocalDateTime dateArriver = rs.getObject("date_arriver", LocalDateTime.class);
                    Reservation reservation = new Reservation(
                            rs.getInt("Id_reservation"),
                            dateArriver,
                            rs.getInt("nbr_passager"),
                            rs.getString("id_client"),
                            rs.getInt("Id_hotel"),
                            rs.getInt("id_aeroport"),
                            rs.getInt("TA")
                    );

                    Voiture voiture = new Voiture(
                            rs.getInt("voiture_id"),
                            rs.getString("immatriculation"),
                            rs.getInt("nombre_place"),
                            rs.getInt("id_consommation"),
                            rs.getDouble("vitesse_moyenne")
                    );

                    details.add(new AssignationDetail(rs.getInt("assignation_id"), reservation, voiture));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des assignations par date", e);
        }

        return details;
    }
}
