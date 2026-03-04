package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VoitureRepository {

    public List<Voiture> findClosestByRequiredSeats(int requiredSeats) {
    String sql = "SELECT id, immatriculation, nombre_place, id_consommation " +
                "FROM voiture " +
                "WHERE nombre_place >= ? " +
                "AND nombre_place = (SELECT MIN(nombre_place) FROM voiture WHERE nombre_place >= ?) " +
                "ORDER BY id ASC";

        List<Voiture> voitures = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requiredSeats);
            ps.setInt(2, requiredSeats);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
            voitures.add(new Voiture(
                rs.getInt("id"),
                rs.getString("immatriculation"),
                rs.getInt("nombre_place"),
                rs.getInt("id_consommation"),
                0
            ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des voitures proposées", e);
        }

        return voitures;
    }

    public Voiture findBestByRequiredSeats(int requiredSeats) {
    String sql = "SELECT v.id, v.immatriculation, v.nombre_place, v.id_consommation " +
                "FROM voiture v " +
                "JOIN consommation c ON c.id = v.id_consommation " +
                "WHERE v.nombre_place >= ? " +
                "AND v.nombre_place = (SELECT MIN(nombre_place) FROM voiture WHERE nombre_place >= ?) " +
                "ORDER BY CASE WHEN LOWER(c.description) = 'diesel' THEN 0 ELSE 1 END, RAND() " +
                "LIMIT 1";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requiredSeats);
            ps.setInt(2, requiredSeats);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

        return new Voiture(
            rs.getInt("id"),
            rs.getString("immatriculation"),
            rs.getInt("nombre_place"),
            rs.getInt("id_consommation"),
            0
        );
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la sélection de la meilleure voiture", e);
        }
    }
}
