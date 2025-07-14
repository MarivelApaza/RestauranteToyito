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
public class LoginEmpleadoBean implements Serializable {

    private String correo;
    private String contraseña;
    private String nombre;
    private String rol;

   public String login() {
    try (Connection con = ConexionBD.conectar()) {
        String sql = "SELECT u.id_usuario, u.nombre, u.contraseña, r.nombre_rol " +
                     "FROM usuario u JOIN rol r ON u.id_rol = r.id_rol " +
                     "WHERE u.correo = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, correo);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String contraseñaHash = rs.getString("contraseña");

            // Validar contraseña con BCrypt
            if (BCrypt.checkpw(contraseña, contraseñaHash)) {
                int idUsuario = rs.getInt("id_usuario");
                nombre = rs.getString("nombre");
                rol = rs.getString("nombre_rol");

                FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("idUsuario", idUsuario);
                FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("nombreUsuario", nombre);
                FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("rolUsuario", rol);
                FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put("tipoUsuario", "empleado");

                FacesContext.getCurrentInstance().getExternalContext().redirect("controller?op=dashboard");
                return null;
            } else {
                FacesContext.getCurrentInstance().addMessage(null,
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, "Contraseña incorrecta", null));
            }
        } else {
            FacesContext.getCurrentInstance().addMessage(null,
                new FacesMessage(FacesMessage.SEVERITY_ERROR, "Correo no encontrado", null));
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
        return "login_empleado.xhtml?faces-redirect=true";
    }

    // Getters y Setters
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    public String getContraseña() { return contraseña; }
    public void setContraseña(String contraseña) { this.contraseña = contraseña; }
    public String getNombre() { return nombre; }
    public String getRol() { return rol; }
}
