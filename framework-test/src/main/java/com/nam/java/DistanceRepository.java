package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DistanceRepository {

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
}
