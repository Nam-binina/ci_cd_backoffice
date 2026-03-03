package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
}
