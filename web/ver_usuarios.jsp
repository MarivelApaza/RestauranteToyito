<%-- 
    Document   : ver_usuarios
    Created on : 30/06/2025, 12:32:43 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div style="padding: 40px;">
    <h2>👥 Lista de Usuarios</h2>

    <table id="tablaUsuarios" style="width:100%; border-collapse: collapse; margin-top: 20px;">
        <thead>
            <tr style="background-color: #C3A7D9;">
                <th>ID</th>
                <th>Nombre</th>
                <th>Apellidos</th>
                <th>DNI</th>
                <th>Correo</th>
                <th>Rol</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody id="cuerpoTablaUsuarios">
            <!-- Se llenará con JavaScript -->
        </tbody>
    </table>
</div>

<script>
    const contexto = '${pageContext.request.contextPath}';
document.addEventListener("DOMContentLoaded", function () {
    const tabla = document.getElementById("cuerpoTablaUsuarios");
    if (tabla) {
        console.log("🔄 Cargando usuarios...");

        fetch('${pageContext.request.contextPath}/api/usuarios')
            .then(response => {
                if (!response.ok) throw new Error("HTTP " + response.status);
                return response.json();
            })
            .then(data => {
                console.log("📦 Usuarios recibidos:", data);
                tabla.innerHTML = "";

               data.forEach(usuario => {
    console.log("📄 Usuario:", usuario);

    const fila = document.createElement("tr");

    const celdaId = document.createElement("td");
    celdaId.textContent = usuario.id_usuario ?? "⚠️";

    const celdaNombre = document.createElement("td");
    celdaNombre.textContent = usuario.nombre ?? "⚠️";

    const celdaApellidos = document.createElement("td");
    celdaApellidos.textContent = usuario.apellidos ?? "⚠️";

    const celdaDni = document.createElement("td");
    celdaDni.textContent = usuario.dni ?? "⚠️";

    const celdaCorreo = document.createElement("td");
    celdaCorreo.textContent = usuario.correo ?? "⚠️";

    const celdaRol = document.createElement("td");
    celdaRol.textContent = usuario.rol?.nombreRol ?? "⚠️";

    const celdaAcciones = document.createElement("td");
    
    
   const btnEditar = document.createElement("button");
btnEditar.textContent = "✏️";
btnEditar.dataset.id = usuario.id_usuario;
btnEditar.onclick = function () {
    editarUsuario(this.dataset.id);
};

const btnEliminar = document.createElement("button");
btnEliminar.textContent = "🗑️";
btnEliminar.dataset.id = usuario.id_usuario;
btnEliminar.onclick = function () {
    eliminarUsuario(this.dataset.id);
};

celdaAcciones.appendChild(btnEditar);
celdaAcciones.appendChild(btnEliminar);


    fila.appendChild(celdaId);
    fila.appendChild(celdaNombre);
    fila.appendChild(celdaApellidos);
    fila.appendChild(celdaDni);
    fila.appendChild(celdaCorreo);
    fila.appendChild(celdaRol);
    fila.appendChild(celdaAcciones);

    tabla.appendChild(fila); // ✅ aquí sí
});

            })
            .catch(error => {
                console.error("❌ Error al cargar usuarios:", error);
                tabla.innerHTML = "<tr><td colspan='7'>Error al cargar usuarios</td></tr>";
            });
    }
});

function editarUsuario(id) {
    window.location.href = contexto + '/controller?op=editarusuario&id=' + id;
}

function eliminarUsuario(id) {
    if (confirm("¿Estás seguro de eliminar este usuario?")) {
        fetch(contexto + '/api/usuarios/' + id, {
            method: 'DELETE'
        })
        .then(response => {
            if (response.ok) {
                alert("✅ Usuario eliminado");
                location.reload();
            } else {
                alert("❌ No se pudo eliminar");
            }
        });
    }
}


</script>
<style>
    body {
    font-family: 'Segoe UI', sans-serif;
    background-color: #f6f3fa;
    margin: 0;
    padding: 0;
}

h2 {
    color: #7b4ca0;
    text-align: center;
    margin-bottom: 30px;
}

#tablaUsuarios {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background-color: #ffffff;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    overflow: hidden;
}

#tablaUsuarios thead tr {
    background-color: #d6b3f5;
    color: #2c2c2c;
}

#tablaUsuarios th,
#tablaUsuarios td {
    padding: 12px 15px;
    text-align: center;
    border-bottom: 1px solid #e6d9f9;
    font-size: 14px;
}

#tablaUsuarios tbody tr:nth-child(even) {
    background-color: #f8f1fd;
}

#tablaUsuarios tbody tr:hover {
    background-color: #efe0fb;
}

#tablaUsuarios button {
    background-color: #c79ae6;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 6px 10px;
    margin: 0 4px;
    cursor: pointer;
    font-size: 14px;
    transition: background-color 0.3s ease;
}

#tablaUsuarios button:hover {
    background-color: #a86fd5;
}

</style>


