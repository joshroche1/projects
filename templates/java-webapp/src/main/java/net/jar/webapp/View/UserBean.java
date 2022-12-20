package net.jar.webapp.View;

import java.util.ArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.MessageDigest;

import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;

import net.jar.webapp.Controller.Datasource;
import net.jar.webapp.Model.User;

@ManagedBean(name = "beanUser", eager = true)
@SessionScoped
public class UserBean {
  
  private int id;
  private String username;
  private String password;
  private String email;
  
  private Datasource dbInstance;
  private ResultSet rs; 
  private User user;
  private ArrayList<User> users;
  
  public UserBean() {}
  
  public void setUsername(String tmp) { this.username = tmp; }
  public void setPassword(String tmp) { this.password = tmp; }
  public void setEmail(String tmp) { this.email = tmp; }
  public void setId(int tmp) { this.id = tmp; }
  
  public String getUsername() { return this.username; }
  public String getPassword() { return this.password; }
  public String getEmail() { return this.email; }
  public int getId() { return this.id; }
  public User getUser() { return this.user; }
  
  private void systemMessage(String msg) {
    FacesContext.getCurrentInstance().addMessage("showmessages", new FacesMessage(
        FacesMessage.SEVERITY_WARN, msg, "..."));
  }
  
  private String generateHash(String instr) {
    systemMessage("generateHash: " + instr);
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
      systemMessage(result);
    } catch (Exception ex) {
      systemMessage(ex.getMessage());
    }
    return result;
  }
  
  public String getUser(int usrid) {
    try {
      dbInstance = new Datasource();
      rs = dbInstance.getUser(usrid);
      user = new User();
      while (rs.next()) {
        user.setId(rs.getInt("id"));
		    user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
      }
    } catch (Exception ex) {
      systemMessage(ex.getMessage());
    }
    return "auth/settings";
  }
  public ArrayList getUsers() {
    try {
      dbInstance = new Datasource();
      rs = dbInstance.getUsers();
      users = new ArrayList<User>();
      while (rs.next()) {
      	user = new User();
        user.setId(rs.getInt("id"));
	      user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
	      users.add(user);
      }
    } catch (Exception ex) {
      systemMessage(ex.getMessage());
    }
    return users;
  }
  
  public String createUser() {
    String result = "";
    return result;
  }
  
  public String updateUser(int usrid) {
    String result = "";
    return result;
  }
  
  public String deleteUser(int usrid) {
    String result = "";
    return result;
  }
    
}
