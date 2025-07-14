<%-- 
    Document   : registrar_pedido_completo
    Created on : 29/06/2025, 04:06:10 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<!-- 1. Formulario para seleccionar fecha -->
<div class="registrar-pedido">
    <h2>🍽️ Registrar Pedido Completo</h2>

    <form method="get" action="controller">
        <input type="hidden" name="op" value="registrarpedido" />
        <label>Selecciona una fecha:</label>
        <input type="date" name="fecha" value="${param.fecha}" required />
        <button type="submit">Buscar mesas</button>
    </form>
</div>

<!-- 2. Consultas según la fecha seleccionada -->
<c:if test="${not empty param.fecha}">

<!-- Mesas reservadas para la fecha seleccionada -->
<sql:query var="mesasReservadas" dataSource="${db}">
    SELECT DISTINCT m.id_mesa, m.numero_mesa
    FROM mesa m
    JOIN reserva r ON m.id_mesa = r.id_mesa
    WHERE r.estado = 'Pendiente'
    AND DATE(r.fecha) = ?
    AND NOT EXISTS (
        SELECT 1 FROM pedido p
        WHERE p.id_mesa = m.id_mesa
        AND DATE(p.fecha) = ?
        AND p.estado = 'En curso'
    )
    <sql:param value="${param.fecha}" />
    <sql:param value="${param.fecha}" />
</sql:query>


<sql:query var="mesasLibres" dataSource="${db}">
    SELECT m.id_mesa, m.numero_mesa
    FROM mesa m
    WHERE NOT EXISTS (
        SELECT 1 FROM reserva r 
        WHERE r.id_mesa = m.id_mesa 
        AND DATE(r.fecha) = ?
        AND r.estado = 'Pendiente'
    )
    AND NOT EXISTS (
        SELECT 1 FROM pedido p 
        WHERE p.id_mesa = m.id_mesa 
        AND p.estado = 'En curso'
        AND DATE(p.fecha) = ?
    )
    <sql:param value="${param.fecha}" />
    <sql:param value="${param.fecha}" />
</sql:query>




    <!-- Cliente de la reserva -->
    <c:if test="${not empty param.id_mesa}">
        <sql:query var="clienteReserva" dataSource="${db}">
            SELECT cli.id_cliente, cli.nombre, cli.apellidos, cli.dni
            FROM reserva r
            JOIN cliente cli ON r.id_cliente = cli.id_cliente
            WHERE r.id_mesa = ? AND DATE(r.fecha) = ? AND r.estado = 'Pendiente'
            <sql:param value="${param.id_mesa}" />
            <sql:param value="${param.fecha}" />
        </sql:query>
    </c:if>

    <!-- Lista de clientes -->
    <sql:query var="clientesRegistrados" dataSource="${db}">
        SELECT id_cliente, nombre, apellidos FROM cliente
    </sql:query>
        

    <!-- Formulario completo -->
    <div class="registrar-pedido">
        <form method="get" action="controller">
            <input type="hidden" name="op" value="registrarpedido" />
            <input type="hidden" name="fecha" value="${param.fecha}" />
            <label>Selecciona una mesa:</label>
            <select name="id_mesa" onchange="this.form.submit()" required>
                <option value="">-- Mesa reservada o libre --</option>
                <optgroup label="🔒 Mesas reservadas">
                    <c:forEach var="m" items="${mesasReservadas.rows}">
                        <option value="${m.id_mesa}" <c:if test="${m.id_mesa == param.id_mesa}">selected</c:if>>
                            Mesa ${m.numero_mesa}
                        </option>
                    </c:forEach>
                </optgroup>
                <optgroup label="🟢 Mesas libres">
                    <c:forEach var="m" items="${mesasLibres.rows}">
                        <option value="${m.id_mesa}" <c:if test="${m.id_mesa == param.id_mesa}">selected</c:if>>
                            Mesa ${m.numero_mesa}
                        </option>
                    </c:forEach>
                </optgroup>
            </select>
        </form>

        <br/>

        <c:if test="${not empty param.id_mesa}">
            <form method="post" action="controller?op=guardarpedidocompleto" class="formulario-pedido">
                <input type="hidden" name="id_mesa" value="${param.id_mesa}" />
                <input type="hidden" name="fecha" value="${param.fecha}" />

                <!-- Cliente por reserva -->
                <c:if test="${not empty clienteReserva.rows}">
                    <input type="hidden" name="id_cliente" value="${clienteReserva.rows[0].id_cliente}" />
                    <label>Cliente:</label>
                    <input type="text" value="${clienteReserva.rows[0].nombre} ${clienteReserva.rows[0].apellidos}" disabled />
                </c:if>

                <!-- Cliente sin reserva -->
                <c:if test="${empty clienteReserva.rows}">
                    <label>Seleccionar cliente existente:</label>
                    <select name="id_cliente">
                        <option value="">-- Nuevo cliente --</option>
                        <c:forEach var="c" items="${clientesRegistrados.rows}">
                            <option value="${c.id_cliente}">${c.nombre} ${c.apellidos}</option>
                        </c:forEach>
                    </select>

                    <p><em>O registrar cliente nuevo:</em></p>
                    <label>Nombre:</label>
                    <input type="text" name="nombre_cliente" />
                    <label>Apellidos:</label>
                    <input type="text" name="apellidos_cliente" />
                    <label>DNI:</label>
                    <input type="text" name="dni_cliente" />
                </c:if>

                <!-- Productos -->
                <sql:query var="productos" dataSource="${db}">
                    SELECT c.id_carta, c.nombre, cat.nombre_categoria 
                    FROM carta c JOIN categoria cat ON c.id_categoria = cat.id_categoria
                </sql:query>

                <table id="comandas" class="tabla-comandas">
                    <thead>
                        <tr><th>Producto</th><th>Cantidad</th><th>Observaciones</th><th></th></tr>
                    </thead>
                    <tbody>
                        <tr class="comanda-group">
                            <td>
                                <select name="producto[]" required>
                                    <c:forEach var="p" items="${productos.rows}">
                                        <option value="${p.id_carta}">${p.nombre_categoria} - ${p.nombre}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td><input type="number" name="cantidad[]" min="1" required /></td>
                            <td><textarea name="observaciones[]" rows="2"></textarea></td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>

                <template id="plantillaComanda">
                    <tr class="comanda-group">
                        <td>
                            <select name="producto[]" required>
                                <c:forEach var="p" items="${productos.rows}">
                                    <option value="${p.id_carta}">${p.nombre_categoria} - ${p.nombre}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td><input type="number" name="cantidad[]" min="1" required /></td>
                        <td><textarea name="observaciones[]" rows="2"></textarea></td>
                        <td><button type="button" onclick="this.closest('tr').remove()">🗑️</button></td>
                    </tr>
                </template>

                <br/>
                <button type="button" onclick="agregarComanda()">➕ Añadir Comanda</button>
                <button type="submit">✅ Guardar Pedido y Comandas</button>
                <a href="controller?op=vercomandas" class="btn-cancelar">❌ Cancelar</a>
            </form>
        </c:if>
    </div>
