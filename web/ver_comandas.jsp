<%-- 
    Document   : ver_comandas
    Created on : 29/06/2025, 04:07:44 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<h2>📋 Lista de Comandas Registradas</h2>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<sql:query var="comandas" dataSource="${db}">
    SELECT 
        p.id_pedido, c.nombre AS nombre_cliente, c.apellidos, 
        m.numero_mesa, p.fecha AS fecha_pedido, p.estado AS estado_pedido,
        co.id_comanda, co.fecha AS fecha_comanda,
        ca.nombre AS nombre_producto, dc.cantidad, dc.observaciones
    FROM pedido p
    JOIN cliente c ON p.id_cliente = c.id_cliente
    JOIN mesa m ON p.id_mesa = m.id_mesa
    JOIN comanda co ON co.id_pedido = p.id_pedido
    JOIN detalle_comanda dc ON dc.id_comanda = co.id_comanda
    JOIN carta ca ON dc.id_carta = ca.id_carta
    ORDER BY p.id_pedido DESC, co.id_comanda
</sql:query>


<style>
    body {
        font-family: 'Segoe UI', sans-serif;
    }

    h2 {
        text-align: center;
        color: #5D3A9B;
        margin-top: 30px;
    }

    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0 8px;
        margin-top: 30px;
        background-color: transparent;
    }

    th {
        background-color: #C3A7D9;
        color: #black;
        padding: 14px;
        text-align: center;
        border-radius: 10px 10px 0 0;
        font-size: 15px;
    }

    td {
        background-color: white;
        padding: 12px 14px;
        text-align: center;
        border-bottom: 1px solid #ddd;
        font-size: 14px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
    }

    .pedido-header {
        background-color: #F1E5FC;
        font-weight: bold;
        font-size: 15px;
        text-align: left;
        padding: 14px 18px;
        border-radius: 8px;
        color: #4A235A;
    }

    .comanda-header {
        background-color: #EFEFEF;
        font-style: italic;
        padding: 12px 16px;
        text-align: left;
        border-radius: 8px;
        color: #333;
        position: relative;
    }

    .acciones {
        margin-top: 6px;
    }

    .btn {
        padding: 6px 14px;
        margin: 4px 2px;
        border: none;
        border-radius: 5px;
        font-size: 13px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
    }

    .btn-editar {
        background-color: #6EC177;
        color: white;
    }

    .btn-editar:hover {
        background-color: #58a960;
    }

    .btn-eliminar {
        background-color: #E57373;
        color: white;
    }

    .btn-eliminar:hover {
        background-color: #d35454;
    }

    .sin-datos {
        margin-top: 30px;
        text-align: center;
        font-style: italic;
        color: #d32f2f;
        font-size: 16px;
    }
</style>


<c:choose>
    <c:when test="${not empty comandas.rows}">
        <c:set var="pedidoAnterior" value="-1" />
        <c:set var="comandaAnterior" value="-1" />

        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Observaciones</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="row" items="${comandas.rows}">
                <!-- Nuevo Pedido -->
                <c:if test="${pedidoAnterior ne row.id_pedido}">
                    <tr>
                        <td colspan="4" class="pedido-header">
                            🧾 Pedido #${row.id_pedido} | Cliente: ${row.nombre_cliente} ${row.apellidos} 
                            | Mesa: ${row.numero_mesa} | Fecha: ${row.fecha} | Estado: ${row.estado}
                        </td>
                    </tr>
                    <c:set var="pedidoAnterior" value="${row.id_pedido}" />
                    <c:set var="comandaAnterior" value="-1" />
                </c:if>

                <!-- Nueva Comanda -->
                <c:if test="${comandaAnterior ne row.id_comanda}">
                    <tr>
                        <td colspan="4" class="comanda-header">
                            🕒 Comanda #${row.id_comanda} | Fecha: ${row.fecha}
                            <div class="acciones">
                                <a href="controller?op=editarcomanda&id_comanda=${row.id_comanda}" class="btn btn-editar">✏️ Editar</a>


                                <a href="controller?op=eliminarcomanda&id_comanda=${row.id_comanda}" 
                                   onclick="return confirm('¿Estás seguro de eliminar esta comanda?')" 
                                   class="btn btn-eliminar">🗑️ Eliminar</a>
                            </div>
                        </td>
                    </tr>
                    <c:set var="comandaAnterior" value="${row.id_comanda}" />
                </c:if>

                <!-- Detalle del producto -->
                <tr>
                    <td>${row.nombre}</td>
                    <td>${row.cantidad}</td>
                    <td>${row.observaciones}</td>
                    <td></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <p class="sin-datos">⚠️ No hay comandas registradas.</p>
    </c:otherwise>
</c:choose>


