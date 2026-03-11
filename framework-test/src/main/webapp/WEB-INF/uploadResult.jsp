<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Résultat Upload</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="result-container">
        <h1 class="page-title">Résultat de l'Upload</h1>
        <p class="success">${message}</p>
        <div class="info">
            <p><strong>Nom du fichier:</strong> ${fileName}</p>
            <p><strong>Taille:</strong> ${fileSize} octets</p>
            <p><strong>Type de contenu:</strong> ${contentType}</p>
            <p><strong>Sauvegardé dans:</strong> ${savedPath}</p>
        </div>
        <br>
        <a href="${pageContext.request.contextPath}/TestClass/upload">← Retour au formulaire d'upload</a>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
