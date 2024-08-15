package net.jar.webapp.Controller.auth;

import java.security.MessageDigest;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpSession;

import net.jar.webapp.Controller.auth.SessionUtils;
import net.jar.webapp.Controller.Datasource;

@ManagedBean(name = "beanLogin", eager = true)
@RequestScoped
public class LoginUtil {
  
  private Datasource dbInstance = null;
  
  private String username;
  private String password;
  
  public String getUsername() { return this.username; }
  public String getPassword() { return this.password; }
  
  public void setUsername(String user) { this.username = user; }
  public void setPassword(String pass) { this.password = pass; }
  
  public LoginUtil() {}
  
  private void systemMessage(String msg) {
    FacesContext.getCurrentInstance().addMessage("showmessages", new FacesMessage(
        FacesMessage.SEVERITY_WARN, msg, "..."));
  }
  
  private String generateHash(String instr) {
    String result = "";
    try {
      MessageDigest md = MessageDigest.getInstance("SHA-256");
      md.update(instr.getBytes());
      byte[] digest = md.digest();
      StringBuffer hexString = new StringBuffer();
      for (int i = 0; i < digest.length; i++) {
        hexString.append(Integer.toHexString(0xFF & digest[i]));
      }
      result = hexString.toString();
    } catch (Exception ex) {
      systemMessage(ex.getMessage());
    }
    return result;
  }
  public String validateUserCredentials() {
    boolean valid = false;
    String hashpass = "";
    hashpass = generateHash(password);
    dbInstance = new Datasource();
    /* This is from SMC Project implementation */
    //valid = dbInstance.validateUser(username, hashpass);
    if (username.equals("admin") && password.equals("admin")) { valid = true; }
    if (valid) {
      HttpSession sess = SessionUtils.getSession();
      sess.setAttribute("username", username);
      return "system/list";
    } else {
      systemMessage("Incorrect username and/or password");
      systemMessage("Please enter the username and password");
      return "auth/login";
    }
  }
  
  public String logout() {
    HttpSession session = SessionUtils.getSession();
    session.invalidate();
    return "auth/login";
  }
}
