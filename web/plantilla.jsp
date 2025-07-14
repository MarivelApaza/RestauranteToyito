<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - El Toyito</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/superior.css" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            font-family: 'Segoe UI', sans-serif;
        }

        .navbar {
            background-color: #2c2c2c;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .main-container {
            display: flex;
            height: calc(100vh - 80px); /* navbar = 80px aprox */
            overflow: hidden;
        }

        .sidebar {
            width: 250px;
            background-color: #2c2c2c;
            color: white;
            padding: 20px;
            overflow-y: auto;
        }

        .content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
            background-color: #f8f8f8;
        }

        button {
            background-color: #f5c518;
            color: #2c2c2c;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #e0b817;
        }
    </style>
</head>
<body>

<!-- Barra superior -->
<div class="navbar">
    <!-- Logo y Título -->
    <div style="display: flex; align-items: center;">
        <img src="resources/images/logotoyito.png" alt="Logo" style="height: 50px; margin-right: 15px; border-radius: 8px;" />
        <h2 style="margin: 0; font-family: 'Poppins', sans-serif; font-weight: 600; font-size: 24px; color: #f5c518;">
            Restaurante "El Toyito"
        </h2>
    </div>

    <!-- Usuario y botón cerrar sesión -->
    <div class="usuario-info" style="display: flex; align-items: center; gap: 20px;">
        <span style="font-size: 16px; font-weight: 500;">
            Bienvenido, <strong style="color: #f5c518;">${sessionScope.nombreUsuario}</strong>
        </span>
        <form action="logout.jsp" method="post" style="margin: 0;">
            <button>⎋ Cerrar Sesión</button>
        </form>
    </div>
</div>

<!-- Contenedor principal -->
<div class="main-container">
    <div class="sidebar">
        <jsp:include page="barra.jsp" />
    </div>

    <div class="content">
        <jsp:include page="${requestScope.vista}" />
    </div>
</div>

</body>
</html>
