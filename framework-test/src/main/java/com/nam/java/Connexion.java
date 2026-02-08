package com.nam.java;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utilitaire de connexion MySQL via JDBC.
 *
 * Exemple d'URL : jdbc:mysql://localhost:3306/ma_base?useSSL=false&serverTimezone=UTC
 */
public final class Connexion {

    private static final String URL = "jdbc:mysql://localhost:3306/ci_cd?useSSL=false&serverTimezone=UTC";
    private static final String USER = "safidy";
    private static final String PASSWORD = "safidy";

    private Connexion() {
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver JDBC MySQL introuvable. Vérifie que mysql-connector-j est bien dans WEB-INF/lib", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
}
