package com.nam.java.model;

/**
 * Classe simple représentant un utilisateur pour les tests
 */
public class User {
    private String username;
    private String email;
    private long createdAt;

    public User() {
        this.createdAt = System.currentTimeMillis();
    }

    public User(String username) {
        this.username = username;
        this.createdAt = System.currentTimeMillis();
    }

    public User(String username, String email) {
        this.username = username;
        this.email = email;
        this.createdAt = System.currentTimeMillis();
    }

    // Getters et Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public long getCreatedAt() {
        return createdAt;
    }

    @Override
    public String toString() {
        return "User{username='" + username + "', email='" + email + "'}";
    }
}
