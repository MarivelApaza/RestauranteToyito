<%-- 
    Document   : carta_consumo_cliente
    Created on : 12/07/2025, 05:35:57 PM
    Author     : Windows
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<sql:setDataSource var="db" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/restaurante_el_toyito"
    user="root" password="" />

<!-- Traer productos con categoría -->
<sql:query var="productos" dataSource="${db}">
    SELECT c.nombre, c.descripcion, c.precio, cat.nombre_categoria 
    FROM carta c
    JOIN categoria cat ON c.id_categoria = cat.id_categoria
    ORDER BY cat.nombre_categoria, c.nombre
</sql:query>

<!-- Traer categorías únicas -->
<sql:query var="categorias" dataSource="${db}">
    SELECT DISTINCT cat.nombre_categoria 
    FROM categoria cat 
    JOIN carta c ON c.id_categoria = cat.id_categoria
    ORDER BY cat.nombre_categoria
</sql:query>

<div class="menu-cliente">
    <h2>🍽️ Carta de Consumo</h2>

    <c:forEach var="cat" items="${categorias.rows}">
        <h3 class="categoria-titulo">🍽️ ${cat.nombre_categoria}</h3>
        <div class="grid">
            <c:forEach var="p" items="${productos.rows}">
                <c:if test="${p.nombre_categoria == cat.nombre_categoria}">
                    <div class="tarjeta-plato">
                        <img class="imagen-plato" 
                             src="resources/images/carta/${p.nombre}.jpg" 
                             alt="${p.nombre}" />
                        <h4>${p.nombre}</h4>
                        <p class="descripcion">${p.descripcion}</p>
                        <div class="precio">S/ ${p.precio}</div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </c:forEach>
</div>

<style>
.menu-cliente {
    font-family: 'Segoe UI', sans-serif;
    padding: 30px;
    background-color: #f7f0ff;
}

.menu-cliente h2 {
    text-align: center;
    color: #6C47A6;
    font-size: 34px;
    margin-bottom: 30px;
}

.categoria-titulo {
    font-size: 22px;
    color: #814FBF;
    margin-top: 35px;
    margin-bottom: 15px;
    border-left: 6px solid #C8A2E7;
    padding-left: 10px;
}

.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.tarjeta-plato {
    background-color: #f3e8ff;
    border-radius: 12px;
    padding: 15px;
    box-shadow: 0 6px 12px rgba(0,0,0,0.1);
    text-align: center;
    transition: transform 0.2s ease;
    max-width: 100%;
    box-sizing: border-box;
}

.tarjeta-plato:hover {
    transform: scale(1.03);
}

.imagen-plato {
    width: 100%;
    max-width: 180px;
    height: 120px;
    object-fit: cover;
    border-radius: 10px;
    margin: 0 auto;
    display: block;
}

.tarjeta-plato h4 {
    margin-top: 10px;
    color: #5D3A9B;
    font-size: 18px;
}

.descripcion {
    font-size: 14px;
    color: #5f5f5f;
    margin: 10px 0;
    min-height: 50px;
}

.precio {
    font-size: 16px;
    font-weight: bold;
    color: #2c2c2c;
}
</style>
