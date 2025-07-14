<%-- 
    Document   : disponibilidad_mesas
    Created on : 28/06/2025, 08:36:12 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Estilo -->
<style>
    .content {
        padding: 40px;
        background-color: #f7f6fb;
        font-family: 'Segoe UI', sans-serif;
    }

    h1 {
        color: #5D3A9B;
        margin-bottom: 20px;
        text-align: center;
    }

    form {
        text-align: center;
        margin-bottom: 30px;
    }

    input[type="date"] {
        padding: 10px;
        border-radius: 6px;
        border: 1px solid #ccc;
        font-size: 15px;
    }

    button {
        padding: 10px 18px;
        background-color: #C3A7D9;
        color: black;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: bold;
        margin-left: 10px;
    }

    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0 10px;
    }

    th {
        background-color: #BFA2DB;
        color: black;
        padding: 14px;
        text-align: center;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
    }

    td {
        background-color: black;
        padding: 14px;
        text-align: center;
        font-size: 15px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        color: white;
    }

    tr.disponible td {
        background-color: #D9F7BE;
        color: black;
    }

    tr.reservada td {
        background-color: #FFD6D6;
        color: black;
    }

    .mensaje {
        font-weight: bold;
        margin-top: 20px;
        text-align: center;
        font-size: 16px;
    }

    .mensaje.error {
        color: red;
    }

    .mensaje.success {
        color: green;
    }
</style>

<!-- CONTENIDO -->
<div class="content">
    <h1>📌 Disponibilidad de Mesas</h1>

    <!-- Formulario para seleccionar fecha -->
    <form method="get" action="controller">
        <input type="hidden" name="op" value="disponibilidadmesas" />
        <input type="date" name="fecha" value="${param.fecha}" required />
        <button type="submit">🔍 Consultar</button>
    </form>

    <!-- Conexión a base de datos -->
    <sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
        user="root" password="" />

    <!-- Consultar mesas disponibles para la fecha -->
    <c:if test="${not empty param.fecha}">
        <sql:query var="mesas" dataSource="${db}">
    SELECT m.id_mesa, m.numero_mesa,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM reserva r 
                WHERE r.id_mesa = m.id_mesa 
                AND DATE(r.fecha) = ?
                AND r.estado = 'Pendiente'
            ) 
            OR EXISTS (
                SELECT 1 FROM pedido p 
                WHERE p.id_mesa = m.id_mesa 
                AND DATE(p.fecha) = ?
                AND p.estado = 'En curso'
            )
            THEN 'Reservada'
            ELSE 'Disponible'
        END AS estado
    FROM mesa m
    ORDER BY m.numero_mesa
    <sql:param value="${param.fecha}" />
    <sql:param value="${param.fecha}" />
</sql:query>


        <c:set var="totalDisponibles" value="0" />
        <c:set var="totalReservadas" value="0" />

        <c:forEach var="m" items="${mesas.rows}">
            <c:if test="${m.estado == 'Disponible'}">
                <c:set var="totalDisponibles" value="${totalDisponibles + 1}" />
            </c:if>
            <c:if test="${m.estado == 'Reservada'}">
                <c:set var="totalReservadas" value="${totalReservadas + 1}" />
            </c:if>
        </c:forEach>

        <!-- Mensaje -->
        <c:if test="${fn:length(mesas.rows) == 0}">
            <p class="mensaje error">❌ No hay mesas registradas.</p>
        </c:if>

        <c:if test="${fn:length(mesas.rows) > 0}">
            <p class="mensaje success">✅ Mesas disponibles: ${totalDisponibles} / Total: ${fn:length(mesas.rows)}</p>

            <!-- Tabla -->
            <table>
                <tr>
                    <th>ID</th>
                    <th>Número</th>
                    <th>Estado</th>
                </tr>
                <c:forEach var="m" items="${mesas.rows}">
                    <tr class="${m.estado == 'Disponible' ? 'disponible' : 'reservada'}">
                        <td>${m.id_mesa}</td>
                        <td>Mesa ${m.numero_mesa}</td>
                        <td>${m.estado}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
    </c:if>

    <!-- Si aún no se ha seleccionado fecha -->
    <c:if test="${empty param.fecha}">
        <p class="mensaje">🗓️ Por favor, selecciona una fecha para consultar la disponibilidad.</p>
    </c:if>
</div>
