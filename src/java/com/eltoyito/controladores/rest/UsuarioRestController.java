/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.controladores.rest;

import com.eltoyito.dao.UsuarioDAO;
import com.eltoyito.modelo.Rol;
import com.eltoyito.modelo.Usuario;
import com.eltoyito.util.ConexionBD;
import java.sql.Connection;
import java.util.ArrayList;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;
import javax.ws.rs.core.Response;

/**
 * Jersey REST client generated for REST resource:UsuarioRestController
 * [/usuarios]<br>
 * USAGE:
 * <pre>
 *        UsuarioRestControllers client = new UsuarioRestControllers();
 *        Object response = client.XXX(...);
 *        // do whatever with response
 *        client.close();
 * </pre>
 *
 * @author Windows
 * 
 */
@Path("/usuarios")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UsuarioRestController {
    UsuarioDAO dao = new UsuarioDAO();

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Usuario> getUsuarios() {
        try (Connection con = ConexionBD.conectar()) {
            return UsuarioDAO.listarTodos(con);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
        @DELETE
    @Path("/{id}")
    public String eliminarUsuario(@PathParam("id") int id) {
        boolean exito = dao.eliminar(id);
        return exito ? "✅ Usuario eliminado" : "❌ No se pudo eliminar";
    }





}
