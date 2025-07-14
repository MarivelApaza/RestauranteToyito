<%-- 
    Document   : barra.jsp
    Created on : 28/06/2025, 03:07:12 PM
    Author     : Windows
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>

    .sidebar {
        width: 250px;
        height: auto;
        background-color: #2c2c2c;
        color: white;
        padding: 5px 5px;
          box-sizing: border-box;
    min-height: 100vh;
    }

    .sidebar h4 {
        color: #f5c518;
        height: auto;
        margin-top: 20px;
        margin-bottom: 10px;
        font-size: 16px;
    }

    .menu-link {
        display: block;
        padding: 10px 15px;
        margin: 5px 0;
        background-color: #444;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        transition: 0.3s;
    }

    .menu-link:hover {
        background-color: #DECB8A;
        color: #000;
    }

    .logout-button {
        background-color: #e74c3c;
        border: none;
        padding: 8px 15px;
        margin-top: 20px;
        color: white;
        cursor: pointer;
        border-radius: 5px;
        width: 100%;
        font-weight: bold;
        transition: background-color 0.3s;
    }

    .logout-button:hover {
        background-color: #c0392b;
    }
</style>

<div class="sidebar">
    <a href="controller?op=dashboard" class="menu-link">Dashboard</a>

    <!-- CLIENTE -->
    <c:if test="${sessionScope.rolUsuario eq 'Cliente'}">
        <h4>RESERVAS</h4>
        <a href="controller?op=dolistadoreservas" class="menu-link">Ver Reservas</a>
        <a href="controller?op=donuevareserva" class="menu-link">Agregar Reserva</a>
        <a href="controller?op=docartaconsumocliente" class="menu-link">Carta Consumo</a>
    </c:if>

    <!-- EMPLEADOS -->
    <c:if test="${sessionScope.rolUsuario eq 'Maitre' || sessionScope.rolUsuario eq 'Mozo' || sessionScope.rolUsuario eq 'Cajero'}">
        <h4>RESERVAS</h4>
        <a href="controller?op=dolistadoreservas" class="menu-link">Ver Reservas</a>
        <a href="controller?op=disponibilidadmesas" class="menu-link">Disponibilidad de Mesas</a>

        <h4>PEDIDOS</h4>
        <a href="controller?op=vercomandas" class="menu-link">Ver Comandas</a>
        <a href="controller?op=registrarpedido" class="menu-link">Registrar Pedido</a>

        <h4>PAGOS</h4>
        <a href="controller?op=verboletas" class="menu-link">Ver Boletas</a>
        <a href="controller?op=generarboleta" class="menu-link">Boleta/Factura</a>

        <h4>MENÚ</h4>
        <a href="controller?op=vercarta" class="menu-link">Ver Carta</a>
        <a href="controller?op=agregarcarta" class="menu-link">Agregar Carta</a>

        <!-- SOLO MAITRE -->
        <c:if test="${sessionScope.rolUsuario eq 'Maitre'}">
            <h4>USUARIOS</h4>
            <a href="controller?op=verusuarios" class="menu-link">Ver Usuarios</a>
            <a href="controller?op=agregarusuario" class="menu-link">Agregar Usuario</a>
            
            <h4>REPORTES</h4>
            <a href="controller?op=reporteproductos" class="menu-link">Productos más vendidos</a>
            <a href="controller?op=reporteclientes" class="menu-link">Clientes más frecuentes</a>
            <a href="controller?op=reportecomandas" class="menu-link">Comandas por mozo</a>
            <a href="controller?op=reportepagos" class="menu-link">Pagos por método</a>
            <a href="controller?op=reportereservas" class="menu-link">Reservas realizadas</a>
        </c:if>
    </c:if>

</div>
