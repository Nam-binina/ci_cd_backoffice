package com.nam.java.model;

import java.time.LocalDateTime;

public class Token {
    private int idToken;
    private String guid;
    private LocalDateTime dateExpiration;

    public Token() {
    }

    public Token(int idToken, String guid, LocalDateTime dateExpiration) {
        this.idToken = idToken;
        this.guid = guid;
        this.dateExpiration = dateExpiration;
    }

    public int getIdToken() {
        return idToken;
    }

    public void setIdToken(int idToken) {
        this.idToken = idToken;
    }

    public String getGuid() {
        return guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    public LocalDateTime getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(LocalDateTime dateExpiration) {
        this.dateExpiration = dateExpiration;
    }
}
