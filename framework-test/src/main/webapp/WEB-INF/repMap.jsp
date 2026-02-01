<%@ page contentType="text/html; charset=UTF-8" import="java.util.Map" %>

<%
    Map<String, Object> map = (Map<String, Object>) request.getAttribute("map");
    if (map == null || map.isEmpty()) {
%>
    <p>Aucune donnée reçue.</p>
<%
    } else {
%>
    <table border="1" cellpadding="8">
        <tr>
            <th>Clé</th>
            <th>Valeur</th>
        </tr>

        <%
            for (Map.Entry<String, Object> entry : map.entrySet()) {
        %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td>
                    <%
                        Object value = entry.getValue();
                        if (value instanceof java.util.List) {
                            java.util.List<?> list = (java.util.List<?>) value;
                            if (list.isEmpty()) {
                                out.print("[]");
                            } else {
                                out.print("<ul>");
                                for (Object item : list) {
                                    out.print("<li>" + item + "</li>");
                                }
                                out.print("</ul>");
                            }
                        } else {
                            out.print(value);
                        }
                    %>
                </td>
            </tr>
        <%
            }
        %>
    </table>
<br/>
<a href="<%= request.getContextPath() %>/TestClass/formMap">Retour au formulaire</a>