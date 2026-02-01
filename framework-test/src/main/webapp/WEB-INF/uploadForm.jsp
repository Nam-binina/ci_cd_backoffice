<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Upload</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .form-container { max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px; }
        h1 { color: #333; }
        input[type="file"] { margin: 10px 0; }
        button { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer; border-radius: 4px; }
        button:hover { background-color: #45a049; }
        a { color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>Test Upload de Fichier</h1>
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
</body>
</html>
