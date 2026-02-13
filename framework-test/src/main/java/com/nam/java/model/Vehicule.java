package com.nam.java.model;

public class Vehicule {
    private int idVehicule;
    private int capacite;
    private int idCarburant;

    public Vehicule() {
    }

    public Vehicule(int idVehicule, int capacite, int idCarburant) {
        this.idVehicule = idVehicule;
        this.capacite = capacite;
        this.idCarburant = idCarburant;
    }

    public int getIdVehicule() {
        return idVehicule;
    }

    public void setIdVehicule(int idVehicule) {
        this.idVehicule = idVehicule;
    }

    public int getCapacite() {
        return capacite;
    }

    public void setCapacite(int capacite) {
        this.capacite = capacite;
    }

    public int getIdCarburant() {
        return idCarburant;
    }

    public void setIdCarburant(int idCarburant) {
        this.idCarburant = idCarburant;
    }
}
