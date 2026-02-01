package com.nam.java;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;



@MyAnnotation(value = "/TestClass" , method = HttpMethod.CONTROLLER)
public class DemoClass {

    private static List<Etudiant> etudiants = new ArrayList<>();

    static {
        etudiants.add(new Etudiant("Nam", "Nguyen"));
        etudiants.add(new Etudiant("John", "Doe"));
        etudiants.add(new Etudiant("Alice", "Smith"));
    }
    @MyAnnotation(value = "/HelloMethod",method = HttpMethod.GET)
    public String hello() {
        return " Hello";
    }

    @MyAnnotation(value = "GoodbyeMethod",method = HttpMethod.GET)
    public void goodbye() {
        System.out.println("Goodbye !");
        etudiants.add(new Etudiant("John", "Doe"));
        etudiants.add(new Etudiant("Alice", "Smith"));
    }

    @MyAnnotation(value = "/GoodbyeMethod",method = HttpMethod.POST)
    public ModelView list() {
    System.out.println("Goodbye !");
    ModelView M = new ModelView();
    Etudiant E = new Etudiant("Nam", "Nguyen");
    M.addItem("etudiant", E);
    Etudiant E2 = new Etudiant("John", "Doe");
    M.addItem("etudiant2", E2);
    M.setJspName("index");
    return M;
    }
    @MyAnnotation(value = "/Etudiant/{id}",method = HttpMethod.GET)
    public ModelView etudiant() {
        System.out.println("Goodbye !");
        ModelView M = new ModelView();
        Etudiant E = new Etudiant("Nam", "Nguyen");
        Etudiant E2 = new Etudiant("John", "Doe");
        M.setJspName("index");
        return M;
    }

    @MyAnnotation(value = "/sprint6ter/{id}",method = HttpMethod.GET)
    public ModelView etudiant2(int id) {
        System.out.println("Goodbye !");
        ModelView M = new ModelView();

        M.addItem("etudiant", findEtudiantById(id));
        M.setJspName("test3");
        return M;
    }
    @MyAnnotation(value = "/json/{id}",method = HttpMethod.GET)
    @JsonAnnotation
    public ModelView json1(int id) {
        System.out.println("Goodbye !");
        ModelView M = new ModelView();
        M.addItem("test", "test");
        M.addItem("test", "test");
        M.addItem("test", "test");
        M.addItem("etudiant", findEtudiantById(id));
        M.setJspName("test3");
        return M;
    }
    @MyAnnotation(value = "/json",method = HttpMethod.GET)
    @JsonAnnotation
    public String json2() {
        System.out.println("Goodbye !");
        return "Hello";
    }
    @MyAnnotation(value = "/sprint6", method = HttpMethod.GET)
    public ModelView Idetudiant(int id) {
        System.out.println("Goodbye !");
        ModelView M = new ModelView();
        M.addItem("etudiant", findEtudiantById(id));
        M.setJspName("test");
        return M;
    }
    @MyAnnotation(value = "/form", method = HttpMethod.POST)
    public ModelView repForm(@MyParam(value = "nom") String nom, @MyParam(value = "prenom") String prenom) {
        System.out.println("Goodbye !");
        ModelView M = new ModelView();
        Etudiant e = new Etudiant(nom, prenom);
        M.addItem("etudiant",e);
        M.setJspName("rep");
        return M;
    }
    @MyAnnotation(value = "/form", method = HttpMethod.GET)
    public ModelView form() {
        System.out.println("Goodbye !");
        ModelView M = new ModelView();
        M.setJspName("post");
        return M;
    }

    @MyAnnotation(value = "/formMap", method = HttpMethod.POST)
    public ModelView repFormMap(@MyParam(value = "map") Map<String, Object> map) {
        System.out.println("Ok boys here we go !");
        ModelView M = new ModelView();
        M.addItem("map",map);
        M.setJspName("repMap");
        return M;
    }
    @MyAnnotation(value = "/formMap", method = HttpMethod.GET)
    public ModelView formMap() {
        System.out.println("Ok_boys_here_we  !");
        ModelView M = new ModelView();
        M.setJspName("formMap");
        return M;
    }


    @MyAnnotation(value = "/sprint6bis",method = HttpMethod.GET)
    public ModelView Idetudiants(@MyParam(value = "myid") int id) {
        System.out.println("Goodbye !");
        ModelView M = new ModelView();
        M.addItem("etudiant", findEtudiantById(id));
        M.setJspName("test1");
        return M;
    }

    private Etudiant findEtudiantById(int id) {
        return etudiants.get(id);
    }

    // ==================== TEST UPLOAD ====================
    
