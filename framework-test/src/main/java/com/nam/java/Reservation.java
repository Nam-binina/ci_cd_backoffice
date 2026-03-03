package com.nam.java;

import java.time.LocalDateTime;

public class Reservation {
    private int idReservation;
    private LocalDateTime dateArriver;
    private int nbrPassager;
    private String idClient;
    private int idHotel;
    private int idAeroport;
    private int ta;

    public Reservation() {
    }

    public Reservation(int idReservation, LocalDateTime dateArriver, int nbrPassager, String idClient, int idHotel) {
        this(idReservation, dateArriver, nbrPassager, idClient, idHotel, 0, 0);
    }

    public Reservation(int idReservation, LocalDateTime dateArriver, int nbrPassager, String idClient, int idHotel, int ta) {
        this(idReservation, dateArriver, nbrPassager, idClient, idHotel, 0, ta);
    }

    public Reservation(int idReservation, LocalDateTime dateArriver, int nbrPassager, String idClient, int idHotel, int idAeroport, int ta) {
        this.idReservation = idReservation;
        this.dateArriver = dateArriver;
        this.nbrPassager = nbrPassager;
        this.idClient = idClient;
        this.idHotel = idHotel;
        this.idAeroport = idAeroport;
        this.ta = ta;
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

    public int getIdAeroport() {
        return idAeroport;
    }

    public void setIdAeroport(int idAeroport) {
        this.idAeroport = idAeroport;
    }

    public int getTa() {
        return ta;
    }

    public void setTa(int ta) {
        this.ta = ta;
    }

    @Override
    public String toString() {
        return "Reservation{idReservation=" + idReservation + ", dateArriver=" + dateArriver +
                ", nbrPassager=" + nbrPassager + ", idClient='" + idClient + "', idHotel=" + idHotel +
                ", idAeroport=" + idAeroport +
                ", ta=" + ta + "}";
    }
}
