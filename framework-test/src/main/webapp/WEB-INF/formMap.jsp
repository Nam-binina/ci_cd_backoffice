<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Exemple de formulaire JSP</title>
</head>
<body>
    <h2>Formulaire exemple</h2>
    <form action="<%= request.getContextPath() %>/TestClass/formMap" method="post">
        <!-- Input text -->
        <label for="nom">Nom :</label>
        <input type="text" id="nom" name="nom" placeholder="Entrez votre nom" /><br/><br/>

        <label for="email">Email :</label>
        <input type="text" id="email" name="email" placeholder="votre@exemple.com" /><br/><br/>

        <!-- Checkbox (plusieurs valeurs possibles) -->
        <p>Centres d'intérêt :</p>
        <input type="checkbox" id="sport" name="interets" value="sport" />
        <label for="sport">Sport</label><br/>
        <input type="checkbox" id="musique" name="interets" value="musique" />
        <label for="musique">Musique</label><br/>
        <input type="checkbox" id="lecture" name="interets" value="lecture" />
        <label for="lecture">Lecture</label><br/><br/>

        <!-- Select simple -->
        <label for="pays">Pays :</label>
        <select id="pays" name="pays">
            <option value="">--Choisissez--</option>
            <option value="fr">France</option>
            <option value="be">Belgique</option>
            <option value="ch">Suisse</option>
        </select><br/><br/>

        <!-- Select multiple -->
        <label for="skills">Compétences (multi) :</label><br/>
        <select id="skills" name="skills" multiple size="4">
            <option value="java">Java</option>
            <option value="js">JavaScript</option>
            <option value="sql">SQL</option>
            <option value="html">HTML/CSS</option>
        </select><br/><br/>

        <button type="submit">Envoyer</button>
        <button type="reset">Réinitialiser</button>
    </form>
</body>
</html>
