package com.nam.java.repository;

import com.nam.java.model.Vehicule;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VehiculeRepository {

    public List<Vehicule> findAll() {
        String sql = "SELECT Id_vehicule, capacite, Id_carburant FROM vehicule ORDER BY Id_vehicule DESC";
        List<Vehicule> vehicules = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                vehicules.add(new Vehicule(
                        rs.getInt("Id_vehicule"),
                        rs.getInt("capacite"),
                        rs.getInt("Id_carburant")
                ));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des véhicules", e);
        }

        return vehicules;
    }

    public Vehicule findById(int idVehicule) {
        String sql = "SELECT Id_vehicule, capacite, Id_carburant FROM vehicule WHERE Id_vehicule = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idVehicule);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Vehicule(
                            rs.getInt("Id_vehicule"),
                            rs.getInt("capacite"),
                            rs.getInt("Id_carburant")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement du véhicule", e);
        }

        return null;
    }

    public void insert(Vehicule vehicule) {
        String sql = "INSERT INTO vehicule (capacite, Id_carburant) VALUES (?, ?)";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vehicule.getCapacite());
            ps.setInt(2, vehicule.getIdCarburant());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion du véhicule : " + e.getMessage(), e);
        }
    }

    public void update(Vehicule vehicule) {
        String sql = "UPDATE vehicule SET capacite = ?, Id_carburant = ? WHERE Id_vehicule = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vehicule.getCapacite());
            ps.setInt(2, vehicule.getIdCarburant());
            ps.setInt(3, vehicule.getIdVehicule());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du véhicule : " + e.getMessage(), e);
        }
    }

    public void delete(int idVehicule) {
        String sql = "DELETE FROM vehicule WHERE Id_vehicule = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idVehicule);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du véhicule : " + e.getMessage(), e);
        }
    }
}
