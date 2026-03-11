<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Résultat assignation</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">Traitement de l'assignation</h1>
        <p>Méthode choisie : <span class="mode"><%= request.getAttribute("modeChoisi") %></span></p>
        <p><%= request.getAttribute("message") %></p>

        <a class="link" href="${pageContext.request.contextPath}/assignation/method">← Revenir au choix de méthode</a>
        <a class="link" href="${pageContext.request.contextPath}/assignation/page">Retour page assignation</a>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
