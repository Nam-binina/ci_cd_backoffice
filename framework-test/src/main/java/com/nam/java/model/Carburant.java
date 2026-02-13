package com.nam.java.model;

public class Carburant {
    private int idCarburant;
    private String nom;

    public Carburant() {
    }

    public Carburant(int idCarburant, String nom) {
        this.idCarburant = idCarburant;
        this.nom = nom;
    }

    public int getIdCarburant() {
        return idCarburant;
    }

    public void setIdCarburant(int idCarburant) {
        this.idCarburant = idCarburant;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
