<%-- 
    Document   : reporte_productos
    Created on : 12/07/2025, 10:06:10 PM
    Author     : Windows
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<html>
<head>
    <title>Reporte: Productos Más Vendidos</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f3ff;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 30px;
            background: linear-gradient(to bottom right, #fce4ec, #e3f2fd);
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #6a5acd;
            margin-bottom: 30px;
        }

        canvas {
            max-width: 100%;
            margin-bottom: 40px;
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
        }

        .btn-imprimir:hover {
            background-color: #4fc3f7;
        }

        @media print {
            body * {
                visibility: hidden;
            }

            .container, .container * {
                visibility: visible;
            }

            .container {
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

<div class="container">
    <h2>📦 Reporte: Productos Más Vendidos</h2>

    <sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
                       url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
                       user="root" password="" />

    <sql:query var="reporteProductos" dataSource="${db}">
        SELECT 
            c.nombre AS nombre_producto, 
            COALESCE(SUM(dc.cantidad), 0) AS total_vendido
        FROM carta c
        LEFT JOIN detalle_comanda dc ON c.id_carta = dc.id_carta
        GROUP BY c.id_carta
        ORDER BY total_vendido DESC
    </sql:query>

    <c:if test="${not empty reporteProductos.rows}">
        <!-- 🎨 Gráfico de barras -->
        <canvas id="graficoProductos"></canvas>

        <table border="1" cellpadding="10" cellspacing="0">
            <thead>
            <tr>
                <th>Producto</th>
                <th>Total Vendido</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="fila" items="${reporteProductos.rows}">
                <tr>
                    <td>${fila.nombre}</td>
                    <td>${fila.total_vendido}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty reporteProductos.rows}">
        <p style="text-align: center; color: red;">⚠️ No hay ventas registradas.</p>
    </c:if>

    <button class="btn-imprimir" onclick="window.print()">🖨️ Imprimir Reporte</button>
</div>

<!-- 💡 SCRIPT: Cargar datos en Chart.js -->
<script>
    const ctx = document.getElementById('graficoProductos').getContext('2d');
    const nombres = [
        <c:forEach var="fila" items="${reporteProductos.rows}" varStatus="status">
            "${fila.nombre}"<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const cantidades = [
        <c:forEach var="fila" items="${reporteProductos.rows}" varStatus="status">
            ${fila.total_vendido}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: nombres,
            datasets: [{
                label: 'Cantidad Vendida',
                data: cantidades,
                backgroundColor: '#ce93d8',
                borderColor: '#ab47bc',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision:0
                    }
                }
            }
        }
    });
</script>

</body>
</html>
