<%-- 
    Document   : editar_reserva
    Created on : 28/06/2025, 04:32:57 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background-color: #f6f5fa;
    }

    h1 {
        color: #5D3A9B;
        text-align: center;
        margin-top: 30px;
        margin-bottom: 20px;
    }

    .editar-form {
        background-color: #DBCFDB;
        width: 55%;
        margin: 0 auto;
        padding: 35px;
        border-radius: 12px;
        box-shadow: 0 6px 14px rgba(0,0,0,0.1);
    }

    .editar-form label {
        display: block;
        margin-top: 20px;
        font-weight: bold;
        color: #444;
        font-size: 15px;
    }

    .editar-form input,
    .editar-form select {
        padding: 12px;
        width: 100%;
        border: 1px solid #ccc;
        border-radius: 8px;
        margin-top: 8px;
        font-size: 14px;
        background-color: #fefefe;
    }

    .editar-form input:focus,
    .editar-form select:focus {
        border-color: #C3A7D9;
        outline: none;
        box-shadow: 0 0 4px rgba(195, 167, 217, 0.5);
    }

    .editar-form button {
        margin-top: 30px;
        padding: 14px 20px;
        background-color: #C3A7D9;
        color: #2c2c2c;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        transition: background-color 0.3s ease;
        width: 100%;
    }

    .editar-form button:hover {
        background-color: #b094ca;
    }
    .btn-cancelar {
        display: inline-block;
        margin-top: 15px;
        text-align: center;
        padding: 12px 252px;
        background-color: #f8d7da;
        color: #721c24;
        font-weight: bold;
        border-radius: 8px;
        text-decoration: none;
        transition: background-color 0.3s ease;
    }

    .btn-cancelar:hover {
        background-color: #f5c6cb;
    }
</style>

<div class="content">
    <h1>✏️ Editar Reserva</h1>

    <sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
        user="root" password="" />

    <!-- Datos actuales -->
    <sql:query dataSource="${db}" var="reserva">
        SELECT * FROM reserva WHERE id_reserva = ?
        <sql:param value="${param.id}" />
    </sql:query>

    <c:set var="mesaActual" value="${reserva.rows[0].id_mesa}" />

    <sql:query var="mesas" dataSource="${db}">
    SELECT id_mesa, numero_mesa
    FROM mesa
    WHERE (
        id_mesa NOT IN (
            SELECT id_mesa FROM reserva 
            WHERE DATE(fecha) = ? AND estado = 'Pendiente' AND id_reserva != ?
        )
        AND id_mesa NOT IN (
            SELECT id_mesa FROM pedido 
            WHERE DATE(fecha) = ? AND estado = 'En curso'
        )
    )
    OR id_mesa = ?
    ORDER BY numero_mesa
    <sql:param value="${param.fecha}" />
    <sql:param value="${param.id}" />
    <sql:param value="${param.fecha}" />
    <sql:param value="${reserva.rows[0].id_mesa}" />
</sql:query>





    <!-- Guardar cambios -->
    <c:if test="${param.actualizar eq 'true'}">

        <!-- Liberar mesa anterior si se cambió -->
        <c:if test="${param.id_mesa ne mesaActual}">
            <sql:update dataSource="${db}">
                UPDATE mesa SET estado = 'Disponible' WHERE id_mesa = ?
                <sql:param value="${mesaActual}" />
            </sql:update>
        </c:if>

        <!-- Actualizar reserva -->
        <sql:update dataSource="${db}">
            UPDATE reserva
            SET id_mesa = ?, fecha = ?, cantidad_personas = ?
            WHERE id_reserva = ?
            <sql:param value="${param.id_mesa}" />
            <sql:param value="${param.fecha}" />
            <sql:param value="${param.cantidad}" />
            <sql:param value="${param.id}" />
        </sql:update>

        <!-- Reservar nueva mesa -->
        <sql:update dataSource="${db}">
            UPDATE mesa SET estado = 'Reservada' WHERE id_mesa = ?
            <sql:param value="${param.id_mesa}" />
        </sql:update>

        <!-- Volver al listado con plantilla -->
        <c:redirect url="controller?op=dolistadoreservas" />
    </c:if>

    <!-- 🔍 Formulario para buscar mesas disponibles por fecha -->
<!-- 🔍 Formulario para buscar mesas disponibles por fecha -->
<form method="get" action="controller" class="editar-form">
    <input type="hidden" name="op" value="editarreserva" />
    <input type="hidden" name="id" value="${param.id}" />
    
    <label>Fecha:</label>
    <input type="date" name="fecha"
           value="${param.fecha != null ? param.fecha : fn:substring(reserva.rows[0].fecha, 0, 10)}" required />
    
    <button type="submit">🔍 Ver mesas disponibles</button>
</form>
<br><br>

<!-- ✏️ Formulario para editar reserva -->
<form method="post" action="editar_reserva.jsp?id=${param.id}" class="editar-form">
    <label>Cantidad de Personas:</label>
    <input type="number" name="cantidad" value="${reserva.rows[0].cantidad_personas}" required />

    <label>Mesa:</label>
    <select name="id_mesa" required>
        <c:forEach var="m" items="${mesas.rows}">
            <option value="${m.id_mesa}" ${m.id_mesa == mesaActual ? 'selected' : ''}>
                Mesa ${m.numero_mesa}
            </option>
        </c:forEach>
    </select>

    <!-- Fecha oculta si ya fue seleccionada -->
    <input type="hidden" name="fecha" value="${param.fecha != null ? param.fecha : fn:substring(reserva.rows[0].fecha, 0, 10)}" />
    <input type="hidden" name="id" value="${param.id}" />
    <input type="hidden" name="actualizar" value="true" />

    <button type="submit">✅ Actualizar Reserva</button>
    <a href="controller?op=dolistadoreservas" class="btn-cancelar">❌ Cancelar</a>

</form>

</div>
