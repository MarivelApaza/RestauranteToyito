/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.controladores;

import com.eltoyito.dao.RolDAO;
import com.eltoyito.dao.UsuarioDAO;
import com.eltoyito.modelo.Rol;
import com.eltoyito.modelo.Usuario;
import com.eltoyito.util.ConexionBD;
import static com.oracle.wls.shaded.org.apache.xalan.xsltc.compiler.util.Type.Int;
import static com.oracle.wls.shaded.org.apache.xpath.XPath.SELECT;
import static com.sun.org.apache.xalan.internal.xsltc.compiler.util.Type.Int;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;


/**
 *
 * @author Windows
 */
@WebServlet(name = "ServletController", urlPatterns = {"/controller"})
public class ServletController extends HttpServlet {
    

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. 
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ServletController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServletController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");*/

    String op = request.getParameter("op");
    String url = "dashboard.jsp";

    switch (op) {
        case "dashboard":
            request.setAttribute("vista", "dashboard.jsp");
            url = "plantilla.jsp";
            break;
        
        case "docartaconsumocliente":
            request.setAttribute("vista", "carta_consumo_cliente.jsp");
            url = "plantilla.jsp";
            break;   

        case "dolistadoreservas":
            request.setAttribute("vista", "ver_reserva.jsp");
            url = "plantilla.jsp";
            break;

        case "donuevareserva":
            request.setAttribute("vista", "nueva_reserva.jsp");
            url = "plantilla.jsp";
            break;

        case "editarreserva":
            request.setAttribute("idReserva", request.getParameter("id"));
            request.setAttribute("fechaSeleccionada", request.getParameter("fecha"));
            request.setAttribute("vista", "editar_reserva.jsp");
            url = "plantilla.jsp";
            break;

        case "eliminarreserva":
            String id = request.getParameter("id");
            try (Connection con = ConexionBD.conectar()) {
                String sqlMesa = "SELECT id_mesa FROM reserva WHERE id_reserva = ?";
                PreparedStatement psMesa = con.prepareStatement(sqlMesa);
                psMesa.setString(1, id);
                ResultSet rs = psMesa.executeQuery();

                if (rs.next()) {
                    int idMesa = rs.getInt("id_mesa");

                    String sqlEliminar = "DELETE FROM reserva WHERE id_reserva = ?";
                    PreparedStatement psEliminar = con.prepareStatement(sqlEliminar);
                    psEliminar.setString(1, id);
                    psEliminar.executeUpdate();

                    String sqlActualizarMesa = "UPDATE mesa SET estado = 'Disponible' WHERE id_mesa = ?";
                    PreparedStatement psUpdate = con.prepareStatement(sqlActualizarMesa);
                    psUpdate.setInt(1, idMesa);
                    psUpdate.executeUpdate();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("controller?op=dolistadoreservas");
            return; // ← Importante
 /////////////
            

        case "disponibilidadmesas":
            request.setAttribute("vista", "disponibilidad_mesas.jsp");
            url = "plantilla.jsp";
            break;
            
////////////
                            case "vercomandas":
            request.setAttribute("vista", "ver_comandas.jsp");
            url = "plantilla.jsp";
            break;
            
 case "registrarpedido":
    request.setAttribute("vista", "registrar_pedido_completo.jsp");
    url = "plantilla.jsp";
    break;

case "guardarpedidocompleto":
    try (Connection con = ConexionBD.conectar()) {
        String idMesa = request.getParameter("id_mesa");
        String idCliente = request.getParameter("id_cliente");
        String nombreCliente = request.getParameter("nombre_cliente");
        String apellidosCliente = request.getParameter("apellidos_cliente");
        String dniCliente = request.getParameter("dni_cliente");
        String fecha = request.getParameter("fecha"); // ✅ ahora tomamos la fecha del formulario

        String[] productos = request.getParameterValues("producto[]");
        String[] cantidades = request.getParameterValues("cantidad[]");
        String[] observaciones = request.getParameterValues("observaciones[]");

        if (idMesa == null || productos == null || cantidades == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        int idClienteFinal;

        // Registrar nuevo cliente si no hay uno existente
        if (idCliente == null || idCliente.isEmpty()) {
            if (nombreCliente == null || apellidosCliente == null || dniCliente == null ||
                nombreCliente.isEmpty() || apellidosCliente.isEmpty() || dniCliente.isEmpty()) {
                throw new IllegalArgumentException("Faltan datos del cliente manual");
            }

            String sqlInsertCliente = "INSERT INTO cliente (nombre, apellidos, dni) VALUES (?, ?, ?)";
            try (PreparedStatement psCli = con.prepareStatement(sqlInsertCliente, Statement.RETURN_GENERATED_KEYS)) {
                psCli.setString(1, nombreCliente);
                psCli.setString(2, apellidosCliente);
                psCli.setString(3, dniCliente);
                psCli.executeUpdate();

                try (ResultSet rsCli = psCli.getGeneratedKeys()) {
                    if (rsCli.next()) {
                        idClienteFinal = rsCli.getInt(1);
                    } else {
                        throw new SQLException("No se pudo obtener el ID del cliente recién insertado.");
                    }
                }
            }
        } else {
            idClienteFinal = Integer.parseInt(idCliente);
        }

        // Insertar en pedido con la fecha elegida
        int idPedido;
        String sqlPedido = "INSERT INTO pedido (id_cliente, id_mesa, fecha, estado) VALUES (?, ?, ?, 'En curso')";
        try (PreparedStatement psPedido = con.prepareStatement(sqlPedido, Statement.RETURN_GENERATED_KEYS)) {
            psPedido.setInt(1, idClienteFinal);
            psPedido.setInt(2, Integer.parseInt(idMesa));
            psPedido.setString(3, fecha); // ✅ usar fecha del formulario
            psPedido.executeUpdate();

            try (ResultSet rsPedido = psPedido.getGeneratedKeys()) {
                idPedido = rsPedido.next() ? rsPedido.getInt(1) : 0;
            }
        }

        // Insertar comanda
        // Insertar comanda con la fecha del pedido
int idComanda;
String sqlComanda = "INSERT INTO comanda (id_pedido, id_usuario, fecha) VALUES (?, ?, ?)";
try (PreparedStatement psComanda = con.prepareStatement(sqlComanda, Statement.RETURN_GENERATED_KEYS)) {
    psComanda.setInt(1, idPedido);
    psComanda.setInt(2, 1); // Aquí podrías colocar el ID del usuario logueado
    psComanda.setDate(3, java.sql.Date.valueOf(fecha)); // ✅ Usamos la fecha seleccionada del formulario
    psComanda.executeUpdate();

    try (ResultSet rsComanda = psComanda.getGeneratedKeys()) {
        idComanda = rsComanda.next() ? rsComanda.getInt(1) : 0;
    }
}


        // Insertar detalles de la comanda
        String sqlDetalle = "INSERT INTO detalle_comanda (id_comanda, id_carta, cantidad, observaciones) VALUES (?, ?, ?, ?)";
        try (PreparedStatement psDetalle = con.prepareStatement(sqlDetalle)) {
            for (int i = 0; i < productos.length; i++) {
                if (productos[i] == null || productos[i].isEmpty() ||
                    cantidades[i] == null || cantidades[i].isEmpty()) continue;

                psDetalle.setInt(1, idComanda);
                psDetalle.setInt(2, Integer.parseInt(productos[i]));
                psDetalle.setInt(3, Integer.parseInt(cantidades[i]));
                psDetalle.setString(4, observaciones[i] != null ? observaciones[i] : "");
                psDetalle.addBatch();
            }
            psDetalle.executeBatch();
        }

        // Cambiar estado de la mesa a 'Reservada'
        String sqlUpdateMesa = "UPDATE mesa SET estado = 'Reservada' WHERE id_mesa = ?";
        try (PreparedStatement psUpdateMesa = con.prepareStatement(sqlUpdateMesa)) {
            psUpdateMesa.setInt(1, Integer.parseInt(idMesa));
            psUpdateMesa.executeUpdate();
        }

        // ✅ Marcar reserva como atendida para esa mesa y fecha
        String sqlUpdateReserva = "UPDATE reserva SET estado = 'Atendida' WHERE id_mesa = ? AND DATE(fecha) = ? AND estado = 'Pendiente'";
        try (PreparedStatement psUpdateReserva = con.prepareStatement(sqlUpdateReserva)) {
            psUpdateReserva.setInt(1, Integer.parseInt(idMesa));
            psUpdateReserva.setDate(2, java.sql.Date.valueOf(fecha));
            psUpdateReserva.executeUpdate();
        }

        // Redirigir a ver comandas
        response.sendRedirect("controller?op=vercomandas");
        return;

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("mensajeError", "❌ Ocurrió un error al registrar el pedido.");
        request.setAttribute("vista", "ver_comandas.jsp");
        url = "plantilla.jsp";
    }
    break;



    
case "eliminarcomanda":
    try (Connection con = ConexionBD.conectar()) {
        String idComanda = request.getParameter("id_comanda");

        // 1. Obtener datos relacionados: pedido, cliente y mesa
        int idPedido = 0, idCliente = 0, idMesa = 0;
        PreparedStatement psPedido = con.prepareStatement(
            "SELECT p.id_pedido, p.id_cliente, p.id_mesa " +
            "FROM comanda c JOIN pedido p ON c.id_pedido = p.id_pedido " +
            "WHERE c.id_comanda = ?"
        );
        psPedido.setString(1, idComanda);
        ResultSet rsPedido = psPedido.executeQuery();
        if (rsPedido.next()) {
            idPedido = rsPedido.getInt("id_pedido");
            idCliente = rsPedido.getInt("id_cliente");
            idMesa = rsPedido.getInt("id_mesa");
        }

        // 2. Eliminar detalle_comanda
        PreparedStatement ps1 = con.prepareStatement("DELETE FROM detalle_comanda WHERE id_comanda = ?");
        ps1.setString(1, idComanda);
        ps1.executeUpdate();

        // 3. Eliminar comanda
        PreparedStatement ps2 = con.prepareStatement("DELETE FROM comanda WHERE id_comanda = ?");
        ps2.setString(1, idComanda);
        ps2.executeUpdate();

        // 4. Verificar si quedan más comandas para el pedido
        boolean eliminarPedido = false;
        PreparedStatement psCheck = con.prepareStatement("SELECT COUNT(*) FROM comanda WHERE id_pedido = ?");
        psCheck.setInt(1, idPedido);
        ResultSet rsCheck = psCheck.executeQuery();
        if (rsCheck.next() && rsCheck.getInt(1) == 0) {
            eliminarPedido = true;

            // 5. Eliminar el pedido
            PreparedStatement ps3 = con.prepareStatement("DELETE FROM pedido WHERE id_pedido = ?");
            ps3.setInt(1, idPedido);
            ps3.executeUpdate();

            // 6. Verificar si la mesa tiene reservas activas
            PreparedStatement psReserva = con.prepareStatement(
                "SELECT COUNT(*) AS total FROM reserva WHERE id_mesa = ? AND estado IN ('Pendiente', 'En curso')"
            );
            psReserva.setInt(1, idMesa);
            ResultSet rsReserva = psReserva.executeQuery();

            boolean liberarMesa = true;
            if (rsReserva.next() && rsReserva.getInt("total") > 0) {
                liberarMesa = false; // Tiene reserva activa, no liberar
            }

            // 7. Liberar mesa si fue usada manualmente (sin reserva activa)
            if (liberarMesa) {
                PreparedStatement psUpdateMesa = con.prepareStatement(
                    "UPDATE mesa SET estado = 'Disponible' WHERE id_mesa = ?"
                );
                psUpdateMesa.setInt(1, idMesa);
                psUpdateMesa.executeUpdate();
            }

            // 8. Verificar si el cliente fue manual (sin reservas ni pedidos)
            boolean eliminarCliente = true;

            PreparedStatement psRes = con.prepareStatement("SELECT COUNT(*) FROM reserva WHERE id_cliente = ?");
            psRes.setInt(1, idCliente);
            ResultSet rsRes = psRes.executeQuery();
            if (rsRes.next() && rsRes.getInt(1) > 0) {
                eliminarCliente = false;
            }

            PreparedStatement psPed = con.prepareStatement("SELECT COUNT(*) FROM pedido WHERE id_cliente = ?");
            psPed.setInt(1, idCliente);
            ResultSet rsPed = psPed.executeQuery();
            if (rsPed.next() && rsPed.getInt(1) > 0) {
                eliminarCliente = false;
            }

            if (eliminarCliente) {
                PreparedStatement psDelCli = con.prepareStatement("DELETE FROM cliente WHERE id_cliente = ?");
                psDelCli.setInt(1, idCliente);
                psDelCli.executeUpdate();
            }
        }

        // 9. Redirigir
        response.sendRedirect("controller?op=vercomandas");
        return;

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("mensajeError", "Error al eliminar comanda.");
        request.setAttribute("vista", "ver_comandas.jsp");
        request.getRequestDispatcher("plantilla.jsp").forward(request, response);
    }
    break;



    case "editarcomanda":
    try (Connection con = ConexionBD.conectar()) {
        String idComanda = request.getParameter("id_comanda");

        String sql = "SELECT co.id_comanda, co.fecha, p.id_pedido, p.id_mesa, p.id_cliente, "
                   + "cli.nombre AS nombre_cliente, cli.apellidos, m.numero_mesa "
                   + "FROM comanda co "
                   + "JOIN pedido p ON co.id_pedido = p.id_pedido "
                   + "JOIN cliente cli ON p.id_cliente = cli.id_cliente "
                   + "JOIN mesa m ON p.id_mesa = m.id_mesa "
                   + "WHERE co.id_comanda = ?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, idComanda);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            request.setAttribute("id_comanda", rs.getInt("id_comanda"));
            request.setAttribute("id_pedido", rs.getInt("id_pedido"));
            request.setAttribute("id_mesa", rs.getInt("id_mesa"));
            request.setAttribute("id_cliente", rs.getInt("id_cliente"));
            request.setAttribute("nombre_cliente", rs.getString("nombre_cliente"));
            request.setAttribute("apellidos", rs.getString("apellidos"));
            request.setAttribute("numero_mesa", rs.getInt("numero_mesa"));
            request.setAttribute("fecha_comanda", rs.getString("fecha"));

            // Detalles actuales
            String sqlDetalles = "SELECT dc.id_detalle, dc.id_carta, dc.cantidad, dc.observaciones, c.nombre "
                               + "FROM detalle_comanda dc "
                               + "JOIN carta c ON dc.id_carta = c.id_carta "
                               + "WHERE dc.id_comanda = ?";
            PreparedStatement psDetalles = con.prepareStatement(sqlDetalles);
            psDetalles.setString(1, idComanda);
            ResultSet rsDetalles = psDetalles.executeQuery();
            request.setAttribute("detalles", rsDetalles);

            // Productos disponibles
            PreparedStatement psProductos = con.prepareStatement("SELECT id_carta, nombre FROM carta");
            ResultSet rsProductos = psProductos.executeQuery();
            request.setAttribute("productos", rsProductos);

            request.setAttribute("vista", "editar_comanda.jsp");
            url = "plantilla.jsp"; // usa la plantilla general
        } else {
            response.sendRedirect("controller?op=vercomandas");
            return;
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("controller?op=vercomandas");
        return;
    }
    break;

                
                case "actualizarcomanda":
    try (Connection con = ConexionBD.conectar()) {
        int idComanda = Integer.parseInt(request.getParameter("id_comanda"));

        // Borrar los productos anteriores
        PreparedStatement psDelete = con.prepareStatement("DELETE FROM detalle_comanda WHERE id_comanda = ?");
        psDelete.setInt(1, idComanda);
        psDelete.executeUpdate();

        // Insertar los nuevos
        String[] productos = request.getParameterValues("producto[]");
        String[] cantidades = request.getParameterValues("cantidad[]");
        String[] observaciones = request.getParameterValues("observaciones[]");

        String sqlInsert = "INSERT INTO detalle_comanda (id_comanda, id_carta, cantidad, observaciones) VALUES (?, ?, ?, ?)";
        PreparedStatement psInsert = con.prepareStatement(sqlInsert);

        for (int i = 0; i < productos.length; i++) {
            psInsert.setInt(1, idComanda);
            psInsert.setInt(2, Integer.parseInt(productos[i]));
            psInsert.setInt(3, Integer.parseInt(cantidades[i]));
            psInsert.setString(4, observaciones[i] != null ? observaciones[i] : "");
            psInsert.addBatch();
        }

        psInsert.executeBatch();

        response.sendRedirect("controller?op=vercomandas");
        return;
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("mensajeError", "Error al actualizar la comanda.");
        request.setAttribute("vista", "ver_comandas.jsp");
        request.getRequestDispatcher("plantilla.jsp").forward(request, response);
    }
    break;
///////////

        case "vercarta":
            request.setAttribute("vista", "ver_carta.jsp");
            url = "plantilla.jsp";
            break;
        case "editarcarta":
            request.setAttribute("id", request.getParameter("id"));
            request.setAttribute("vista", "editar_carta.jsp");
            url = "plantilla.jsp";
            break;


        case "eliminarcarta":
            String idCarta = request.getParameter("id");

            try (Connection con = ConexionBD.conectar()) {
                String sqlEliminar = "DELETE FROM carta WHERE id_carta = ?";
                PreparedStatement psEliminar = con.prepareStatement(sqlEliminar);
                psEliminar.setString(1, idCarta);
                psEliminar.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.sendRedirect("controller?op=vercarta");
            return;
            
        case "agregarcarta":
            request.setAttribute("vista", "agregar_carta.jsp");
            url = "plantilla.jsp";
            break;   
            
case "generarboleta":
    request.setAttribute("vista", "generar_boleta.jsp");
    url = "plantilla.jsp";
    break;

case "guardarboleta":
    try (Connection con = ConexionBD.conectar()) {
        String idPedidoStr = request.getParameter("id_pedido");
        String totalStr = request.getParameter("total");
        String metodoPagoStr = request.getParameter("id_metodo_pago");

        if (idPedidoStr == null || totalStr == null || metodoPagoStr == null ||
            idPedidoStr.trim().isEmpty() || totalStr.trim().isEmpty() || metodoPagoStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Faltan datos obligatorios para guardar la boleta");
        }

        int idPedido = Integer.parseInt(idPedidoStr);
        BigDecimal total = new BigDecimal(totalStr);
        int idMetodoPago = Integer.parseInt(metodoPagoStr);

        // 1. Insertar la boleta
        String sql = "INSERT INTO boleta_de_pago (id_pedido, total, fecha, estado, id_metodo_pago) "
                   + "VALUES (?, ?, NOW(), 'Pagado', ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idPedido);
        ps.setBigDecimal(2, total);
        ps.setInt(3, idMetodoPago);
        ps.executeUpdate();

        // 2. Cambiar el estado del pedido a "Finalizado"
        PreparedStatement psPedido = con.prepareStatement(
            "UPDATE pedido SET estado = 'Finalizado' WHERE id_pedido = ?");
        psPedido.setInt(1, idPedido);
        psPedido.executeUpdate();

        // 3. Cambiar el estado de la mesa a "Disponible"
        PreparedStatement psMesa = con.prepareStatement(
            "UPDATE mesa SET estado = 'Disponible' WHERE id_mesa = (SELECT id_mesa FROM pedido WHERE id_pedido = ?)");
        psMesa.setInt(1, idPedido);
        psMesa.executeUpdate();
        
        // Actualizar la reserva relacionada a este pedido (si existe)
        PreparedStatement psActualizarReserva = con.prepareStatement(
            "UPDATE reserva SET estado = 'Realizada' WHERE id_mesa = (SELECT id_mesa FROM pedido WHERE id_pedido = ?) AND estado IN ('Pendiente', 'En curso')"
        );
        psActualizarReserva.setInt(1, idPedido);
        psActualizarReserva.executeUpdate();

        // 4. Redirigir
        response.sendRedirect("controller?op=verboletas");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    }
    break;


    case "verboletas":
            request.setAttribute("vista", "ver_boletas.jsp");
            url = "plantilla.jsp";
            break;           
            
    case "eliminarboleta":
    try (Connection con = ConexionBD.conectar()) {
        int idBoleta = Integer.parseInt(request.getParameter("id"));

        // Liberar mesa y cambiar estado del pedido si deseas (opcional)
        PreparedStatement getPedido = con.prepareStatement("SELECT id_pedido FROM boleta_de_pago WHERE id_boleta = ?");
        getPedido.setInt(1, idBoleta);
        ResultSet rs = getPedido.executeQuery();

        if (rs.next()) {
            int idPedido = rs.getInt("id_pedido");

            // Cambiar estado del pedido
            PreparedStatement updatePedido = con.prepareStatement("UPDATE pedido SET estado = 'En curso' WHERE id_pedido = ?");
            updatePedido.setInt(1, idPedido);
            updatePedido.executeUpdate();

            // Marcar mesa como ocupada nuevamente (opcional)
            PreparedStatement updateMesa = con.prepareStatement(
                "UPDATE mesa SET estado = 'Ocupada' WHERE id_mesa = (SELECT id_mesa FROM pedido WHERE id_pedido = ?)");
            updateMesa.setInt(1, idPedido);
            updateMesa.executeUpdate();
        }

        // Eliminar boleta
        PreparedStatement ps = con.prepareStatement("DELETE FROM boleta_de_pago WHERE id_boleta = ?");
        ps.setInt(1, idBoleta);
        ps.executeUpdate();

        response.sendRedirect("controller?op=verboletas");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    }
    break;

        
    case "editarboleta":
    request.setAttribute("vista", "editar_boleta.jsp");
    request.setAttribute("id", request.getParameter("id"));
    url = "plantilla.jsp";
    break;
     
    case "actualizarboleta":
    try (Connection con = ConexionBD.conectar()) {
        int idBoleta = Integer.parseInt(request.getParameter("id_boleta"));
        String estado = request.getParameter("estado");
        int idMetodoPago = Integer.parseInt(request.getParameter("id_metodo_pago"));

        String sql = "UPDATE boleta_de_pago SET estado = ?, id_metodo_pago = ? WHERE id_boleta = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, estado);
        ps.setInt(2, idMetodoPago);
        ps.setInt(3, idBoleta);
        ps.executeUpdate();

        response.sendRedirect("controller?op=verboletas");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    }
    break;
        
        
    case "verusuarios":
    request.setAttribute("vista", "ver_usuarios.jsp");
    url = "plantilla.jsp";
    break;
        
    case "editarusuario":
    try {
        int idEditar = Integer.parseInt(request.getParameter("id"));
        UsuarioDAO daoU = new UsuarioDAO();
        Usuario usuario = daoU.buscarPorId(idEditar); // Método que debes tener

        List<Rol> listaRoles = RolDAO.listar(); // ✅ usa el método estático

        request.setAttribute("usuarioEditar", usuario);
        request.setAttribute("listaRoles", listaRoles);
        request.setAttribute("vista", "editar_usuario.jsp");
        url = "plantilla.jsp";

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("mensajeError", "Error al cargar usuario para edición");
        request.setAttribute("vista", "ver_usuarios.jsp");
        url = "plantilla.jsp";
    }
    break;

        case "agregarusuario":
    List<Rol> listaRoles = RolDAO.listar();
    request.setAttribute("listaRoles", listaRoles);
    request.setAttribute("vista", "agregar_usuario.jsp");
    url = "plantilla.jsp";
    break;



   case "guardarusuario":
    try {
        String idUsuarioStr = request.getParameter("id_usuario"); // editar vs nuevo
        String nombre      = request.getParameter("nombre");
        String apellidos   = request.getParameter("apellidos");
        String dni         = request.getParameter("dni");
        String correo      = request.getParameter("correo");
        String contrasena  = request.getParameter("contrasena");
        String idRolStr    = request.getParameter("id_rol");

        int idRol = Integer.parseInt(idRolStr);
        Rol rol = new Rol(); rol.setIdRol(idRol);

        Usuario u = new Usuario();
        u.setNombre(nombre);
        u.setApellidos(apellidos);
        u.setDni(dni);
        u.setCorreo(correo);
        u.setRol(rol);

        UsuarioDAO dao = new UsuarioDAO();
        boolean exito;

        if (idUsuarioStr != null && !idUsuarioStr.isEmpty()) {
            int idUsuario = Integer.parseInt(idUsuarioStr);
            u.setId_usuario(idUsuario);
            if (contrasena != null && !contrasena.isEmpty()) {
                String contrasenaEncriptada = BCrypt.hashpw(contrasena, BCrypt.gensalt());
                u.setContraseña(contrasenaEncriptada);
            }
            exito = dao.actualizar(u);
        } else {
            String contrasenaEncriptada = BCrypt.hashpw(contrasena, BCrypt.gensalt());
            u.setContraseña(contrasenaEncriptada);
            exito = dao.insertar(u);
        }

        if (exito) {
            response.sendRedirect("controller?op=verusuarios");
            return;
        } else {
            request.setAttribute("mensajeError", "❌ No se pudo guardar el usuario");
            request.setAttribute("listaRoles", RolDAO.listar());
            request.setAttribute("vista", 
                (idUsuarioStr != null && !idUsuarioStr.isEmpty())
                  ? "editar_usuario.jsp"
                  : "agregar_usuario.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("mensajeError", "❌ Error: " + e.getMessage());
        request.setAttribute("listaRoles", RolDAO.listar());
        request.setAttribute("vista", "agregar_usuario.jsp");
    }
    url = "plantilla.jsp";
    break;

    case "reporteproductos":
    request.setAttribute("vista", "reportes/reporte_productos.jsp");
    url = "plantilla.jsp";
    break;

    case "reporteclientes":
        request.setAttribute("vista", "reportes/reporte_clientes.jsp");
        url = "plantilla.jsp";
        break;

    case "reportecomandas":
        request.setAttribute("vista", "reportes/reporte_comandas.jsp");
        url = "plantilla.jsp";
        break;

    case "reportepagos":
        request.setAttribute("vista", "reportes/reporte_pagos.jsp");
        url = "plantilla.jsp";
        break;

    case "reportereservas":
        request.setAttribute("vista", "reportes/reporte_reservas.jsp");
        url = "plantilla.jsp";
        break;

        default:
            request.setAttribute("vista", "dashboard.jsp");
            url = "plantilla.jsp";
            break;
    }

    request.getRequestDispatcher(url).forward(request, response);
    }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    processRequest(request, response);
}

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
