/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.controladores;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import java.io.Serializable;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;


import com.eltoyito.util.ConexionBD;

@ManagedBean
@SessionScoped
public class LoginClienteBean implements Serializable {

    private String correo;
    private String contraseña;
    private String nombre;

    public String validarCliente() {
    try (Connection con = ConexionBD.conectar()) {
        String sql = "SELECT id_cliente, nombre, contraseña FROM cliente WHERE correo = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, correo);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String contraseñaHash = rs.getString("contraseña");

            // Verifica con BCrypt
            if (BCrypt.checkpw(contraseña, contraseñaHash)) {
                int idCliente = rs.getInt("id_cliente");
                nombre = rs.getString("nombre");

                // Guardar en sesión para JSTL
                FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("id_cliente", idCliente);
                FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("tipoUsuario", "cliente");
                FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("nombreUsuario", nombre);
                FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("rolUsuario", "Cliente");

                FacesContext.getCurrentInstance().getExternalContext().redirect("controller?op=dashboard");
                return null;
            } else {
                // Contraseña incorrecta
                FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, "Contraseña incorrecta", null));
            }
        } else {
            // Correo no encontrado
            FacesContext.getCurrentInstance().addMessage(null,
                new FacesMessage(FacesMessage.SEVERITY_ERROR, "Correo no registrado", null));
        }
    } catch (Exception e) {
        e.printStackTrace();
        FacesContext.getCurrentInstance().addMessage(null,
            new FacesMessage(FacesMessage.SEVERITY_ERROR, "Error interno al iniciar sesión", null));
    }
    return null;
}


    public String logout() {
        FacesContext.getCurrentInstance().getExternalContext().invalidateSession();
        return "login_cliente.xhtml?faces-redirect=true";
    }

    // Getters y Setters
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    public String getContraseña() { return contraseña; }
    public void setContraseña(String contraseña) { this.contraseña = contraseña; }
    public String getNombre() { return nombre; }
}
