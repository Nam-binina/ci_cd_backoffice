<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nam.java.Hotel" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des hôtels</title>
    
    <style>
<%@ include file="/assets/theme.css" %>
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/site-header.jspf" %>
    <main class="page-main">
        <section class="content-card">
    <h1 class="page-title">Liste des hôtels</h1>

    <%
        List<Hotel> hotels = (List<Hotel>) request.getAttribute("hotels");
        if (hotels == null || hotels.isEmpty()) {
    %>
        <p>Aucun hôtel trouvé.</p>
    <%
        } else {
    %>
        <table>
            <tr>
                <th>ID</th>
                <th>Nom</th>
            </tr>
            <% for (Hotel h : hotels) { %>
            <tr>
                <td><%= h.getIdHotel() %></td>
                <td><%= h.getNom() %></td>
            </tr>
            <% } %>
        </table>
    <%
        }
    %>
        </section>
    </main>
    <%@ include file="/WEB-INF/jspf/site-footer.jspf" %>
</body>
</html>
