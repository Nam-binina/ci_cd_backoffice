package com.nam.java;

import com.nam.java.repository.Connexion;

public class TestConnexion {
    public static void main(String[] args) {
        boolean ok = Connexion.testConnection();
        System.out.println(ok ? "Connexion OK" : "Connexion KO");
    }
}
