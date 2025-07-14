<%-- 
    Document   : reporte_clientes
    Created on : 12/07/2025, 10:32:24 PM
    Author     : Windows
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reporte: Clientes Más Frecuentes</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f8ff;
            margin: 0;
        }

        .reporte-container {
            max-width: 900px;
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
            max-width: 750px;
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

    img.print-chart {
        max-width: 600px !important;
        height: auto !important;
        display: block;
        margin: 30px auto;
    }
}

        
    </style>
</head>
<body>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
                   user="root" password="" />

<sql:query var="reporteClientes" dataSource="${db}">
    SELECT c.nombre, c.apellidos, c.dni, c.telefono, COUNT(p.id_pedido) AS total_pedidos
    FROM cliente c
    JOIN pedido p ON c.id_cliente = p.id_cliente
    GROUP BY c.id_cliente
    ORDER BY total_pedidos DESC
    LIMIT 10
</sql:query>

<div class="reporte-container" id="reporte">
    <h2>👥 Reporte: Clientes Más Frecuentes</h2>

    <c:choose>
        <c:when test="${not empty reporteClientes.rows}">
            <table>
                <thead>
                    <tr>
                        <th>Cliente</th>
                        <th>DNI</th>
                        <th>Teléfono</th>
                        <th>Total de Pedidos</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="fila" items="${reporteClientes.rows}">
                        <tr>
                            <td>${fila.nombre} ${fila.apellidos}</td>
                            <td>${fila.dni}</td>
                            <td>${fila.telefono}</td>
                            <td>${fila.total_pedidos}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Gráfico -->
            <canvas id="graficoClientes" width="750" height="400"></canvas>
        </c:when>
        <c:otherwise>
            <p style="color:red; text-align:center;">⚠️ No hay registros de clientes frecuentes.</p>
        </c:otherwise>
    </c:choose>

    <button onclick="printReport()" class="btn-imprimir">🖨️ Imprimir Reporte</button>
</div>

<script>
    function printReport() {
    const canvas = document.getElementById('graficoClientes');
    const dataURL = canvas.toDataURL(); // Convertimos el canvas a imagen

    const img = new Image();
    img.src = dataURL;
    img.style.maxWidth = '750px';
    img.style.display = 'block';
    img.style.margin = '40px auto';

    // Insertar imagen justo debajo del canvas y ocultar el canvas
    canvas.style.display = 'none';
    canvas.parentNode.insertBefore(img, canvas.nextSibling);

    // Imprimir
    setTimeout(() => {
        window.print();

        // Restaurar canvas después de imprimir
        img.remove();
        canvas.style.display = 'block';
    }, 500);
}


    // Gráfico de barras horizontales
    <c:if test="${not empty reporteClientes.rows}">
    const ctx = document.getElementById('graficoClientes').getContext('2d');
    const graficoClientes = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [
                <c:forEach var="row" items="${reporteClientes.rows}" varStatus="status">
                    "${row.nombre} ${row.apellidos}"<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ],
            datasets: [{
                label: 'Total de Pedidos',
                data: [
                    <c:forEach var="row" items="${reporteClientes.rows}" varStatus="status">
                        ${row.total_pedidos}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                backgroundColor: '#81d4fa'
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            plugins: {
                legend: { display: false }
            },
            scales: {
                x: {
                    beginAtZero: true
                }
            }
        }
    });
    </c:if>
</script>

</body>
</html>
