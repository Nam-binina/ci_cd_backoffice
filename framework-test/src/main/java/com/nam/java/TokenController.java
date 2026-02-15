package com.nam.java;

/**
 * Contrôleur pour la validation des tokens d'accès.
 * 
 * Le frontoffice envoie un token (uid) via l'URL :
 *   GET /token/validate?token=xxxx-xxxx-xxxx
 * 
 * Le backoffice vérifie si ce token existe dans la base de données
 * et s'il n'a pas encore expiré, puis retourne un JSON de réponse.
 */
@MyAnnotation(value = "/token", method = HttpMethod.CONTROLLER)
public class TokenController {

    /**
     * Endpoint de validation de token.
     * 
     * GET /token/validate?token=xxxx-xxxx-xxxx
     * 
     * Réponse JSON :
     * - Token valide :   { "valid": true,  "token": { id, uid, created_at, expires_at, valid }, "status": 200 }
     * - Token expiré :   { "valid": false, "message": "Token expiré",      "status": 403 }
     * - Token absent :   { "valid": false, "message": "Token introuvable", "status": 404 }
     * - Token manquant : { "valid": false, "message": "Token manquant",    "status": 400 }
     * - Erreur serveur : { "valid": false, "message": "Erreur serveur",    "status": 500 }
     */
    /**
     * Affiche le formulaire de création de token.
     * GET /token/form
     */
    @MyAnnotation(value = "/form", method = HttpMethod.GET)
    public ModelView form() {
        ModelView mv = new ModelView();
        mv.setJspName("tokenForm");
        return mv;
    }

    /**
     * Crée un nouveau token.
     * POST /token/create
     */
    @MyAnnotation(value = "/create", method = HttpMethod.POST)
    public ModelView create(@MyParam("durationHours") int durationHours) {
        ModelView mv = new ModelView();

        try {
            TokenRepository repo = new TokenRepository();
            String uid = repo.insert(durationHours);

            mv.addItem("success", "Token créé avec succès !");
            mv.addItem("createdUid", uid);
            mv.addItem("tokens", repo.findAll());
        } catch (Exception e) {
            mv.addItem("error", "Erreur lors de la création : " + e.getMessage());
        }

        mv.setJspName("tokenList");
        return mv;
    }

    /**
     * Liste tous les tokens.
     * GET /token/list
     */
    @MyAnnotation(value = "/list", method = HttpMethod.GET)
    public ModelView list() {
        ModelView mv = new ModelView();

        try {
            TokenRepository repo = new TokenRepository();
            mv.addItem("tokens", repo.findAll());
        } catch (Exception e) {
            mv.addItem("error", "Erreur lors du chargement : " + e.getMessage());
        }

        mv.setJspName("tokenList");
        return mv;
    }

    /**
     * Supprime un token.
     * GET /token/delete?id=X
     */
    @MyAnnotation(value = "/delete", method = HttpMethod.GET)
    public ModelView delete(@MyParam("id") int id) {
        ModelView mv = new ModelView();

        try {
            TokenRepository repo = new TokenRepository();
            repo.deleteById(id);
            mv.addItem("success", "Token supprimé.");
            mv.addItem("tokens", repo.findAll());
        } catch (Exception e) {
            mv.addItem("error", "Erreur lors de la suppression : " + e.getMessage());
        }

        mv.setJspName("tokenList");
        return mv;
    }

    @MyAnnotation(value = "/validate", method = HttpMethod.GET)
    @JsonAnnotation
    public ModelView validate(@MyParam("token") String token) {
        ModelView mv = new ModelView();

        if (token == null || token.trim().isEmpty()) {
            mv.addItem("valid", false);
            mv.addItem("message", "Token manquant");
            mv.addItem("status", 400);
            return mv;
        }

        try {
            TokenRepository tokenRepository = new TokenRepository();
            java.util.Map<String, Object> tokenInfo = tokenRepository.findByUid(token.trim());

            if (tokenInfo == null) {
                mv.addItem("valid", false);
                mv.addItem("message", "Token introuvable");
                mv.addItem("status", 404);
                return mv;
            }

            boolean isValid = (boolean) tokenInfo.get("valid");

            if (!isValid) {
                mv.addItem("valid", false);
                mv.addItem("message", "Token expiré");
                mv.addItem("status", 403);
                return mv;
            }

            mv.addItem("valid", true);
            mv.addItem("token", tokenInfo);
            mv.addItem("status", 200);

        } catch (Exception e) {
            mv.addItem("valid", false);
            mv.addItem("message", "Erreur serveur : " + e.getMessage());
            mv.addItem("status", 500);
        }

        return mv;
    }
}
