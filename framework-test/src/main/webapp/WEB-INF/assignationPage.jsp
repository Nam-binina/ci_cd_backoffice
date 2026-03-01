<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assignation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        .btn { display: inline-block; margin-top: 20px; margin-right: 10px; padding: 12px 18px; background: #4CAF50; color: white; text-decoration: none; border-radius: 6px; }
        .btn:hover { background: #45a049; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Gestion des assignations</h1>
        <p>Choisir une action :</p>
        <a class="btn" href="${pageContext.request.contextPath}/assignation/method">Choisir la méthode d'assignation</a>
        <a class="btn" href="${pageContext.request.contextPath}/assignation/list">Voir la liste des assignations</a>
    </div>
</body>
</html>
