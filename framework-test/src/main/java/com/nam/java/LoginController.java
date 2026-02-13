package com.nam.java;
/*
package com.nam.java;

import java.util.Map;

/**
 * Contrôleur pour gérer l'authentification et les tests de rôles
 */
public class LoginController {

    /**
     * Affiche le formulaire de connexion
     */
    @MyAnnotation(value = "/login", method = HttpMethod.GET)
    public ModelView showLoginForm() {
        ModelView mv = new ModelView();
        mv.setJspName("loginForm");
        return mv;
    }

    /**
     * Traite la connexion de l'utilisateur
     * Utilise UserDatabase pour authentifier
     */
    @MyAnnotation(value = "/login", method = HttpMethod.POST)
    public ModelView doLogin(@MyParam("username") String username, @MyParam("password") String password) {
        ModelView mv = new ModelView();
        
        if (username == null || username.isEmpty()) {
            mv.addItem("error", "Nom d'utilisateur requis");
            mv.setJspName("loginForm");
            return mv;
        }
        
        // Authentification avec la base de données
        UserDatabase db = UserDatabase.getInstance();
        UserDatabase.UserData userData = db.authenticate(username, password);
        
        if (userData != null) {
            // Authentification réussie
            User user = userData.getUser();
            String role = userData.getRole();
            
            // Stocker l'utilisateur et son rôle en session
            RoleChecker.setCurrentUser(user);
            RoleChecker.setUserRoleInSession(role);
            
            mv.addItem("message", "Connexion réussie! Bienvenue " + user.getUsername());
            mv.addItem("user", user);
            mv.addItem("role", role);
            mv.setJspName("loginResult");
        } else {
            // Échec d'authentification
            mv.addItem("error", "Nom d'utilisateur ou mot de passe incorrect");
            mv.addItem("username", username);
            mv.setJspName("loginForm");
        }
        
        return mv;
    }

    /**
     * Déconnexion de l'utilisateur
     */
    @MyAnnotation(value = "/logout", method = HttpMethod.GET)
    public ModelView logout() {
        // Utiliser RoleChecker pour déconnecter
        RoleChecker.logout();
        
        ModelView mv = new ModelView();
        mv.addItem("message", "Vous avez été déconnecté");
        mv.setJspName("loginForm");
        return mv;
    }

    /**
     * Affiche les informations de session actuelles (JSON)
     */
    @MyAnnotation(value = "/session-info", method = HttpMethod.GET)
    @JsonAnnotation
    public ModelView getSessionInfo() {
        ModelView mv = new ModelView();
        
        boolean isAuthenticated = RoleChecker.isAuthenticated();
        mv.addItem("authenticated", isAuthenticated);
        
        if (isAuthenticated) {
            Object user = RoleChecker.getCurrentUser();
            String role = RoleChecker.getUserRoleFromSession();
            mv.addItem("user", user);
            mv.addItem("role", role);
        }
        
        // Afficher aussi les noms de variables configurés
        FrameworkConfig config = FrameworkConfig.getInstance();
        mv.addItem("sessionVariable", config.getSessionVariable());
        mv.addItem("roleVariable", config.getRoleVariable());
        
        return mv;
    }

    /**
     * Page publique - accessible à tous
     */
    @MyAnnotation(value = "/public", method = HttpMethod.GET)
    public ModelView publicPage() {
        ModelView mv = new ModelView();
        mv.addItem("message", "Cette page est accessible à tous");
        mv.setJspName("test");
        return mv;
    }

    /**
     * Page protégée - nécessite le rôle USER
     */
    @MyAnnotation(value = "/user-only", method = HttpMethod.GET, role = "USER")
    public ModelView userPage() {
        ModelView mv = new ModelView();
        Object user = RoleChecker.getCurrentUser();
        mv.addItem("message", "Bienvenue sur la page utilisateur!");
        mv.addItem("user", user);
        mv.setJspName("protectedPage");
        return mv;
    }

    /**
     * Page admin - nécessite le rôle ADMIN
     */
    @MyAnnotation(value = "/admin-only", method = HttpMethod.GET, role = "ADMIN")
    public ModelView adminPage() {
        ModelView mv = new ModelView();
        Object user = RoleChecker.getCurrentUser();
        mv.addItem("message", "Bienvenue sur la page administrateur!");
        mv.addItem("user", user);
        mv.addItem("role", "ADMIN");
        mv.setJspName("protectedPage");
        return mv;
    }

    /**
     * Page manager - nécessite le rôle MANAGER
     */
    @MyAnnotation(value = "/manager-only", method = HttpMethod.GET, role = "MANAGER")
    public ModelView managerPage() {
        ModelView mv = new ModelView();
        Object user = RoleChecker.getCurrentUser();
        mv.addItem("message", "Bienvenue sur la page manager!");
        mv.addItem("user", user);
        mv.addItem("role", "MANAGER");
        mv.setJspName("protectedPage");
        return mv;
    }

    /**
     * Test JSON pour vérifier l'accès protégé
     */
    @MyAnnotation(value = "/admin-api", method = HttpMethod.GET, role = "ADMIN")
    @JsonAnnotation
    public ModelView adminApi() {
        ModelView mv = new ModelView();
        mv.addItem("success", true);
        mv.addItem("data", "Données sensibles admin");
        mv.addItem("user", RoleChecker.getCurrentUser());
        return mv;
    }
    
    /**
     * Page protégée par @Authorized - nécessite uniquement d'être connecté
     * Aucun rôle spécifique requis
     */
    @Authorized
    @MyAnnotation(value = "/profile", method = HttpMethod.GET)
    public ModelView profilePage() {
        ModelView mv = new ModelView();
        Object user = RoleChecker.getCurrentUser();
        String role = RoleChecker.getUserRoleFromSession();
        mv.addItem("message", "Votre profil - Vous êtes connecté!");
        mv.addItem("user", user);
        mv.addItem("role", role);
        mv.setJspName("protectedPage");
        return mv;
    }
    
    /**
     * API protégée par @Authorized avec message personnalisé
     */
    @Authorized(message = "Vous devez être connecté pour accéder à cette API")
    @MyAnnotation(value = "/my-data", method = HttpMethod.GET)
    @JsonAnnotation
    public ModelView myData() {
        ModelView mv = new ModelView();
        mv.addItem("success", true);
        mv.addItem("user", RoleChecker.getCurrentUser());
        mv.addItem("role", RoleChecker.getUserRoleFromSession());
        mv.addItem("message", "Vos données personnelles");
        return mv;
    }
}
*/
