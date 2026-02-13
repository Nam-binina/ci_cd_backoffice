<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ page
import="com.nam.java.model.Etudiant" %>
<html>
  <head>
    <title>Étudiant</title>
  </head>
  <body>
    <h2>Sprint 6</h2>

    <% Etudiant etudiant = (Etudiant) request.getAttribute("etudiant"); if
    (etudiant != null) { %>
    <p>Nom: <%= etudiant.getNom() %></p>
    <p>Prénom: <%= etudiant.getPrenom() %></p>
    <% } else { %>
    <p>Aucun étudiant trouvé.</p>
    <% } %>
  </body>
</html>
