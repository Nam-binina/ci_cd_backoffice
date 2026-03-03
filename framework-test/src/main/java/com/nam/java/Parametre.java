package com.nam.java;

public class Parametre {
    private int idParametre;
    private double vitesseMoyenne;
    private int tempsAttente;

    public Parametre() {
    }

    public Parametre(int idParametre, double vitesseMoyenne, int tempsAttente) {
        this.idParametre = idParametre;
        this.vitesseMoyenne = vitesseMoyenne;
        this.tempsAttente = tempsAttente;
    }

    public int getIdParametre() {
        return idParametre;
    }

    public void setIdParametre(int idParametre) {
        this.idParametre = idParametre;
    }

    public double getVitesseMoyenne() {
        return vitesseMoyenne;
    }

    public void setVitesseMoyenne(double vitesseMoyenne) {
        this.vitesseMoyenne = vitesseMoyenne;
    }

    public int getTempsAttente() {
        return tempsAttente;
    }

    public void setTempsAttente(int tempsAttente) {
        this.tempsAttente = tempsAttente;
    }
}
