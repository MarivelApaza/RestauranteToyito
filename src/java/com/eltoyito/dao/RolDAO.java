/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.dao;

import com.eltoyito.modelo.Rol;
import com.eltoyito.util.ConexionBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Windows
 */
public class RolDAO {
     public static List<Rol> listar() {
    List<Rol> lista = new ArrayList<>();
    String sql = "SELECT id_rol, nombre_rol FROM rol";
    try (Connection con = ConexionBD.conectar();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        Rol r = new Rol();
        r.setIdRol(rs.getInt("id_rol"));
        r.setNombreRol(rs.getString("nombre_rol"));
        lista.add(r);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return lista;
  }


}
