<%-- 
    Document   : agregar_carta
    Created on : 29/06/2025, 04:25:45 PM
    Author     : Windows
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<sql:query var="categorias" dataSource="${db}">
    SELECT id_categoria, nombre_categoria FROM categoria
</sql:query>

<!-- Procesar formulario -->
<c:if test="${param.registrar eq 'true'}">
    <sql:update dataSource="${db}">
        INSERT INTO carta (nombre, descripcion, precio, id_categoria)
        VALUES (?, ?, ?, ?)
        <sql:param value="${param.nombre}" />
        <sql:param value="${param.descripcion}" />
        <sql:param value="${param.precio}" />
        <sql:param value="${param.id_categoria}" />
    </sql:update>
    <c:redirect url="controller?op=vercarta" />
</c:if>

<div class="form-wrapper">
    <h1>➕ Agregar Nuevo Producto</h1>

    <form method="post" action="agregar_carta.jsp" class="form-carta">
        <label>Nombre del Producto:</label>
        <input type="text" name="nombre" required />

        <label>Descripción:</label>
        <textarea name="descripcion" rows="3" required></textarea>

        <label>Precio (S/.):</label>
        <input type="number" name="precio" step="0.01" required />

        <label>Categoría:</label>
        <select name="id_categoria" required>
            <c:forEach var="c" items="${categorias.rows}">
                <option value="${c.id_categoria}">${c.nombre_categoria}</option>
            </c:forEach>
        </select>

        <input type="hidden" name="registrar" value="true" />
        <button type="submit">💾 Guardar Producto</button>
        <a href="controller?op=vercarta" class="btn-cancelar">❌ Cancelar</a>
    </form>
</div>

<style>
    .form-wrapper {
    max-width: 700px;
    margin: 40px auto;
    padding: 30px;
    background-color: #f8f2fb;
    border-radius: 12px;
    box-shadow: 0 6px 14px rgba(0, 0, 0, 0.1);
    font-family: 'Segoe UI', sans-serif;
}

.form-wrapper h1 {
    text-align: center;
    color: #7b4ca0;
    margin-bottom: 25px;
}

.form-carta label {
    display: block;
    font-weight: bold;
    margin-bottom: 6px;
    margin-top: 15px;
    color: #4c3a5d;
}

.form-carta input,
.form-carta select,
.form-carta textarea {
    width: 100%;
    padding: 10px;
    font-size: 14px;
    border: 1px solid #d1c3e2;
    border-radius: 6px;
    box-sizing: border-box;
    background-color: #fff;
}

.form-carta input:focus,
.form-carta select:focus,
.form-carta textarea:focus {
    outline: none;
    border-color: #c9a7e5;
    box-shadow: 0 0 6px rgba(174, 137, 215, 0.4);
}

.form-carta textarea {
    resize: vertical;
}

.form-carta button {
    margin-top: 25px;
    padding: 12px 20px;
    font-size: 16px;
    background-color: #d4b1f1;
    color: #2c2c2c;
    border: none;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
    width: 100%;
    transition: background-color 0.3s ease;
}

.form-carta button:hover {
    background-color: #c199e7;
}
.btn-cancelar {
        display: inline-block;
        margin-top: 15px;
        text-align: center;
        padding: 12px 271px;
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

