package net.jar.webapp.Model;


public class User {
  private String username;
  private String password;
  private String email;
  private int id;
  
  public User() {}
  
  public void setUsername(String tmp) { this.username = tmp; }
  public void setPassword(String tmp) { this.password = tmp; }
  public void setEmail(String tmp) { this.email = tmp; }
  public void setId(int tmp) { this.id = tmp; }
  
  public String getUsername() { return this.username; }
  public String getPassword() { return this.password; }
  public String getEmail() { return this.email; }
  public int getId() { return this.id; }
  
}
