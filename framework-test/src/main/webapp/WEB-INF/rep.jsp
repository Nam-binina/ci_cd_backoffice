<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ page
import="com.nam.java.Etudiant" %>
<html>
  <head>
    <title>Étudiant</title>
      <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
  <body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <h2>Sprint 6</h2>

    <% Etudiant etudiant = (Etudiant) request.getAttribute("etudiant"); if
    (etudiant != null) { %>
    <p>Nom: <%= etudiant.getNom() %></p>
    <p>Prénom: <%= etudiant.getPrenom() %></p>
    <% } else { %>
    <p>Aucun étudiant trouvé.</p>
    <% } %>
          </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
