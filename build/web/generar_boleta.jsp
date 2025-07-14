<%-- 
    Document   : generar_boleta
    Created on : 30/06/2025, 08:41:59 AM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<style>
.generar-boleta-wrapper {
    font-family: 'Segoe UI', sans-serif;
    background-color: #f8f8f8;
    padding: 30px;
    max-width: 960px;
    margin: auto;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.generar-boleta-wrapper h2,
.generar-boleta-wrapper h3 {
    color: #5D3A9B;
    text-align: center;
}

.generar-boleta-wrapper label {
    font-weight: bold;
    display: block;
    margin-top: 15px;
}

.generar-boleta-wrapper select,
.generar-boleta-wrapper input {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    margin-top: 6px;
    border-radius: 6px;
}

.generar-boleta-wrapper table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 25px;
    background-color: #fff;
    border-radius: 8px;
    overflow: hidden;
}

.generar-boleta-wrapper th {
    background-color: #C3A7D9;
    color: white;
    padding: 10px;
    font-weight: bold;
}

.generar-boleta-wrapper td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
    text-align: center;
}

.generar-boleta-wrapper .button-group {
    margin-top: 20px;
}

.generar-boleta-wrapper button,
.generar-boleta-wrapper .button-cancel {
    padding: 10px 20px;
    margin-top: 15px;
    border: none;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
    font-size: 14px;
}

.generar-boleta-wrapper button[type="submit"] {
    background-color: #f5c518;
    color: #2c2c2c;
}

.generar-boleta-wrapper .button-cancel {
    background-color: #e74c3c;
    color: white;
    text-decoration: none;
}

.generar-boleta-wrapper button[type="button"] {
    background-color: #dcd0e8;
    color: #2c2c2c;
}

.generar-boleta-wrapper button:hover,
.generar-boleta-wrapper .button-cancel:hover {
    opacity: 0.9;
}

@media print {
    body * {
        visibility: hidden;
    }

    #zonaBoleta, #zonaBoleta * {
        visibility: visible;
    }

    #zonaBoleta {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
    }
}
</style>
<div class="generar-boleta-wrapper">

    <h2>🧾 Generar Boleta de Pago</h2>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<sql:query var="pedidos" dataSource="${db}">
    SELECT p.id_pedido, c.nombre AS cliente, m.numero_mesa, p.fecha
    FROM pedido p
    JOIN cliente c ON p.id_cliente = c.id_cliente
    JOIN mesa m ON p.id_mesa = m.id_mesa
    WHERE p.id_pedido NOT IN (SELECT id_pedido FROM boleta_de_pago)
</sql:query>

<sql:query var="metodos" dataSource="${db}">
    SELECT id_metodo_pago, nombre_metodo FROM metodo_pago
</sql:query>


<form method="get" action="controller">
    <input type="hidden" name="op" value="generarboleta" />
    <label>Seleccione Pedido:</label>
    <select name="id_pedido" required onchange="this.form.submit()">
        <option value="">-- Elegir pedido --</option>
        <c:forEach var="p" items="${pedidos.rows}">
            <option value="${p.id_pedido}" ${param.id_pedido == p.id_pedido ? "selected" : ""}>
                Pedido #${p.id_pedido} - ${p.cliente} - Mesa ${p.numero_mesa}
            </option>
        </c:forEach>
    </select>
</form>

<c:if test="${not empty param.id_pedido}">
    <div id="zonaBoleta">
        <h3>🍽 Restaurante El Toyito</h3>

        <sql:query var="mozo" dataSource="${db}">
            SELECT u.nombre, u.apellidos
            FROM comanda c
            JOIN usuario u ON c.id_usuario = u.id_usuario
            WHERE c.id_pedido = ?
              AND u.id_rol = 2
            <sql:param value="${param.id_pedido}" />
        </sql:query>

        <sql:query var="cliente" dataSource="${db}">
            SELECT c.nombre, c.apellidos, c.dni, p.fecha
            FROM pedido p
            JOIN cliente c ON p.id_cliente = c.id_cliente
            WHERE p.id_pedido = ?
            <sql:param value="${param.id_pedido}" />
        </sql:query>

        <c:forEach var="cli" items="${cliente.rows}">
            <p><strong>Cliente:</strong> ${cli.nombre} ${cli.apellidos}</p>
            <p><strong>DNI:</strong> ${cli.dni}</p>
            <p><strong>Fecha del pedido:</strong> ${cli.fecha}</p>
        </c:forEach>
         <c:forEach var="m" items="${mozo.rows}">
            <p><strong>Mozo:</strong> ${m.nombre} ${m.apellidos}</p>
        </c:forEach>



        <sql:query var="detalles" dataSource="${db}">
            SELECT ca.nombre, dc.cantidad, ca.precio
            FROM pedido p
            JOIN comanda co ON co.id_pedido = p.id_pedido
            JOIN detalle_comanda dc ON dc.id_comanda = co.id_comanda
            JOIN carta ca ON ca.id_carta = dc.id_carta
            WHERE p.id_pedido = ?
            <sql:param value="${param.id_pedido}" />
        </sql:query>

        <table>
            <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio Unitario</th>
                <th>Subtotal</th>
            </tr>
            <c:set var="total" value="0" />
            <c:forEach var="d" items="${detalles.rows}">
                <c:set var="subtotal" value="${d.cantidad * d.precio}" />
                <tr>
                    <td>${d.nombre}</td>
                    <td>${d.cantidad}</td>
                    <td>S/ ${d.precio}</td>
                    <td>S/ ${subtotal}</td>
                </tr>
                <c:set var="total" value="${total + subtotal}" />
            </c:forEach>
            <tr>
                <td colspan="3" align="right"><strong>Total:</strong></td>
                <td><strong>S/ ${total}</strong></td>
            </tr>
        </table>
    </div>

    <form method="post" action="controller?op=guardarboleta">
        <input type="hidden" name="id_pedido" value="${param.id_pedido}" />
        <input type="hidden" name="total" value="${total}" />

        <label>Método de pago:</label>
        <select name="id_metodo_pago" required>
            <option value="">-- Seleccione método --</option>
            <c:forEach var="m" items="${metodos.rows}">
                <option value="${m.id_metodo_pago}">${m.nombre_metodo}</option>
            </c:forEach>
        </select>

        <div class="button-group">
            <button type="submit">💾 Emitir Boleta</button>
            <a href="controller?op=generarboleta" class="button-cancel">❌ Cancelar</a>
            <button type="button" onclick="imprimirBoleta()">🖨️ Imprimir</button>
        </div>
    </form>
</c:if>

<script>
    function imprimirBoleta() {
        window.print();
    }
</script>

 </div>

