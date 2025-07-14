<%-- 
    Document   : reporte_pagos
    Created on : 12/07/2025, 10:32:54 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reporte: Pagos por Método de Pago</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f8ff;
            margin: 0;
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

        canvas {
            margin-top: 40px;
            max-width: 600px;
            display: block;
            margin-left: auto;
            margin-right: auto;
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

<sql:query var="reportePagos" dataSource="${db}">
    SELECT m.nombre_metodo AS metodo, COUNT(b.id_boleta) AS total_transacciones, 
           SUM(b.total) AS total_recaudado
    FROM boleta_de_pago b
    JOIN metodo_pago m ON b.id_metodo_pago = m.id_metodo_pago
    WHERE b.estado = 'Pagado'
    GROUP BY b.id_metodo_pago
    ORDER BY total_recaudado DESC
</sql:query>

<div class="reporte-container" id="reporte">
    <h2>💳 Reporte: Pagos por Método de Pago</h2>

    <c:choose>
        <c:when test="${not empty reportePagos.rows}">
            <table>
                <thead>
                    <tr>
                        <th>Método de Pago</th>
                        <th>Total Transacciones</th>
                        <th>Total Recaudado (S/)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="fila" items="${reportePagos.rows}">
                        <tr>
                            <td>${fila.nombre_metodo}</td>
                            <td>${fila.total_transacciones}</td>
                            <td>S/ ${fila.total_recaudado}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Gráfico -->
            <canvas id="graficoPagos"></canvas>

        </c:when>
        <c:otherwise>
            <p style="color:red; text-align:center;">⚠️ No hay pagos registrados.</p>
        </c:otherwise>
    </c:choose>

</div>

<script>


    // Gráfico de pagos (solo si hay datos)
    <c:if test="${not empty reportePagos.rows}">
    const ctx = document.getElementById('graficoPagos').getContext('2d');
    const graficoPagos = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: [
                <c:forEach var="row" items="${reportePagos.rows}" varStatus="status">
                    "${row.nombre_metodo}"<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ],
            datasets: [{
                label: 'Recaudado (S/)',
                data: [
                    <c:forEach var="row" items="${reportePagos.rows}" varStatus="status">
                        ${row.total_recaudado}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                backgroundColor: ['#b39ddb', '#81d4fa', '#ce93d8', '#aed581', '#ffcc80']
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
    </c:if>
</script>

</body>
</html>
