<%-- 
    Document   : reporte_reservas
    Created on : 12/07/2025, 10:34:52 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<html>
<head>
    <title>Reporte: Reservas Realizadas</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            background-color: #f8f8ff;
        }

        .reporte-container {
            max-width: 850px;
            margin: 40px auto;
            background: linear-gradient(to bottom right, #e6e6fa, #d0f0f7);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #6a5acd;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
        }

        thead {
            background-color: #b39ddb;
            color: white;
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
        }

        tbody tr:nth-child(even) {
            background-color: #f3f4f8;
        }

        .btn-imprimir {
            display: block;
            margin: 25px auto 0 auto;
            background-color: #81d4fa;
            color: #333;
            padding: 10px 20px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-imprimir:hover {
            background-color: #4fc3f7;
        }

        @media print {
            body * {
                visibility: hidden;
            }

            .reporte-container, .reporte-container * {
                visibility: visible;
            }

            .reporte-container {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                box-shadow: none;
                background: white;
            }

            .btn-imprimir {
                display: none;
            }
        }
    </style>
</head>
<body>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
                   user="root" password="" />

<sql:query var="reservas" dataSource="${db}">
    SELECT 
    r.id_reserva, 
    c.nombre, 
    c.apellidos, 
    m.numero_mesa, 
    r.fecha, 
    r.estado
FROM reserva r
JOIN cliente c ON r.id_cliente = c.id_cliente
JOIN mesa m ON r.id_mesa = m.id_mesa
ORDER BY r.fecha DESC;

</sql:query>

<div class="reporte-container" id="reporte">
    <h2>📅 Reporte: Reservas Realizadas</h2>

    <c:choose>
        <c:when test="${not empty reservas.rows}">
            <table>
                <thead>
                    <tr>
                        <th>ID Reserva</th>
                        <th>Cliente</th>
                        <th>Mesa</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${reservas.rows}">
                        <tr>
                            <td>${r.id_reserva}</td>
                            <td>${r.nombre} ${r.apellidos}</td>
                            <td>${r.numero_mesa}</td>
                            <td>${r.fecha}</td>
                            <td>${r.estado}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <p style="color:red; text-align:center;">⚠️ No hay reservas registradas.</p>
        </c:otherwise>
    </c:choose>

    <button onclick="printReport()" class="btn-imprimir">🖨️ Imprimir Reporte</button>
</div>

<script>
    function printReport() {
        const contenido = document.getElementById("reporte").innerHTML;
        const original = document.body.innerHTML;
        document.body.innerHTML = contenido;
        window.print();
        document.body.innerHTML = original;
    }
</script>

</body>
</html>
