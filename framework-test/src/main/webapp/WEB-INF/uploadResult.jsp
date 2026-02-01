<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Résultat Upload</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .result-container { max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px; }
        h1 { color: #333; }
        .success { color: green; }
        .info { background-color: #f0f0f0; padding: 10px; border-radius: 4px; margin: 10px 0; }
        a { color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
    <div class="result-container">
        <h1>Résultat de l'Upload</h1>
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
</body>
</html>
