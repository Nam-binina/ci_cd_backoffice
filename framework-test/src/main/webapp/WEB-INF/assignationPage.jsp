<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assignation</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="container">
        <h1 class="page-title">Gestion des assignations</h1>
        <p>Choisir une action :</p>
        <a class="btn" href="${pageContext.request.contextPath}/assignation/method">Choisir la méthode d'assignation</a>
        <a class="btn" href="${pageContext.request.contextPath}/assignation/list">Voir la liste des assignations</a>
    <a class="btn" href="${pageContext.request.contextPath}/assignation/filter">Filtrer par date</a>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
