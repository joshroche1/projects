package net.jar.webapp.Controller.auth;

import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


public class SessionUtils {

  public static HttpSession getSession() {
    return (HttpSession) FacesContext.getCurrentInstance().getExternalContext().getSession(false);
  }

  public static HttpServletRequest getRequest() {
    return (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
  }

  public static String getUserName() {
    HttpSession session = (HttpSession) FacesContext.getCurrentInstance().getExternalContext().getSession(false);
    return session.getAttribute("username").toString();
  }

  public static String getUserId() {
    HttpSession session = getSession();
    if (session != null)
      return (String) session.getAttribute("userid");
    else
      return null;
  }
  
  public static String setSessionValue(String varKey, String varValue, String viewId) {
    HttpSession session = SessionUtils.getSession();
    if (varKey != "" && varValue != "") {
      session.setAttribute(varKey,varValue);
    }
    return viewId;
  }
  
}
