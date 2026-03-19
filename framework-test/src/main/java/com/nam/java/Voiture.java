package com.nam.java;

public class Voiture {
    private int id;
    private String immatriculation;
    private int nombrePlace;
    private int idConsommation;
    private double vitesseMoyenne;
    private java.time.LocalTime heureDisponibilite;

    public Voiture() {
    }

    public Voiture(int id, String immatriculation, int nombrePlace, int idConsommation, double vitesseMoyenne) {
        this.id = id;
        this.immatriculation = immatriculation;
        this.nombrePlace = nombrePlace;
        this.idConsommation = idConsommation;
        this.vitesseMoyenne = vitesseMoyenne;
    }

    public Voiture(int id, String immatriculation, int nombrePlace, int idConsommation, double vitesseMoyenne, java.time.LocalTime heureDisponibilite) {
        this.id = id;
        this.immatriculation = immatriculation;
        this.nombrePlace = nombrePlace;
        this.idConsommation = idConsommation;
        this.vitesseMoyenne = vitesseMoyenne;
        this.heureDisponibilite = heureDisponibilite;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImmatriculation() {
        return immatriculation;
    }

    public void setImmatriculation(String immatriculation) {
        this.immatriculation = immatriculation;
    }

    public int getNombrePlace() {
        return nombrePlace;
    }

    public void setNombrePlace(int nombrePlace) {
        this.nombrePlace = nombrePlace;
    }

    public int getIdConsommation() {
        return idConsommation;
    }

    public void setIdConsommation(int idConsommation) {
        this.idConsommation = idConsommation;
    }

    public double getVitesseMoyenne() {
        return vitesseMoyenne;
    }

    public void setVitesseMoyenne(double vitesseMoyenne) {
        this.vitesseMoyenne = vitesseMoyenne;
    }

    public java.time.LocalTime getHeureDisponibilite() {
        return heureDisponibilite;
    }

    public void setHeureDisponibilite(java.time.LocalTime heureDisponibilite) {
        this.heureDisponibilite = heureDisponibilite;
    }

    @Override
    public String toString() {
        return "Voiture{id=" + id + ", immatriculation='" + immatriculation + "', nombrePlace=" + nombrePlace +
                ", idConsommation=" + idConsommation + ", vitesseMoyenne=" + vitesseMoyenne +
                ", heureDisponibilite=" + heureDisponibilite + "}";
    }
}
