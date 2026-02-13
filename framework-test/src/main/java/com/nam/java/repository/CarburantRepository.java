package com.nam.java.repository;

import com.nam.java.model.Carburant;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CarburantRepository {

    public List<Carburant> findAll() {
        String sql = "SELECT Id_carburant, nom FROM carburant ORDER BY Id_carburant";
        List<Carburant> carburants = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                carburants.add(new Carburant(rs.getInt("Id_carburant"), rs.getString("nom")));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des carburants", e);
        }

        return carburants;
    }
}
