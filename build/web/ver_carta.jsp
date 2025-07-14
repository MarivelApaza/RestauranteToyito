<%-- 
    Document   : ver_carta
    Created on : 29/06/2025, 04:25:55 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<div class="carta-wrapper">
    <h1>📋 Productos Disponibles en la Carta</h1>

    <sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
                       url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
                       user="root" password="" />

    <sql:query var="productos" dataSource="${db}">
        SELECT c.id_carta, c.nombre, c.descripcion, c.precio, cat.nombre_categoria
        FROM carta c
        JOIN categoria cat ON c.id_categoria = cat.id_categoria
        ORDER BY c.id_carta DESC
    </sql:query>

    <c:choose>
        <c:when test="${not empty productos.rows}">
            <table class="tabla-carta">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Precio (S/.)</th>
                        <th>Categoría</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${productos.rows}">
                        <tr>
                            <td>${p.id_carta}</td>
                            <td>${p.nombre}</td>
                            <td class="desc">${p.descripcion}</td>
                            <td>S/ ${p.precio}</td>
                            <td>${p.nombre_categoria}</td>
                            <td class="acciones">
                                <a href="controller?op=editarcarta&id=${p.id_carta}" class="btn btn-editar">✏️</a>
                                <a href="controller?op=eliminarcarta&id=${p.id_carta}"
                                   onclick="return confirm('¿Eliminar este producto?')"
                                   class="btn btn-eliminar">🗑️</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <p class="no-data">⚠️ No hay productos registrados actualmente en la carta.</p>
        </c:otherwise>
    </c:choose>
</div>

<style>
.carta-wrapper {
    padding: 30px;
    font-family: 'Segoe UI', sans-serif;
    background-color: #f9f9fb;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    margin: auto;
    max-width: 1200px;
}

.carta-wrapper h1 {
    text-align: center;
    color: #5D3A9B;
    margin-bottom: 25px;
}

.tabla-carta {
    width: 100%;
    border-collapse: collapse;
    background-color: #fff;
    border-radius: 10px;
    overflow: hidden;
}

.tabla-carta th {
    background-color: #C3A7D9;
    color: white;
    padding: 12px;
    font-weight: bold;
    text-align: center;
}

.tabla-carta td {
    padding: 12px;
    text-align: center;
    border-bottom: 1px solid #eee;
}

.tabla-carta td.desc {
    max-width: 280px;
    text-align: left;
    white-space: pre-wrap;
    word-wrap: break-word;
}

.tabla-carta tr:hover {
    background-color: #f4f2f7;
}

.acciones {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.btn {
    padding: 6px 10px;
    border: none;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
    text-decoration: none;
    font-size: 14px;
}

.btn-editar {
    background-color: #b4e3c4;
    color: #2c2c2c;
}

.btn-eliminar {
    background-color: #efb3b3;
    color: #2c2c2c;
}

.btn-editar:hover {
    background-color: #a1d4b4;
}

.btn-eliminar:hover {
    background-color: #e29292;
}

.no-data {
    color: #b30000;
    font-style: italic;
    text-align: center;
    margin-top: 20px;
}
</style>
