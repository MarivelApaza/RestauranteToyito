/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.util;
import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author Windows
 */
public class ConexionBD {
    public static Connection conectar() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/restaurante_el_toyito", "root", "");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
}
