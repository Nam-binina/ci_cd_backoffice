package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Repository d'accès aux voitures pour proposer un véhicule adapté
 * au nombre de passagers d'une assignation.
 */
public class VoitureRepository {

    public List<Voiture> findAllOrderBySeatsAsc() {
        String sql = "SELECT id, immatriculation, nombre_place, id_consommation " +
                "FROM voiture " +
                "ORDER BY nombre_place ASC, id ASC";

        List<Voiture> voitures = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                voitures.add(new Voiture(
                        rs.getInt("id"),
                        rs.getString("immatriculation"),
                        rs.getInt("nombre_place"),
                        rs.getInt("id_consommation"),
                        0
                ));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des voitures", e);
        }

        return voitures;
    }

    public Voiture findById(int id) {
        String sql = "SELECT id, immatriculation, nombre_place, id_consommation " +
                "FROM voiture " +
                "WHERE id = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
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
            throw new RuntimeException("Erreur lors du chargement de la voiture", e);
        }
    }

    /**
     * Retourne toutes les voitures ayant la capacité minimale suffisante.
     *
     * <p>Exemple : si {@code requiredSeats = 7}, la méthode cherche les voitures
     * de 7 places (si elles existent), sinon 8, 9, etc.</p>
     *
     * @param requiredSeats nombre de places nécessaires
     * @return liste des voitures correspondant à la capacité minimale requise
     * @throws RuntimeException si une erreur SQL survient
     */
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

    /**
     * Retourne une seule voiture optimale pour le nombre de places demandé.
     *
     * <p>La priorité est :</p>
     * <ol>
     *   <li>capacité minimale suffisante,</li>
     *   <li>type Diesel en priorité si disponible,</li>
     *   <li>choix aléatoire en cas d'égalité.</li>
     * </ol>
     *
     * @param requiredSeats nombre de places nécessaires
     * @return voiture retenue, ou {@code null} si aucune voiture n'est disponible
     * @throws RuntimeException si une erreur SQL survient
     */
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

    public Set<Integer> findDieselConsommationIds() {
        String sql = "SELECT id FROM consommation WHERE LOWER(description) = 'diesel'";
        Set<Integer> dieselIds = new HashSet<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                dieselIds.add(rs.getInt("id"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des consommations Diesel", e);
        }

        return dieselIds;
    }
}
