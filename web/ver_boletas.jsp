<%-- 
    Document   : ver_boletas
    Created on : 30/06/2025, 09:16:12 AM
    Author     : Windows
--%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<style>
    .tabla-boletas {
        width: 100%;
        border-collapse: collapse;
        margin-top: 30px;
        background-color: #fff;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        border-radius: 8px;
        overflow: hidden;
    }

    .tabla-boletas th, .tabla-boletas td {
        padding: 12px 15px;
        text-align: center;
        border-bottom: 1px solid #ddd;
    }

    .tabla-boletas th {
        background-color: #C3A7D9;
        color: white;
        font-weight: bold;
    }

    .tabla-boletas tr:hover {
        background-color: #f9f9f9;
    }

    .acciones a {
        padding: 6px 10px;
        margin: 0 4px;
        border-radius: 5px;
        font-size: 14px;
        text-decoration: none;
        font-weight: bold;
    }

    .acciones a:first-child {
        background-color: #AED581; /* verde claro */
        color: black;
    }

    .acciones a:last-child {
        background-color: #EF9A9A; /* rojo claro */
        color: black;
    }

    .acciones a:hover {
        opacity: 0.85;
    }

    h2 {
        color: #5D3A9B;
        margin-bottom: 20px;
    }
</style>

<h2>📄 Boletas Emitidas</h2>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<sql:query var="boletas" dataSource="${db}">
    SELECT b.id_boleta, b.fecha, b.total, b.estado,
           mp.nombre_metodo,
           c.nombre, c.apellidos
    FROM boleta_de_pago b
    JOIN pedido p ON b.id_pedido = p.id_pedido
    JOIN cliente c ON p.id_cliente = c.id_cliente
    JOIN metodo_pago mp ON b.id_metodo_pago = mp.id_metodo_pago
    ORDER BY b.id_boleta DESC
</sql:query>

<table class="tabla-boletas">
    <tr>
        <th>ID Boleta</th>
        <th>Cliente</th>
        <th>Fecha</th>
        <th>Total</th>
        <th>Estado</th>
        <th>Método de Pago</th>
        <th>Acciones</th>
    </tr>

    <c:forEach var="b" items="${boletas.rows}">
        <tr>
            <td>${b.id_boleta}</td>
            <td>${b.nombre} ${b.apellidos}</td>
            <td>${b.fecha}</td>
            <td>S/ ${b.total}</td>
            <td>${b.estado}</td>
            <td>${b.nombre_metodo}</td>
            <td class="acciones">
                <a href="controller?op=editarboleta&id=${b.id_boleta}">✏️ Editar</a>
                <a href="controller?op=eliminarboleta&id=${b.id_boleta}" onclick="return confirm('¿Seguro que deseas eliminar esta boleta?');">🗑️ Eliminar</a>
            </td>
        </tr>
    </c:forEach>
</table>
