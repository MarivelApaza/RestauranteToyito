<%-- 
    Document   : agregar_usuario
    Created on : 30/06/2025, 12:33:02 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="formulario-registro-usuario">
  <h2>➕ Registrar Usuario</h2>

  <c:if test="${not empty mensajeError}">
    <p class="mensaje-error">${mensajeError}</p>
  </c:if>

  <form action="controller?op=guardarusuario" method="post">
    <label>Nombre:</label>
    <input type="text" name="nombre" required />

    <label>Apellidos:</label>
    <input type="text" name="apellidos" required />

    <label>DNI:</label>
    <input type="text" name="dni" required />

    <label>Correo:</label>
    <input type="email" name="correo" required />

    <label>Contraseña:</label>
    <input type="password" name="contrasena" required autocomplete="new-password" />

    <label>Rol:</label>
    <select name="id_rol" required>
      <option value="">-- Seleccione un rol --</option>
      <c:forEach var="r" items="${listaRoles}">
        <option value="${r.idRol}">${r.nombreRol}</option>
      </c:forEach>
    </select>

    <button type="submit">💾 Guardar</button>
    <a href="controller?op=verusuarios" class="btn-cancelar">❌ Cancelar</a>
  </form>
</div>

<style>
  .formulario-registro-usuario {
    padding: 40px;
    font-family: 'Segoe UI', sans-serif;
    background-color: #f7f3fc;
    min-height: 40vh;
  }

  .formulario-registro-usuario h2 {
    color: #8e6ac0;
    text-align: center;
    margin-bottom: 30px;
  }

  .formulario-registro-usuario form {
    max-width: 600px;
    margin: 0 auto;
    background-color: #ffffff;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
  }

  .formulario-registro-usuario label {
    display: block;
    margin-top: 15px;
    font-weight: bold;
    color: #5b4a79;
  }

  .formulario-registro-usuario input[type="text"],
  .formulario-registro-usuario input[type="email"],
  .formulario-registro-usuario input[type="password"],
  .formulario-registro-usuario select {
    width: 100%;
    padding: 10px;
    margin-top: 6px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
    box-sizing: border-box;
  }

  .formulario-registro-usuario button[type="submit"] {
    margin-top: 25px;
    width: 100%;
    padding: 12px;
    background-color: #C3A7D9;
    color: #fff;
    border: none;
    border-radius: 6px;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  .formulario-registro-usuario button[type="submit"]:hover {
    background-color: #a388c0;
  }

  .formulario-registro-usuario .mensaje-error {
    text-align: center;
    margin-bottom: 20px;
    font-weight: bold;
    color: #b20000;
    background-color: #ffe5e5;
    padding: 10px;
    border-radius: 8px;
    border: 1px solid #e6b0b0;
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
