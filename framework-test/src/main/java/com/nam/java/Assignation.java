package com.nam.java;

public class Assignation {
    private int id;
    private int idReservation;
    private int idVoiture;

    public Assignation() {
    }

    public Assignation(int id, int idReservation, int idVoiture) {
        this.id = id;
        this.idReservation = idReservation;
        this.idVoiture = idVoiture;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(int idReservation) {
        this.idReservation = idReservation;
    }

    public int getIdVoiture() {
        return idVoiture;
    }

    public void setIdVoiture(int idVoiture) {
        this.idVoiture = idVoiture;
    }

    @Override
    public String toString() {
        return "Assignation{id=" + id + ", idReservation=" + idReservation + ", idVoiture=" + idVoiture + "}";
    }
}
