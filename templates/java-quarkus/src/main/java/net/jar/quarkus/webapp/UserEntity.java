package net.jar.quarkus.webapp;


import javax.persistence.Entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;
import io.quarkus.elytron.security.common.BcryptUtil;
import io.quarkus.security.jpa.Password;
import io.quarkus.security.jpa.Roles;
import io.quarkus.security.jpa.UserDefinition;
import io.quarkus.security.jpa.Username;

@Entity
@UserDefinition
public class UserEntity extends PanacheEntity {

  @Username
  public String username;

  @Password
  public String password;
  
  @Roles
  public String role;


  public static void add(String username, String password, String role) {
    UserEntity user = new UserEntity();
    user.username = username;
    user.password = BcryptUtil.bcryptHash(password);
    user.role = role;
    user.persist();
  }
  
}