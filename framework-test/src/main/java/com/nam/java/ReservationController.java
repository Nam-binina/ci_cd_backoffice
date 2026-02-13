package com.nam.java;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

@MyAnnotation(value = "/reservation", method = HttpMethod.CONTROLLER)
public class ReservationController {

    @MyAnnotation(value = "/form", method = HttpMethod.GET)
    public ModelView showForm() {
        ModelView mv = new ModelView();
        try {
            List<Hotel> hotels = new HotelRepository().findAll();
            mv.addItem("hotels", hotels);
        } catch (Exception e) {
            mv.addItem("error", e.getMessage());
        }
        mv.setJspName("reservationForm");
        return mv;
    }

    @MyAnnotation(value = "/insert", method = HttpMethod.POST)
    public ModelView insert(
            @MyParam("dateArriver") String dateArriver,
            @MyParam("nbrPassager") int nbrPassager,
            @MyParam("idClient") String idClient,
            @MyParam("idHotel") int idHotel
    ) {
        ModelView mv = new ModelView();

        if (idHotel <= 0) {
            mv.addItem("error", "Sélectionne un hôtel valide");
            mv.setJspName("reservationForm");
            return mv;
        }

        if (idClient == null || idClient.trim().isEmpty()) {
            mv.addItem("error", "Identifiant client requis");
            mv.setJspName("reservationForm");
            return mv;
        }

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime date = LocalDateTime.parse(dateArriver, formatter);
            Reservation reservation = new Reservation(0, date, nbrPassager, idClient, idHotel);
            new ReservationRepository().insert(reservation);

            List<Reservation> reservations = new ReservationRepository().findAll();
            mv.addItem("reservations", reservations);
            mv.setJspName("reservationList");
            return mv;
        } catch (DateTimeParseException e) {
            mv.addItem("error", "Format de date invalide (ex: 2026-02-09T14:30)");
        } catch (Exception e) {
            mv.addItem("error", e.getMessage());
        }

        mv.addItem("dateArriver", dateArriver);
        mv.addItem("nbrPassager", nbrPassager);
        mv.addItem("idClient", idClient);
        mv.addItem("idHotel", idHotel);
        mv.setJspName("reservationForm");
        return mv;
    }

    @MyAnnotation(value = "/list", method = HttpMethod.GET)
    public ModelView list() {
        ModelView mv = new ModelView();
        List<Reservation> reservations = new ReservationRepository().findAll();
        mv.addItem("reservations", reservations);
        mv.setJspName("reservationList");
        return mv;
    }

    @MyAnnotation(value = "/api", method = HttpMethod.GET)
    @JsonAnnotation
    public ModelView api() {
        ModelView mv = new ModelView();
        List<Reservation> reservations = new ReservationRepository().findAll();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        List<java.util.Map<String, Object>> payload = new java.util.ArrayList<>();
        for (Reservation reservation : reservations) {
            java.util.Map<String, Object> item = new java.util.HashMap<>();
            item.put("Id_reservation", reservation.getIdReservation());
            item.put("date_arriver", reservation.getDateArriver() != null
                    ? formatter.format(reservation.getDateArriver())
                    : null);
            item.put("nbr_passager", reservation.getNbrPassager());
            item.put("id_client", reservation.getIdClient());
            item.put("Id_hotel", reservation.getIdHotel());
            payload.add(item);
        }

        mv.addItem("reservations", payload);
        mv.addItem("count", reservations.size());
        mv.addItem("status", 200);
        return mv;
    }
}
