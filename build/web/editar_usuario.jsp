<%-- 
    Document   : editar_usuario
    Created on : 30/06/2025, 05:56:32 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="formulario-editar-usuario">
    <h2>✏️ Editar Usuario</h2>

    <form action="controller?op=guardarusuario" method="post">
        <input type="hidden" name="id_usuario" value="${usuarioEditar.id_usuario}" />

        <label>Nombre:</label>
        <input type="text" name="nombre" value="${usuarioEditar.nombre}" required />

        <label>Apellidos:</label>
        <input type="text" name="apellidos" value="${usuarioEditar.apellidos}" required />

        <label>DNI:</label>
        <input type="text" name="dni" value="${usuarioEditar.dni}" required />

        <label>Correo:</label>
        <input type="email" name="correo" value="${usuarioEditar.correo}" required />

        <label>Rol:</label>
        <select name="id_rol" required>
            <c:forEach var="r" items="${listaRoles}">
                <option value="${r.idRol}"
                        <c:if test="${r.idRol == usuarioEditar.rol.idRol}">selected</c:if>>
                    ${r.nombreRol}
                </option>
            </c:forEach>
        </select>

        <button type="submit">💾 Guardar Cambios</button>
        <a href="controller?op=verusuarios" class="btn-cancelar">❌ Cancelar</a>
    </form>
</div>

<style>
    .formulario-editar-usuario {
        font-family: 'Segoe UI', sans-serif;
        background-color: #f7f3fc;
        padding: 40px;
        min-height: 50vh;
    }

    .formulario-editar-usuario h2 {
        color: #8e6ac0;
        text-align: center;
        margin-bottom: 30px;
    }

    .formulario-editar-usuario form {
        max-width: 600px;
        margin: 0 auto;
        background-color: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .formulario-editar-usuario label {
        display: block;
        margin-top: 15px;
        font-weight: bold;
        color: #5b4a79;
    }

    .formulario-editar-usuario input[type="text"],
    .formulario-editar-usuario input[type="email"],
    .formulario-editar-usuario input[type="password"],
    .formulario-editar-usuario select {
        width: 100%;
        padding: 10px;
        margin-top: 6px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 14px;
        box-sizing: border-box;
    }

    .formulario-editar-usuario button[type="submit"] {
        margin-top: 25px;
        padding: 12px 20px;
        background-color: #C3A7D9;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
        width: 100%;
        transition: background-color 0.3s;
    }

    .formulario-editar-usuario button[type="submit"]:hover {
        background-color: #a388c0;
    }

    .formulario-editar-usuario p[style*="color:red"] {
        text-align: center;
        font-weight: bold;
        margin-bottom: 15px;
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
