<%-- 
    Document   : dashboard
    Created on : 28/06/2025, 02:40:01 PM
    Author     : Windows
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<!-- Consultas solo si es empleado -->
<c:if test="${sessionScope.tipoUsuario eq 'empleado'}">
    <sql:query var="ventasHoy" dataSource="${db}">
        SELECT COUNT(*) AS total FROM boleta_de_pago 
        WHERE DATE(fecha) = CURDATE() AND estado = 'Pagado'
    </sql:query>

    <sql:query var="mesasDisponibles" dataSource="${db}">
        SELECT COUNT(*) AS total FROM mesa WHERE estado = 'Disponible'
    </sql:query>

    <sql:query var="pedidosHoy" dataSource="${db}">
        SELECT COUNT(*) AS total FROM pedido WHERE DATE(fecha) = CURDATE()
    </sql:query>

    <sql:query var="usuarios" dataSource="${db}">
        SELECT 
            (SELECT COUNT(*) FROM cliente) + 
            (SELECT COUNT(*) FROM usuario) AS total
    </sql:query>
</c:if>

<div class="content">
    <h1 style="font-family: 'Poppins', sans-serif; color: #6b3e26; font-size: 36px;">
        ¡Bienvenido, ${sessionScope.nombreUsuario}!
    </h1>

    <div class="dashboard-container">
        <!-- Panel para cliente -->
        <c:if test="${sessionScope.tipoUsuario eq 'cliente'}">
    <a href="controller?op=dolistadoreservas" class="card card-link" style="background-color: #B2DAF0;">
        <div class="icon">🛎️</div>
        <div class="label">Tus Reservas</div>
        <div class="value">Revisa tus reservas</div>
    </a>

    <a href="controller?op=docartaconsumocliente" class="card card-link" style="background-color: #A3D5E0;">
        <div class="icon">🍽️</div>
        <div class="label">Menú</div>
        <div class="value">Explora nuestros platos</div>
    </a>

    <a href="controller?op=donuevareserva" class="card card-link" style="background-color: #C3E8E0;">
        <div class="icon">📅</div>
        <div class="label">Reservar</div>
        <div class="value">¡Haz tu próxima reserva!</div>
    </a>
</c:if>


        <!-- Panel para empleados -->
        <c:if test="${sessionScope.tipoUsuario eq 'empleado'}">
            <div class="card" style="background-color: #9E8FB2;">
                <div class="icon">🍽️</div>
                <div class="label">Ventas del Día</div>
                <div class="value">${ventasHoy.rows[0].total}</div>
            </div>

            <div class="card" style="background-color: #B9ACC4;">
                <div class="icon">🍷</div>
                <div class="label">Mesas Disponibles</div>
                <div class="value">${mesasDisponibles.rows[0].total}</div>
            </div>

            <div class="card" style="background-color: #C8B6A6;">
                <div class="icon">📖</div>
                <div class="label">Pedidos Hoy</div>
                <div class="value">${pedidosHoy.rows[0].total}</div>
            </div>

            <div class="card" style="background-color: #A6C8B6;">
                <div class="icon">👤</div>
                <div class="label">Usuarios Totales</div>
                <div class="value">${usuarios.rows[0].total}</div>
            </div>
            
        </c:if>
    </div>
</div>

<style>
    .dashboard-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin-top: 30px;
    }

    .card {
        flex: 1 1 220px;
        padding: 20px;
        border-radius: 10px;
        color: white;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        text-align: center;
    }

    .card .icon {
        font-size: 36px;
        margin-bottom: 10px;
    }

    .card .label {
        font-size: 16px;
        margin-bottom: 8px;
    }

    .card .value {
        font-size: 20px;
        font-weight: bold;
    }
    .card-link {
    text-decoration: none;
    color: black;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.card-link:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 14px rgba(0, 0, 0, 0.2);
}
</style>
