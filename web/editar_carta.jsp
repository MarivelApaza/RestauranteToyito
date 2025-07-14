<%-- 
    Document   : editar_carta
    Created on : 29/06/2025, 04:49:01 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
                   user="root" password="" />

<!-- Obtener producto -->
<sql:query var="producto" dataSource="${db}">
    SELECT * FROM carta WHERE id_carta = ?
    <sql:param value="${param.id}" />
</sql:query>

<!-- Obtener categorías -->
<sql:query var="categorias" dataSource="${db}">
    SELECT * FROM categoria
</sql:query>

<!-- Actualizar -->
<c:if test="${param.actualizar eq 'true'}">
    <sql:update dataSource="${db}">
        UPDATE carta
        SET nombre = ?, descripcion = ?, precio = ?, id_categoria = ?
        WHERE id_carta = ?
        <sql:param value="${param.nombre}" />
        <sql:param value="${param.descripcion}" />
        <sql:param value="${param.precio}" />
        <sql:param value="${param.id_categoria}" />
        <sql:param value="${param.id}" />
    </sql:update>
    <c:redirect url="controller?op=vercarta" />
</c:if>

<div class="form-wrapper">
    <h1>✏️ Editar Producto</h1>

    <c:forEach var="p" items="${producto.rows}">
        <form method="post" action="editar_carta.jsp" class="form-carta">
            <input type="hidden" name="id" value="${p.id_carta}" />

            <label>Nombre:</label>
            <input type="text" name="nombre" value="${p.nombre}" required />

            <label>Descripción:</label>
            <textarea name="descripcion" rows="3" required>${p.descripcion}</textarea>

            <label>Precio (S/.):</label>
            <input type="number" step="0.01" name="precio" value="${p.precio}" required />

            <label>Categoría:</label>
            <select name="id_categoria" required>
                <c:forEach var="c" items="${categorias.rows}">
                    <option value="${c.id_categoria}" <c:if test="${c.id_categoria == p.id_categoria}">selected</c:if>>
                        ${c.nombre_categoria}
                    </option>
                </c:forEach>
            </select>

            <input type="hidden" name="actualizar" value="true" />
            <button type="submit">💾 Guardar Cambios</button>
            <a href="controller?op=vercarta" class="btn-cancelar">❌ Cancelar</a>
        </form>
    </c:forEach>
</div>

<style>
    body {
        background-color: #f6f3fa;
        font-family: 'Segoe UI', sans-serif;
    }

    .form-wrapper {
        max-width: 700px;
        margin: 40px auto;
        padding: 30px;
        background: linear-gradient(to bottom right, #f8f2fb, #f8f2fb);
        border-radius: 14px;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
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
        color: #444;
    }

    .form-carta input,
    .form-carta select,
    .form-carta textarea {
        width: 100%;
        padding: 12px;
        font-size: 14px;
        border: 1px solid #ccc;
        border-radius: 8px;
        box-sizing: border-box;
        background-color: #fff;
    }

    .form-carta textarea {
        resize: vertical;
    }

    .form-carta button {
        margin-top: 25px;
        padding: 12px 20px;
        font-size: 16px;
        background-color: #cfa9f3;
        color: #2c2c2c;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
        width: 100%;
        transition: background-color 0.3s ease;
    }

    .form-carta button:hover {
        background-color: #b889e6;
    }

    .btn-cancelar {
        display: inline-block;
        text-align: center;
        width: 100%;
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

