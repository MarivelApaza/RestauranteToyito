<%-- 
    Document   : editar_boleta
    Created on : 30/06/2025, 10:09:49 AM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<style>
    .formulario-editar-boleta {
        font-family: 'Segoe UI', sans-serif;
    }

    .formulario-editar-boleta h2,
    .formulario-editar-boleta h3 {
        color: #5D3A9B;
    }

    .formulario-editar-boleta #zonaBoleta {
        background-color: #ffffff;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        max-width: 800px;
        margin: auto;
        margin-bottom: 30px;
    }

    .formulario-editar-boleta table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        font-size: 14px;
    }

    .formulario-editar-boleta table th {
        background-color: #C3A7D9;
        color: white;
        padding: 10px;
    }

    .formulario-editar-boleta table td {
        padding: 10px;
        border-bottom: 1px solid #ddd;
        text-align: center;
    }

    .formulario-editar-boleta form {
        max-width: 800px;
        margin: auto;
        padding: 20px;
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }

    .formulario-editar-boleta label {
        font-weight: bold;
        display: block;
        margin-top: 15px;
        margin-bottom: 5px;
    }

    .formulario-editar-boleta select {
        width: 100%;
        padding: 10px;
        border-radius: 6px;
        border: 1px solid #ccc;
        font-size: 14px;
    }

    .formulario-editar-boleta button {
        margin-top: 20px;
        margin-right: 10px;
        padding: 10px 18px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: bold;
        font-size: 14px;
    }

    .formulario-editar-boleta button[type="submit"] {
        background-color: #f5c518;
        color: #2c2c2c;
    }

    .formulario-editar-boleta button[type="button"] {
        background-color: #e0e0e0;
    }

    .formulario-editar-boleta button:hover {
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


<h2 style="text-align: center;">✏️ Editar Boleta</h2>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<sql:query var="boleta" dataSource="${db}">
    SELECT b.id_boleta, b.total, b.estado, b.id_metodo_pago, b.id_pedido,
           c.nombre, c.apellidos, c.dni, p.fecha
    FROM boleta_de_pago b
    JOIN pedido p ON b.id_pedido = p.id_pedido
    JOIN cliente c ON p.id_cliente = c.id_cliente
    WHERE b.id_boleta = ?
    <sql:param value="${param.id}" />
</sql:query>

<sql:query var="metodos" dataSource="${db}">
    SELECT id_metodo_pago, nombre_metodo FROM metodo_pago
</sql:query>

<c:forEach var="b" items="${boleta.rows}">
    <div class="formulario-editar-boleta"> 
    <div id="zonaBoleta">
        <h3>Boleta N° ${b.id_boleta}</h3>
        <p><strong>Cliente:</strong> ${b.nombre} ${b.apellidos}</p>
        <p><strong>DNI:</strong> ${b.dni}</p>
        <p><strong>Fecha del Pedido:</strong> ${b.fecha}</p>

        <sql:query var="detalles" dataSource="${db}">
            SELECT ca.nombre, dc.cantidad, ca.precio
            FROM pedido p
            JOIN comanda co ON co.id_pedido = p.id_pedido
            JOIN detalle_comanda dc ON dc.id_comanda = co.id_comanda
            JOIN carta ca ON ca.id_carta = dc.id_carta
            WHERE p.id_pedido = ?
            <sql:param value="${b.id_pedido}" />
        </sql:query>

        <table>
            <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio</th>
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
                <td colspan="3" style="text-align: right;"><strong>Total:</strong></td>
                <td><strong>S/ ${total}</strong></td>
            </tr>
        </table>
    </div>

    <form action="controller?op=actualizarboleta" method="post">
        <input type="hidden" name="id_boleta" value="${b.id_boleta}" />
        <input type="hidden" name="total" value="${total}" />

        <label>Estado:</label>
        <select name="estado" required>
            <option value="Pendiente" ${b.estado == 'Pendiente' ? 'selected' : ''}>Pendiente</option>
            <option value="Pagado" ${b.estado == 'Pagado' ? 'selected' : ''}>Pagado</option>
        </select>

        <label>Método de Pago:</label>
        <select name="id_metodo_pago" required>
            <c:forEach var="m" items="${metodos.rows}">
                <option value="${m.id_metodo_pago}" ${b.id_metodo_pago == m.id_metodo_pago ? 'selected' : ''}>
                    ${m.nombre_metodo}
                </option>
            </c:forEach>
        </select>

        <button type="submit">💾 Guardar Cambios</button>
        <button type="button" onclick="window.location.href='controller?op=verboletas'">❌ Cancelar</button>
        <button type="button" onclick="imprimirBoleta()">🖨️ Imprimir</button>
    </form>
            </div> 
</c:forEach>

<script>
    function imprimirBoleta() {
        window.print();
    }
</script>
