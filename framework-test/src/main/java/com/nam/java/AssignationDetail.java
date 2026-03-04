package com.nam.java;

public class AssignationDetail {
    private int id;
    private Reservation reservation;
    private Voiture voiture;

    public AssignationDetail(int id, Reservation reservation, Voiture voiture) {
        this.id = id;
        this.reservation = reservation;
        this.voiture = voiture;
    }

    public int getId() {
        return id;
    }

    public Reservation getReservation() {
        return reservation;
    }

    public Voiture getVoiture() {
        return voiture;
    }
}
