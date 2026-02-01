package com.nam.java;

import java.util.HashMap;
import java.util.Map;

/**
 * Base de données simulée pour les utilisateurs de test.
 * Stocke les utilisateurs avec leurs mots de passe et rôles.
 */
public class UserDatabase {
    
    // Singleton instance
    private static UserDatabase instance;
    
    // Map: username -> UserData
    private Map<String, UserData> users;
    
    /**
     * Données d'un utilisateur
     */
    public static class UserData {
        private User user;
        private String password;
        private String role;
        
        public UserData(User user, String password, String role) {
            this.user = user;
            this.password = password;
            this.role = role;
        }
        
        public User getUser() { return user; }
        public String getPassword() { return password; }
        public String getRole() { return role; }
    }
    
    private UserDatabase() {
        users = new HashMap<>();
        initDefaultUsers();
    }
    
    public static UserDatabase getInstance() {
        if (instance == null) {
            instance = new UserDatabase();
        }
        return instance;
    }
    
    /**
     * Initialise les utilisateurs de test par défaut
     */
    private void initDefaultUsers() {
        // Admin
        addUser("admin", "admin123", "admin@test.com", "ADMIN");
        
        // Manager
        addUser("manager", "manager123", "manager@test.com", "MANAGER");
        
        // Utilisateurs standards
        addUser("user", "user123", "user@test.com", "USER");
        addUser("john", "john123", "john@test.com", "USER");
        addUser("alice", "alice123", "alice@test.com", "USER");
        
        // Utilisateur invité (guest)
        addUser("guest", "guest123", "guest@test.com", "GUEST");
    }
    
    /**
     * Ajoute un utilisateur à la base
     */
    public void addUser(String username, String password, String email, String role) {
        User user = new User(username, email);
        users.put(username.toLowerCase(), new UserData(user, password, role));
    }
    
    /**
     * Authentifie un utilisateur
     * @return UserData si authentification réussie, null sinon
     */
    public UserData authenticate(String username, String password) {
        if (username == null || password == null) {
            return null;
        }
        
        UserData userData = users.get(username.toLowerCase());
        if (userData != null && userData.getPassword().equals(password)) {
            return userData;
        }
        return null;
    }
    
    /**
     * Récupère un utilisateur par son username (sans vérification du mot de passe)
     */
    public UserData getUser(String username) {
        if (username == null) return null;
        return users.get(username.toLowerCase());
    }
    
    /**
     * Vérifie si un utilisateur existe
     */
    public boolean userExists(String username) {
        if (username == null) return false;
        return users.containsKey(username.toLowerCase());
    }
    
    /**
     * Liste tous les utilisateurs (pour debug)
     */
    public Map<String, UserData> getAllUsers() {
        return new HashMap<>(users);
    }
    
    /**
     * Réinitialise la base avec les utilisateurs par défaut
     */
    public void reset() {
        users.clear();
        initDefaultUsers();
    }
}
