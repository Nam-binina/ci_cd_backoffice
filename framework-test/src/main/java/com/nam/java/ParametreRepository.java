package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ParametreRepository {

    public Parametre getCurrent() {
        String sql = "SELECT Id_parametre, vitesse_moyenne, temps_attente FROM parametre ORDER BY Id_parametre DESC LIMIT 1";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (!rs.next()) {
                return null;
            }

            return new Parametre(
                    rs.getInt("Id_parametre"),
                    rs.getDouble("vitesse_moyenne"),
                    rs.getInt("temps_attente")
            );
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des paramètres", e);
        }
    }
}
