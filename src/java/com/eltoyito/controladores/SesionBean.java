/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.controladores;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;

import java.io.Serializable;
import javax.faces.bean.SessionScoped;

/**
 *
 * @author Windows
 */
@ManagedBean(name = "sesionBean")
@SessionScoped 
public class SesionBean implements Serializable {
    private String tipoUsuario; // "cliente" o "empleado"
    private String rol;         // si es empleado: "maitre", "mozo", "cajero"
    private String nombre;

    // Getters y setters
    public String getTipoUsuario() {
        return tipoUsuario;
    }
    public void setTipoUsuario(String tipoUsuario) {
        this.tipoUsuario = tipoUsuario;
    }

    public String getRol() {
        return rol;
    }
    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    // Métodos de ayuda para visibilidad
    public boolean esCliente() {
        return "cliente".equals(tipoUsuario);
    }

    public boolean esMozo() {
        return "empleado".equals(tipoUsuario) && "mozo".equals(rol);
    }

    public boolean esMaitre() {
        return "empleado".equals(tipoUsuario) && "maitre".equals(rol);
    }

    public boolean esCajero() {
        return "empleado".equals(tipoUsuario) && "cajero".equals(rol);
    }

    public String cerrarSesion() {
        tipoUsuario = null;
        rol = null;
        nombre = null;
        return "index.xhtml?faces-redirect=true";
    }
}
