<%-- 
    Document   : nueva_reserva
    Created on : 28/06/2025, 03:21:34 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<!-- Registrar reserva -->
<c:if test="${param.registrar eq 'true'}">
    <sql:update dataSource="${db}">
        INSERT INTO reserva (id_cliente, id_mesa, fecha, cantidad_personas, estado)
        VALUES (?, ?, ?, ?, 'Pendiente')
        <sql:param value="${sessionScope.id_cliente}" />
        <sql:param value="${param.id_mesa}" />
        <sql:param value="${param.fecha}" />
        <sql:param value="${param.cantidad}" />
    </sql:update>
    <c:redirect url="controller?op=dolistadoreservas" />
</c:if>

<!-- Si ya seleccionó una fecha -->
<c:if test="${not empty param.fecha}">
    <sql:query var="mesas" dataSource="${db}">
    SELECT * FROM mesa 
    WHERE id_mesa NOT IN (
        SELECT id_mesa 
        FROM reserva 
        WHERE DATE(fecha) = ? 
        AND estado = 'Pendiente'
    )
    AND id_mesa NOT IN (
        SELECT id_mesa 
        FROM pedido 
        WHERE DATE(fecha) = ? 
        AND estado = 'En curso'
    )
    <sql:param value="${param.fecha}" />
    <sql:param value="${param.fecha}" />
</sql:query>

</c:if>

<style>
    .reserva {
        font-family: 'Segoe UI', sans-serif;
        background-color: #E6D1ED;
        padding: 40px;
        margin: 0 auto;
        max-width: 700px;
        border-radius: 12px;
        box-shadow: 0 0 12px rgba(0, 0, 0, 0.05);
    }

    .reserva h2 {
        color: #3498db;
        text-align: center;
        margin-bottom: 30px;
    }

    .reserva form {
        background-color: #ffffff;
        padding: 25px 30px;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .reserva label {
        font-weight: bold;
        display: block;
        margin-top: 15px;
        color: #2c3e50;
    }

    .reserva input,
    .reserva select {
        width: 100%;
        padding: 10px;
        margin-top: 6px;
        border-radius: 8px;
        border: 1px solid #b2bec3;
        font-size: 15px;
        background-color: #f9fcfd;
    }

    .reserva button {
        margin-top: 25px;
        padding: 12px;
        background-color: #64B5F6; /* celeste vivo */
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        transition: background-color 0.3s ease;
    }

    .reserva button:hover {
        background-color: #5D3A9B;
    }

    .mensaje {
        text-align: center;
        font-weight: bold;
        color: red;
        margin-top: 20px;
    }
</style>

<div class="reserva">
    <h2>📅 Nueva Reserva</h2>

    <!-- Formulario para seleccionar fecha -->
    <form method="get" action="controller">
        <input type="hidden" name="op" value="donuevareserva" />
        <label>Selecciona la fecha:</label>
        <input type="date" name="fecha" value="${param.fecha}" onchange="this.form.submit()" required />
    </form> <br><br>

    <!-- Si hay fecha seleccionada -->
    <c:if test="${not empty param.fecha}">
        <c:choose>
            <c:when test="${not empty mesas.rows}">
                <!-- Segundo formulario para cantidad y mesa -->
                <form method="post" action="nueva_reserva.jsp">
                    <input type="hidden" name="fecha" value="${param.fecha}" />

                    <label>Cantidad de Personas:</label>
                    <input type="number" name="cantidad" min="1" required />

                    <label>Mesa Disponible:</label>
                    <select name="id_mesa" required>
                        <c:forEach var="m" items="${mesas.rows}">
                            <option value="${m.id_mesa}">Mesa ${m.numero_mesa}</option>
                        </c:forEach>
                    </select>

                    <input type="hidden" name="registrar" value="true" />
                    <button type="submit">✅ Confirmar Reserva</button>
                </form>
            </c:when>

            <c:otherwise>
                <p class="mensaje">⚠ No hay mesas disponibles para esa fecha.</p>
            </c:otherwise>
        </c:choose>
    </c:if>
</div>
