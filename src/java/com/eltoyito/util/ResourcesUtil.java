/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eltoyito.util;
import javax.faces.context.FacesContext;

/**
 *
 * @author Windows
 */
public class ResourcesUtil {
     public static String getString(String key) {
        FacesContext context = FacesContext.getCurrentInstance();
        return context.getApplication().evaluateExpressionGet(context, key, String.class);
    }
}
