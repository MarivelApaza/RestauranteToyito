/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.controladores;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;

import com.eltoyito.util.ConexionBD;
import java.io.Serializable;
import java.sql.*;
import javax.faces.bean.RequestScoped;
import org.mindrot.jbcrypt.BCrypt;


/**
 *
 * @author Windows
 */
@ManagedBean
@RequestScoped
public class RegistroClienteBean implements Serializable {
    private String nombre;
    private String apellidos;
    private String dni;
    private String telefono;
    private String correo;
    private String contraseña;

    public String registrar() {
    try (Connection con = ConexionBD.conectar()) {
        if (con != null) {
            String sql = "INSERT INTO cliente (nombre, apellidos, dni, telefono, correo, contraseña) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, apellidos);
            ps.setString(3, dni);
            ps.setString(4, telefono);
            ps.setString(5, correo);
            // 🔐 Encriptar la contraseña con BCrypt
            ps.setString(6, BCrypt.hashpw(contraseña, BCrypt.gensalt()));
            ps.executeUpdate();
            System.out.println("✅ Registro exitoso");
            return "login_cliente.xhtml?faces-redirect=true";
        } else {
            System.out.println("❌ Error: conexión es null");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    // Getters y Setters
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getContraseña() { return contraseña; }
    public void setContraseña(String contraseña) { this.contraseña = contraseña; }
}