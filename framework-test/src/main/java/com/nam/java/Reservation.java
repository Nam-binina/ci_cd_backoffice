package com.nam.java;

import java.time.LocalDateTime;

public class Reservation {
    private int idReservation;
    private LocalDateTime dateArriver;
    private int nbrPassager;
    private String idClient;
    private int idHotel;

    public Reservation() {
    }

    public Reservation(int idReservation, LocalDateTime dateArriver, int nbrPassager, String idClient, int idHotel) {
        this.idReservation = idReservation;
        this.dateArriver = dateArriver;
        this.nbrPassager = nbrPassager;
        this.idClient = idClient;
        this.idHotel = idHotel;
    }

    public int getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(int idReservation) {
        this.idReservation = idReservation;
    }

    public LocalDateTime getDateArriver() {
        return dateArriver;
    }

    public void setDateArriver(LocalDateTime dateArriver) {
        this.dateArriver = dateArriver;
    }

    public int getNbrPassager() {
        return nbrPassager;
    }

    public void setNbrPassager(int nbrPassager) {
        this.nbrPassager = nbrPassager;
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public int getIdHotel() {
        return idHotel;
    }

    public void setIdHotel(int idHotel) {
        this.idHotel = idHotel;
    }

    @Override
    public String toString() {
        return "Reservation{idReservation=" + idReservation + ", dateArriver=" + dateArriver +
                ", nbrPassager=" + nbrPassager + ", idClient='" + idClient + "', idHotel=" + idHotel + "}";
    }
}
