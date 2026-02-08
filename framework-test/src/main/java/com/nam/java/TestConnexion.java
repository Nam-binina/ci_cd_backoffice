package com.nam.java;
public class TestConnexion {
    public static void main(String[] args) {
        boolean ok = Connexion.testConnection();
        System.out.println(ok ? "Connexion OK" : "Connexion KO");
    }
}
