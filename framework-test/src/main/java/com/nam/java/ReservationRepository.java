package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ReservationRepository {

    public List<Reservation> findAll() {
        String sql = "SELECT Id_reservation, date_arriver, nbr_passager, id_client, Id_hotel FROM reservation ORDER BY Id_reservation DESC";
        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("Id_reservation");
                Timestamp ts = rs.getTimestamp("date_arriver");
                LocalDateTime dateArriver = (ts != null) ? ts.toLocalDateTime() : null;
                int nbrPassager = rs.getInt("nbr_passager");
                String idClient = rs.getString("id_client");
                int idHotel = rs.getInt("Id_hotel");
                reservations.add(new Reservation(id, dateArriver, nbrPassager, idClient, idHotel));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des réservations", e);
        }

        return reservations;
    }

    public void insert(Reservation reservation) {
        String sql = "INSERT INTO reservation(date_arriver, nbr_passager, id_client, Id_hotel) VALUES (?,?,?,?)";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, reservation.getDateArriver() != null
                    ? Timestamp.valueOf(reservation.getDateArriver())
                    : null);
            ps.setInt(2, reservation.getNbrPassager());
            ps.setString(3, reservation.getIdClient());
            ps.setInt(4, reservation.getIdHotel());

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'insertion de la réservation", e);
        }
    }
}
