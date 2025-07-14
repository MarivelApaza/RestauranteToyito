<%-- 
    Document   : reporte_comandas
    Created on : 12/07/2025, 10:32:39 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
                   user="root" password="" />

<sql:query var="comandasMozo" dataSource="${db}">
    SELECT 
    u.nombre,
    u.apellidos,
    COUNT(c.id_comanda) AS total_comandas
FROM comanda c
JOIN usuario u ON c.id_usuario = u.id_usuario
WHERE u.id_rol = 2
GROUP BY u.id_usuario
ORDER BY total_comandas DESC

</sql:query>

<html>
<head>
    <title>Reporte de Comandas por Mozo</title>
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

<div class="reporte-container">
    <h2>👨‍🍳 Reporte: Comandas por Mozo</h2>

    <c:choose>
        <c:when test="${not empty comandasMozo.rows}">
            <table>
                <thead>
                    <tr>
                        <th>Mozo</th>
                        <th>Total de Comandas</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${comandasMozo.rows}">
                        <tr>
                            <td>${m.nombre} ${m.apellidos}</td>
                            <td>${m.total_comandas}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <button class="btn-imprimir" onclick="window.print()">🖨️ Imprimir</button>
        </c:when>
        <c:otherwise>
            <p style="color:red; text-align:center;">⚠️ No hay registros de comandas aún.</p>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
