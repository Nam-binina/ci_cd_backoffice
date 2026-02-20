package com.nam.java;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Repository pour vérifier la validité des tokens d'accès.
 * Un token est valide s'il existe dans la table `token` et que sa date d'expiration
 * (expires_at) n'est pas encore dépassée.
 */
public class TokenRepository {

    /**
     * Vérifie si un token (uid) existe et est encore valide (non expiré).
     *
     * @param uid le UUID du token à vérifier
     * @return true si le token existe et n'a pas expiré, false sinon
     */
    public boolean isTokenValid(String uid) {
        if (uid == null || uid.trim().isEmpty()) {
            return false;
        }

        String sql = "SELECT COUNT(*) FROM token WHERE uid = ? AND expires_at > NOW()";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, uid.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la vérification du token", e);
        }

        return false;
    }

    /**
     * Récupère les informations d'un token par son uid.
     *
     * @param uid le UUID du token
     * @return une Map avec les infos du token, ou null si non trouvé
     */
    public java.util.Map<String, Object> findByUid(String uid) {
        if (uid == null || uid.trim().isEmpty()) {
            return null;
        }

        String sql = "SELECT id, uid, created_at, expires_at FROM token WHERE uid = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, uid.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.util.Map<String, Object> token = new java.util.HashMap<>();
                    token.put("id", rs.getInt("id"));
                    token.put("uid", rs.getString("uid"));

                    java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                    java.sql.Timestamp expiresAt = rs.getTimestamp("expires_at");

                    token.put("created_at", createdAt != null ? createdAt.toString() : null);
                    token.put("expires_at", expiresAt != null ? expiresAt.toString() : null);

                    // Vérifier la validité en comparant expires_at avec maintenant
                    boolean valid = expiresAt != null && expiresAt.after(new java.sql.Timestamp(System.currentTimeMillis()));
                    token.put("valid", valid);

                    return token;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du token", e);
        }

        return null;
    }

    /**
     * Crée un nouveau token avec une durée de validité en heures.
     *
     * @param durationHours durée de validité en heures (par défaut 24h)
     * @return le uid du token créé
     */
    public String insert(int durationHours) {
        if (durationHours <= 0) {
            durationHours = 24;
        }

        String sql = "INSERT INTO token (uid, created_at, expires_at) VALUES (UUID(), NOW(), NOW() + INTERVAL ? HOUR)";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, durationHours);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    // Récupérer le uid généré
                    java.util.Map<String, Object> token = findById(id);
                    if (token != null) {
                        return (String) token.get("uid");
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la création du token", e);
        }

        return null;
    }

    /**
     * Récupère un token par son id.
     */
    public java.util.Map<String, Object> findById(int id) {
        String sql = "SELECT id, uid, created_at, expires_at FROM token WHERE id = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche du token par id", e);
        }

        return null;
    }

    /**
     * Récupère tous les tokens, triés du plus récent au plus ancien.
     */
    public java.util.List<java.util.Map<String, Object>> findAll() {
        String sql = "SELECT id, uid, created_at, expires_at FROM token ORDER BY created_at DESC";
        java.util.List<java.util.Map<String, Object>> tokens = new java.util.ArrayList<>();

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                tokens.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des tokens", e);
        }

        return tokens;
    }

    /**
     * Supprime un token par son id.
     */
    public void deleteById(int id) {
        String sql = "DELETE FROM token WHERE id = ?";

        try (Connection conn = Connexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression du token", e);
        }
    }

    /**
     * Mappe une ligne ResultSet en Map.
     */
    private java.util.Map<String, Object> mapRow(ResultSet rs) throws SQLException {
        java.util.Map<String, Object> token = new java.util.HashMap<>();
        token.put("id", rs.getInt("id"));
        token.put("uid", rs.getString("uid"));

        java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
        java.sql.Timestamp expiresAt = rs.getTimestamp("expires_at");

        token.put("created_at", createdAt != null ? createdAt.toString() : null);
        token.put("expires_at", expiresAt != null ? expiresAt.toString() : null);

        boolean valid = expiresAt != null && expiresAt.after(new java.sql.Timestamp(System.currentTimeMillis()));
        token.put("valid", valid);

        return token;
    }
}