</c:if>

<script>
function agregarComanda() {
    const plantilla = document.getElementById("plantillaComanda");
    const nuevaFila = plantilla.content.cloneNode(true);
    document.querySelector("#comandas tbody").appendChild(nuevaFila);
}
</script>

<style>
.registrar-pedido {
    font-family: 'Segoe UI', sans-serif;
    background-color: #f5f5f5;
    padding: 20px;
}
.registrar-pedido h2 {
    color: #5D3A9B;
    text-align: center;
    margin-bottom: 20px;
}
.registrar-pedido form {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.07);
    padding: 30px;
    margin: 20px auto;
    max-width: 1000px;
}
.registrar-pedido label {
    font-weight: bold;
    display: block;
    margin-top: 15px;
    color: #333;
}
.registrar-pedido input,
.registrar-pedido textarea,
.registrar-pedido select {
    width: 100%;
    padding: 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
    margin-top: 6px;
    font-size: 14px;
    box-sizing: border-box;
}
.tabla-comandas {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}
.tabla-comandas th {
    background-color: #C3A7D9;
    color: white;
    padding: 10px;
}
.tabla-comandas td {
    padding: 10px;
    border: 1px solid #ddd;
}
.registrar-pedido button {
    padding: 12px 20px;
    border: none;
    border-radius: 6px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
    margin-top: 20px;
    margin-right: 10px;
}
button[type="submit"] {
    background-color: #f5c518;
    color: #2c2c2c;
}
button[type="submit"]:hover {
    background-color: #e6b915;
}
button[type="button"] {
    background-color: #dcd0e8;
    color: #333;
}
button[type="button"]:hover {
    background-color: #cbb6de;
}
.btn-cancelar {
        display: inline-block;
        text-align: center;
        margin-top: 12px;
        padding: 12px 20px;
        font-size: 16px;
        background-color: #dbc8f0;
        color: #2c2c2c;
        font-weight: bold;
        border-radius: 8px;
        text-decoration: none;
        transition: background-color 0.3s ease;
    }

    .btn-cancelar:hover {
        background-color: #c3b2e2;
    }
</style>

