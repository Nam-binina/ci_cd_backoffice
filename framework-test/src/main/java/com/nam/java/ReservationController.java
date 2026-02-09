package com.nam.java;

import java.time.LocalDateTime;
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

        if (idClient == null || idClient.trim().isEmpty()) {
            mv.addItem("error", "Identifiant client requis");
            mv.setJspName("reservationForm");
            return mv;
        }

        try {
            LocalDateTime date = LocalDateTime.parse(dateArriver);
            Reservation reservation = new Reservation(0, date, nbrPassager, idClient, idHotel);
            new ReservationRepository().insert(reservation);

            List<Reservation> reservations = new ReservationRepository().findAll();
            mv.addItem("reservations", reservations);
            mv.setJspName("reservationList");
            return mv;
        } catch (DateTimeParseException e) {
            mv.addItem("error", "Format de date invalide");
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
        mv.addItem("reservations", reservations);
        mv.addItem("count", reservations.size());
        return mv;
    }
}
