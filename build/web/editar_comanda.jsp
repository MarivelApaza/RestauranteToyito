<%-- 
    Document   : editar_comanda
    Created on : 30/06/2025, 07:23:46 AM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<h2>✏️ Editar Comanda</h2>

<!-- Conexión -->
<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<!-- Traer productos actuales -->
<sql:query var="detalles" dataSource="${db}">
    SELECT dc.id_carta, dc.cantidad, dc.observaciones, c.nombre
    FROM detalle_comanda dc
    JOIN carta c ON dc.id_carta = c.id_carta
    WHERE dc.id_comanda = ?
    <sql:param value="${id_comanda}" />
</sql:query>

<!-- Lista completa de productos -->
<sql:query var="productos" dataSource="${db}">
    SELECT id_carta, nombre FROM carta
</sql:query>

<form method="post" action="controller?op=actualizarcomanda" class="editar-comanda-form">
    <input type="hidden" name="id_comanda" value="${id_comanda}" />
    <input type="hidden" name="id_comanda" value="${id_comanda}" />

    <p><strong>Cliente:</strong> ${nombre_cliente} ${apellidos}</p>
    <p><strong>Mesa:</strong> ${numero_mesa}</p>
    <p><strong>Fecha:</strong> ${fecha_comanda}</p>

    <table id="tablaComanda">
        <thead>
            <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Observaciones</th>
                <th>Acción</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="detalle" items="${detalles.rows}">
                <tr>
                    <td>
                        <select name="producto[]">
                            <c:forEach var="prod" items="${productos.rows}">
                                <option value="${prod.id_carta}"
                                    <c:if test="${prod.id_carta == detalle.id_carta}">selected</c:if>>
                                    ${prod.nombre}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                    <td><input type="number" name="cantidad[]" value="${detalle.cantidad}" min="1" required /></td>
                    <td><textarea name="observaciones[]">${detalle.observaciones}</textarea></td>
                    <td><button type="button" onclick="this.closest('tr').remove()">🗑️</button></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br/>
    <button type="button" onclick="agregarFila()">➕ Agregar Producto</button>
    <br/><br/>
    <button type="submit">✅ Guardar Cambios</button>
    <a href="controller?op=vercomandas" class="btn-cancelar">❌ Cancelar</a>
</form>

<!-- Opciones para clonar -->
<select id="productoOpciones" style="display: none;">
    <c:forEach var="prod" items="${productos.rows}">
        <option value="${prod.id_carta}">${prod.nombre}</option>
    </c:forEach>
</select>

<script>
function agregarFila() {
    const tabla = document.getElementById("tablaComanda").querySelector("tbody");
    const fila = document.createElement("tr");

    const select = document.getElementById("productoOpciones").cloneNode(true);
    select.removeAttribute("id");
    select.name = "producto[]";
    select.style.display = "inline-block";

    fila.innerHTML = `
        <td></td>
        <td><input type="number" name="cantidad[]" min="1" required /></td>
        <td><textarea name="observaciones[]"></textarea></td>
        <td><button type="button" onclick="this.closest('tr').remove()">🗑️</button></td>
    `;
    fila.children[0].appendChild(select);

    tabla.appendChild(fila);
}
</script>
<style>
.editar-comanda-form {
    max-width: 1100px;
    margin: 30px auto;
    padding: 30px;
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
    font-family: 'Segoe UI', sans-serif;
}

.editar-comanda-form p {
    margin-bottom: 10px;
    font-size: 16px;
}

.editar-comanda-form table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 25px;
}

.editar-comanda-form th {
    background-color: #C3A7D9;
    color: white;
    font-weight: bold;
    padding: 12px;
    text-align: center;
}

.editar-comanda-form td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}

.editar-comanda-form select,
.editar-comanda-form input[type="number"],
.editar-comanda-form textarea {
    width: 100%;
    padding: 8px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 14px;
    box-sizing: border-box;
}

.editar-comanda-form textarea {
    resize: vertical;
}

.editar-comanda-form button[type="button"],
.editar-comanda-form button[type="submit"] {
    padding: 10px 20px;
    font-size: 14px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    margin-top: 15px;
    margin-right: 10px;
    font-weight: bold;
}

.editar-comanda-form button[type="button"] {
    background-color: #dcd0e8;
    color: #333;
}

.editar-comanda-form button[type="submit"] {
    background-color: #f5c518;
    color: #2c2c2c;
}

.editar-comanda-form button[type="button"]:hover {
    background-color: #cbb6de;
}

.editar-comanda-form button[type="submit"]:hover {
    background-color: #e6b915;
}

.editar-comanda-form td button {
    background-color: #E57373;
    color: white;
    padding: 6px 10px;
    font-size: 14px;
    border: none;
    border-radius: 4px;
}

.editar-comanda-form td button:hover {
    background-color: #d15050;
}
.btn-cancelar {
    display: inline-block;
    padding: 10px 20px;
    background-color: #f8d7da;
    color: #721c24;
    font-weight: bold;
    border-radius: 6px;
    text-decoration: none;
    margin-top: 15px;
    transition: background-color 0.3s ease;
}

.btn-cancelar:hover {
    background-color: #f5c6cb;
}

</style>


