<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Upload</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <div class="form-container">
        <h1 class="page-title">Test Upload de Fichier</h1>
        <form action="${pageContext.request.contextPath}/TestClass/upload" method="POST" enctype="multipart/form-data">
            <p>Sélectionnez un fichier à uploader:</p>
            <input type="file" name="file" required>
            <br><br>
            <button type="submit">Uploader</button>
        </form>
        <br>
        <a href="${pageContext.request.contextPath}/TestClass/session/view">← Voir la session</a> | 
        <a href="${pageContext.request.contextPath}/TestClass/login">Connexion</a>
    </div>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
