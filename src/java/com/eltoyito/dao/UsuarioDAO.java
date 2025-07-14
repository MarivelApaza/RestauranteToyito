/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.dao;

import com.eltoyito.modelo.Rol;
import com.eltoyito.modelo.Usuario;
import com.eltoyito.util.ConexionBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {
    public Usuario buscarPorId(int idUsuario) {
    Usuario u = null;
    String sql = "SELECT u.*, r.nombre_rol FROM usuario u JOIN rol r ON u.id_rol = r.id_rol WHERE u.id_usuario = ?";

    try (Connection con = ConexionBD.conectar();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            u = new Usuario();
            u.setId_usuario(rs.getInt("id_usuario"));
            u.setNombre(rs.getString("nombre"));
            u.setApellidos(rs.getString("apellidos"));
            u.setDni(rs.getString("dni"));
            u.setCorreo(rs.getString("correo"));

            Rol rol = new Rol();
            rol.setIdRol(rs.getInt("id_rol"));
            rol.setNombreRol(rs.getString("nombre_rol"));
            u.setRol(rol);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return u;
}

public static List<Usuario> listarTodos(Connection con) throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, r.nombre_rol FROM usuario u JOIN rol r ON u.id_rol = r.id_rol";

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Usuario u = new Usuario();
            u.setId_usuario(rs.getInt("id_usuario"));
            u.setNombre(rs.getString("nombre"));
            u.setApellidos(rs.getString("apellidos"));
            u.setDni(rs.getString("dni"));
            u.setCorreo(rs.getString("correo"));

            // Crear y asignar el rol
            Rol rol = new Rol();
            rol.setIdRol(rs.getInt("id_rol"));
            rol.setNombreRol(rs.getString("nombre_rol"));
            u.setRol(rol);

            lista.add(u);
        }
        return lista;
    }

    public boolean insertar(Usuario u) {
    String sql = "INSERT INTO usuario (nombre, apellidos, dni, correo, contraseña, id_rol) VALUES (?,?,?,?,?,?)";
    try (Connection con = ConexionBD.conectar();
         PreparedStatement ps = con.prepareStatement(sql)) {
      ps.setString(1, u.getNombre());
      ps.setString(2, u.getApellidos());
      ps.setString(3, u.getDni());
      ps.setString(4, u.getCorreo());
      ps.setString(5, u.getContraseña());
      ps.setInt(6, u.getRol().getIdRol());
      return ps.executeUpdate() > 0;
    } catch (SQLException e) {
      e.printStackTrace();
      return false;
    }
  }
    
    public boolean eliminar(int idUsuario) {
    String sql = "DELETE FROM usuario WHERE id_usuario = ?";
    try (Connection con = ConexionBD.conectar();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idUsuario);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

    
    public boolean actualizar(Usuario u) {
    String sql = "UPDATE usuario SET nombre=?, apellidos=?, dni=?, correo=?, id_rol=? WHERE id_usuario=?";

    try (Connection con = ConexionBD.conectar();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, u.getNombre());
        ps.setString(2, u.getApellidos());
        ps.setString(3, u.getDni());
        ps.setString(4, u.getCorreo());
        ps.setInt(5, u.getRol().getIdRol()); // ✅ correcto
        ps.setInt(6, u.getId_usuario());

        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
    
    
    
    
}

}

