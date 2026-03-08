<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Choix méthode d'assignation</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">Choisir la méthode d'assignation</h1>
        <p>Sélectionne le mode de traitement :</p>

        <div class="actions">
            <a class="btn btn-auto" href="${pageContext.request.contextPath}/assignation/method/auto" style="text-decoration:none; display:inline-block;">Automatique</a>
            <a class="btn btn-manual" href="${pageContext.request.contextPath}/assignation/method/manual" style="text-decoration:none; display:inline-block;">Manuel</a>
        </div>

        <a class="link" href="${pageContext.request.contextPath}/assignation/page">← Retour page assignation</a>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
