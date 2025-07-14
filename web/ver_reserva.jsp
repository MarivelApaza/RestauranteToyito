<%-- 
    Document   : ver_reserva
    Created on : 28/06/2025, 01:38:59 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background-color: #f6f5fa;
    }

    h1 {
        color: #5D3A9B;
        text-align: center;
        margin-bottom: 30px;
    }

    .tabla-reservas {
        width: 100%;
        border-collapse: collapse;
        background-color: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 6px 14px rgba(0, 0, 0, 0.1);
    }

    .tabla-reservas th {
        background-color: #C3A7D9;
        color: black;
        padding: 14px;
        font-size: 15px;
        text-transform: uppercase;
    }

    .tabla-reservas td {
        padding: 14px;
        text-align: center;
        border-bottom: 1px solid #eee;
        font-size: 14px;
        color: #333;
    }

    .tabla-reservas tr:hover {
        background-color: #f2e7fb;
    }

    .acciones {
        display: flex;
        justify-content: center;
        gap: 10px;
    }

    .btn {
        padding: 6px 14px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        text-decoration: none;
        font-weight: bold;
        transition: 0.3s;
    }

    .btn-editar {
        background-color: #A5E6CF;
        color: #004d40;
    }

    .btn-editar:hover {
        background-color: #8bd6be;
    }

    .btn-eliminar {
        background-color: #F7A5A5;
        color: #7b1e1e;
    }

    .btn-eliminar:hover {
        background-color: #ef8d8d;
    }

    .no-data {
        margin-top: 20px;
        color: #cc0000;
        font-style: italic;
        text-align: center;
    }
</style>

<h1>📝 Lista de Reservas</h1>


<c:if test="${sessionScope.tipoUsuario eq 'cliente' and empty sessionScope.id_cliente}">
    <p style="color:red;">Sesión inválida. Vuelve a iniciar sesión.</p>
    <c:redirect url="login_cliente.xhtml" />
</c:if>

<!-- Conexión a la base de datos -->
<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<!-- Consulta SQL -->
<c:choose>
    <%-- CLIENTE --%>
    
    <c:when test="${sessionScope.tipoUsuario eq 'cliente'}">
        <sql:query dataSource="${db}" var="reservas">
            SELECT r.id_reserva, r.fecha, r.cantidad_personas, r.estado, m.numero_mesa
            FROM reserva r
            JOIN mesa m ON r.id_mesa = m.id_mesa
            WHERE r.id_cliente = ?
            ORDER BY r.fecha DESC
            <sql:param value="${sessionScope.id_cliente}" />
        </sql:query>
    </c:when>

    <%-- EMPLEADO --%>
    <c:otherwise>
        <sql:query dataSource="${db}" var="reservas">
            SELECT r.id_reserva, c.nombre AS nombre_cliente, r.fecha, r.cantidad_personas, r.estado, m.numero_mesa
            FROM reserva r
            JOIN cliente c ON r.id_cliente = c.id_cliente
            JOIN mesa m ON r.id_mesa = m.id_mesa
            ORDER BY r.fecha DESC
        </sql:query>
    </c:otherwise>
</c:choose>

<!-- Mostrar resultados -->
<c:choose>
    <c:when test="${not empty reservas.rows}">
        <table class="tabla-reservas">
            <tr>
                <th>ID</th>
                <c:if test="${sessionScope.tipoUsuario eq 'empleado'}">
                    <th>Cliente</th>
                </c:if>
                <th>Fecha</th>
                <th>Personas</th>
                <th>Mesa</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
            <c:forEach var="r" items="${reservas.rows}">
                <tr>
                    <td>${r.id_reserva}</td>
                    <c:if test="${sessionScope.tipoUsuario eq 'empleado'}">
                        <td>${r.nombre}</td>
                    </c:if>
                    <td>${r.fecha}</td>
                    <td>${r.cantidad_personas}</td>
                    <td>${r.numero_mesa}</td>
                    <td>${r.estado}</td>
                    <td class="acciones">
                        <a href="controller?op=editarreserva&id=${r.id_reserva}" class="btn btn-editar">Editar</a>
                        <a href="controller?op=eliminarreserva&id=${r.id_reserva}"
                            onclick="return confirm('¿Eliminar esta reserva?')"
                            class="btn btn-eliminar">Eliminar</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        <p class="no-data">No hay reservas registradas.</p>
    </c:otherwise>
</c:choose>
