package com.nam.java;

import java.time.LocalDate;

public class Assignation {
    private int id;
    private int idReservation;
    private int idVoiture;
    private LocalDate debutTrajet;
    private LocalDate finTrajet;

    public Assignation() {
    }

    public Assignation(int id, int idReservation, int idVoiture) {
        this.id = id;
        this.idReservation = idReservation;
        this.idVoiture = idVoiture;
    }

    public Assignation(int id, int idReservation, int idVoiture, LocalDate debutTrajet, LocalDate finTrajet) {
        this.id = id;
        this.idReservation = idReservation;
        this.idVoiture = idVoiture;
        this.debutTrajet = debutTrajet;
        this.finTrajet = finTrajet;
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

    public LocalDate getDebutTrajet() {
        return debutTrajet;
    }

    public void setDebutTrajet(LocalDate debutTrajet) {
        this.debutTrajet = debutTrajet;
    }

    public LocalDate getFinTrajet() {
        return finTrajet;
    }

    public void setFinTrajet(LocalDate finTrajet) {
        this.finTrajet = finTrajet;
    }

    @Override
    public String toString() {
        return "Assignation{id=" + id + ", idReservation=" + idReservation + ", idVoiture=" + idVoiture
                + ", debutTrajet=" + debutTrajet + ", finTrajet=" + finTrajet + "}";
    }
}