    @MyAnnotation(value = "/upload", method = HttpMethod.GET)
    public ModelView uploadForm() {
        ModelView M = new ModelView();
        M.setJspName("uploadForm");
        return M;
    }

    @MyAnnotation(value = "/upload", method = HttpMethod.POST)
    public ModelView handleUpload(@MyFile(value = "file") UploadedFile file) {
        ModelView M = new ModelView();
        if (file != null) {
            // Dossier de destination pour les uploads
            String uploadDir = System.getProperty("java.io.tmpdir") + "/uploads";
            java.io.File dir = new java.io.File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            
            // Sauvegarder le fichier
            java.io.File destination = new java.io.File(dir, file.getOriginalName());
            try {
                file.saveTo(destination);
                M.addItem("fileName", file.getOriginalName());
                M.addItem("fileSize", file.getSize());
                M.addItem("contentType", file.getContentType());
                M.addItem("savedPath", destination.getAbsolutePath());
                M.addItem("message", "Fichier uploadé et sauvegardé avec succès !");
            } catch (Exception e) {
                M.addItem("message", "Erreur lors de la sauvegarde: " + e.getMessage());
            }
        } else {
            M.addItem("message", "Aucun fichier reçu");
        }
        M.setJspName("uploadResult");
        return M;
    }

    // ==================== TEST SESSION ====================
    
    @MyAnnotation(value = "/session/set", method = HttpMethod.GET)
    public ModelView setSession(@MyParam(value = "key") String key, @MyParam(value = "value") String value) {
        Session.put(key, value);
        ModelView M = new ModelView();
        M.addItem("message", "Session définie: " + key + " = " + value);
        M.addItem("session", Session.getSession());
        M.setJspName("sessionResult");
        return M;
    }

    @MyAnnotation(value = "/session/get", method = HttpMethod.GET)
    public ModelView getSession(@MyParam(value = "key") String key) {
        Object value = Session.get(key);
        ModelView M = new ModelView();
        M.addItem("key", key);
        M.addItem("value", value != null ? value.toString() : "null");
        M.addItem("session", Session.getSession());
        M.setJspName("sessionResult");
        return M;
    }

    @MyAnnotation(value = "/session/view", method = HttpMethod.GET)
    public ModelView viewSession() {
        ModelView M = new ModelView();
        M.addItem("session", Session.getSession());
        M.setJspName("sessionResult");
        return M;
    }

    // ==================== TEST ROLE ====================
    
    @MyAnnotation(value = "/login", method = HttpMethod.GET)
    public ModelView loginForm() {
        ModelView M = new ModelView();
        M.setJspName("loginForm");
        return M;
    }

    @MyAnnotation(value = "/login", method = HttpMethod.POST)
    public ModelView login(@MyParam(value = "username") String username, @MyParam(value = "role") String role) {
        // Simuler une connexion en définissant le rôle dans la session
        RoleChecker.setUserRoleInSession(role);
        Session.put("username", username);
        ModelView M = new ModelView();
        M.addItem("message", "Connecté en tant que: " + username + " avec le rôle: " + role);
        M.addItem("username", username);
        M.addItem("role", role);
        M.setJspName("loginResult");
        return M;
    }

    @MyAnnotation(value = "/logout", method = HttpMethod.GET)
    public ModelView logout() {
        Session.put("userRole", null);
        Session.put("username", null);
        ModelView M = new ModelView();
        M.addItem("message", "Déconnecté avec succès");
        M.setJspName("loginResult");
        return M;
    }

    // Route protégée - accessible uniquement aux utilisateurs avec le rôle USER
    @MyAnnotation(value = "/protected/user", method = HttpMethod.GET, role = "USER")
    public ModelView protectedUserPage() {
        ModelView M = new ModelView();
        M.addItem("message", "Bienvenue sur la page protégée USER !");
        M.addItem("currentRole", RoleChecker.getUserRoleFromSession());
        M.setJspName("protectedPage");
        return M;
    }

    // Route protégée - accessible uniquement aux administrateurs
    @MyAnnotation(value = "/protected/admin", method = HttpMethod.GET, role = "ADMIN")
    public ModelView protectedAdminPage() {
        ModelView M = new ModelView();
        M.addItem("message", "Bienvenue sur la page ADMIN !");
        M.addItem("currentRole", RoleChecker.getUserRoleFromSession());
        M.setJspName("protectedPage");
        return M;
    }

    // Page publique pour tester les accès
    @MyAnnotation(value = "/public", method = HttpMethod.GET)
    public ModelView publicPage() {
        ModelView M = new ModelView();
        M.addItem("message", "Page publique - accessible à tous");
        M.addItem("currentRole", RoleChecker.getUserRoleFromSession());
        M.setJspName("protectedPage");
        return M;
    }
}
