package com.nam.java.repository;

import com.nam.java.model.Hotel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HotelRepository {

    public List<Hotel> findAll() {
        String sql = "SELECT Id_hotel, nom FROM hotel ORDER BY Id_hotel";
        List<Hotel> hotels = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("Id_hotel");
                String nom = rs.getString("nom");
                hotels.add(new Hotel(id, nom));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des hôtels", e);
        }

        return hotels;
    }
}
