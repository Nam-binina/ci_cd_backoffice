<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Choix méthode d'assignation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        .actions { margin-top: 20px; }
        .btn { border: none; cursor: pointer; margin-right: 10px; padding: 12px 18px; color: white; border-radius: 6px; font-size: 15px; }
        .btn-auto { background: #4CAF50; }
        .btn-auto:hover { background: #45a049; }
        .btn-manual { background: #1e88e5; }
        .btn-manual:hover { background: #1976d2; }
        .link { display: inline-block; margin-top: 16px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Choisir la méthode d'assignation</h1>
        <p>Sélectionne le mode de traitement :</p>

        <div class="actions">
            <a class="btn btn-auto" href="${pageContext.request.contextPath}/assignation/method/auto" style="text-decoration:none; display:inline-block;">Automatique</a>
            <a class="btn btn-manual" href="${pageContext.request.contextPath}/assignation/method/manual" style="text-decoration:none; display:inline-block;">Manuel</a>
        </div>

        <a class="link" href="${pageContext.request.contextPath}/assignation/page">← Retour page assignation</a>
    </div>
</body>
</html>
